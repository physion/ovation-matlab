% Converts an object (cell) array to a Java Set
%
%   set = arrayToSet(array)
%
%   arr: Cell array of objects
%
%   Example Usage
%   -------------
%
%   >> arr = {1,2,3};
%   
%   >> array2set(arr)
%   
%   ans =
%    
%   [3.0, 2.0, 1.0]
%
%   >> array2set({'abc','def'})
% 
%   ans =
% 
%   [def, abc]
%    
%   >> array2set('abc')
%   Error using ovation.array2set (line 32)
%   array2set argument must be an object (cell) array
% 
%   >> array2set([1,2,3])
%   Error using ovation.array2set (line 32)
%   array2set argument must be an object (cell) array

% Copyright (c) 2012 Physion Consulting LLC


function s = array2set(arr)

    import com.google.common.collect.*;
    
    if(isempty(arr))
        s = Sets.newHashSet();
    else
        if(~iscell(arr))
            error('ovation:array2set:unsupported_value',...
                'array2set argument must be an object (cell) array');
        end
        
        s = Sets.newHashSet(arr);
    end
end
