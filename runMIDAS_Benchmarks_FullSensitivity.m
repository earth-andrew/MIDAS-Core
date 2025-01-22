function runMIDAS_Benchmark_SA()

clear functions
clear classes

addpath('./Override_Core_MIDAS_Code');
addpath('./Application_Specific_MIDAS_Code');
addpath('./Core_MIDAS_Code');

rng('shuffle');

outputList = {};
series = 'Benchmark_SA_';
saveDirectory = './Outputs/';



fprintf(['Building Experiment List.\n']);

experimentList = {};
experiment_table = table([],[],'VariableNames',{'parameterNames','parameterValues'});

%%%%%%%%%Add specific experiments in the blocks below.  Each new experiment
%%%%%%%%%should mirro what is done below for the 'baseline', updating the
%%%%%%%%%name and adding any additional parameter changes



for indexI = 1:1000
    experiment = experiment_table;

    owningCost = rand() * 150;
    experiment = [experiment;{'modelParameters.shortName',  'varying_everything'}];
    experiment = [experiment;{'modelParameters.runID',  'VE'}];
    experiment = [experiment;{'modelParameters.placeAttachmentFlag',  randperm(2,1) - 1}];
    experiment = [experiment;{'modelParameters.aspirationsFlag',  randperm(2,1) - 1}];
    experiment = [experiment;{'agentParameters.placeAttachmentMean', rand()}];
    experiment = [experiment;{'agentParameters.rValueMean', rand() * 1.5}];
    experiment = [experiment;{'mapParameters.movingCostsPerMile', rand() * 0.002}];
    experiment = [experiment;{'modelParameters.largeFarmCost', owningCost * 2}];
    experiment = [experiment;{'modelParameters.smallFarmCost', owningCost}];
    experiment = [experiment; {'modelParameters.utility_k', rand() * 4 + 1}];
    experiment = [experiment; {'modelParameters.utility_m', rand() + 1}];
    experiment = [experiment; {'modelParameters.remitRate', rand() * 20}];
    experiment = [experiment; {'mapParameters.minDistForCost', rand() * 50}];
    experiment = [experiment; {'mapParameters.maxDistForCost', rand() * 5000}];
    experiment = [experiment; {'networkParameters.networkDistanceSD', randperm(10,1) + 5}];
    experiment = [experiment; {'networkParameters.connectionsMean', randperm(4,1) + 1}];
    experiment = [experiment; {'networkParameters.connectionsSD', randperm(2,1) + 1}];
    experiment = [experiment; {'networkParameters.weightLocation', rand() * 10 + 5}];
    experiment = [experiment; {'networkParameters.weightNetworkLink', rand() * 10 + 5}];
    experiment = [experiment; {'networkParameters.weightSameLayer', rand() * 7 + 3}];
    experiment = [experiment; {'networkParameters.distancePolynomial', rand() * 0.0002 + 0.0001}];
    experiment = [experiment; {'networkParameters.decayPerStep', max(0.001, rand() * 0.01)}];
    experiment = [experiment; {'networkParameters.interactBump', max(0.005, rand() * 0.03)}];
    experiment = [experiment; {'networkParameters.shareBump', max(0.0005, rand() * 0.005)}];
    
    
    experiment = [experiment; {'agentParameters.incomeShareFractionMean', max(0.01, rand() * 0.6)}];
    experiment = [experiment; {'agentParameters.incomeShareFractionSD', rand() * 0.2}];
    experiment = [experiment; {'agentParameters.shareCostThresholdMean', rand() * 0.4 + 0.2}];
    experiment = [experiment; {'agentParameters.shareCostThresholdSD', rand() * 0.2}];
    experiment = [experiment; {'agentParameters.interactMean', rand() * 0.4 + 0.2}];
    experiment = [experiment; {'agentParameters.interactSD', rand() * 0.2}];
    experiment = [experiment; {'agentParameters.meetNewMean', rand() * 0.4 + 0.2}];
    experiment = [experiment; {'agentParameters.meetNewSD', rand() * 0.2}];
    experiment = [experiment; {'agentParameters.probAddFitElementMean', rand() * 0.5 + 0.5}];
    experiment = [experiment; {'agentParameters.probAddFitElementSD', rand() * 0.2}];

    
    
    experiment = [experiment; {'agentParameters.randomLearnMean', rand() * 0.6 + 0.1}];
    experiment = [experiment; {'agentParameters.randomLearnSD', rand() * 0.2}];
    experiment = [experiment; {'agentParameters.randomLearnCountMean', randperm(2,1) + 1}];
    experiment = [experiment; {'agentParameters.randomLearnCountSD', randperm(3,1) - 1}];
    experiment = [experiment; {'agentParameters.chooseMean', rand() * 0.7 + 0.2}];
    experiment = [experiment; {'agentParameters.chooseSD', rand() * 0.2}];
    experiment = [experiment; {'agentParameters.knowledgeShareFracMean', max(0.01, rand() * 0.4)}];
    experiment = [experiment; {'agentParameters.knowledgeShareFracSD', rand() * 0.2}];
    experiment = [experiment; {'agentParameters.bestLocationMean', randperm(2,1) + 1}];
    experiment = [experiment; {'agentParameters.bestLocationSD', randperm(3,1) - 1}];
    experiment = [experiment; {'agentParameters.bestPortfolioMean', randperm(2,1) + 1}];
    experiment = [experiment; {'agentParameters.bestPortfolioSD', randperm(3,1) - 1}];
    experiment = [experiment; {'agentParameters.randomLocationMean', randperm(2,1) + 1}];
    experiment = [experiment; {'agentParameters.randomLocationSD', randperm(3,1) - 1}];
    experiment = [experiment; {'agentParameters.randomPortfolioMean', randperm(2,1) + 1}];
    experiment = [experiment; {'agentParameters.randomPortfolioSD', randperm(3,1) - 1}];
    experiment = [experiment; {'agentParameters.numPeriodsEvaluateMean', randperm(18,1) + 6}];
    experiment = [experiment; {'agentParameters.numPeriodsEvaluateSD', randperm(7,1) - 1}];
    experiment = [experiment; {'agentParameters.numPeriodsMemoryMean', randperm(18,1) + 6}];
    experiment = [experiment; {'agentParameters.numPeriodsMemorySD', randperm(7,1) - 1}];
    experiment = [experiment; {'agentParameters.discountRateMean', max(0.02, rand() * 0.2)}];
    experiment = [experiment; {'agentParameters.discountRateSD', rand() + 0.02}];
    experiment = [experiment; {'agentParameters.rValueMean', rand() * 0.75 + 0.75}];
    experiment = [experiment; {'agentParameters.rValueSD', rand() * 0.3 + 0.1}];
    experiment = [experiment; {'agentParameters.prospectLossMean', rand() + 1}];
    experiment = [experiment; {'agentParameters.prospectLossSD', rand() + 0.2}];
    experiment = [experiment; {'agentParameters.informedExpectedProbJoinLayerMean', rand() * 0.2 + 0.8}];
    experiment = [experiment; {'agentParameters.informedExpectedProbJoinLayerSD', rand() * 0.2}];
    experiment = [experiment; {'agentParameters.uninformedMaxExpectedProbJoinLayerMean', rand() * 0.4}];
    experiment = [experiment; {'agentParameters.uninformedMaxExpectedProbJoinLayerSD', rand() * 0.2}];
    experiment = [experiment; {'agentParameters.expectationDecayMean', rand() * 0.15 + 0.05}];
    experiment = [experiment; {'agentParameters.expectationDecaySD', rand() * 0.2}];
    experiment = [experiment; {'agentParameters.placeAttachmentSD', rand() * 0.2}];
    experiment = [experiment; {'agentParameters.placeAttachmentGrowMean', rand() * 0.02}];
    experiment = [experiment; {'agentParameters.placeAttachmentGrowSD', rand() *  0.002}];
    experiment = [experiment; {'agentParameters.placeAttachmentDecayMean', rand() *  0.002}];
    experiment = [experiment; {'agentParameters.placeAttachmentDecaySD',  rand() * 0.0002}];
    experiment = [experiment; {'agentParameters.initialPlaceAttachmentMean',  rand() * 0.7}];
    experiment = [experiment; {'agentParameters.initialPlaceAttachmentSD',  rand() * 0.2}];

    experimentList{end+1} = experiment;
end



experimentList = experimentList(randperm(length(experimentList)));

fprintf(['Saving Experiment List.\n']);
save([saveDirectory 'benchmarks_' date '_input_summary'], 'experimentList');

numRuns = length(experimentList);
runList = zeros(length(experimentList),1);
%run the model
parfor indexI = 1:length(experimentList)
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
