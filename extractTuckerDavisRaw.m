function extractTuckerDavisRaw(myTank, myBlock, myEvent, Channel, directorySave, filenameSave, chunkSize, varargin)
% Uses the subfunction getdataATR to extract a single channel from a tank,
% writes the data to two binary files:
%               - data.F32 for the samples
%               - time.F32 for the timestamps for each sample

maxMemUse = 1024;       % Maximum allowed memory, in MB
                        % 32bits * 25KHz sampling = 97 KB/chan/sec.
                        % So 500MB is 320sec of a 16-chan raw recording.
global TDTX;

if TDTX.ConnectServer('Local','Me') == 0 error('Error connecting to server'); end
if TDTX.OpenTank(myTank,'R') == 0 error('Error opening tank'); end
if TDTX.SelectBlock(['~' myBlock]); % ~ autogenerates epoch index
TDTX.ResetFilters;
TDTX.ResetGlobals;
TDTX.SetGlobalV('WavesMemLimit',maxMemUse*1024*1024);
TR = TDTX.GetValidTimeRangesV();

numvarargs = length(varargin);
if numvarargs > 3
    error('Too many arguments');
elseif numvarargs == 0 % Time span not entered, extracting full length, assuming single precision
    T1 = 0;
    T2 = TR(2);
    dataType = 'single';
elseif numvarargs == 1 % One extra argument entered, assumed to be a datatype
    T1 = 0;
    T2 = TR(2);
    dataType = varargin{1};
    if ~ischar(dataType) 
        error('A single extra argument should be a data type. To adjust the time span enter both a start and end time.');
    end
elseif numvarargs == 2 % Two extra arguments should be the start and end times
    T1 = varargin{1};
    if varargin{2} == 0
        T2 = TR(2);
    else
        T2 = varargin{2};
    end
    dataType = 'single';
elseif numvarargs == 3 % The third extra argument will be the data type
    T1 = varargin{1};
    T2 = varargin{2};
    dataType = varargin{3};
end

if strcmp(dataType,'single')
    fidD = fopen([directorySave '\' filenameSave '_Channel_' num2str(Channel) ' ' myEvent '_data.F32'],'w');
    fidT = fopen([directorySave '\' filenameSave '_Channel_' num2str(Channel) ' ' myEvent '_time.F32'],'w');
elseif strcmp(dataType,'int32')
    fidD = fopen([directorySave '\' filenameSave '_Channel_' num2str(Channel) ' ' myEvent '_data.I32'],'w');
    fidT = fopen([directorySave '\' filenameSave '_Channel_' num2str(Channel) ' ' myEvent '_time.I32'],'w');
elseif strcmp(dataType,'int16')
    fidD = fopen([directorySave '\' filenameSave '_Channel_' num2str(Channel) ' ' myEvent '_data.I16'],'w');
    fidT = fopen([directorySave '\' filenameSave '_Channel_' num2str(Channel) ' ' myEvent '_time.I16'],'w');
else
    error([dataType ' is not a recognized data dataType.']);
end;

i = T1;
lastTS = -1;
onemore = true;

while i+chunkSize < T2
    disp(['Extracting channel ' num2str(Channel) ' time window starting at ' num2str(i) ' seconds.']);
    [y t ti] = getdataATR(TDTX, myEvent, Channel, i, i+chunkSize);
    j = 1;
    while t(j) < (lastTS + (ti/4))
        j = j+1;
    end
    fwrite(fidD,y(j:end),dataType);
    fwrite(fidT,t(j:end),dataType);
    i = i+chunkSize-ti;
    lastTS = t(end);
end

disp(['Extracting channel ' num2str(Channel) ' time window starting at ' num2str(i) ' seconds.']);
[y t ti] = getdataATR(TDTX, myEvent, Channel, i, T2);
j = 1;
while t(j) < (lastTS + (ti/4))
    j = j+1;
end
fwrite(fidD,y(j:end),dataType);
fwrite(fidT,t(j:end),dataType);

fclose(fidD);
fclose(fidT);
disp(['Finished extracting channel ' num2str(Channel) ' data.']);

fidD = fopen([directorySave '\' filenameSave '_Channel_' num2str(Channel) ' ' myEvent '_data.F32'],'r');
fidT = fopen([directorySave '\' filenameSave '_Channel_' num2str(Channel) ' ' myEvent '_time.F32'],'r');

extractedData = fread(fidD, inf, '*single');
extractedTimes = fread(fidT, inf, '*single');
filenameData = [directorySave '\' filenameSave '_Channel_' num2str(Channel) ' ' myEvent '_extracted_data.mat']; 
filenameTime = [directorySave '\' filenameSave '_' myEvent '_extracted_time.mat'];
save(filenameData,'extractedData','-mat')
save(filenameTime,'extractedTimes','-mat')

fclose(fidD);
fclose(fidT);

disp(['Finished saving channel ' num2str(Channel) ' data (no zero-padding).']);
TDTX.CloseTank;
TDTX.ReleaseServer;

delete([directorySave '\*.F32']);

end