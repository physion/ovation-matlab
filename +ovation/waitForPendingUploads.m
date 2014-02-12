% Waits for all pending Ovation cloud uploads to complete

function waitForPendingUploads(context)
    fs = context.getFileService();
    while(fs.hasPendingUploads())
        try
            fs.waitForPendingUploads(60, java.util.concurrent.TimeUnit.MINUTES);
        catch e
            timeout = false;
            if(isa(e, 'matlab.exception.JavaException'))
                ex = e.ExceptionObject;
                if(isa(ex, 'java.util.concurrent.TimeoutException'))
                    timeout = true;
                end
            end
            
            if(~timeout)
                rethrow(e);
            end
        end
    end
end
