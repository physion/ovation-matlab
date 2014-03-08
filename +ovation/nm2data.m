% Converts an Ovation numeric Measurement or analysis output to a struct 
% of vector/matrix entries by data element name.

% Copyright (c) 2013 Physion Consulting LLC

function m = nm2data(nm)
    import ovation.*;
    
    data_map = asnumeric(nm);
    
    keys = asarray(data_map.keySet());
    m = struct();
    
    for i = 1:length(keys)
        name = keys(i);
        data = data_map.get(name);
        field = strrep(name, ' ', '_');
        m.(genvarname(field)) = data.dataArray.copyToNDJavaArray();
    end
end
    