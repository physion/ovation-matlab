function context = NewDataContext(userEmail, password)
% Creates a new ovation.DataContext with a connection to the specified
% connection file. Prompts for the user password.
%
%  context = NewDataContext(email, [password]);
%
%    email (optional): ovation.io user email
%    password (optional): ovation.io password for authenticating the 
%                         new DataContext
%

% Copyright (c) 2012 Physion Consulting LLC

    import ovation.util.*;
    import java.lang.Thread;
    
    narginchk(0,2);
    
    
    classLoader = ovation_classloader(fullfile(fileparts(which(mfilename('fullpath'))), 'ovation.jar'));
    ovationClass = classLoader.loadClass('us.physion.ovation.api.Ovation');
    strClass = classLoader.loadClass('java.lang.String');
    connectMethod = ovationClass.getMethod('connect', [strClass, strClass]);
    versionMethod = ovationClass.getMethod('getVersion', []);
    
    currentThread = Thread.currentThread();
    currentThread.setContextClassLoader(ovationClass.getClassLoader());
    
    if(nargin == 0)
        [userEmail, password] = logindlg('Title', 'ovation.io');
        if(isempty(userEmail) || isempty(password))
            context = [];
            return
        end
    elseif(nargin == 1)
        password = logindlg('Title', ['ovation.io (' userEmail ')'], 'Password', 'only');
        if(isempty(password))
            context = [];
            return
        end
    end
    
	import us.physion.ovation.api.*
    
    disp(['Ovation Matlab Core API version ' char(versionMethod.invoke([], []))]);
    
    disp('Authenticating...');
    
    args = javaArray('java.lang.String', 2);
    args(1) = java.lang.String(userEmail);
    args(2) = java.lang.String(password);
    
    dsc = connectMethod.invoke([], args);
    
    context = dsc.getContext();
end