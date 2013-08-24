function extractTuckerDavisRaw2(myTank, myBlock, myEvent, Channel, directorySave, filenameSave)

maxMemUse = 1024*1024*1024;

global TDTX;
if TDTX.ConnectServer('Local','Me') == 0 error('Error connecting to server'); end
if TDTX.OpenTank(myTank,'R') == 0 error('Error opening tank'); end
if TDTX.SelectBlock(['~' myBlock]); % ~ autogenerates epoch index
TDTX.ResetFilters;
TDTX.ResetGlobals;

extractedMethod2{1,1} = 'Event Name';
extractedMethod2{1,2} = 'Channel #';
extractedMethod2{1,3} = 'Total Samples';
extractedMethod2{1,4} = 'Waveform';
extractedMethod2{1,5} = 'Timestamps';

if exist(directorySave,'dir')
    disp([directorySave ' found.']);
else
    mkdir(directorySave)
    disp([directorySave ' created.']);
end

TDTX.GetCodeSpecs(TDTX.StringToEvCode(myEvent))
fs = TDTX.EvSampFreq;
ts1 = TDTX.GetValidTimeRangesV;
% ts(2) = total # of seconds
totalSamp = ts1(2)*fs;
waveData = TDTX.ReadWavesOnTimeRangeV(myEvent,Channel);
timesData = [ts1(1):(1/fs):ts1(2)];

extractedMethod2{2,1} = char(myEvent);
extractedMethod2{2,2} = Channel;
extractedMethod2{2,3} = totalSamp;
extractedMethod2{2,4} = waveData;
extractedMethod2{2,5} = timesData;

filenameRaw2 = [directorySave '\' filenameSave '_Channel_' num2str(Channel) '_' myEvent '_extracted_data_and_time_Method2.mat']; 
save(filenameRaw2, 'extractedMethod2','-mat');
disp(['Finished saving channel ' num2str(Channel) ' data using Method 2 (allows zero-padding).']);

TDTX.CloseTank;          % Close connection to tank
TDTX.ReleaseServer;

end

