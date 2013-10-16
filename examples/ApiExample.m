%% Connect to the Ovation database

ctx = NewDataContext();

%% Create a project
import ovation.*

projectName = 'Api Example';
projectPurpose = 'Learning Ovation';

% You can use datetime() to make a timestamp at the current instant, or you
% can provide year,month,day,etc. as arguments to create a timestamp in the
% past (or future). 
project = ctx.insertProject(projectName, projectPurpose, datetime());


%% Add/find a Source

% See if there are already sources with the label and id
label = 'mouse';
source_id = 'mouse-id-number'; % e.g. the mouse's ID in the facility database

% Ovation methods that return more than one item return an Iterator that
% can iterate through the (maybe very large) result set. If you want a
% Matlab array, use the asarray function.
sources = asarray(ctx.getSources(label, source_id));
if(isempty(sources))
    source = ctx.insertSource(label, source_id);
    % Add source properties
    source.addProperty('sex', 'F');
    % etc.
else
    % Assume there's only one source with that label and ID
    source = sources(1);
end


%% Insert an experiment

% Is the experiment already added to project?
experiments = asarray(project.getExperiments());

expDescription = 'Demo Experiment';

% You'll probably want to parse the FIRA{1}.plx.date field for the
% experiment start time.
experiment = project.insertExperiment(expDescription, datetime());

% Set the equipment setup for this project.
%
% Equipment setup is a map of "hierarchical" equipment attributes (allowing multiple
% roots), with the hierarchy represented by "dotted notation". For example:
% 
% rig.amplifier.manufacturer = 'Acme';
% rig.monitor.manufacturer = 'Samsung';
% rig.headstage.channel_1.name = 'WB01';
% 
% for devices "rig.amplifier", "rig.monitor", and "rig.headstage.channel_1", etc.

equipment.rig.amplifier.manufacturer = 'Acme';
equipment.rig.amplifier.channel_1.headstage.name = 'HS1';
equipment.rig.amplifier.channel_2.headstage.name = 'HS2';
equipment.microscope.manufacturer = 'Zeiss';


experiment.setEquipmentSetupFromMap(struct2map(equipment));

%% Add an EpochGroup to group trials

groupLabel = 'block 1';
group = experiment.insertEpochGroup(groupLabel,...
    experiment.getStart(),... % first EpochGroup in the experiment, or use datetime()
    [], ... % No group-level protocol
    [], ... % No group-level parameteres
    []); % No group-level device parameters


%% Define the Protocol for trials

protocolName = 'Experiment Demo Protocol';
protocol = ctx.getProtocol(protocolName);

if(isempty(protocol))
    % The Protocol document would describe the protocol in detail,
    % including protocol "variables" called protocol parameters, which we
    % denote by convention as {VARIABLE_NAME} within the protocol document.
    protocol = ctx.insertProtocol(protocolName, '...Protocol Document...');
end

%% Insert an Epoch

protocolParameters = struct();
protocolParameters.param1 = 1; % Set protocol parameters

deviceParameters = struct();
deviceParameters.rig.amplifier.channel_1.gain = 10; % Variable device settings, using EquipmentSetup key prefixes
deviceParameters.rig.amplifier.channel_2.gain = 100;

epoch = group.insertEpoch(datetime(),... % Start
    datetime(),... %End
    protocol,...
    struct2map(protocolParameters),...
    struct2map(deviceParameters));

%% Add a numeric measurement

% Assign the monkey Source to this Epoch with a local name of "subject"
epoch.addInputSource('subject', source);

samplingRateHz = 10000;

data = us.physion.ovation.values.NumericData();
data.addData('channel_1',...
        random(1,1000),... % real data would go here!
        'units',... % units of measure
        samplingRateHz,... % sampling rate
        'Hz'); % sampling rate units
data.addData('channel_2',...
    random(1,1000),... % real data would go here!
    'units',... % units of measure
    samplingRateHz,... % sampling rate
    'Hz'); % sampling rate units

epoch.insertNumericMeasurement('measurement-name',...
    array2set({'subject'}),...
    array2set({'rig.amplifier.channel_1', 'rig.amplifier.channel_2'}),... % Uses EquipmentSetup names to describe devices
    data);
    

%% Get the measurement data for channel 2

measurement = epoch.getMeasurement('measurement-name');

% Get info about the numeric measurement
numericMeasurement = asnumeric(measurement);
units = numericMeasurement.get('channel 2').units;
srate = numericMeasurement.get('channel 2').samplingRates;

% Get the numeric data as a struct
data = nm2data(measurement);
time = (1:length(data.channel_2)) / srate;
plot(time, data.channel_2);
ylabel([char(measurement.getName()) ' (' char(units) ')']);
xlabel('Time (s)');

