function extractSnippets (myTank, myBlock, myStore, myChannels, directorySave, OutFile, startTime, endTime)

maxMemUse = 1024;       % Maximum allowed memory, in MB
                        % 32bits * 25KHz sampling = 97 KB/chan/sec.
                        % So 500MB is 320sec of a 16-chan raw recording.

global TDTX;

if TDTX.ConnectServer('Local','Me') == 0 error('Error connecting to server'); end
if TDTX.OpenTank(myTank,'R') == 0 error('Error opening tank'); end
if TDTX.SelectBlock(['~' myBlock]); % ~ autogenerates epoch index

% Increase memory limit available to the connection.
TDTX.SetGlobalV('WavesMemLimit',maxMemUse*1024*1024);

% Initialize blank return arrays.
spikeTimes = [];
spikeSnippets = [];
%spikeChannels = [];
spikeCodes = [];


% Iterate through the channels.
for i=1:length(myChannels)
    disp(['Extracting snippets for channel ' num2str(myChannels(i))]);
    % Load the channel into tank memory.
    numEvents = TDTX.ReadEventsV(1000000, myStore, myChannels(i), 0, startTime, endTime, 'All');
    
    if (numEvents > 0) 
        % ParseEvV returns data in columns, and we want rows.
        spikeSnippets = (TDTX.ParseEvV(0,numEvents))';
        spikeTimes = (TDTX.ParseEvInfoV(0,numEvents,6))';
        %spikeChannels = (TTank.ParseEvInfoV(0,numEvents,4))';
        spikeCodes = (TDTX.ParseEvInfoV(0,numEvents,5))';
    end
    snippetData{1,1} = spikeSnippets;
    snippetData{1,2} = spikeTimes;
    %snippetData{i,3} = spikeChannels;
    snippetData{1,3} = spikeCodes;
    filenameSnippets = [directorySave '\' OutFile '_Channel_' num2str(myChannels(i)) '_extracted_snippets.mat'];
    save(filenameSnippets, 'numEvents','snippetData','-mat');
    disp(['Finished extracting snippets from channel ' num2str(myChannels(i)) '.']);
    clear snippetData;
end

% Close connection to tank
TDTX.CloseTank;
TDTX.ReleaseServer;

end
