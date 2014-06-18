function contentType = content_type(path)
    %Guesses the content type (MIME type) of a file from its path
    %   This method uses Java's URLConnection known content types plus
    %   several manually defined mappings to guess the correct content type
    %   for a file from its file name.
    
    
    import com.google.common.collect.Maps;
    import java.io.File;
    import java.io.IOException;
    import java.net.URLConnection;
    import java.util.Map;
    import org.apache.commons.io.FilenameUtils;
    
    contentType = URLConnection.guessContentTypeFromName(path);
    if isempty(contentType)
        customContentTypes = Maps.newHashMap();
        
        customContentTypes.put('doc', 'application/msword');
            customContentTypes.put('docx', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document');

            customContentTypes.put('xls', 'application/vnd.ms-excel');
            customContentTypes.put('xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

            customContentTypes.put('ppt', 'application/vnd.ms-powerpoint');
            customContentTypes.put('pptx', 'application/vnd.openxmlformats-officedocument.presentationml.presentation');

            customContentTypes.put('csv', 'text/csv');

            customContentTypes.put('tif', 'image/tiff');
            customContentTypes.put('tiff', 'image/tiff');

            customContentTypes.put('lsm', 'image/tiff');
            
            customContentTypes.put('mat', 'application/vnd.matlab-octet-stream');
            
            customContentTypes.put('pdf', 'application/pdf');
            
            
            extension = FilenameUtils.getExtension(path);
            if customContentTypes.containsKey(extension)
                contentType = customContentTypes.get(extension);
            else
                contentType = 'application/octet-stream'; % fallback to binary
            end
end

