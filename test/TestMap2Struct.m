% Copyright (c) 2012 Physion Consulting LLC

classdef TestMap2Struct < TestCase
    
    methods
        function self = TestMap2Struct(name)
             self = self@TestCase(name);
        end
        
        function testConvertsToMatlabStruct(self)
            import ovation.*;
            
			m = java.util.HashMap();
			m.put('key1', 10);
			m.put('key2', 'abc');
			m.put('key3', [1,2,3]);
			
			s = map2struct(m);
			
			assert(s.key1 == m.get('key1'));
			assert(strcmp(s.key2, char(m.get('key2'))));
			assert(all(s.key3 == m.get('key3')));
        end
        
        function testShouldConvertNestedStructuresFromStruct2Map(self)
            import ovation.*;
            
            s.c.d = 10;
            s.a = 1;
            s.b = 'abc';
            s.c.d = 10;
            m = struct2map(s);
            
            a = map2struct(m);
            
            assertEqual(s.a, a.a);
            assertEqual(s.b, a.b);
            assertEqual(s.c.d, a.c.d);
        end
        
        function testShouldConvertNestedStructArrays(~)
            import ovation.*;
            
            s.key1 = 'value1';
            s.arr(1).foo = 1;
            s.arr(1).bar = 'abc';
            s.arr(2).foo = 2;
            s.arr(2).bar = 'def';
            
            m = struct2map(s);
            
            actual = map2struct(m);
            
            assertEqual(s.arr(1).foo, actual.arr(1).foo);
            assertEqual(s.arr(2).foo, actual.arr(2).foo);
            
            assertEqual(s.arr(1).bar, actual.arr(1).bar);
            assertEqual(s.arr(2).bar, actual.arr(2).bar);
            
            assertEqual(s.key1, actual.key1);
        end
    end
end