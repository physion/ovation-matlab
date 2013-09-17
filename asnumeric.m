% Retrieves a Map of NumericData.Data instances from an Ovation numeric
% Measurement
%
%     map = asnumeric(numericMeasurement);
%     
%     numericMeasurement: us.physion.ovation.domain.Measurement
%         Numeric measurement (content type application/x-ovation-numeric)
%         

% Copyright (c) 2013 Physion LLC

function data_map = asnumeric(m)
    import us.physion.ovation.domain.NumericDataElements;
    
    data_map = NumericDataElements.getDataMap(m);
end