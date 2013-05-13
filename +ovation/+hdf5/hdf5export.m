function hdf5export(filename, context, iteratorOrCellArray, overwrite)
% hdf5export('filename', context, iteratorOrCellArray)
%
%  Exports to hdf5 all the data relevant to the set of Objects specified by the given iterator or cell array,
%  overwriting any existing file. This includes data about objects not
%  included in the set - i.e. Epochs for a given Experiment, Responses for
%  a given Epoch.

	import ovation.*;
	
   if nargin <4
        overwrite = false;
    end
    
    if exist(filename, 'file') 
        if overwrite
            delete(filename)
        else
            err = MException('Ovation:FileExists', ...
            ['To overwrite the file "' filename '", pass an optional boolean argument true']);
            throw(err)
        end
    end
    
    fopen(filename, 'w');
    
	objs = context.tohdf5(iteratorOrCellArray);
    
    for i=1:objs.size()
        data = format(objs(i).getObjectDataset);
        details = ovation.map2struct(objs(i).getObjectDatasetDetails);
        hdf5write(filename, details, data, 'WriteMode', 'append');
    end
        
    for i=1:objs.size()
        attr = objs(i).getAttributes();
        for j=1:attr.size()
            details = ovation.map2struct(attr(j).details);
            data = format(attr(j).data);
            hdf5write(filename, details, data, 'WriteMode', 'append');
        end
        
        datasets = objs(i).getDatasets();
        for j=1:datasets.size()
            details = ovation.map2struct(datasets(j).details);
            
            data = format(datasets(j).data);
            hdf5write(filename, details, data, 'WriteMode', 'append');
        end
    end
    
    function data = format(data)
        if (strcmp(class(data), 'java.util.HashMap') || strcmp(class(data), 'java.util.Collections$UnmodifiableMap'))
            data = ovation.map2struct(data);
            names = fieldnames(data);
            for c1=1:size(names, 1)
                data.(names{c1}) = format(data.(names{c1}));
            end
        elseif (strcmp(class(data), 'java.lang.String[]'))
            for c2=1:data.length
                stringData(c2) = hdf5.h5string(char(data(c2))); %#ok<AGROW>
            end
            data = stringData;
        elseif(iscell(data) || (isnumeric(data) && (size(data, 1)>1 || size(data, 2)>1)))
            data = hdf5.h5array(data);
        elseif (strcmp(class(data), 'java.lang.String'))
            data = hdf5.h5string(char(data));    
        end
    end
        
	
end
