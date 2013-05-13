function elements = splitString(str, tokens)
    % Splits a string on given tokens
	
% Copyright (c) 2012 Physion Consulting LLC


	elements = {};
	
	r = str;
	token = str;
	while ~isempty(r)
		[token,r] = strtok(token, tokens);
		if(~isempty(token))
			elements{end+1} = token; %#ok<AGROW>
		end
		
	end
end