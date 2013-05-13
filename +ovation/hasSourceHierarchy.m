function b = hasSourceHierarchy(expt, sourceLabels)
% Tests an experiment for the presense of a Source hierarchy
%
%   b = hasSourceHierarchy(expt, sourceLabels)
%
%   expt: Experiment instance
%   sourceLabels: cell array of Source lables
%
%   Returns true (1) if the given experiment has a hierarchy of Sources
%   with the given labels, false (0) otherwise.
%
%   Example Usage:
%     >> p=context.insertProject('ab','ab', datetime(1,1,1));
%     >> exp = p.insertExperiment('unused', datetime(1,1,1));
%     >> s1 = exp.insertSource('label1');
%     >> s2 = s1.insertSource('label2');
%     >> s3 = s2.insertSource('label3');
%     >> hasSourceHierarchy(exp, {'label1'})
%     
%     ans =
%     
%          1
%     
%     >> hasSourceHierarchy(exp, {})
%     
%     ans =
%     
%          1
%     
%     >> hasSourceHierarchy(exp, {'label1','label2','label3'})
%     
%     ans =
%     
%          1
%     
%     >> hasSourceHierarchy(exp, {'label1','label2','label3x'})
%     
%     ans =
%     
%          0
%     
%     >> hasSourceHierarchy(exp, {'label1','label2x','label3'})
%     
%     ans =
%     
%          0
%     
%     >> hasSourceHierarchy(exp, {'label1x','label2','label3'})
%     
%     ans =
%     
%          0
%     
%     >> hasSourceHierarchy(exp, {'label1x','label2x','label3x'})
%     
%     ans =
%     
%          0
     

% Copyright (c) 2012 Physion Consulting LLC


	if(isempty(sourceLabels))
		b = true;
		return;
	end
	
	if(length(sourceLabels) == 1)
		b = ~isempty(expt.getSources(sourceLabels{1}));
		return;
	end
	
	
	children = expt.getSources(sourceLabels{1});
	
	for i = 1:length(children)
		src = children(i);
		if(srcHasSourceHierarchy(src, sourceLabels(2:end)))
			b = true;
			return;
		end
	end
	
	b = false;
end

function b = srcHasSourceHierarchy(head, sourceLabels)
	
	if(isempty(sourceLabels))
		b = true;
		return;
	end
	
	if(length(sourceLabels) == 1)
		b = ~isempty(head.getChildren(sourceLabels{1}));
		return;
	end
	
	
	children = head.getChildren(sourceLabels{1});
	
	for i = 1:length(children)
		src = children(i);
		if(srcHasSourceHierarchy(src, sourceLabels(2:end)))
			b = true;
			return;
		end
	end
	
	b = false;
end
