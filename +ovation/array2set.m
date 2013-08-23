function s = array2set(arr)
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
%   >>> array2set(arr)
%   
%   ans =
%    
%   [3.0, 2.0, 1.0]

% Copyright (c) 2012 Physion Consulting LLC
  import com.google.common.collect.*
  s = Sets.newHashSet(arr)
end
