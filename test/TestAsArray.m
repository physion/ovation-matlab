% Copyright (c) 2012 Physion Consulting LLC

classdef TestAsArray < TestCase
    
    methods
        function self = TestAsArray(name)
             self = self@TestCase(name);
        end
        
        function testConvertsIterableToArray(self)
			import com.google.common.collect.*;
			
			l = Lists.newArrayList();
			l.add(1);
			l.add(2);
			
			arr = ovation.asarray(l);
			
			assert(1 == arr(1));
			assert(2 == arr(2))
		end
    end
end