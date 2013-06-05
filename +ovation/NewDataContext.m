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
    
    narginchk(0,2);
    
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
    
    disp('Authenticating...');
    dsc = Ovation.connect(userEmail, password);
    
    context = dsc.getContext();
end