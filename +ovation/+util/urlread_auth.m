function [s,info] = urlread_auth(javaUrl, user, password)
    %URLREAD_AUTH Like URLREAD, with basic authentication
    %
    % [s,info] = urlread_auth(url, user, password)
    %
    %
    % Examples:
    % sampleUrl = 'http://ovation.io/123';
    % [s,info] = urlread_auth(sampleUrl, 'test', 'test');
    
    % Originally from http://stackoverflow.com/a/1323535/2140
    
    
    javaUrl = java.net.URL(javaUrl);
    conn = javaUrl.openConnection();
    
    encoder = sun.misc.BASE64Encoder();
    authString = [user ':' password];
    auth = char(encoder.encode(java.lang.String(authString).getBytes()));
    conn.setRequestProperty('Authorization', ['Basic ' auth]);\
    
    conn.connect();
    
    info.status = conn.getResponseCode();
    info.errMsg = char(readstream(conn.getErrorStream()));
    
    s = char(readstream(conn.getInputStream()));
end

%%
function out = readstream(inStream)
    %READSTREAM Read all bytes from stream to uint8
    try
        import com.mathworks.mlwidgets.io.InterruptibleStreamCopier;
        bos = java.io.ByteArrayOutputStream();
        isc = InterruptibleStreamCopier.getInterruptibleStreamCopier();
        isc.copyStream(inStream, bos);
        inStream.close();
        bos.close();
        out = typecast(bos.toByteArray', 'uint8'); %'
    catch err
        out = []; %HACK: quash
    end
end
