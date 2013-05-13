function context = NewDataContext(connection_file, varargin)
% Creates a new ovation.DataContext with a connection to the specified
% connection file. Prompts for the user password.
%
%  context = NewDataContext(path_to_connection_file, [username]);
%
%    connection_file: path to Ovation connection file
%    username (optional): Ovation username for authenticating the 
%                         new DataContext
%

% Copyright (c) 2012 Physion Consulting LLC


    error(nargchk(1,2, nargin)); %#ok<NCHKN>
    
    if(nargin < 2)
        username = '';
    else
        username = varargin{1};
    end
    
	import ovation.*;
    import com.physion.ovation.ui.*
    
    if(isempty(strfind(connection_file, '::')))
        f = java.io.File(connection_file);
        if(~f.isAbsolute())
            fullPath = fullfile(pwd(), connection_file);
            f = java.io.File(fullPath);
            connection_file = f.getCanonicalPath();
        end
    end
    
    model = DatabaseCredentialsModel(username);
    if(DatabaseCredentialsDialog.showCredentialsDialog(model))
        context = Ovation.connect(connection_file,...
            model.getUsername(),...
            java.lang.String(model.getPassword()));
    else
        context = [];
    end
end