function extractEpochNoRef(myTank, myBlock, myEpoch, directorySave, filenameSave, startTime, endTime)

maxMemUse = 1024*1024*1024;         % Maximum allowed memory, in MB
                                    % 32bits * 25KHz sampling = 97 KB/chan/sec.
                                    % So 500MB is 320sec of a 16-chan raw recording.
global TDTX;
if TDTX.ConnectServer('Local','Me') == 0 error('Error connecting to server'); end
if TDTX.OpenTank(myTank,'R') == 0 error('Error opening tank'); end
if TDTX.SelectBlock(['~' myBlock]); % ~ autogenerates epoch index
TDTX.ResetFilters;
TDTX.ResetGlobals;

if(endTime == 0)
    endTime = TDTX.CurBlockStopTime - TDTX.CurBlockStartTime;
end

% Increase memory limit available to the connection. It expects a number in bytes.
TDTX.SetGlobalV('WavesMemLimit',maxMemUse*1024*1024);

if exist(directorySave,'dir')
    disp([directorySave ' found.']);
else
    mkdir(directorySave)
    disp([directorySave ' created.']);
end

% Read out the times that the epochs transition, and what value they transition to. These are row vectors.
numEvents=TDTX.ReadEventsV(1000000,myEpoch,0,0,startTime,endTime,'ALL');
epochTransitionVals = TDTX.ParseEvV(0,numEvents);
epochTransitionTimes = TDTX.ParseEvInfoV(0,numEvents,6);

% If the first transition time is greater than the start time, then assume the value was zero beforehand.
if (epochTransitionTimes(1) > startTime)
   epochTransitionVals = [0 epochTransitionVals];
   epochTransitionTimes = [startTime epochTransitionTimes];
end

% If the last transition time is less than the end time, then the value carries forward.
if (epochTransitionTimes(end) < endTime)
   epochTransitionVals(end+1) = epochTransitionVals(end);
   epochTransitionTimes(end+1) = endTime;
end

epochData{1,1} = 'Epoch Store Name';
epochData{1,2} = 'Sampling Reference Name';
epochData{1,3} = 'Sampling Reference Freq';
epochData{1,4} = 'Epoch Values Resampled';
epochData{1,5} = 'Transition Values (Plain)';
epochData{1,6} = 'Transition Timestamps (NO Freq Ref)';
epochData{1,7} = 'Transition Sample #s (Sampling Ref)';

epochData{2,1} = myEpoch;
epochData{2,2} = 'No Reference Given';
epochData{2,3} = 'No Reference Given';
epochData{2,4} = 'No Reference Given';
epochData{2,5} = epochTransitionVals;
epochData{2,6} = epochTransitionTimes;

filenameEpochs = [directorySave '\' filenameSave '_' myEpoch '_extracted_epoch_series_NoSamplingReference.mat']; 
save(filenameEpochs,'epochData','-mat');
disp(['Finished extracting epoch time series (with no sampling frequency reference).']);

TDTX.CloseTank;
TDTX.ReleaseServer;

end
