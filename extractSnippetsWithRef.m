function extractSnippetsWithRef (myTank, myBlock, myStore, myChannels, directorySave, OutFile, startTime, endTime, samplingRefStore)

maxMemUse = 1024;       % Maximum allowed memory, in MB
                        % 32bits * 25KHz sampling = 97 KB/chan/sec.
                        % So 500MB is 320sec of a 16-chan raw recording.

global TDTX;
if TDTX.ConnectServer('Local','Me') == 0 error('Error connecting to server'); end
if TDTX.OpenTank(myTank,'R') == 0 error('Error opening tank'); end
if TDTX.SelectBlock(['~' myBlock]); % ~ autogenerates epoch index
TDTX.ResetFilters;
TDTX.ResetGlobals;

% Increase memory limit available to the connection.
TDTX.SetGlobalV('WavesMemLimit',maxMemUse*1024*1024);

% Initialize blank return arrays.
spikeTimes = [];
spikeSnippets = [];
spikeChannels = [];
spikeCodes = [];

snippetData{1,1} = 'Snippet Store';
snippetData{1,2} = 'Snippet Data';
snippetData{1,3} = 'Snippet Timestamps';
snippetData{1,4} = 'Snippet Sort Codes';
snippetData{1,5} = 'Snippet Channels';
snippetData{1,6} = 'Sampling Reference Store';
snippetData{1,7} = 'Reference Sampling Freq';
snippetData{1,8} = 'Snippet Sample #s (Ref)';

TDTX.GetCodeSpecs(TDTX.StringToEvCode(samplingRefStore));
samplingFreq = TDTX.EvSampFreq;

% Iterate through the channels.
for i=1:length(myChannels)
    disp(['Extracting snippets for channel ' num2str(myChannels(i))]);
    % Load the channel into tank memory.
    numEvents = TDTX.ReadEventsV(1000000, myStore, myChannels(i), 0, startTime, endTime, 'All');
    
    if (numEvents > 0) 
        % ParseEvV returns data in columns, and we want rows.
        spikeSnippets = (TDTX.ParseEvV(0,numEvents))';
        spikeTimes = (TDTX.ParseEvInfoV(0,numEvents,6))';
        spikeCodes = (TDTX.ParseEvInfoV(0,numEvents,5))';
        spikeChannels = (TDTX.ParseEvInfoV(0,numEvents,4))';
    end
    
    for j=1:numEvents
        snippetRefTimes(j,1) = ceil(spikeTimes(j,1)*samplingFreq);
    end
    
    snippetData{2,1} = myStore;
    snippetData{2,2} = spikeSnippets;
    snippetData{2,3} = spikeTimes;
    snippetData{2,4} = spikeCodes;
    snippetData{2,5} = spikeChannels;
    snippetData{2,6} = samplingRefStore;
    snippetData{2,7} = samplingFreq;
    snippetData{2,8} = snippetRefTimes;
    filenameSnippets = [directorySave '\' OutFile '_Channel_' num2str(myChannels(i)) '_extracted_snippets.mat'];
    save(filenameSnippets, 'numEvents','snippetData','-mat');
    disp(['Finished extracting snippets from channel ' num2str(myChannels(i)) '.']);
    disp(['If you are trying to match snippet times to a stream of data, use the Sample Numbers (snippetData{2,8}) as a reference.']);
    clear snippetData;
end

% Close connection to tank
TDTX.CloseTank;
TDTX.ReleaseServer;

end
