% Make a Java URL for a file path
%
%    url = fileUrl('/path/to/my/file');
%
%  path: string
%    File path (must be absolute)
%
%  return: URL
%    java.net.URL (i.e. 'file://...') corresponding to the given path

function url = fileUrl(filePath)

    url = java.net.URL(['file://' filePath]);
end