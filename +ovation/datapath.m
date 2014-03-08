function p = datapath(data_element)
% Returns the path to a Measurement or AnalsysiOutput 
% data element's locally cached copy. If the data is not available locally,
% the data is retrieved from cloud storage.
%
%   path = datapath(data_element)
	
% Copyright (c) 2014 Physion Consulting LLC


    p = data_element.getLocalDataPath().get();
end