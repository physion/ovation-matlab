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
    
    jarName = 'ovation.jar';
    jarEtag = 'ovation.jar.etag';
    homeFolder = char(java.lang.System.getProperty('user.home'));
    if(ismac())
        jarFolder = fullfile(homeFolder, 'Library', 'Application Support', 'us.physion.ovation', 'matlab');
    elseif(ispc())
        jarFolder = fullfile(homeFolder, 'AppData', 'Local', 'ovation', 'matlab');
    elseif(isunix())
        jarFolder = fullfile(homeFolder, '.ovation', 'matlab');
    else
        error(['Unsupported platform: ' computer()]);
    end
    
    if(~exist(jarFolder, 'dir'))
        mkdir(jarFolder);
    end
    
    jarPath = fullfile(jarFolder, jarName);
    etagPath = fullfile(jarFolder, jarEtag);
    
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
   
    
    [r,status] = urlread('https://ovation.io/api/v1/sessions', ...
        'POST', {'email', userEmail, 'password', password});
    
    if(status)
        r = ovation.util.parse_json(r);
        session = r{1};
        
        api_key = session.api_key;
        
        [r,status] = urlread('https://ovation.io/api/v1/downloads/Ovation%20Matlab%20API%20Core',...
            'Authentication','Basic',...
            'Username', api_key,...
            'Password', api_key);
        
        if(status)
           r = ovation.util.parse_json(r);
           download_info = r{1};
           
           if(~exist(etagPath, 'file') || ...
                   ~strcmp(ovation.util.read_lines(etagPath),...
                   download_info.etag))
              
               disp('Downloading Ovation Core API...');
               urlwrite(download_info.url, jarPath);
               
               fid = fopen(etagPath, 'w');
               fprintf(fid, download_info.etag);
               fclose(fid);
           end
        end
    end
    
    if(~check_classpath(jarPath))
        firstrun_classpath(jarPath);
        context = [];
        return
    end
    
    if(~exist(jarPath, 'file'))
        error('Ovation Matlab Core API JAR is not available'); %TODO a better error message.
    end
    
    
    disp('Loading Ovation libraries...');
    
    import us.physion.ovation.api.*;
    
    
%     classLoader = ovation_classloader(jarPath);
%     
%     currentThread = Thread.currentThread();
%     currentThread.setContextClassLoader(classLoader);
%     
%     ovationClass = classLoader.loadClass('us.physion.ovation.api.Ovation');
%     strClass = classLoader.loadClass('java.lang.String');
%     connectMethod = ovationClass.getMethod('connect', [strClass, strClass]);
%     versionMethod = ovationClass.getMethod('getVersion', []);
    
    versionString = Ovation.getVersion(); %versionMethod.invoke([], [])
    
    disp(['Ovation Matlab Core API version ' char(versionString)]);
    disp(' ');
    disp('Authenticating...');
    
%     args = javaArray('java.lang.String', 2);
%     args(1) = java.lang.String(userEmail);
%     args(2) = java.lang.String(password);
%     
%     dsc = connectMethod.invoke([], args);
    
    dsc = Ovation.connect(userEmail, password);
    context = dsc.getContext();
end
