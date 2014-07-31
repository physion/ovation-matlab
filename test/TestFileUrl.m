% Copyright (c) 2012 Physion Consulting LLC
 
classdef TestFileUrl < TestCase
    
    methods
        function self = TestFileUrl(name)
             self = self@TestCase(name);
        end
        
        function testCreatesAbsoluteUrl(~)
            pth = '/path/to/file';
            url = ovation.util.fileUrl(pth);
            assert(strcmp(url.getPath(), pth));
        end
    end
end