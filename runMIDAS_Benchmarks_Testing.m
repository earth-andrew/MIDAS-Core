function runMIDASExperiment()

clear functions
clear classes

%cd /home/rocky/MIDAS-Core;

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



for indexI = 1:1
    experiment = experiment_table;
    
    owningCost = rand() * 15000;
    experiment = [experiment;{'modelParameters.shortName',  ['testing' num2str(indexI) '_']}];
    experiment = [experiment;{'modelParameters.aspirationsFlag',  0}];
    experiment = [experiment;{'modelParameters.runID',  'testing'}];
    %experiment = [experiment;{'modelParameters.placeAttachmentFlag', 1}];
    %experiment = [experiment;{'agentParameters.placeAttachmentMean', 1}];
    %experiment = [experiment;{'agentParameters.initialPlaceAttachmentMean', 0}];
    experiment = [experiment;{'modelParameters.largeFarmCost', owningCost * 2}];
    experiment = [experiment;{'modelParameters.smallFarmCost', owningCost}];

    experiment = [experiment;{'modelParameters.visualizeYN', 0}];
    
    experimentList{end+1} = experiment;
end

%%%%%%%

experimentList = experimentList(randperm(length(experimentList)));

fprintf(['Saving Experiment List.\n']);
save([saveDirectory 'benchmarks_' date '_input_summary'], 'experimentList');

numRuns = length(experimentList);
runList = zeros(length(experimentList),1);
%run the model

setenv('MW_PCT_TRANSPORT_HEARTBEAT_INTERVAL', '100000');

for indexI = 1:length(experimentList)
%for indexI = 1:length(experimentList)
    if(runList(indexI) == 0)
        input = experimentList{indexI};
        
        %this next line runs MIDAS using the current experimental
        %parameters
        output = midasMainLoop(input, ['Experiment Run ' num2str(indexI) ' of ' num2str(numRuns)]);
        
        
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
