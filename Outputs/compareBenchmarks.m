function compareBenchmarks

clear all
close all

timeSteps = 90;
phases = 4;
spinup = 10;

fileList = dir('Benchmark_*.mat');

expNames = dir('benchmarks_*.mat');
experimentList = load(expNames(1).name);

expNamesList = {};
%for indexI = 1:size(fileList,1);
%    expNamesList{indexI} = strrep(experimentList.experimentList{indexI}.parameterValues{1},'_','-');
%end

averageIncome = [];
migrations = [];
incomeInequality = []; 
layerOccupation_1 = zeros(length(fileList),timeSteps);
layerOccupation_2 = zeros(length(fileList),timeSteps);
layerOccupation_3 = zeros(length(fileList),timeSteps);
layerOccupation_4 = zeros(length(fileList),timeSteps);
layerOccupation_5 = zeros(length(fileList),timeSteps);
layerOccupation_6 = zeros(length(fileList),timeSteps);
shannonPlaceLabor = zeros(length(fileList),timeSteps);

inputListRun = [];
outputListRun = [];
skip = false(length(fileList),1);
for indexI = 1:length(fileList)
    
        currentRun = load(fileList(indexI).name);
        fprintf(['Run ' num2str(indexI) ' of ' num2str(length(fileList)) '.\n']);


  
        %number of migrations
        migrations = [migrations; currentRun.output.migrations'];

        expNamesList{indexI} = currentRun.input.parameterValues{1};

        %average income
        currentAveIncome = zeros(1,timeSteps);
        currentAveIncomeN = currentAveIncome;
        fullIncomeMap = NaN * ones(size(currentRun.output.agentSummary,1),timeSteps);
        for indexJ = 1:size(currentRun.output.agentSummary,1)
            temp = currentRun.output.agentSummary.incomeHistory{indexJ};
            currentAveIncome(1:size(temp,2)) = currentAveIncome(1:size(temp,2)) + temp;
            currentAveIncomeN(1:size(temp,2)) = currentAveIncomeN(1:size(temp,2)) + 1;
            fullIncomeMap(indexJ,1:size(temp,2)) = temp;
        end
        fullYearIncomeMap = phaseToYear(fullIncomeMap, spinup, phases);
        tempIncomeInequality = zeros(1,size(fullYearIncomeMap,2));
        for indexJ = 1:size(fullYearIncomeMap,2)
            currentIncome = fullYearIncomeMap(:, indexJ);
            tempIncomeInequality(indexJ) = calcGini(currentIncome(~isnan(currentIncome))');
        end
        %tempIncomeInequality = phaseToYear(tempIncomeInequality, spinup, phases);
        incomeInequality = [incomeInequality; tempIncomeInequality];
        currentAveIncome = currentAveIncome ./ currentAveIncomeN;
        averageIncome = [averageIncome; currentAveIncome];

        %income inequality

        %population GINI (income layer in place GINI, for now)
        occLayer = currentRun.output.countAgentsPerLayer;
        occLayer = reshape(sum(occLayer,2),[size(occLayer,1) size(occLayer,3)]);
        for indexK = 1:timeSteps
            shannonPlaceLabor(indexI,indexK) = shannon(occLayer(:,indexK));
        end

        %layer occupation
        tempPortfolios = currentRun.output.agentSummary.portfolioHistory;
        for indexJ = 1:size(tempPortfolios,1)
            for indexK = 1:size(tempPortfolios{indexJ},2)
                
                tempAgent = tempPortfolios{indexJ}{indexK};
               
                if(~isempty(tempAgent))
                    layerOccupation_1(indexI,indexK) = layerOccupation_1(indexI,indexK) + tempAgent(1);
                    layerOccupation_2(indexI,indexK) = layerOccupation_2(indexI,indexK) + tempAgent(2);
                    layerOccupation_3(indexI,indexK) = layerOccupation_3(indexI,indexK) + tempAgent(3);
                    layerOccupation_4(indexI,indexK) = layerOccupation_4(indexI,indexK) + tempAgent(4);
                    layerOccupation_5(indexI,indexK) = layerOccupation_5(indexI,indexK) + tempAgent(5);
                    layerOccupation_6(indexI,indexK) = layerOccupation_6(indexI,indexK) + tempAgent(6);
                end


            end
        end
        layerOccupation_1(indexI,:) = layerOccupation_1(indexI,:) / indexJ;
        layerOccupation_2(indexI,:) = layerOccupation_2(indexI,:) / indexJ;
        layerOccupation_3(indexI,:) = layerOccupation_3(indexI,:) / indexJ;
        layerOccupation_4(indexI,:) = layerOccupation_4(indexI,:) / indexJ;
        layerOccupation_5(indexI,:) = layerOccupation_5(indexI,:) / indexJ;
        layerOccupation_6(indexI,:) = layerOccupation_6(indexI,:) / indexJ;
        

        inputListRun{indexI} = currentRun.input;

end

skip = skip(1:height(inputListRun));
inputListRun(skip,:) = [];
outputListRun(skip,:) = [];
fileList(skip) = [];

averageIncome = phaseToYear(averageIncome, spinup, phases);
migrations = phaseToYear(migrations, spinup, phases);
layerOccupation_1 = phaseToYear(layerOccupation_1, spinup, phases) / phases;
layerOccupation_2 = phaseToYear(layerOccupation_2, spinup, phases) / phases;
layerOccupation_3 = phaseToYear(layerOccupation_3, spinup, phases) / phases;
layerOccupation_4 = phaseToYear(layerOccupation_4, spinup, phases) / phases;
layerOccupation_5 = phaseToYear(layerOccupation_5, spinup, phases) / phases;
layerOccupation_6 = phaseToYear(layerOccupation_6, spinup, phases) / phases;
%incomeInequality = phaseToYear(incomeInequality, spinup, phases);

colorList = ["b" "g" "y" "c" "m" "r" "k"];
[b_name,i_name,j_name] = unique(expNamesList);
c_name = colorList(j_name);



h = figure;
for indexI = 1:size(averageIncome,1)
    p(indexI) = patchline(1:size(averageIncome,2),averageIncome(indexI,:), 'FaceColor', c_name(indexI),'EdgeColor',c_name(indexI),'EdgeAlpha', 0.2);
end
legend(p(i_name),strrep(expNamesList(i_name),'_','-'));
colororder(c_name);
title('Average Income')
xlabel('Years')
print('-dpng','-painters','-r100', 'averageIncome.png');

h = figure;
for indexI = 1:size(averageIncome,1)
    p(indexI) = patchline(1:size(averageIncome,2),incomeInequality(indexI,:), 'FaceColor', c_name(indexI),'EdgeColor',c_name(indexI),'EdgeAlpha', 0.2);
end
legend(p(i_name),strrep(expNamesList(i_name),'_','-'));
colororder(c_name);
title('Income GINI')
xlabel('Years')
print('-dpng','-painters','-r100', 'incomeGINI.png');

h = figure;
for indexI = 1:size(averageIncome,1)
    p(indexI) = patchline(1:size(averageIncome,2),migrations(indexI,:), 'FaceColor', c_name(indexI),'EdgeColor',c_name(indexI),'EdgeAlpha', 0.2);
end
legend(p(i_name),strrep(expNamesList(i_name),'_','-'));
colororder(c_name);
title('Number of Migrations')
xlabel('Years')
print('-dpng','-painters','-r100', 'migrations.png');

h = figure;
for indexI = 1:size(averageIncome,1)
    p(indexI) = patchline(1:size(averageIncome,2),layerOccupation_1(indexI,:), 'FaceColor', c_name(indexI),'EdgeColor',c_name(indexI),'EdgeAlpha', 0.2);
end
legend(p(i_name),strrep(expNamesList(i_name),'_','-'));
colororder(c_name);
title('Frac in Unskilled 1')
xlabel('Years')
print('-dpng','-painters','-r100', 'fracUS1.png');

h = figure;
for indexI = 1:size(averageIncome,1)
    p(indexI) = patchline(1:size(averageIncome,2),layerOccupation_2(indexI,:), 'FaceColor', c_name(indexI),'EdgeColor',c_name(indexI),'EdgeAlpha', 0.2);
end
legend(p(i_name),strrep(expNamesList(i_name),'_','-'));
colororder(c_name);
title('Frac in Unskilled 2')
xlabel('Years')
print('-dpng','-painters','-r100', 'fracUS2.png');

h = figure;
for indexI = 1:size(averageIncome,1)
    p(indexI) = patchline(1:size(averageIncome,2),layerOccupation_3(indexI,:), 'FaceColor', c_name(indexI),'EdgeColor',c_name(indexI),'EdgeAlpha', 0.2);
end
legend(p(i_name),strrep(expNamesList(i_name),'_','-'));
colororder(c_name);
title('Frac in Skilled')
xlabel('Years')
print('-dpng','-painters','-r100', 'fracS.png');

h = figure;
for indexI = 1:size(averageIncome,1)
    p(indexI) = patchline(1:size(averageIncome,2),layerOccupation_4(indexI,:), 'FaceColor', c_name(indexI),'EdgeColor',c_name(indexI),'EdgeAlpha', 0.2);
end
legend(p(i_name),strrep(expNamesList(i_name),'_','-'));
colororder(c_name);
title('Frac in Ag 1')
xlabel('Years')
print('-dpng','-painters','-r100', 'fracA1.png');

h = figure;
for indexI = 1:size(averageIncome,1)
    p(indexI) = patchline(1:size(averageIncome,2),layerOccupation_5(indexI,:), 'FaceColor', c_name(indexI),'EdgeColor',c_name(indexI),'EdgeAlpha', 0.2);
end
legend(p(i_name),strrep(expNamesList(i_name),'_','-'));
colororder(c_name);
title('Frac in Ag 2')
xlabel('Years')
print('-dpng','-painters','-r100', 'fracA2.png');

h = figure;
for indexI = 1:size(averageIncome,1)
    p(indexI) = patchline(1:size(averageIncome,2),layerOccupation_6(indexI,:), 'FaceColor', c_name(indexI),'EdgeColor',c_name(indexI),'EdgeAlpha', 0.2);
end
legend(p(i_name),strrep(expNamesList(i_name),'_','-'));
colororder(c_name);
title('Frac in School')
xlabel('Years')
print('-dpng','-painters','-r100', 'fracSc.png');


h = figure;
for indexI = 1:size(averageIncome,1)
    p(indexI) = patchline(1:size(shannonPlaceLabor,2),shannonPlaceLabor(indexI,:), 'FaceColor', c_name(indexI),'EdgeColor',c_name(indexI),'EdgeAlpha', 0.2);
end
legend(p(i_name),strrep(expNamesList(i_name),'_','-'));
colororder(c_name);
title('Shannon Entropy - Jobs in Places')
xlabel('Seasons')
print('-dpng','-painters','-r100', 'shannonSeasons.png');

h = figure;
shannonPlaceLaborSmooth = phaseToYear(shannonPlaceLabor, spinup, phases);

for indexI = 1:size(averageIncome,1)
    p(indexI) = patchline(1:size(shannonPlaceLaborSmooth,2),shannonPlaceLaborSmooth(indexI,:), 'FaceColor', c_name(indexI),'EdgeColor',c_name(indexI),'EdgeAlpha', 0.2);
end
legend(p(i_name),strrep(expNamesList(i_name),'_','-'));
colororder(c_name);
title('Shannon Entropy - Jobs in Places (smoothed)')
xlabel('Years')
print('-dpng','-painters','-r100', 'shannonYears.png');

%riskSubset
h_income = figure;
h_moves = figure;
for indexI = 1:size(averageIncome,1)


    if strcmp(expNamesList{indexI},  'baseline_high_risk_aversion')

        riskVar = inputListRun{indexI}.parameterValues{3};
        figure(h_income)
        plot(riskVar, averageIncome(indexI, 15),'ro');
        hold on;

        figure(h_moves)
        plot(riskVar, migrations(indexI, 15),'bo');
        hold on;

    end


end
    figure(h_income)
    xlabel('Risk aversion');
    title('Average income');
    print('-dpng','-painters','-r100', 'riskVIncome.png');


     figure(h_moves)
    xlabel('Risk aversion');
    title('Number of migrations');
    print('-dpng','-painters','-r100', 'riskVMigs.png');


h_income = figure;
h_moves = figure;
for indexI = 1:size(averageIncome,1)

    if strcmp(expNamesList{indexI},  'baseline_high_moving')

        costVar = inputListRun{indexI}.parameterValues{3};

        if costVar <= 0.03 
            figure(h_income)
            plot(costVar, averageIncome(indexI, 15),'ro');
            hold on;
    
            figure(h_moves)
            plot(costVar, migrations(indexI, 15),'bo');
            hold on;

        end

    end




end
    figure(h_income)
    xlabel('Moving cost (per mile)');
    title('Average income');
    print('-dpng','-painters','-r100', 'costVIncome.png');


    figure(h_moves)
    xlabel('Moving cost (per mile)');
    title('Number of migrations');
    print('-dpng','-painters','-r100', 'costVMigs.png');


end

function varHistory = phaseToYear(varHistory, spinup, phases)

varHistory(:,1:spinup) = [];
for indexJ = 2:phases
    varHistory(:,1:phases:end) = varHistory(:,1:phases:end) + varHistory(:,indexJ:phases:end);
end
varHistory = varHistory(:,1:phases:end);


end

function shannonEntropy = shannon(a)

b = hist(a,1:max(a));
b = b / length(a);
b = - b .* log(b);

shannonEntropy = sum(b(~isnan(b)));

end

function gini = calcGini(values)


n = length(values);

index = 1:n;

sortValues = sort(values);

sumV = sum(values);
try
sumIV = sum(sortValues.*index);
catch
sumIV = sum(sortValues.*index');
end
gini = 2*sumIV/(n*sumV) - (n+1)/n;

end