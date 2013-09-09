classdef TestNamedMap < TestCase
    
    methods
        function self = TestNamedMap(name)
             self = self@TestCase(name);
        end
        
        function testShouldCollectNamedElements(~)
            import ovation.*;
            
            s = java.util.HashSet();
            
            s.add(javaClass('java.lang.String'));
            s.add(javaClass('java.io.File'));
            
            m = namedMap(s);
            
            assertTrue(m.containsKey('java.lang.String'));
            assertTrue(m.containsKey('java.io.File'));
        end
        
        function testShouldCollectMultiple(~)
            import ovation.*;
            
            s = java.util.HashSet();
            
            s.add(javaClass('java.lang.String'));
            s.add(javaClass('java.lang.String'));
            s.add(javaClass('java.io.File'));
            
            m = namedMap(s);
            
            assertEqual([1 1], m.get('java.lang.String').size());
            assertEqual([1 1], m.get('java.io.File').size());
        end
    end
    
end
