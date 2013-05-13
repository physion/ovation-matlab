% Copyright (c) 2012 Physion Consulting LLC

function linesep = platform_linesep()
	if(isequal(computer,'PCWIN'))
		linesep = '\r\n';
	else
		linesep = '\n';
	end
end