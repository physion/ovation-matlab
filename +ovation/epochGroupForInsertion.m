function [epochGroup,isNew] = epochGroupForInsertion(experiment, source, labels, startDate)
% Find or create an EpochGroup for insertion. Locates and returns an existing
% group with the given label hierarchy or creates a new EpochGroup with the
% given hiearchy.
%
%   [epochGroup,isNew] = epochGroupForInsertion(experiment, source, labels, startDate)
%
%     experiment: ovation.Experiment instance to contain this EpochGroup
%     source: ovation.Source instance to contain this EpochGroup
%     labels: Matlab cell array of label strings or ovation.EpochGroup
%      instances.
%     startDate: datetime instance
%
%   For each element in labels, this function creates a new EpochGroup for
%   string elements and uses the existing EpochGroup for EpochGroup
%   elements.
	
	
% Copyright (c) 2012 Physion Consulting LLC


	assert(~isempty(labels));
	
	[epochGroup,isNew] = insertLabeledGroup(experiment, ...
		source,...
		labels,...
		startDate);
end



function [group,isNew] = insertLabeledGroup(parent, source, labels, startDate)
	
    import ovation.*
    
	assert(~isempty(labels));
	
	label = labels{1};
	
	if(isjava(label))
		assert(strcmp('us.physion.ovation.domain.concrete.EpochGroup', char(label.getClass().getName())),...
			'Hierarchy element must be either a string label or an EpochGroup instance.');
		group = label;
		isNew = false;
	else
		group = parent.insertEpochGroup(label, startDate, [], [], []);
		isNew = true;
	end
	
	
	if(length(labels) == 1) % Base case
		return
	else
		[group,isNew] = insertLabeledGroup(group, ...
			source,...
			labels(2:end),...
			startDate);
	end
end