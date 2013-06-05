function varargout = TDTExtract_GUI(varargin)
% Begin initialization code, probably don't want to edit this part.
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TDTExtract_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TDTExtract_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% --- Executes just before TDTExtract_GUI is made visible.
function TDTExtract_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
global tankTDT;
global blockTDT;
global eventTDT;
global event2TDT;
global event3TDT;
global event4TDT;
global event5TDT;

handles.output = hObject;   % Choose default command line output for TDTExtract_GUI
guidata(hObject, handles);  % Update handles structure

tankTDT = actxcontrol('TANKSELECT.TankSelectActiveXCtrl.1','position',[20 680 375 150],'parent',hObject,'callback','tankChange');
tankTDT.SingleClickSelect = 1;

blockTDT = actxcontrol('BlockSelect.BlockSelectActiveXCtrl.1','position',[20 390 375 240],'parent',hObject,'callback',{'BlockChanged' 'blockChange'});
blockTDT.HideDetails = 0;
blockTDT.ShowOwner = 0;
blockTDT.ShowMemo = 0;
blockTDT.ShowStart = 1;
blockTDT.ShowStop = 0;
blockTDT.SingleClickSelect = 1;

eventTDT = actxcontrol('EVENTSELECT.EventSelectActiveXCtrl.1','position',[20 225 375 115],'parent',hObject,'callback',{'ActEventChanged' 'eventChange'});
eventTDT.HideDetails = 0;
eventTDT.SingleClickSelect = 1;

event2TDT = actxcontrol('EVENTSELECT.EventSelectActiveXCtrl.1','position',[450 630 375 115],'parent',hObject,'callback',{'ActEventChanged' 'event2Change'});
event2TDT.HideDetails = 0;
event2TDT.SingleClickSelect = 1;

event3TDT = actxcontrol('EVENTSELECT.EventSelectActiveXCtrl.1','position',[450 495 375 115],'parent',hObject,'callback',{'ActEventChanged' 'event3Change'});
event3TDT.HideDetails = 0;
event3TDT.SingleClickSelect = 1;

event4TDT = actxcontrol('EVENTSELECT.EventSelectActiveXCtrl.1','position',[450 360 375 115],'parent',hObject,'callback',{'ActEventChanged' 'event4Change'});
event4TDT.HideDetails = 0;
event4TDT.SingleClickSelect = 1;

event5TDT = actxcontrol('EVENTSELECT.EventSelectActiveXCtrl.1','position',[450 225 375 115],'parent',hObject,'callback',{'ActEventChanged' 'event5Change'});
event5TDT.HideDetails = 0;
event5TDT.SingleClickSelect = 1;

% --- Outputs from this function are returned to the command line.
function varargout = TDTExtract_GUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes on button press in clearEvents.
function clearEvents_Callback(hObject, eventdata, handles)
global tankTDT;
global blockTDT;
global eventTDT;
global event2TDT;
global event3TDT;
global event4TDT;
global event5TDT;
global currentEvent;
global currentEvent2;
global currentEvent3;
global currentEvent4;
global currentEvent5;

eventTDT.UseTank = tankTDT.ActiveTank;
eventTDT.UseBlock = blockTDT.ActiveBlock;
eventTDT.Refresh;

event2TDT.UseTank = tankTDT.ActiveTank;
event2TDT.UseBlock = blockTDT.ActiveBlock;
event2TDT.Refresh;

event3TDT.UseTank = tankTDT.ActiveTank;
event3TDT.UseBlock = blockTDT.ActiveBlock;
event3TDT.Refresh;

event4TDT.UseTank = tankTDT.ActiveTank;
event4TDT.UseBlock = blockTDT.ActiveBlock;
event4TDT.Refresh;

event5TDT.UseTank = tankTDT.ActiveTank;
event5TDT.UseBlock = blockTDT.ActiveBlock;
event5TDT.Refresh;

currentEvent = '';
currentEvent2 = '';
currentEvent3 = '';
currentEvent4 = '';
currentEvent5 = '';

%%%%%%%%%%%%% List of Channels
function channelList_Callback(hObject, eventdata, handles)
function channelList_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

userChannelList = str2num(get(hObject,'String'));
if isempty(userChannelList)
    set(hObject,'String','1:16');
end
guidata(hObject,handles);

%%%%%%%%%%%%% Chunk Size
function chunkSize_Callback(hObject, eventdata, handles)
function chunkSize_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

userChunkSize = str2num(get(hObject,'String'));
if isempty(userChunkSize)
    set(hObject,'String','100');
end
guidata(hObject,handles);

%%%%%%%%%%%%% Start Time via User
function startTime_Callback(hObject, eventdata, handles)
function startTime_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

userT1 = str2num(get(hObject,'String'));
if isempty(userT1)
    set(hObject,'String','0.0');
end
guidata(hObject,handles);
    
%%%%%%%%%%%%% End Time via User
function endTime_Callback(hObject, eventdata, handles)
function endTime_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

userT2 = str2num(get(hObject,'String'));
if isempty(userT2)
    set(hObject,'String','0.0');
end
guidata(hObject,handles);

function epochSamplingRef_Callback(hObject, eventdata, handles)
function epochSamplingRef_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

epochSamplingRef = get(hObject,'String');
if  isempty(epochSamplingRef)
    set(hObject,'String','n/a');
    epochSamplingRef = 'n/a';
end
guidata(hObject,handles);

%%%%%%%%%%%%% Filename Prefix via User
function filenameSave_Callback(hObject, eventdata, handles)
function filenameSave_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

filenameSave = get(hObject,'String');
if  isempty(filenameSave)
    set(hObject,'String','Extracted_TDT_Data');
    filenameSave = 'Extracted_TDT_Data';
end
guidata(hObject,handles);

function directorySave_Callback(hObject, eventdata, handles)
function directorySave_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

directorySave = get(hObject,'String');
if  isempty(directorySave)
    set(hObject,'String','C:\ExtractedTDTData');
    directorySave = 'C:\ExtractedTDTData';
end
guidata(hObject,handles);

% --- Executes on button press in changesavedir.
function changesavedir_Callback(hObject, eventdata, handles)
newDirectory = uigetdir('','Please select a folder to save to:');
set(handles.directorySave,'String',newDirectory);
guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Data extraction is a go! Start extracting data!   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function extractDataGo_Callback(hObject, eventdata, handles)
global currentTank;
global currentBlock;
global eventType;

userChannelList = get(handles.channelList,'String');
userChunkSize = str2num(get(handles.chunkSize,'String'));
userT1 = str2num(get(handles.startTime,'String'));
userT2 = str2num(get(handles.endTime,'String'));
epochSamplingRef = get(handles.epochSamplingRef,'String');
filenameSave = get(handles.filenameSave,'String');
directorySave = get(handles.directorySave,'String');
guidata(hObject,handles);

checkTypes;

%if chan list = 0, 1-16
%if chan list has :, n:m
%if chan list has , -- []

commaChannels = strfind(userChannelList,',');
coloChannels = strfind(userChannelList,':');

if userChannelList == '0'
    inputChannels = 1:16;
elseif not(isempty(commaChannels))
    inputChannels = (strread(userChannelList,'%u','delimiter',','))';
elseif not(isempty(coloChannels))
    pullChan = (strread(userChannelList,'%u','delimiter',':'))';
    inputChannels = pullChan(1):pullChan(2);
else
    inputChannels = str2num(userChannelList);
end


for i=1:length(eventType)
    if isempty(eventType{1,i})
        eventType{1,i}{1,1} = 'unused';
    end
    switch eventType{1,i}{1,1}
        case '257'          %257 = Strobe+ (e.g. "Tick")
                if (strcmp(epochSamplingRef,'n/a') || strcmp(epochSamplingRef,''))
                    disp('WARNING: NO SAMPLING REFERENCE WAS GIVEN -- EXTRACTING BASE EPOCH VALUES.');
                    extractEpochNoRef(currentTank,currentBlock,eventType{2,i},directorySave,filenameSave,userT1,userT2);
                else
                    disp('Extracting epoch data with given sampling reference');
                    extractEpochWithRef(currentTank,currentBlock,eventType{2,i},directorySave,filenameSave,userT1,userT2,epochSamplingRef);
                end
        case '33025'        %33025 = stream
            disp('Extracting stream data.')
            for definedChannel = inputChannels
                extractTuckerDavisRaw(currentTank,currentBlock,eventType{2,i},definedChannel,directorySave,filenameSave,userChunkSize,userT1,userT2);
            end
        case '33281'        %33281 = snippet
            if (strcmp(epochSamplingRef,'n/a') || strcmp(epochSamplingRef,''))
                disp('No sampling reference given; extracting snippets without sample references.')
                extractSnippetsNoRef(currentTank,currentBlock,eventType{2,i},inputChannels,directorySave,filenameSave,userT1,userT2);
            else
                disp('Extracting snippet data with sample references');
                extractSnippetsWithRef(currentTank,currentBlock,eventType{2,i},inputChannels,directorySave,filenameSave,userT1,userT2,epochSamplingRef);
            end
        case '258'          %258 = strobe- ]
            error('Error: This version of TDT GUI Extract does not support the STROBE- data type.');
        case '513'          %513 = scalar? 
            error('Error: This version of TDT GUI Extract does not support the SCALAR data type.');
        case '34817'        %34817 = mark?
            error('Error: This version of TDT GUI Extract does not support the MARK data type.');
        case '32768'        %32768 = hasdata?
            error('Error: This version of TDT GUI Extract does not support the HASDATA data type.');
        case 'unused'       % unused
        otherwise           %0 = unknown
            error('Error: Data type unknown.');
    end
end
