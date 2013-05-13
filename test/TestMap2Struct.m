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
    end
end