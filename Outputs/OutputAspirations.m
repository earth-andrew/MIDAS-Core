%Load Model Outputs data
load Aspirations_SenegalTest_SenegalRiverDrought0_28-Feb-2024_10-04-21.mat
migCalibration = output;

scenariolist = [migCalibration];
scenarios= length(scenariolist);
locations = 45;

numAgents = height(scenariolist(1).agentSummary(:,1));
locations = size(scenariolist(1).countAgentsPerLayer,1);
jobcats = size(scenariolist(1).countAgentsPerLayer,2);
steps = size(scenariolist(1).countAgentsPerLayer,3);
time = 1:steps;

%% Plot Average Proportion Backcasting over time
tic

backCastProp = zeros(steps,numAgents);
for indexA = 1:1:numAgents

    %Determine if agent died during simulation
    if scenariolist(1).agentSummary.TOD > -9999
        endIndex = scenariolist(1).agentSummary.TOD
    else
        endIndex = steps;
    end

    %Collect all agents' backCast proportions in a time-based array
    for indexT = 1:1:steps

        %If agent died, set this array element empty so it doesn't factor
        %into population-wide average
        if indexT > endIndex
            backCastProp(indexT,indexA) = [];
        else
            backCastProp(indexT,indexA) = scenariolist(1).agentSummary.backCastProportion{indexA,1}(indexT);
        end

    end
end

plot(time,mean(backCastProp,2),'LineWidth',3)

ax = gca;
ax.FontSize = 16;
ylabel('Mean Back Cast Proportion','FontSize',16)
xlabel('Time', 'FontSize',16)
xlim([11,steps])
legend({'Base Case'},'FontSize',14)
