% Copyright (c) 2012-2013 Physion LLC
function found = check_classpath(jarPath)
	
	filePath = fullfile(matlabroot,'toolbox','local','classpath.txt');
	
    lines = ovation.util.read_lines(filePath);
    
    found = true;
    if ~any(cell2mat(regexp(lines, strrep(jarPath, '\', '\\'))))
        found = false;
    end
end
