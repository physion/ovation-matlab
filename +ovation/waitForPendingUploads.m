% Waits for all pending Ovation cloud uploads to complete

function waitForPendingUploads(context)
    fs = context.getFileService();
    while(fs.hasPendingUploads())
        fs.waitForPendingUploads(60, java.util.concurrent.TimeUnit.MINUTES);
    end
end