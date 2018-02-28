function dydt = DiffusiveFitzHughNagumo(t, y, A, R, C, I, nSensors, CouplingMatrix)
%% function dydt = DiffusiveFitzHughNagumo(t, y, A, R, C, I, nSensors, CouplingMatrix)
% This function implements the modified Fitzhugh - Nagumo model used
% by Wang and Slotine
%
% Output:
% dydt: column vector corresponding to [dv dw]^T

% Define a 2-dimensional column vector
dydt = zeros(2*nSensors, 1);

% Iteratively build the differential equations
for i=1:2:(2*nSensors)
    % base dynamics (w\ couplings)
    dydt(i) = 3*y(i) - y(i)^3 - y(i)^7 + 2 - y(i+1) + I((i+1)/2);
    dydt(i+1) = C*(A*(1 + tanh(R*y(i))) - y(i+1));       
    % add couplings according to the diffusive coupling matrix
    for s=1:nSensors   
        % evaluate coupling strenght between neurons i and startNeuron
        dydt(i) = dydt(i) + CouplingMatrix((i+1)/2, s)*(y((s*2)-1) - y(i));
        dydt(i+1) = dydt(i+1) + CouplingMatrix(((i+1)/2), s)*(y((s*2)) - y(i+1));  
    end
end