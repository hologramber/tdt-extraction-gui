function [epochCol] = extractEpochWithRef(myTank, myBlock, myEpoch, directorySave, filenameSave, startTime, endTime, samplingRefStore)

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

if exist(directorySave,'dir')
    disp([directorySave ' found.']);
else
    mkdir(directorySave)
    disp([directorySave ' created.']);
end

% Increase memory limit available to the connection. It expects a number in bytes.
TDTX.SetGlobalV('WavesMemLimit',maxMemUse*1024*1024);

% Read the store whose frequency we intend to match, and extract its sampling frequency.
TDTX.GetCodeSpecs(TDTX.StringToEvCode(samplingRefStore));
samplingFreq = TDTX.EvSampFreq;
samplingPeriod = 1/samplingFreq;

% Read out the times that the epochs transition, and what value they transition to. These are row vectors.
numEvents=TDTX.ReadEventsV(1000000,myEpoch,0,0,startTime,endTime,'ALL');
epochTransitionVals = TDTX.ParseEvV(0,numEvents);
epochTransitionTimes = TDTX.ParseEvInfoV(0,numEvents,6);

% Pluck out sample numbers
for i=1:length(epochTransitionTimes)
    epochData{2,7}(i,1) = ceil(epochTransitionTimes(i)*samplingFreq);
end

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

% Now, using those transition times, stitch together a vector running from startTime to endTime that upsamples the epochs into a continuous record.
epochTime = startTime:samplingPeriod:(endTime);

% Next, create a MATLAB Timeseries object using the known transitions; this will let us efficiently upsample.
% Use the built-in resampling functions to get out a data vector that matches the time vector. 'zoh' is zero-order hold, as opposed to a linear interpolation which would mess us up.
% What we get back is still a timeseries object, so we need to pull out the "Data" vector and ensure it's a row.
epochCol = resample(timeseries(epochTransitionVals,epochTransitionTimes),epochTime,'zoh');
epochCol = epochCol.Data;
epochCol = reshape(epochCol,1,[]);

epochData{1,1} = 'Epoch Store Name';
epochData{1,2} = 'Sampling Reference Name';
epochData{1,3} = 'Sampling Reference Freq';
epochData{1,4} = 'Epoch Values Resampled';
epochData{1,5} = 'Transition Values (Plain)';
epochData{1,6} = 'Transition Timestamps (NO Freq Ref)';
epochData{1,7} = 'Transition Sample #s (Sampling Ref)';

epochData{2,1} = myEpoch;
epochData{2,2} = samplingRefStore;
epochData{2,3} = samplingFreq;
epochData{2,4} = epochCol;
epochData{2,5} = epochTransitionVals;
epochData{2,6} = epochTransitionTimes;

filenameEpochs = [directorySave '\' filenameSave '_' myEpoch '_extracted_epoch_series_SamplingReference_' samplingRefStore '.mat']; 
save(filenameEpochs,'epochData','-mat');
disp(['Finished extracting epoch time series.']);
disp(['If you are trying to match epoch times to a stream of data, use the Sample Numbers (epochData{2,7}) as a reference.']);

TDTX.CloseTank;
TDTX.ReleaseServer;

end
