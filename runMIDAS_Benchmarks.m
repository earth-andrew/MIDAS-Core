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

experiment = experiment_table;

experiment = [experiment;{'modelParameters.shortName',  'baseline'}];
experiment = [experiment;{'modelParameters.runID',  'B'}];

experimentList{end+1} = experiment;

%%%%baseline + one hub

experiment = experiment_table;

experiment = [experiment;{'modelParameters.shortName',  'one_hub'}];
experiment = [experiment;{'modelParameters.runID',  'HUB1'}];

experimentList{end+1} = experiment;

%%%%baseline + multiple hubs

experiment = experiment_table;

experiment = [experiment;{'modelParameters.shortName',  'four_hub'}];
experiment = [experiment;{'modelParameters.runID',  'HUB4'}];

experimentList{end+1} = experiment;
%%%%%%%baseline + high moving costs

experiment = experiment_table;

experiment = [experiment;{'modelParameters.shortName',  'baseline_high_moving'}];
experiment = [experiment;{'modelParameters.runID',  'B_HM'}];
experiment = [experiment;{'mapParameters.movingAdminCosts',  [1000; 2000; 4000; 8000]}];

experimentList{end+1} = experiment;

%%%%%%%baseline + high risk aversion

experiment = experiment_table;

experiment = [experiment;{'modelParameters.shortName',  'baseline_high_risk_aversion'}];
experiment = [experiment;{'modelParameters.runID',  'B_HR'}];
experiment = [experiment;{'agentParameters.rValueMean',  0.2}];

experimentList{end+1} = experiment;

%%%%%%%baseline + differing development between states

experiment = experiment_table;

experiment = [experiment;{'modelParameters.shortName',  'different_development'}];
experiment = [experiment;{'modelParameters.runID',  'D_Dev'}];

experimentList{end+1} = experiment;

%%%%%%%baseline + C&A

experiment = experiment_table;

experiment = [experiment;{'modelParameters.shortName',  'cap_asp'}];
experiment = [experiment;{'modelParameters.runID',  'CA'}];
experiment = [experiment;{'modelParameters.aspirationsFlag',  1}];

experimentList{end+1} = experiment;
%%%%%%%

fprintf(['Saving Experiment List.\n']);
save([saveDirectory 'benchmarks_' date '_input_summary'], 'experimentList');

runList = zeros(length(experimentList),1);
%run the model
%parfor indexI = 1:length(experimentList)
for indexI = 1:length(experimentList)
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
