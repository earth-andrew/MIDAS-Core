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

experiment = [experiment;{'agentParameters.placeAttachmentFlag',  1}];
experiment = [experiment;{'agentParameters.placeAttachmentMean',  0}];
experiment = [experiment;{'agentParameters.placeAttachmentSD',  0}];
experiment = [experiment;{'agentParameters.placeAttachmentGrowMean',  0}];
experiment = [experiment;{'agentParameters.placeAttachmentGrowSD',  0}];
experiment = [experiment;{'agentParameters.placeAttachmentDecayMean',  0}];
experiment = [experiment;{'agentParameters.placeAttachmentDecaySD',  0}];
experiment = [experiment;{'agentParameters.initialPlaceAttachmentMean',  0}];
experiment = [experiment;{'agentParameters.initialPlaceAttachmentSD',  0}];

experimentList{end+1} = experiment;

%%%%%%%%%%
for indexI = 1:10
    experiment = experiment_table;
    
    experiment = [experiment;{'modelParameters.shortName',  'PA_level_1'}];
    experiment = [experiment;{'modelParameters.runID',  'PA1'}];
    
    experiment = [experiment;{'agentParameters.placeAttachmentFlag',  1}];
    experiment = [experiment;{'agentParameters.placeAttachmentMean',  indexI * 0.1}];
    experiment = [experiment;{'agentParameters.placeAttachmentSD',  0}];
    experiment = [experiment;{'agentParameters.placeAttachmentGrowMean',  0}];
    experiment = [experiment;{'agentParameters.placeAttachmentGrowSD',  0}];
    experiment = [experiment;{'agentParameters.placeAttachmentDecayMean',  0}];
    experiment = [experiment;{'agentParameters.placeAttachmentDecaySD',  0}];
    experiment = [experiment;{'agentParameters.initialPlaceAttachmentMean',  0}];
    experiment = [experiment;{'agentParameters.initialPlaceAttachmentSD',  0}];
    
    experimentList{end+1} = experiment;

end
%%%%%%%

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
