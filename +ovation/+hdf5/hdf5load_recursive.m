% Recursively load an HDF5 hierarchy
%
%   datastruct = hdf5load_recursive(datastruct,h5group)
%
%   Walks the group hierarchy of given h5 info structure and returns a
%   Matlab parallel structure .
%
%   Parameters
%     datastruct: Matlab struct to insert into
%     h5group: HDF5 group object


% Author: Barry Wark <barry@physionconsulting.com>
% Copyright (c) 2011, Physion Consulting LLC

% Original author
% Author: Gael Varoquaux <gael.varoquaux@normalesup.org>
% Copyright: Gael Varoquaux
% License: BSD-like

function datastruct = hdf5load_recursive(datastruct, h5group)
	import ovation.*;
	% Load the datasets (the leafs of the tree):
	for i = 1:numel(h5group.Datasets)
		[data, ~] = hdf5read(h5group.Datasets(i), 'ReadAttributes', true);
		
		attr = struct;
		attributes = h5group.Attributes;
		for count=1:size(attributes, 2)
			v = attributes(count).Value;
			
			value = digestData(v);
			
			shortname = removeUnwantedCharacters(attributes(count).Shortname);
			
			attr.(shortname) = value;
			
		end
		
		data = digestData(data);
		
		[~, name, ~] = fileparts(h5group.Datasets(i).Name);
		
		name = removeUnwantedCharacters(name);
		
		if(~isempty(attr))
			datastruct.(name).data = data;
			datastruct.(name).attr = attr;
		else
			datastruct.(name) = data;
		end
	end
	
	% Then load the branches:
	% Create structures for the group and pass them on recursively:
	for i = 1:numel(h5group.Groups)
		[~, name, ~] = fileparts(h5group.Groups(i).Name);
		disp(['Loading ' name '...']);
		
		groupname = removeUnwantedCharacters(name);
		datastruct.(genvarname(groupname)) = hdf5.hdf5load_recursive(struct(),h5group.Groups(i));%%
	end
	
	
end

%%%only letters digits and underscores are allowed, it must begin with
%%%a letter
function ret = removeUnwantedCharacters(name)
	ret = regexprep(name, '-', '');
	ret = regexprep(ret, '!', '');
end

function ret = digestData(data)
	switch class(data)
		case 'hdf5.h5string'
			ret = h5string(data);
		case 'hdf5.h5array'
			ret = h5array(data);
		case 'hdf5.h5compound'
			ret = h5compound(data);
		case 'double'
			ret = data;
		case 'single'
			ret = data;
		otherwise
			disp('Did not import correctly!');
	end
end

function ret = h5string(data)
	try
		if size(data,2)>1
            ret = {};
            for j=1:size(data,1)
                for k=1:size(data,2)
                    % Put in row major order
                    ret{k,j}=data(j,k).Data; %#ok<AGROW>
                end
            end
        else
            ret = data.Data;
        end
		
	catch %#ok<CTCH>
	end
end

function ret = h5array(data)
	try
		if size(data,2)>1
			
			ret = {};
			for j=1:size(data,1)
				for k=1:size(data,2)
					% Put in row major order
					ret{k,j}=data(j,k).Data; %#ok<AGROW>
				end
			end
		else
			ret=data.Data;
		end
	catch %#ok<CTCH>
	end
end

function ret = h5compound(data)
	ret = struct;
	
	for c=1:size(data.MemberNames, 2)
		if strcmp(class(data.Data{c}), 'hdf5.h5string')
			d = h5string(data.Data{c});
		elseif strcmp(class(data.Data{c}), 'hdf5.h5array')
			d = h5array(data.Data{c});
		else
			d = data.Data(c);
		end
		ret.(data.MemberNames{c}) = d;
	end
	
end







