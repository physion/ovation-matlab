function lines = read_lines(filePath)
	
    % Copyright (c) 2012 Physion Consulting LLC
    
	[fid,msg] = fopen(filePath, 'r');
	if(fid < 0)
		error('ovation:update_librarypath',...
			'Unable to open %s: %s',...
			fielPath,...
			msg...
			);
	end
	
	lines = textscan(fid, '%s', 'Delimiter', ovation.util.platform_linesep());
	lines = lines{1};
	
	fclose(fid);
end