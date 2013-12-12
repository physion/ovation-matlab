% Copyright (c) 2012 Physion Consulting LLC
function out = isWindowsAdmin()
	%isWindowsAdmin True if this user is in admin role.
	
    wi = System.Security.Principal.WindowsIdentity.GetCurrent();
    wp = System.Security.Principal.WindowsPrincipal(wi);
    out = wp.IsInRole(System.Security.Principal.WindowsBuiltInRole.Administrator);
end