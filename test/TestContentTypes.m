% Copyright (c) 2014 Physion LLC

classdef TestContentTypes < MatlabTestCase
   
    methods
        function self = TestContentTypes(name)
            self = self@MatlabTestCase(name);
        end
        
        function testContentCSVType(self)
            self.assertContentType('text/csv', 'some/file/test_abc.csv');
        end
        
        function testBinaryFallbackType(self)
            self.assertContentType('application/octet-stream', 'foo/bar/baz');
        end
        
        function testMatlabMATType(self)
            self.assertContentType('application/x-matlab-octet-stream', 'foo/bar/baz.mat');
        end
                
        function assertContentType(~, expected, file_path)
            assert(strcmp(expected, char(ovation.util.content_type(file_path))));
        end
    end
end
