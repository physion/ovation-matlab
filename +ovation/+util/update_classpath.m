% Copyright (c) 2012-2013 Physion LLC

function update_classpath(jarPath)
	
	filePath = fullfile(matlabroot,'toolbox','local','classpath.txt');
	
	if(ismac())
	    [success,msg] = system(['osascript -e ''do shell script "cp ' filePath ' ' filePath '.ovation_bak" with administrator privileges''']);
		if(success ~= 0)
			error(['Unable to create backup for ' filepath ': ' msg ]); ...
		end
		
		[success,msg] = system(['osascript -e ''do shell script "chmod ug+w ' filePath '" with administrator privileges'' ']);
		if(success ~= 0)
			error(['Unable to update permissions for ' filepath ': ' msg ]);
		end
	
	elseif(ispc())
		if(~ovation.util.isWindowsAdmin())
			error('Ovation configuration requires Administrator priviledges for first run. Please restart Matlab as an Administrator.');
		end
		
		[success,msg,msgid] = copyfile(filePath, ...
			fullfile(matlabroot,'toolbox','local','classpath.txt.ovation_bak'),...
			'f'...
			);
		
		if (~success)
			error(msgid, msg);
		end
		
	else % Linux
		 [success,msg] = system(['sudo cp ' filePath ' ' filePath '.ovation_bak'], '-echo');
		if(success ~= 0)
			error(['Unable to create backup for ' filePath ': ' msg ]); ...
		end
		
		[success,msg] = system(['sudo chmod a+w "' filePath '" '], '-echo');
		if(success ~= 0)
			error(['Unable to update permissions for ' filePath ': ' msg ]);
		end
    end
    
    if(~ovation.util.check_classpath(jarPath))
        lines = [{jarPath}; ovation.util.read_lines(filePath)];
        write_lines(filePath, lines);
    end
    
end

function write_lines(filePath, lines)
	[fid, msg] = fopen(filePath, 'w');
	if(fid == -1)
		error(msg);
	end
	
	for i = 1:length(lines)
        if(ispc())
            line = strrep(lines{i},'\','\\');
        else
            line = lines{i};
        end
        
        fprintf(fid, [line ovation.util.platform_linesep()]);
	end
	
	fclose(fid);
	
end
