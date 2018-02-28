function [matrixMap] = readMap(file)
%% function [matrixMap] = readMap(file)
% This function reads and displays the flattened map of the
% tactile sensors.
% 
% Input:
%   file = a file built as a table as follows:
%            - one row for each sensor
%            - the first column containing the sensor's ID
%            - the second and third columns containing its (x,y) coordinates on
%              the flattened map
%
% Output:
%   matrixMap = same information stored in the input file

fd = fopen(file,'r');

tline = fgetl(fd);
i = 1;
while tline ~= -1
    matrixMap(i,:) = str2num(tline);
    i = i+1;
    tline = fgetl(fd);
end

% %Display the flattened map of the sensors
% figure;
% axis equal;
% 
% plot(matrixMap(:,2), matrixMap(:,3), '*', 'MarkerSize', 9, 'Color', 'green');
% title('Flattened map of the MiRo sensors');
% xlabel ('x [cm]');
% ylabel('y [cm]')
% 
% numberArray = [1 2 3 4 5 6 7 8];
% spaceArray = [' ' ' ' ' ' ' ' ' ' ' ' ' ' ' '];
% box on;
% text(matrixMap(:,2), matrixMap(:,3), cellstr([spaceArray(:) num2str(numberArray(:))]), 'FontSize', 18, 'Color', 'blue')