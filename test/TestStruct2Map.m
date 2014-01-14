% Copyright (c) 2012 Physion Consulting LLC
 
classdef TestStruct2Map < TestCase
    
    methods
        function self = TestStruct2Map(name)
             self = self@TestCase(name);
        end
        
        function testConvertsToJavaMap(~)
            import ovation.*;
            
			s.key1 = 10;
			s.key2 = 'abc';
			s.key3 = [1,2,3];
			
			m = struct2map(s);
			
			assert(s.key1 == m.get('key1'));
			assert(strcmp(s.key2, char(m.get('key2'))));
			assert(isequal(s.key3, m.get('key3')'));
        end
        
        function testConvertsStructToNestedLabel(~)
           import ovation.*
           
           s.foo.bar = 10;
           s.foo.baz = 100;
           
           m = struct2map(s);
           
           assert(s.foo.bar == m.get('foo.bar'));
           assert(s.foo.baz == m.get('foo.baz'));
        end
        
        function testConvertsArrayToNumericData(~)
           import ovation.*;
           
           s.key1 = [1,2,3.];
           
           m = struct2map(s);
           
           assert(isequal(s.key1, m.get('key1')'));
        end
        
        function testConvertsLogicalArrayToNumericData(~)
            import ovation.*;
            
            s.key1 = [true,false,true];
            
            m = struct2map(s);
            
            assert(isequal(int16(s.key1), int16(m.get('key1')')));
        end
        
        function testConvertsFunctionHandleToFunctionName(~)
            import ovation.*;
            
            s.key1 = @sin;
            
            m = struct2map(s);
            assert(strcmp('sin', m.get('key1')));
        end
        
        function testThrowsExceptionForNonStringCellArray(~)
            import ovation.*;
            
            s.key1 = {'abc',2};
            opts.strict = true;
            f = @() ovation.struct2map(s, opts);
            assertExceptionThrown(f,...
                'ovation:struct2map:unsupported_value');
        end
        
        function testConcatsStringCellArray(~)
            import ovation.*;
            
            s.key1 = {'abc', 'def', 'ghi'};
            m = struct2map(s);
            assert(strcmp('abcdefghi', char(m.get('key1'))));
        end
        
        function testMapsNestedRecordArrays(~)
            import ovation.*;
            
            s.key1 = 'value1';
            s.arr(1).foo = 1;
            s.arr(1).bar = 'abc';
            s.arr(2).foo = 2;
            s.arr(2).bar = 'def';
            
            m = struct2map(s);
            
            assertEqual(s.arr(1).foo, m.get('arr(1).foo'));
            assertEqual(s.arr(2).foo, m.get('arr(2).foo'));
            
            assert(strcmp('abc', char(m.get('arr(1).bar'))));
            assert(strcmp('def', char(m.get('arr(2).bar'))));
        end
        
        function testMatlabObjects(~)
            import ovation.*;
            obj = DocPolynomSimpleTestObject([1 0 -2 -5]);
            s.obj = obj;
            
            m = struct2map(s);
            
            assertEqual(s.obj.coef', m.get('obj.coef'));
        end
        
        
    end
end
