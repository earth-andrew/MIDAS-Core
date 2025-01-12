function runMIDASExperiment()

clear functions
clear classes

addpath('./Override_Core_MIDAS_Code');
addpath('./Application_Specific_MIDAS_Code');
addpath('./Core_MIDAS_Code');

rng('shuffle');

outputList = {};
series = 'Benchmark_';
saveDirectory = './Outputs/';



fprintf(['Building Experiment List.\n']);

experimentList = {};
experiment_table = table([],[],'VariableNames',{'parameterNames','parameterValues'});

%%%%%%%%%Add specific experiments in the blocks below.  Each new experiment
%%%%%%%%%should mirro what is done below for the 'baseline', updating the
%%%%%%%%%name and adding any additional parameter changes


%%%%baseline

for indexI = 1:100
    experiment = experiment_table;

    experiment = [experiment;{'modelParameters.shortName',  'baseline'}];
    experiment = [experiment;{'modelParameters.runID',  'B'}];

    if rand() < 0.5
        experiment = [experiment; {'modelParameters.shockExperiment', 1}];
    end

    experimentList{end+1} = experiment;

end
%%%%baseline + one hub

for indexI = 1:100
    experiment = experiment_table;
    
    experiment = [experiment;{'modelParameters.shortName',  'one_hub'}];
    experiment = [experiment;{'modelParameters.runID',  'HUB1'}];
    
    if rand() < 0.5
        experiment = [experiment; {'modelParameters.shockExperiment', 1}];
    end

    experimentList{end+1} = experiment;
end
%%%%baseline + multiple hubs

for indexI = 1:100
    experiment = experiment_table;
    
    experiment = [experiment;{'modelParameters.shortName',  'four_hub'}];
    experiment = [experiment;{'modelParameters.runID',  'HUB4'}];

    if rand() < 0.5
        experiment = [experiment; {'modelParameters.shockExperiment', 1}];
    end

    experimentList{end+1} = experiment;
end
%%%%%%%baseline + high moving costs

for indexI = 1:100
    experiment = experiment_table;
    
    experiment = [experiment;{'modelParameters.shortName',  'varying_moving_costs'}];
    experiment = [experiment;{'modelParameters.runID',  'VHM'}];
    experiment = [experiment;{'mapParameters.movingCostPerMile', 0.0100 * rand()}];

    if rand() < 0.5
        experiment = [experiment; {'modelParameters.shockExperiment', 1}];
    end

    experimentList{end+1} = experiment;
end

%%%%%%%baseline + place attachment

for indexI = 1:100
    experiment = experiment_table;
    
    experiment = [experiment;{'modelParameters.shortName',  'varying_place_attachment'}];
    experiment = [experiment;{'modelParameters.runID',  'VPA'}];
    experiment = [experiment;{'modelParameters.placeAttachmentFlag',  1}];
    experiment = [experiment;{'agentParameters.placeAttachmentMean', rand()}];

    if rand() < 0.5
        experiment = [experiment; {'modelParameters.shockExperiment', 1}];
    end

    experimentList{end+1} = experiment;
end

%%%%%%%baseline + high risk aversion

for indexI = 1:100
    experiment = experiment_table;
    
    experiment = [experiment;{'modelParameters.shortName',  'varying_risk_aversion'}];
    experiment = [experiment;{'modelParameters.runID',  'VHR'}];
    experiment = [experiment;{'agentParameters.rValueMean',  rand()}];

    if rand() < 0.5
        experiment = [experiment; {'modelParameters.shockExperiment', 1}];
    end

    experimentList{end+1} = experiment;
end

%%%%%%%baseline + differing development between states

for indexI = 1:100
    experiment = experiment_table;
    
    experiment = [experiment;{'modelParameters.shortName',  'different_development'}];
    experiment = [experiment;{'modelParameters.runID',  'D_Dev'}];
    
    if rand() < 0.5
        experiment = [experiment; {'modelParameters.shockExperiment', 1}];
    end

    experimentList{end+1} = experiment;
end

%%%%%%%baseline + C&A

for indexI = 1:100
    experiment = experiment_table;
    
    experiment = [experiment;{'modelParameters.shortName',  'cap_asp'}];
    experiment = [experiment;{'modelParameters.runID',  'CA'}];
    experiment = [experiment;{'modelParameters.aspirationsFlag',  1}];
    
    if rand() < 0.5
        experiment = [experiment; {'modelParameters.shockExperiment', 1}];
    end

    experimentList{end+1} = experiment;
end
%%%%%%%

experimentList = experimentList(randperm(length(experimentList)));

fprintf(['Saving Experiment List.\n']);
save([saveDirectory 'benchmarks_' date '_input_summary'], 'experimentList');

runList = zeros(length(experimentList),1);
%run the model
parfor indexI = 1:length(experimentList)
%for indexI = 1:length(experimentList)
    if(runList(indexI) == 0)
        input = experimentList{indexI};
        
        %this next line runs MIDAS using the current experimental
        %parameters
        output = midasMainLoop(input, ['Experiment Run ' num2str(indexI)]);
        
        
        functionVersions = inmem('-completenames');
        functionVersions = functionVersions(strmatch(pwd,functionVersions));
        output.codeUsed = functionVersions;
        currentFile = [series num2str(length(dir([series '*']))) '_' datestr(now) '.mat'];
        currentFile = [saveDirectory currentFile];
        
        %make the filename compatible across Mac/PC
        currentFile = strrep(currentFile,':','-');
        currentFile = strrep(currentFile,' ','_');

        saveToFile(input, output, currentFile);
        runList(indexI) = 1;
    end
end

end

function saveToFile(input, output, filename);
    save(filename,'input', 'output');
end
