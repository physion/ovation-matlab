function s = arrayToSet(arr)
% Converts an object array to a Java Set
%
%   set = arrayToSet(array)
%
%   arr: Array of objects
%
%   Example Usage
%   -------------
%
%   >>> arr = [1,2,3];
%   
%   >>> arrayToSet(arr)
%   
%   ans =
%    
%   [3.0, 2.0, 1.0]

% Copyright (c) 2012 Physion Consulting LLC


	s = java.util.HashSet();
	for i = 1:length(arr)
		s.add(arr(i));
	end
end