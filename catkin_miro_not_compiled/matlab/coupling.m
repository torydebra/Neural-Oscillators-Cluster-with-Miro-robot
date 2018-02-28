function couplingMatrix = coupling(nearestSensors, gaussParam, nSensors, sensorsCoords)
%% function couplingMatrix = coupling(nearestSensors, nearestSeonsors, nSensors, sensorsCoords)
% This function computes the coupling among the sensors by considering the
% nearestSensors neighbours of each one and using a Gaussian coupling function.
% 
% Input:
%   nearestSensors = number of neighbours that must be identified for each sensor
%   gaussParam = tuning parameter of the Gaussian coupling function
%   nSensors = number of sensors in the map
%   sensorsCoords = (x,y) coordinates of each sensor
%
% Output:
%   couplingMatrix = coupling strenght of each sensor with respect to all of the others

% Determine the nearestSensors neighbours of each sensor
[SelfNeighbors, SelfDistances] = kNearestNeighbors(sensorsCoords, sensorsCoords, nearestSensors+1);
Neighbors = SelfNeighbors(:, 2:nearestSensors+1);
Distances = SelfDistances(:, 2:nearestSensors+1);

% Compute the coupling matrix
couplingMatrix = zeros(nSensors, nSensors);
% consider all the possible couples of neurons
% for each start neuron
for s=1:nSensors
    % loop over the M nearest neighbors
    for g=1:nearestSensors
        couplingMatrix(s, Neighbors(s, g)) = exp( -abs(Distances(s, g))^2/gaussParam^2 );
    end
end