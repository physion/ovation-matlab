% Copyright (c) 2012-2013 Physion LLC

function firstrun_classpath(jarPath)
    
    if(usejava('awt'))
        if(ismac())
            prompt = 'Do you want to update Matlab''s classpath.txt? Please enter your system adminstrator password when prompted (twice).';
        elseif(isunix())
            prompt = 'Do you want to update Matlab''s classpath.txt? Please enter your sudo password in the Matlab Command Window when prompted.';
        else
            prompt = 'Do you want to update Matlab''s classpath.txt?';
        end
        response = questdlg({'Matlab''s Java class path has not been fully configured for Ovation.',...
            'Ovation will not function correctly until the configuration is updated.',...
            ' ',...
            prompt},...
            'Configuration Error',...
            'Yes',...
            'No',...
            'Yes'...
            );
        
        switch response
            case 'Yes'
                ovation.util.update_classpath(jarPath);
                uiwait(warndlg({'Configuration succesfully updated.',...
                    'Please restart Matlab for configuration changes to take effect.'},...
                    'Restart Required',...
                    'modal'));
            case 'No'
        end
    else
        disp(' ');
        disp('Matlab''s Java class path has not been fully configured for Ovation.');
        disp('Ovation will not function correctly until the configuration is updated.');
        disp(' ');
        response = input('Do you want to update Matlab''s classpath.txt ([y]/n)? ','s');
        
        while ~isempty(response) && ~(isequal(lower(response),'y') || isequal(lower(response),'n'))
            input('Do you want to update Matlab''s classpath.txt ([y]/n)? ','s');
        end
        
        switch response
            case 'y'
                ovation.util.update_classpath(jarPath);
                disp('Configuration succesfully updated. Please restart Matlab for changes to take effect.');
            case ''
                ovation.util.update_classpath(jarPath);
                disp('Configuration succesfully updated. Please restart Matlab for changes to take effect.');
        end
    end
end
