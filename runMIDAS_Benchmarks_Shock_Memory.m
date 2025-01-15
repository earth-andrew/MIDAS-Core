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

    experiment = [experiment;{'agentParameters.discountRateMean',  rand() * 0.2}];
    experiment = [experiment;{'agentParameters.numPeriodsEvaluateMean',  round(rand() * 20)}];
    experiment = [experiment;{'agentParameters.numPeriodsMemoryMean',  round(rand() * 20)}];
    
    experiment = [experiment; {'modelParameters.shockExperiment', randperm(3,1) - 1}];
    

    experimentList{end+1} = experiment;

end
%%%%baseline + one hub

for indexI = 1:100
    experiment = experiment_table;
    
    experiment = [experiment;{'modelParameters.shortName',  'one_hub'}];
    experiment = [experiment;{'modelParameters.runID',  'HUB1'}];


    experiment = [experiment;{'agentParameters.discountRateMean',  rand() * 0.2}];
    experiment = [experiment;{'agentParameters.numPeriodsEvaluateMean',  round(rand() * 20)}];
    experiment = [experiment;{'agentParameters.numPeriodsMemoryMean',  round(rand() * 20)}];

    experiment = [experiment; {'modelParameters.shockExperiment', randperm(3,1) - 1}];

    experimentList{end+1} = experiment;
end
%%%%baseline + multiple hubs

for indexI = 1:100
    experiment = experiment_table;
    
    experiment = [experiment;{'modelParameters.shortName',  'four_hub'}];
    experiment = [experiment;{'modelParameters.runID',  'HUB4'}];

        experiment = [experiment;{'agentParameters.discountRateMean',  rand() * 0.2}];
    experiment = [experiment;{'agentParameters.numPeriodsEvaluateMean',  round(rand() * 20)}];
    experiment = [experiment;{'agentParameters.numPeriodsMemoryMean',  round(rand() * 20)}];


    experiment = [experiment; {'modelParameters.shockExperiment', randperm(3,1) - 1}];

    experimentList{end+1} = experiment;
end
%%%%%%%baseline + high moving costs

for indexI = 1:100
    experiment = experiment_table;
    
    experiment = [experiment;{'modelParameters.shortName',  'varying_moving_costs'}];
    experiment = [experiment;{'modelParameters.runID',  'VHM'}];
    experiment = [experiment;{'mapParameters.movingCostPerMile', 0.0100 * rand()}];

        experiment = [experiment;{'agentParameters.discountRateMean',  rand() * 0.2}];
    experiment = [experiment;{'agentParameters.numPeriodsEvaluateMean',  round(rand() * 20)}];
    experiment = [experiment;{'agentParameters.numPeriodsMemoryMean',  round(rand() * 20)}];


    experiment = [experiment; {'modelParameters.shockExperiment', randperm(3,1) - 1}];

    experimentList{end+1} = experiment;
end

%%%%%%%baseline + place attachment

for indexI = 1:100
    experiment = experiment_table;
    
    experiment = [experiment;{'modelParameters.shortName',  'varying_place_attachment'}];
    experiment = [experiment;{'modelParameters.runID',  'VPA'}];
    experiment = [experiment;{'modelParameters.placeAttachmentFlag',  1}];
    experiment = [experiment;{'agentParameters.placeAttachmentMean', rand()}];

        experiment = [experiment;{'agentParameters.discountRateMean',  rand() * 0.2}];
    experiment = [experiment;{'agentParameters.numPeriodsEvaluateMean',  round(rand() * 20)}];
    experiment = [experiment;{'agentParameters.numPeriodsMemoryMean',  round(rand() * 20)}];


    experiment = [experiment; {'modelParameters.shockExperiment', randperm(3,1) - 1}];

    experimentList{end+1} = experiment;
end

%%%%%%%baseline + high risk aversion

for indexI = 1:100
    experiment = experiment_table;
    
    experiment = [experiment;{'modelParameters.shortName',  'varying_risk_aversion'}];
    experiment = [experiment;{'modelParameters.runID',  'VHR'}];
    experiment = [experiment;{'agentParameters.rValueMean',  rand()}];

        experiment = [experiment;{'agentParameters.discountRateMean',  rand() * 0.2}];
    experiment = [experiment;{'agentParameters.numPeriodsEvaluateMean',  round(rand() * 20)}];
    experiment = [experiment;{'agentParameters.numPeriodsMemoryMean',  round(rand() * 20)}];


    experiment = [experiment; {'modelParameters.shockExperiment', randperm(3,1) - 1}];

    experimentList{end+1} = experiment;
end

%%%%%%%baseline + differing development between states

for indexI = 1:100
    experiment = experiment_table;
    
    experiment = [experiment;{'modelParameters.shortName',  'different_development'}];
    experiment = [experiment;{'modelParameters.runID',  'D_Dev'}];

        experiment = [experiment;{'agentParameters.discountRateMean',  rand() * 0.2}];
    experiment = [experiment;{'agentParameters.numPeriodsEvaluateMean',  round(rand() * 20)}];
    experiment = [experiment;{'agentParameters.numPeriodsMemoryMean',  round(rand() * 20)}];


    experiment = [experiment; {'modelParameters.shockExperiment', randperm(3,1) - 1}];

    experimentList{end+1} = experiment;
end

%%%%%%%baseline + C&A

for indexI = 1:100
    experiment = experiment_table;
    
    experiment = [experiment;{'modelParameters.shortName',  'cap_asp'}];
    experiment = [experiment;{'modelParameters.runID',  'CA'}];
    experiment = [experiment;{'modelParameters.aspirationsFlag',  1}];

        experiment = [experiment;{'agentParameters.discountRateMean',  rand() * 0.2}];
    experiment = [experiment;{'agentParameters.numPeriodsEvaluateMean',  round(rand() * 20)}];
    experiment = [experiment;{'agentParameters.numPeriodsMemoryMean',  round(rand() * 20)}];


    experiment = [experiment; {'modelParameters.shockExperiment', randperm(3,1) - 1}];

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
