function m = keyValueStruct(keysAndValues)
% Create a java.util.Map given a struct of keys and values
	
% Copyright (c) 2012 Physion Consulting LLC


	warning('ovation:deprecation', 'keyValueStruct is deprecated and will be removed in a future version of Ovation. Please use ovation.struct2map instead.');

	m = ovation.struct2map(keysAndValues);
end
