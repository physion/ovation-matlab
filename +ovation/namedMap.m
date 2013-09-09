% Constructs a map of named elements from an iterable of elements.
%
% All elements must have a .getName() method
%

function map = namedMap(iterable, allowMultiple)
    import ovation.*;
    
    narginchk(1,2);
    if(nargin < 2)
        allowMultiple = false;
    end
    
    map = java.util.HashMap();
    itr = iterable.iterator();
    while(itr.hasNext())
        e = itr.next();
        if(allowMultiple)
            if(~map.containsKey(e.getName()))
                map.put(e.getName(), java.util.HashSet())
            end
            
            map.get(e.getName()).add(e);
        else
            map.put(e.getName(), e);
        end
    end
end
        