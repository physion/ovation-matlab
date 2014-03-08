% Gets the units of an Ovation numeric Measurement
%
%     units = units(numericMeasurement);
%
%     numericMeasurement: us.physion.ovation.domain.Measurement
%         Numeric measurement (content type application/x-ovation-numeric)
%

% Copyright (c) 2013 Physion LLC

function u = units(m)
	import us.physion.ovation.domain.NumericDataElements;

data_map = NumericDataElements.getDataMap(m);
if (data_map.keySet().size() == 1)
  key = data_map.keySet().iterator().next();
  u = data_map.get(key).units;
 else
   keys = asarray(data_map.keySet());
   u = [];
  for i=1:keys.size()
    u.append(data_map.get(keys(i)).units)
  end
end

