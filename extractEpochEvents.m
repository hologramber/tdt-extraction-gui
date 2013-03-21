function extractEpochEvents(myTank, myBlock, directorySave, filenameSave, T1, T2, epochStores)

maxMemUse = 1024;       % Maximum allowed memory, in MB
                        % 32bits * 25KHz sampling = 97 KB/chan/sec.
                        % So 500MB is 320sec of a 16-chan raw recording.
global TDTX;
if TDTX.ConnectServer('Local','Me') == 0 error('Error connecting to server'); end
if TDTX.OpenTank(myTank,'R') == 0 error('Error opening tank'); end
if TDTX.SelectBlock(['~' myBlock]); % ~ autogenerates epoch index

% Initialize blank return arrays.
epochTimes = [];
epochValues = [];

epochStorage{1,1} = 'Epoch Name';
epochStorage{1,2} = 'Epoch Data';
epochStorage{1,3} = 'Timestamp';

disp(['Extracting ' epochStores ' epoch events & timestamps.']);
% Load the channel into tank memory.
numEvents = TDTX.ReadEventsV(1000000, char(epochStores), 0, 0, T1, T2, 'All');

if (numEvents > 0) 
    % ParseEvV returns data in columns, and we want rows.
    epochValues = (TDTX.ParseEvV(0,numEvents))';
    epochTimes = (TDTX.ParseEvInfoV(0,numEvents,6))';
end

% Save everything into a cell array w/the name of the epoch store.
epochStorage{2,1} = char(epochStores);
epochStorage{2,2} = epochValues;
epochStorage{2,3} = epochTimes;

filenameEpochs = [directorySave '\' filenameSave '_' epochStores '_extracted_epoch_events_and_timestamps.mat']; 
save(filenameEpochs, 'numEvents','epochStorage','-mat');
disp(['Finished extracting epoch events & timestamps.']);

TDTX.CloseTank;          % Close connection to tank
TDTX.ReleaseServer;

end
