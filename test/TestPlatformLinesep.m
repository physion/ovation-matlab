% Copyright (c) 2012 Physion Consulting LLC

classdef TestPlatformLinesep < TestCase
    
    methods
        function self = TestPlatformLinesep(name)
             self = self@TestCase(name);
        end
        
        function testPCLineSep(self)
			if(ispc())
            	assert(all(ovation.util.platform_linesep() == '\r\n'))
			end
        end

        function testUnixLineSep(self)
			if(isunix())
				assert(all(ovation.util.platform_linesep() == '\n'))
			end
        end

        function testMacLineSep(self)
			if(ismac())
				assert(all(ovation.util.platform_linesep() == '\n'))
			end
        end
		
    end
end
