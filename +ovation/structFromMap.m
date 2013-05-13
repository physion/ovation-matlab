function s = structFromMap(map)
% Builds a Matlab struct from a java.util.Map with array values.
% Singleton items are converted to scalars.
%
%  s = structFromMap(map)
%
%    map: java.util.Map<String,Object[]>
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
% >> map
%  
% map =
%  
% {key4=false, key3=abc, key5=[D@25972a5b, key2=1.0, key1=10.0}
%  
% >> s = structFromMap(map);
% >> orderfields(s)
% 
% ans = 
%     illegal_field_name: [2x1 double]
%     key1: 10
%     key2: 1
%     key3: 'abc'
%     key4: 0

% Copyright (c) 2012 Physion Consulting LLC

	
	warning('ovation:deprecation', 'structFromMap is deprecated and will be removed in a future version of Ovation. Please use ovation.map2struct instead.');

	s = ovation.map2struct(map);
end