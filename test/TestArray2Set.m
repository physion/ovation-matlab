% Copyright (c) 2012 Physion Consulting LLC

classdef TestArray2Set < TestCase
    
    methods
        function self = TestArray2Set(name)
             self = self@TestCase(name);
        end
        
        function testConvertsNumericVectorToSet(~)
			v = [1,2,3];
			
			s = ovation.array2set(num2cell(v));
			
            for e = v
                assertTrue(s.contains(e));
            end
        end
        
        function testThrowsErrorWhenPassingCharacterArray(~)
            
            f = @() ovation.array2set('abc');
            assertExceptionThrown(f,...
                'ovation:array2set:unsupported_value');
            
        end
        
        function testThrowsErrorWhenPassingNumericVector(~)
            
            f = @() ovation.array2set([1,2,3]);
            assertExceptionThrown(f,...
                'ovation:array2set:unsupported_value');
            
        end
        
        function testConvertsCellArrayToSetWithCellContentsAsMembers(~)
            v = {'abc','def'};
            
            s = ovation.array2set(v);
            
            for i = 1:length(v)
                assertTrue(s.contains(v{i}));
            end
        end
        
        function testConvertsEmptyArrayToEmptySet(~)
            v = [];
            s = ovation.array2set(v);
            
            assertEqual(0, s.size());
        end
        
    end
end
