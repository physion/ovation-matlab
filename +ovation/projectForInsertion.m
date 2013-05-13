function [project, isNew] = projectForInsertion(ctx, projectName, varargin)
	% Find or create a Project for insertion, prompting user to select from the
	% existing projects with the given name. If none are found, insert a new
	% project, prompting for start date and purpose, unless provided as
	% optional arguments.
	%
	%   [project, isNew] = projectForInsertion(dataContext,
	%                                          projectName,
	%                                          [projectStartDate],
	%                                          [projectPurpose])
	%
	%	dataContext: ovation.DataContext instance
	%	projectName: name of project for insertion
	% 	projectStartDate: yyyy/mm/dd date string (e.g. '2011/12/31') for 
	%		project start date if no project with given name currently exists
	%	projectPurpose: if no project with given name exists, purpose for 
	%		newly inserted project

    % Copyright (c) 2012 Physion Consulting LLC


	projects = ctx.getProjects(projectName);
	if(length(projects) > 1)
		disp(['Multiple project with name ' projectName ':']);
		for i=1:length(projects)
			disp([num2str(i) '. ' char(projects(i).getStartTime().toString())]);
		end
		
		targetProject = -1;
		while (targetProject < 1 || targetProject > length(projects))
			targetProject = input('Import data into project: ');
		end
		
		project = projects(targetProject);
		isNew = false;
	elseif(length(projects) == 1)
		project = projects(1);
		isNew = false;
	else
		% Create a new project
		if(nargin >= 3)
			projectStart = varargin{1};
		else
			projectStart = input('Project start date (yyyy/mm/dd): ', 's');
		end
		
		dateComps = textscan(projectStart, '%d/%d/%d');
		year = dateComps{1};
		month = dateComps{2};
		day = dateComps{3};
		
		assert(~isempty(year) && ~isempty(month) && ~isempty(day), ...
			'Unable to parse project start date.');
		
		if(nargin >= 4)
			purpose = varargin{2};
		else
			purpose = input('Project purpose:\n  ', 's');
		end
		
		project = ctx.insertProject(projectName, purpose, ovation.datetime(year, month, day));
		isNew = true;
	end
end