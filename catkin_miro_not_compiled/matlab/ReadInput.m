function [I, steps] = ReadInput(file, steps, matrixMap, nSensors)
%% function [I, steps]  = ReadInput(file, steps, matrixMap, nSensors)
% This function maps the activation values in input into the [0.8 2.0]
% range, which is necessary if we want to use the convergence parameters
% indicated by Slotine & Wang in their paper, and returns the normalized
% values of pressure of each taxel in the specified number of time
% instants.
%
% Input:
%   file = a file build as a table as follows:
%            - one row for each time instant of activation
%            - the first column the time istant of activation
%            - the second column containing the total number of active
%                   sensors at that time instant
%            - the others columns containing the pressure value registered by the sensors
%   steps = the number of time instants that must be considered to compute
%           the activation input (if zero it take all time instant from file)
%   matrixMap = table of the positions of the sensors on the flattened map
%   nSensors = number of sensors in the map
%
% Output:
%   I = table of the normalized pressure values of each sensor in the
%       considered time instants
%   steps = same as the input if input was not zero, number of all time
%       instants if input was zero

% Read the activation sequence
fd = fopen(file,'r');

tline = fgetl(fd);
i = 1;
while tline ~= -1
    activationMap(i,:) = str2num(tline);
    i = i+1;
    tline = fgetl(fd);
end

% Determine the length of the activation input
activationMapLength =  length(activationMap(:, 1));

% if argument steps is zero, take all row of activationMap
if steps == 0
    steps = activationMapLength;
end

nColumns = 10; %Fixed columns
maxF = 1; %Miro have binary sensors so the maximum given value is 1

% Compute I matrix
% Column of I is row of activationMap (without timestamp and number of 
% activated sensors)
for step = 1:steps    
    I(:,step) = activationMap(step,3:10);
    for i=1:nSensors 
        I(i,step) = I(i,step)*((2.0-0.8)/maxF) + 0.8;
    end
end

% % Print all active sensors of activation sequence, step by step
% figure;
% axis equal;
% for i= 1:activationMapLength
%     for j = 3:nColumns
%         sensor = j-2;
%         if (activationMap(i,j) == 1)
%             plot(matrixMap(sensor,2), matrixMap(sensor,3), "or");
%             hold on
%         end
%         if (activationMap(i,j) == 0)
%             plot(matrixMap(sensor,2), matrixMap(sensor,3), "ob");
%            hold on
%         end
%     end
%     title(['Step ' num2str(i) ' for time ' num2str(activationMap(i,1)) ' with ' num2str(activationMap(i,2))  ' activated sensors'])
%    
%     pause %to see step by step
% 
% end