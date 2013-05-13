function [experiment,isNew] = experimentForInsertion(project,...
		year, ...
		month,...
		day,...
		timezone,...
		purpose, ...
		hr, ...
		min,...
		sec,...
        options)
% Find or create a Experiment for insertion, prompting user to select from the
% existing experiments with the given start date. If none are found, insert a new
% experiment, prompting for exact start date and purpose, unless provided
% as optional parameters.
%
%   [experiment, isNew] = experimentForInsertion(project,
%                                                year,
%                                                month,
%                                                day,
%                                                timezone,
%                                                [purpose],
%                                                [hr, min, sec])
%                
%    project: Containing project
%    year: Experiment year (e.g. 2011)
%    month: Experiment month (1-12)
%    day: Experiment day of month
%    timezone: Experiment time zone name (e.g. America/New_York)
%    purpose (optional): Experiment purpose if inserting a new Experiment
%    hr,min,sec (optional): Experimne start time hour (0-24), minute (0-60) and 
%      second (0-60) if inserting a new Experiment.


    % Copyright (c) 2012 Physion Consulting LLC
    
    defaultOptions.chooseSingle = false;
    
    if(nargin > 9)
        options = ovation.mergeStruct(defaultOptions, options);
    else
        options = defaultOptions;
    end
    
	experiments = project.getExperiments(year, month, day, timezone);
	
    experiment = [];
    isNew = false;
    if(~isempty(experiments))
        if(options.chooseSingle && length(experiments) == 1)
            experiment = experiments(1);
        else
            disp(['Existing experiment(s) on date ' num2str(year) '-' num2str(month)...
                '-' num2str(day) ' (' timezone '): ']);
            for i=1:length(experiments)
                disp(['  ' num2str(i) '. ' char(experiments(i).getPurpose())...
                    ' (Owner: ' char(experiments(i).getOwner().getUsername()) ')']);
            end
            
            disp(['  ' num2str(i+1) '. Insert new experiment...']);
            
            targetExp = -1;
            while (targetExp < 1 || targetExp > (length(experiments) + 1))
                targetExp = input(['Import data into experiment [1-' num2str(i+1) ']: ']);
            end
            
            if(targetExp <= length(experiments))
                disp('  Choosing existing experiment');
                experiment = experiments(targetExp);
            else
                experiment = [];
            end
        end
    end
    
    if(isempty(experiment))
        if(nargin <= 6)
            startTime = input('Experiment start time (hh:mm:ss): ', 's');
            timeComps = textscan(startTime, '%d:%d:%d');
            hr = timeComps{1};
            min = timeComps{2};
            sec = timeComps{3};
            assert(~isempty(hr) && ~isempty(min) && ~isempty(sec), ...
                'Unable to parse experiment start time.');
            
        else
            assert(nargin >= 9, 'Missing start time hour/min/sec arguments.');
        end
        
        if(nargin <= 5)
            purpose = input('Experiment purpose:\n  ', 's');
        end
        
        disp('  Inserting new experiment.')
        experiment = project.insertExperiment(purpose, ovation.datetime(year,month,day,hr,min,sec,0,timezone));
        experiment.addProperty('timezone', timezone);
        
        isNew = true;
    end
end