% Gets the global class loader for the Ovation Matlab API Core

% Copyright (c) 2013 Physion LLC

function loader = ovation_classloader(ovationJarPath)
    persistent classLoader;
    import java.net.*;
    import java.lang.ClassLoader;
    import java.io.File
    
    if ~usejava('jvm')
        warndlg({'Ovation requires a Java Virtual Machine.',...
            'Please restart Matlab with the JVM enabled.'},...
            'Java Required');
    end
    
    if(isempty(classLoader))
        matlabSystemClassLoader = ClassLoader.getSystemClassLoader();
        systemUrls = matlabSystemClassLoader.getURLs();
        
        % Create a URL classloader with Ovation's Jar at the top
        jarUrl = java.io.File(ovationJarPath).toURI().toURL();
        urls = javaArray('java.net.URL', length(systemUrls) + 1);
        urls(1) = jarUrl;
        for i = 1:length(systemUrls)
            urls(i+1) = systemUrls(i);
        end
        
        classLoader = URLClassLoader(urls, matlabSystemClassLoader.getParent());
        
    end

    loader = classLoader;
    
end

