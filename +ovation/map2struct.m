function s = map2struct(map)
% Builds a Matlab struct from a java.util.Map.
% Singleton items are converted to scalars.
%
%  s = map2struct(map)
%
%    map: java.util.Map<String,Object[]>
%
% String values "<empty>" are converted to Matlab's empty array ([]).
% Nested structs are reconstituted by substituting "__" => "." in field
% names. For example, "field1__field2" : value will be reconstituted as
% field1.field2 = value.
%
%
% Example Usage
% -------------
% >> map = java.util.HashMap();
% >> map.put('key1', 10);
% >> map.put('key2',[1]);
% >> map.put('key3', 'abc');
% >> map.put('key4',false);
% >> map.put('illegal-field-name',[1,2]);
% >> map.put('field1__embeddedfield', 5);
% >> map
%  
% map =
%  
% {key4=false, key3=abc, key5=[D@25972a5b, key2=1.0, key1=10.0, field1__embeddedfield=5.0}
%  
% >> s = map2struct(map);
% >> orderfields(s)
% 
% ans = 
%     field1: [1x1 struct]
%     illegal_field_name: [2x1 double]
%     key1: 10
%     key2: 1
%     key3: 'abc'
%     key4: 0

% Copyright (c) 2012 Physion Consulting LLC


    s = struct();
    
	itr = map.entrySet().iterator();
	while(itr.hasNext())
		mapEntry = itr.next();
		key = mapEntry.getKey();
		value = mapEntry.getValue();
		
		if(length(value) == 1 && ~ischar(value))
			value = value(1);
		end
		
		mlKey = char(key);
		
		% Replace obviously illegal field characters
		mlKey(strfind(mlKey,'-')) = '_';
        mlKey = strrep(mlKey, '.', '__');

        fname = mlKey;
%         fname = genvarname(mlKey);
        
        % struct2map represents nested structs with __.
        % Substitute __ => ., so that eval() will reconstitute
        % the nested struct.
        fname = strrep(fname, '__', '.');
        
        % Strip trailing .
        if(fname(end) == '.')
            fname = fname(1:end-1);
        end
        
        if(ischar(value) && strcmp(value, '<empty>'))
            % Replace <empty> with [], reversing struct2map
            eval(['s.' fname '= [];']);
        else
            eval(['s.' fname '= value;']);
        end
	end
end