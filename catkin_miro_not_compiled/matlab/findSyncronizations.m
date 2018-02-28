function [completeSyncro, nTouchCluster] = findSyncronizations (T, Y, tf, nSensors, steps, I, obsMode, errorPercentage)
%% function [completeSyncro, nTouchCluster] = findSyncronizations (T, Y, tf, nSensors, steps, I)
%
% This function finds if neural oscillators are syncronized at each step
% and if they are so, it divides them into different "clusters".
% Each cluster possibly correspond to a single touch on the sensors.
% To be syncronized they must belong to the same cluster, so they must have
% curves' amplitudes that differs at maximum for error.
% Error is calculated considering the maximum and minumim amplitude of the
% curves (errorPercentage% of max-min).
%
% Input:
%   T = time instants considered by the system to compute the oscillators'
%       responses
%   Y = values of the oscillators' responses computed at the time instants
%       listed in T: odd values correspond to v (membrane potential of the
%       oscillator), even values correspond to w (internal state, NOT
%       relevant here)
%   tf = time duration of each step (only values of tf >= 50 permits to
%       evaluate well oscillators' responses 
%   nSensors = number of sensors in the calibrated map
%   steps = number of steps (lines) of the activation input that must be
%           considered to compute the oscillators' responses
%   I = table of the normalized pressure values of each sensor in the
%       considered time instants
%   obsMode = modality to take the observations of the curves to understand if they are syncronized 
%       1 : five observations on the whole step time
%       2 : nine observations on the whole step time
%       3 : five observations on the second half of the step time
%       4 : nine observations near the three maximums of the first curve
%       5 : nine observations at random time
%   errorPercentage = maximum error to say that curves are syncronized in
%   relation at max-min values of the curves
%   
% Output:
%   completeSyncro = matrix of syncronized oscillators; each row correspod
%       to a step and each column to a sensor.
%       Equals numbers means syncronized oscillators, value 0 means
%       oscillator that isn't active
%   nTouchCluster = number of different clusters 
%
% WARNING :
% we use pdist for distances between each couple of activacted sensor,
% so take attention: if the sensors are too much the result vector may be too
% big for memory


% take max and min of the curves to have relative error
% we don't consider firsts time instants because amplitude of the curves
% can be random at the beginning
nTouchCluster = zeros(1,steps);
initRow = find (T<=30, 1, 'last');
maximum = max(Y(initRow:end , 1));
minimum = min(Y(initRow:end , 1));
error = (maximum - minimum)*(errorPercentage/100);

% initialization of the output matrix
completeSyncro = zeros(steps,nSensors);

% for every step find if sensors are coupled
for stepActivation = 1:steps    
    
    % number of row in I is the number of the sensor
    sensorActivated = find(I(:,stepActivation) == 2);
    nSensorActivated = length(sensorActivated);
    
    switch obsMode
        case 1 %5 observations
            row = find( T <= tf*stepActivation - tf/2, 1, 'last' );
            actualTime = T(row);

            subTime(1) = actualTime - tf/3;
            subTime(2) = actualTime - tf/6;
            subTime(3) = actualTime;
            subTime(4) = actualTime + tf/6;
            subTime(5) = actualTime + tf/3;

            subRow(1) = find( T<=  subTime(1), 1, 'last' );
            subRow(2) = find( T<=  subTime(2), 1, 'last' );
            subRow(3) = find( T<=  subTime(3), 1, 'last' );
            subRow(4) = find( T<=  subTime(4), 1, 'last' );
            subRow(5) = find( T<=  subTime(5), 1, 'last' );
   
        case 2 %9 observations     
            row = find( T <= tf*stepActivation - tf/2, 1, 'last' );
            actualTime = T(row);      

            subTime(1) = actualTime - tf/12;
            subTime(2) = actualTime - tf/6;
            subTime(3) = actualTime - tf/4;
            subTime(4) = actualTime - tf/3;
            subTime(5) = actualTime + 5*tf/12;
            subTime(6) = actualTime + tf/12;
            subTime(7) = actualTime + tf/6;
            subTime(8) = actualTime + tf/4;
            subTime(9) = actualTime + tf/3;

            subRow(1) = find( T<=  subTime(1), 1, 'last' );
            subRow(2) = find( T<=  subTime(2), 1, 'last' );
            subRow(3) = find( T<=  subTime(3), 1, 'last' );
            subRow(4) = find( T<=  subTime(4), 1, 'last' );
            subRow(5) = find( T<=  subTime(5), 1, 'last' );
            subRow(6) = find( T<=  subTime(6), 1, 'last' );
            subRow(7) = find( T<=  subTime(7), 1, 'last' );
            subRow(8) = find( T<=  subTime(8), 1, 'last' );
            subRow(9) = find( T<=  subTime(9), 1, 'last' );

        case 3 % 5 observations in the second half
            row = find( T <= tf*stepActivation - tf/2, 1, 'last' );
            actualTime = T(row);

            subTime(1) = actualTime + tf/12;
            subTime(2) = actualTime +tf/6;
            subTime(3) = actualTime + tf/4;
            subTime(4) = actualTime + tf/3;
            subTime(5) = actualTime + 5*tf/12;

            subRow(1) = find( T<=  subTime(1), 1, 'last' );
            subRow(2) = find( T<=  subTime(2), 1, 'last' );
            subRow(3) = find( T<=  subTime(3), 1, 'last' );
            subRow(4) = find( T<=  subTime(4), 1, 'last' );
            subRow(5) = find( T<=  subTime(5), 1, 'last' );
            
        case 4 % 9 observations near three maximum
            initialTime = tf*stepActivation- tf;
            finalTime = tf*stepActivation;
            intervalTime1 = initialTime + (finalTime - initialTime)/3;
            intervalTime2 = initialTime + 2*(finalTime - initialTime)/3;

            initialRow = find( T > initialTime, 1, 'first');
            intervalRow1 = find( T > intervalTime1, 1, 'first');
            intervalRow2 = find( T > intervalTime2, 1, 'first');
            finalRow = find( T < finalTime, 1, 'last');

            [~, maxIndexLocal1] = max(Y(initialRow:intervalRow1 , (2*sensorActivated(1)-1) ));
            [~, maxIndexLocal2] = max(Y(intervalRow1:intervalRow2 , (2*sensorActivated(1)-1) ));
            [~, maxIndexLocal3] = max(Y(intervalRow2:finalRow , (2*sensorActivated(1)-1) ));

            subTime(1) = T(maxIndexLocal1 + initialRow) +1.5;
            subRow(1) = find( T>=  subTime(1), 1, 'first' );
            subTime(2) = T(maxIndexLocal1 + initialRow) + 1;
            subRow(2) = find( T>=  subTime(2), 1, 'first' );
            subTime(3) = T(maxIndexLocal1 + initialRow) + 2;
            subRow(3) = find( T>=  subTime(3), 1, 'first' );

            subTime(4) = T(maxIndexLocal2 + intervalRow1) +1.5;
            subRow(4) = find( T>=  subTime(4), 1, 'first' );
            subTime(5) = T(maxIndexLocal2 + intervalRow1) + 1;
            subRow(5) = find( T>=  subTime(5), 1, 'first' );
            subTime(6) = T(maxIndexLocal2 + intervalRow1) + 2;
            subRow(6) = find( T>=  subTime(6), 1, 'first' );

            subTime(7) = T(maxIndexLocal3 + intervalRow2) +1.5;
            subRow(7) = find( T>=  subTime(7), 1, 'first' );
            subTime(8) = T(maxIndexLocal3 + intervalRow2) + 1;
            subRow(8) = find( T>=  subTime(8), 1, 'first' );
            subTime(9) = T(maxIndexLocal3 + intervalRow2) + 2;
            subRow(9) = find( T>=  subTime(9), 1, 'first' );
            
        case 5 %9 observations at random time
            initialTime = tf*stepActivation- tf;
            finalTime = tf*stepActivation;
            
            subTime = (finalTime - initialTime).*rand(9,1)+initialTime;
            
            for i=1:9
                subRow(i) = find(T<=subTime(i), 1, 'last');
            end
            
        otherwise
           disp('ERROR: Insert modality between 1 and 5')
           return
    end
    
	nObservations = length(subRow);
    
	% find amplitudes of the curves at that times
	values = (Y(subRow, ( (sensorActivated')*2 -1) ))';
    
    if nSensorActivated > 1 
        % distances contains 1 if the differences of amplitudes between each
        % couple of activated oscillators are < error, 0 if not.
        % So the number of the columns is the binomial coefficent of nSensorActivated and 2   
        binDistances = zeros(nObservations, nchoosek(nSensorActivated, 2) );
        
        for i = 1:nObservations
            % pdist differences of amplitudes between each
            % couple of activated oscillators
            % the distances are in the following order : 
            % (1,2) ,(1,3) (1,4) ... (2,3) , (2,4) ...
            distances = pdist(values(:,i));
            lengthDist = length(distances);

            for j = 1: lengthDist
                if distances(1,j) <= error 
                    binDistances(i, j) = 1;
                end
            end
        end
      
       % compute the average and round it to nearest value to take 
       % the more frequent value between five observation
       for i = 1:lengthDist
           resBinDistances(i) = 0;
           for j=1:nObservations
              resBinDistances(i) = resBinDistances(i) + binDistances(j,i);
           end
              resBinDistances(i) = round( resBinDistances(i) / j);
       end
       
     
       % Now we find the clusters group
       
       % syncro is the vector that contains clusters of sincronized
       % oscillators (only the ones activated)
       syncro = zeros(1,nSensorActivated);
       syncro(1) = 1;
       
       counterCluster=2; % the number of the cluster 
       
       % indexing distances between first oscillators and all the others
       for i = 1: nSensorActivated-1
          
           % if 1, they are syncronized so they must have same cluster number
           if resBinDistances(1, i) == 1
               syncro(i+1) = 1;
           else % otherwise they must have different cluster number
               syncro(i+1) = counterCluster;
               counterCluster = counterCluster+1;
           end            
       end
 
       j = 1;  % index to decrease the number of the comparison in the inner for
      
       if nSensorActivated > 2
          d = nSensorActivated;
          for i = nSensorActivated: lengthDist

               first = j+1;
               
               % indexing the comparison between first and the others
               % successive sensors
               for b = d: ( (d-1) + nSensorActivated-1) - j
                   second = first+1;
                   
                   % if so, they must have the same number of the cluster
                   if resBinDistances(b) == 1
                       value = min( syncro(first), syncro(second) );
                       
                       syncro(first) = value;
                       syncro(second) = value;
                   end
                   
                  second = second +1;
               end
               
                d = b+1;
                j = j+1;
          end
        end
      
        % integrate row with not activated oscillators (0 value for them)
        for i = 1:length(syncro)
        	completeSyncro(stepActivation, sensorActivated(i)) = syncro(i);  
        end
      
        nTouchCluster(stepActivation) = length( unique(syncro));
 
	else
        completeSyncro(stepActivation, sensorActivated(1)) = 1;
        nTouchCluster(stepActivation) = 1;
        
    end       
end

% Display heatmap
figure
heatmap(completeSyncro); 
title(['Touch pattern recognized by sensors with method ' num2str(obsMode)]);
xlabel('Sensor Id');
ylabel('Step');
