function samplePortfolio = fillPortfolio(samplePortfolio, constraints, selectable, portfolioPrereqs)
%This function returns a filled portfolio based on an agent's existing portfolio, selectable layers and
%time constraints of each layer

%Sum rows in constraints for active portfolio layers (starting from index 2, as index 1 represents the index of the layer)
timeUse = sum(constraints(samplePortfolio,2:end),1); 
timeRemaining = 1 - timeUse;

%Identify remaining selectable layers that could be added
selectableLayers = selectable & ~samplePortfolio;

%Add one selectableLayer at random
while (sum(timeRemaining) > 0 && any(selectableLayers))
    tempLayers = find(selectableLayers,1);

    if length(tempLayers) > 1    
        indexS = datasample(tempLayers,1); 
    else
        indexS = tempLayers;
    end
                
    samplePortfolio(indexS) = true;    
    timeUse = sum(constraints(samplePortfolio,2:end),1);              
    timeRemaining = 1 - timeUse;    
    selectableLayers(indexS) = false;        
end

%Check if time constraints are exceeded in any time step. If so, remove
%layers at random until all periods fit under constraints
while any(sum(timeRemaining,1) < 0)  
    tempLayers = find(samplePortfolio);
    tempLayers(ismember(tempLayers,portfolioPrereqs)) = [];
                
    if length(tempLayers) > 1
        samplePortfolio(datasample(tempLayers,1)) = false;
    else
        samplePortfolio(tempLayers) = false;
    end
                
    timeUse = sum(constraints(samplePortfolio,2:end),1);
    timeRemaining = 1 - timeUse;    
end

end