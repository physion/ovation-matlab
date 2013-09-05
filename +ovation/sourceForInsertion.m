function [source,isNew] = sourceForInsertion(context,...
		labels,...
		sourceIDKeys,...
		sourceIDs)
% Find or create a Source for insertion. Locates and returns an existing
% source hierarchy with the given labels and identifying property values
%
%   [source,isNew] = sourceForInsertion(context, labels, [sourceIDKeys, sourceIDs])
%   
%     context: ovation.DataContext instance
%     labels: Cell array of Source labels (e.g. {'animal', 'tissue',
%     'cell'}) or ovation.Source instances
%     optional:
%       sourceIDKeys: Property key of source ID. Must be the same length as
%       labels.
%       sourceIDs: Source ID. Must be the same length as labels
%
%   This function traverses the Source hierarchy of an Ovation database to
%   find a desired Source instance. The labels and optional
%   sourceIDKeys & sourceIDs cell arrays are parallel arrays describing the
%   label and (optional) sourceID property of parent => child Sources in
%   the desired hierarchy.
% 
%   For example, a labels array {'parent', 'child', 'grandchild'} specifies
%   a Source hierarchy of Source('parent') => Source('child') =>
%   Source('grandchild).
%
%   If sourceIDKeys and sourceIDs are not provided, sourceForInsertion
%   creates a new Source for each string label in labels. If an element of
%   labels is an ovation.Source instance, that Source is used instead of
%   creating a new instance. 
%
%   If sourceIDkeys and sourceIDs are provided, sourceForInsertion uses
%   these keys/values to identify existing Sources within the hiearchy. For
%   each element in labels, sourceForInsertion finds an existing Source
%   with corresponding sourceID key and owner property value, or creates a
%   new Source with the given label and sourceID key and value. If a label
%   element is an ovation.Source instance, that Source is used. If a
%   sourceID key or value is empty (i.e. [] or ''), a new Source with the
%   corresponding label, but no source ID key/value is inserted at the
%   correct location in the hiearchy.

% Copyright (c) 2012 Physion Consulting LLC

	
    error(nargchk(2, 4, nargin));  %#ok<NCHKN>
    
    assert(~isempty(labels));
    
    if(nargin < 3)
        sourceIDKeys = cell(size(labels));
        sourceIDs = cell(size(labels));
    else
        assert(nargin >= 4, 'Missing source IDs argument.');
    end
    
    if(~iscell(sourceIDKeys))
        sourceIDKeys = {sourceIDKeys};
    end
    
    if(~iscell(sourceIDs))
        sourceIDs = {sourceIDs};
    end
    
    if(numel(sourceIDKeys) ~= numel(sourceIDs))
        error('ovation:sourceForInsertion:IllegalArgument',...
            'Source ID Keys and IDs must be equal length');
    end
    
    if(numel(sourceIDKeys) < numel(labels))
        for i = (length(sourceIDKeys)+1):length(labels)
            sourceIDKeys{i} = [];
            sourceIDs{i} = [];
        end
    end
    
	
	% Convert Keys and IDs to Java Strings
    for i = 1:length(sourceIDs)
        if(~isempty(sourceIDKeys{i}) && ~isnumeric(sourceIDKeys{i}))
            sourceIDKeys{i} = java.lang.String(sourceIDKeys{i});
        end
        
        if(~isempty(sourceIDs{i}) && ~isnumeric(sourceIDs{i}))
            sourceIDs{i} = java.lang.String(sourceIDs{i});
        end
    end
	
	
	[source,isNew] = insertLabeledSource(context,...
		labels,...
		sourceIDKeys,...
		sourceIDs);
end

function src = insertSource(container, label, srcIDKey, srcID)
    if isnumeric(srcID)
        sourceIdentifier = num2str(srcID);
    else
        sourceIdentifier = srcID;
    end
    
	src = container.insertSource(label, sourceIdentifier);
	if(~isempty(srcIDKey) && ~isempty(srcID))
		src.addProperty(srcIDKey, srcID);
	end
end

function [source,isNew] = insertLabeledSource(context, labels, sourceIDKeys, sourceIDs)
    
    import ovation.*;
    
    assert(~isempty(labels));
    
    source = [];
    
    if(isjava(labels{1}) && strcmp('us.physion.ovation.domain.concrete.Source', char(labels{1}.getClass().getName())))
        source = labels{1};
        isNew = false;
    else
        if(strcmp('us.physion.ovation.domain.concrete.Source', char(context.getClass().getName())))
            children = asarray(context.getChildrenSources());
            candidates = java.util.HashSet();
            for i = 1:length(children)
                if(children(i).getLabel().equals(labels{i}))
                    candidates.add(children(i));
                end
            end
            
            candidates = candidates.toArray();
        else
            candidates = asarray(context.getSourcesWithLabel(labels{1}));
        end
        
        for i = 1:length(candidates)
            s = candidates(i);
            if(~isempty(sourceIDKeys{1}) && ~isempty(sourceIDs{1}))
                if((~isnumeric(sourceIDs{1}) && sourceIDs{1}.equals(s.getUserProperty(s.getOwner(), sourceIDKeys{1}))) ||...
                        (isnumeric(sourceIDs{1}) &&  sourceIDs{1} == s.getUserProperty(s.getOwner(), sourceIDKeys{1})))
                    source = s;
                    isNew = false;
                    break;
                    
                end
            end
        end
        
        if(isempty(source))
            source = insertSource(context, labels{1}, sourceIDKeys{1}, sourceIDs{1});
            isNew = true;
        end
    end
    
	if(length(labels) == 1) % Base case
		return
	else
		[source,isNew] = insertLabeledSource(source, ...
			labels(2:end),...
			sourceIDKeys(2:end),...
			sourceIDs(2:end));
	end
end