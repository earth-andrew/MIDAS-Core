function currentAgent = updatePlaceAttachment(currentAgent, distances)

%we do two things here - update place attachment to specific places, and
%then re-estimate how utility of opportunities in a place i should be
%rescaled given place attachments to all places i and otherwise

%current SIMPLE model is to say that place attachment grows at a fixed rate 
%in the place that you are, and decays elsewhere.  a smarter model would do
%more here.

%save and update the attachment to current place
currentPA = currentAgent.currentPlaceAttachment(currentAgent.matrixLocation);
currentPA = min(1,currentPA + currentAgent.placeAttachmentGrow);

%let all places decay
currentAgent.currentPlaceAttachment = max(0,currentAgent.currentPlaceAttachment - currentAgent.placeAttachmentDecay);

%then overwrite the updated current place
currentAgent.currentPlaceAttachment(currentAgent.matrixLocation) = currentPA;


%rescaler = PAN_k * PA_i / (1 + PAN_k * sum (d_ij * PA_j))
%where PAN_k is the 'place attached-ness' of agent k, PA_i is the attachment
%to place i, and d_ij is the scaled distance between i and j

%sum (d_ij * PA_j) is the matrix product of distances (n x n) and PA (n x
%1)
d_i_x_PA = distances * currentAgent.currentPlaceAttachment;

currentAgent.currentPAScaler = currentAgent.placeAttachment * currentAgent.currentPlaceAttachment ./ ...
    (1 + currentAgent.placeAttachment * d_i_x_PA);

end