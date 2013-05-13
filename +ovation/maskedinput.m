function password = maskedinput(prompt)
% Displays a masked password entry field (UI)
%  
%  secret = maskedinput(prompt);
%
%    prompt: UI prompt

% Copyright(c) 2012 Physion Consulting LLC

	num = 1;
	canceled = false;
	if(nargin == 0 || isempty(prompt))
		prompt = 'Enter Password';
	end

	fh = figure(...
	'Visible', 'off', ...
	'Name', prompt, ...
	'NumberTitle', 'off', ...
	'Units', 'Pixels', ...
	'Position', [0, 0, 200, 50], ...
	'Toolbar', 'none', ...
	'Menubar', 'none', ...
	'CloseRequestFcn', @closeRequestedFcn, ...
	'WindowStyle', 'modal', ...
	'KeyPressFcn', @maskedKeyPressFcn);

	th = uicontrol(...
	'Style', 'edit', ...
	'Units', 'Pixels', ...
	'Position', [10, 10, 180, 25], ...
	'BackgroundColor', 'white', ...
	'Enable', 'inactive', ...
	'String', '', ...
	'FontName', 'FixedWidth', ...
	'FontSize', 10);

	movegui(fh, 'center');
	set(fh, 'Visible', 'on');

	% Default password
	password = '';

	uiwait(fh);
	drawnow;

	if canceled
		password = '';
		return;
	end


	function closeRequestedFcn(obj, edata) %#ok<INUSD>
		canceled = true;
		delete(obj);
	end

	function maskedKeyPressFcn(obj, edata)
		switch edata.Key
		case 'return'
			delete(obj);
			return;
		case 'escape'
			canceled = true;
			delete(obj);
			return;
		case {'backspace', 'delete'}
			if ~isempty(password)
				password(end) = '';
			end
		otherwise
			c = edata.Character;
			if ~isempty(c)
				if c >= '!' && c <= '}'
					password = [password, c];
				else
					disp('Unrecognized character');
				end
			end
		end

		set(th, 'String', [repmat('*', 1, length(password))]);
		drawnow;
	end

end