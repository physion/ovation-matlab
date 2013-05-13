function m = keyValueMap(keys, values)
	% Create a java.util.Map given a set of keys and values
	
    % Copyright (c) 2012 Physion Consulting LLC


	warning('ovation:deprecation', 'keyValueMap is deprecated and will be removed in a future version of Ovation. Please use ovation.struct2map instead.');

	m = ovation.struct2map(cell2struct(values, keys, 2));
end
