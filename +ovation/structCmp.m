function eq = structCmp(s1, s2)
% Compare two structs for equality.
%
%     eq = structCmp(s1, s2)
%
% Usage:
%
% >> s1.foo = 10;
% >> s1.bar = 'abc';
% >> s2.foo = 10;
% >> s2.bar = 'abc';
% >> s3.foo = 11;
% >> s3.bar = 'abc';
% >> s4.foo=10;
% >> s4.bar='def';
% >> structCmp(s1,s2)
% 
% ans =
% 
%      1
% 
% >> structCmp(s1,s3)
% 
% ans =
% 
%      0
% 
% >> structCmp(s1,s4)
% 
% ans =
% 
%      0

% Copyright (c) 2012 Physion Consulting LLC


	s1Fields = fieldnames(s1);
	s2Fields = fieldnames(s2);
	
	if(length(s1Fields) ~= length(s2Fields))
		eq = false;
		for j = 1:length(s1Fields)
			if(~isfield(s2, s1Fields{j}))
				disp([s1Fields{j} ' not present in s2.']);
			end
		end
		
		for j = 1:length(s2Fields)
			if(~isfield(s1, s2Fields{j}))
				disp([s2Fields{j} ' not present in s1.']);
			end
		end
		return;
	end
	
	
	for i = 1:length(s1Fields)
		field = s1Fields{i};
		if (~isfield(s2, field))
			eq = false;
			disp(['s2.' field ' does not exist.']);
			return;
		end
		
		if(isstruct(s1.(field)))
			if(~isstruct(s2.(field)))
				eq = false;
				disp(['s2.' field ' is not a struct.']);
				return;
			end
			
			if(~structCmp(s1.(field), s2.(field)))
				eq = false;
				return;
			end
		else
			if(ischar(s1.(field)) && ischar(s2.(field)))
				eq = strcmp(s1.(field), s2.(field));
				continue;
			else
				if(ischar(s1.(field)))
					s1value = s1.(field);
				else
					s1value = num2str(s1.(field));
				end
				
				if(ischar(s2.(field)))
					s2value = s2.(field);
				else
					s2value = num2str(s2.(field));
				end
				
				if(s1.(field) ~= s2.(field))
					
					
					disp(['Expected ' s1value ' but got ' s2value ' for field ' field]);
					eq = false;
					return;
				end
			end
		end
	end
	
	eq = true;
end