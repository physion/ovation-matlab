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
		value = convertValue(mapEntry.getValue());
        
        
		
		if(length(value) == 1 && ~ischar(value))
			value = value(1);
		end
		
		mlKey = char(key);
		
		% Replace obviously illegal field characters
		mlKey(strfind(mlKey,'-')) = '_';

        fname = mlKey; %genvarname(mlKey)

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

function value = convertValue(value)
    if(isjava(value))
        List = ovation.javaClass('java.util.List');
        String = ovation.javaClass('java.lang.String');
        
        if(String.isAssignableFrom(value.getClass()))
            value = char(value);
        elseif(List.isAssignableFrom(value.getClass()))
            m = value.toArray().cell;
            if(any(cellfun(@isjava, m)))
                for i = 1:length(m)
                    if(isjava(m{i}))
                        m{i} = convertValue(m{i});
                    end
                end
                
                if(any(cellfun(@iscell, m)))
                    value = m;
                else
                    value = cell2mat(m);
                end
            else
                if(iscellstr(m))
                    value = m';
                else
                    value = cell2mat(m');
                end
            end
            
            
        end
    end
end
