function [T, Y] = ActivateOscillators(ti, tf, steps, I, nSensors, CouplingMatrix)
%% function [T, Y] = ActivateOscillators(ti, tf, steps, I, n, CouplingMatrix)
% This function creates the network of non-linear oscillators associated to
% the sensors and determines their response according to the input values
% and the coupling.
%--------------------------------------------------------------------------
% This function allows modifications to change the initial state of the
% oscillators and the solving method used to compute their responses.
%--------------------------------------------------------------------------
%
% Input:
%   ti = initial time for the integration (required by the computation of
%        the oscillators' responses)
%   tf = time duration of each step (only values of tf >= 50 permits to
%       evaluate well oscillators' responses)
%   steps = number of steps (lines) of the activation input that must be
%           considered to compute the oscillators' responses
%   I = table of the normalized pressure values of each sensor in the
%       considered time instants
%   nSensors = number of sensors in the calibrated map
%   CouplingMatrix = coupling strenght of each sensor with respect to all of
%                    the others

% Output:
%   T = time instants considered by the system to compute the oscillators'
%       responses
%   Y = values of the oscillators' responses computed at the time instants
%       listed in T: odd values correspond to v (membrane potential of the
%       oscillator), even values correspond to w (internal state, NOT
%       relevant here)

% Define the integration parameters
step = 0.01;    % integration step

% Define the non-linear oscillators parameters (values fixed by Slotine &
% Wang paper)
A = 12;
R = 4;
C = 0.04;

% Create the network of oscillators and determine their responses
% CHOOSE ONE OF THE FOLLOWING 2 OPTIONS:
y0 = rand(2*nSensors, 1);    % random initial response of the oscillators
%y0 = zeros(2*nSensors, 1);   % null initial response of the oscillators

boolActivated = zeros(1,nSensors);
% Integrate the differential equations system
for step = 1:steps
    sensorActivated = find(I(:,step) == 2);
    boolActivated(sensorActivated) = 1;
    
    % CHOOSE ONE OF THE FOLLOWING 5 OPTIONS:
    %[T, Y] = ode45(@(t, y) DiffusiveFitzhughNagumo(t, y, e, g, b, a, d, c, f, NoElements, CouplingMatrix), ti:step:tf, y0);
    %[T, Y] = ode45(@(t, y) ModifiedFitzHughNagumo(t, y, a, r, c, I, NoElements, CouplingMatrix), ti:step:tf, y0);
    %[T, Y] = ode45(@(t, y) DiffusiveFitzHughNagumo(t, y, A, R, C, I, n, CouplingMatrix), ti:step:tf, y0);
    [Tstep, Ystep] = ode15s(@(t, y) DiffusiveFitzHughNagumo(t, y, A, R, C, I(:,step), nSensors, CouplingMatrix), [ti tf], y0);
    %[Tstep, Ystep] = ode15s(@(t, y) DiffusiveFulvio(t, y, I, A, n, CouplingMatrix), [ti tf], y0);
    % define the initial conditions for the next iteration
    numSteps = length(Ystep(:, 1));
    y0 = Ystep(numSteps, :);
    if(step == 1)
        T = Tstep;
        Y = Ystep;
    else
        offset1 = zeros(length(T), 1);
        offset2 = zeros(length(Tstep), 1) + T(length(T));
        offset = [offset1; offset2];
        T = [T; Tstep] + offset;
        Y = [Y; Ystep];
    end
end

% Display only the activated oscillators' responses
% figure;
% colorstring = 'ykbyrgbk';
% 
% j = 1; % for legendInfo array
% for i=1:nSensors
%     title('Activated oscillators responses')
%     if boolActivated(i) == 1
%         plot(T, Y(:, i*2-1),'Color',colorstring(i));
%         legendInfo{j} = ['Sensor ' num2str(i)];
%         hold on;
%         j = j+1;
%     end
% end
% xlabel('Step * tf');
% ylabel('Value of oscillators curves');
% 
% legend(legendInfo);
% legend('show')
