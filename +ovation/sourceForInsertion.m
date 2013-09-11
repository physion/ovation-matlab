% Find or create a Source for insertion. Locates and returns an existing
% source hierarchy with the given labels and identifying property values
%
%   [source,isNew] = sourceForInsertion(context, labels, sourceIDs)
%
%     context: ovation.DataContext instance labels: Cell array of Source
%     labels (e.g. {'animal', 'tissue', 'cell'}) or ovation.Source
%     instances
%     identifiers: Source identifiers. Must be the same length as labels.
%
%   This function traverses the Source hierarchy of an Ovation database to
%   find a desired Source instance. The labels and sourceIDs cell arrays
%   are parallel arrays describing the label and identifier attributes of
%   parent => child Sources in the desired hierarchy.
%
%   For example, a labels array {'parent', 'child', 'grandchild'} specifies
%   a Source hierarchy of Source('parent') => Source('child') =>
%   Source('grandchild').
%
%
%   sourceForInsertion uses label and identifer to identify existing
%   Sources within the hiearchy. For each element in labels and sourceIDs,
%   sourceForInsertion finds an existing Source with corresponding label
%   and identifier, or creates a new Source with the given label and
%   identifier. If a label element is an Source instance, that Source is
%   used, and the corresponding identifier is ignored.

% Copyright (c) 2012 Physion Consulting LLC


function [source,isNew] = sourceForInsertion(context,...
        labels,...
        identifiers,...
        epochContainer,...
        epochStart,...
        epochEnd,...
        protocol,...
        protocolParameters,...
        deviceParameters)
    
    
    error(nargchk(9, 9, nargin));  %#ok<NCHKN>
    
    assert(~isempty(labels));
    assert(~isempty(identifiers));
    
    if(numel(labels) ~= numel(identifiers))
        error('ovation:sourceForInsertion:IllegalArgument',...
            'labels and sourceIDs must be equal length');
    end
    
    if(isempty(deviceParameters))
        deviceParameters = com.google.common.base.Optional.absent();
    elseif(isstruct(deviceParameters))
        deviceParameters = ovation.struct2map(deviceParameters);
    end
    
    if(isempty(protocolParameters))
        protocolParameters = ovation.struct2map(struct());
    elseif(isstruct(protocolParameters))
        protocolParameters = ovation.struct2map(protocolParameters);
    end
    
    
    
    % Convert Keys and IDs to Java Strings
    for i = 1:length(identifiers)
        if(~isempty(identifiers{i}) && ~isnumeric(identifiers{i}))
            identifiers{i} = java.lang.String(identifiers{i});
        end
    end
    
    
    [source,isNew] = insertLabeledSource(context,...
        labels,...
        identifiers,...
        epochContainer,...
        epochStart,...
        epochEnd,...
        protocol,...
        protocolParameters,...
        deviceParameters);
end

function src = insertSource(container, label, identifier,...
        epochContainer,...
        epochStart,...
        epochEnd,...
        protocol,...
        protocolParameters,...
        deviceParameters)
    
    if isnumeric(identifier)
        sourceIdentifier = num2str(identifier);
    else
        sourceIdentifier = identifier;
    end
    
    if(strcmp('us.physion.ovation.api.StdDataContext', char(container.getClass().getName())))
        src = container.insertSource(label, sourceIdentifier);
    else
        src = container.insertSource(epochContainer,...
            epochStart,...
            epochEnd,...
            protocol,...
            protocolParameters,...
            deviceParameters,...
            label,...
            identifier);
    end
end

function [source,isNew] = insertLabeledSource(context,...
        labels,...
        identifiers,...
        epochContainer,...
        epochStart,...
        epochEnd,...
        protocol,...
        protocolParameters,...
        deviceParameters)
    
    import ovation.*;
    
    assert(~isempty(labels));
    assert(~isempty(identifiers));
    
    if(isjava(labels{1}) && strcmp('us.physion.ovation.domain.concrete.Source', char(labels{1}.getClass().getName())))
        source = labels{1};
        isNew = false;
    else
        if(isnumeric(identifiers{1}))
            identifier = num2str(identifiers{1});
        else
            identifier = identifiers{1};
        end
        
        label = labels{1};
        
        if(strcmp('us.physion.ovation.domain.concrete.Source', char(context.getClass().getName())))
            children = asarray(context.getChildrenSources());
            candidates = java.util.HashSet();
            for i = 1:length(children)
                if(children(i).getLabel().equals(label) && ...
                        children(i).getIdentifier().equals(identifier))
                    candidates.add(children(i));
                end
            end
            
            candidates = asarray(candidates);
        else
            candidates = asarray(context.getSources(label, identifier));
        end
        
        if(length(candidates) > 1)
            error('ovation:sourceForInsertion:multipleCandidates',...
                ['Multiple Sources with label ' char(label) ' and identifier ' identifier ' exist.']);
        end
        
        if(length(candidates) == 1)
            %disp(['Found existing source ' char(label) ' - ' char(identifier)]);
            source = candidates(1);
            isNew = false;
        else
            %disp(['Inserting new source ' char(label) ' - ' char(identifier)]);
            source = insertSource(context,...
                label,...
                identifier,...
                epochContainer,...
                epochStart,...
                epochEnd,...
                protocol,...
                protocolParameters,...
                deviceParameters);
            isNew = true;
        end
    end
    
    if(length(labels) == 1) % Base case
        return
    else
        [source,isNew] = insertLabeledSource(source, ...
            labels(2:end),...
            identifiers(2:end),...
            epochContainer,...
            epochStart,...
            epochEnd,...
            protocol,...
            protocolParameters,...
            deviceParameters);
    end
end