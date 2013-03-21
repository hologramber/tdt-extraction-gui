function varargout = TDTExtract_v10(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TDTExtract_v10_OpeningFcn, ...
                   'gui_OutputFcn',  @TDTExtract_v10_OutputFcn, ...
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
% End initialization code - DO NOT EDIT

% --- Executes just before TDTExtract_v10 is made visible.
function TDTExtract_v10_OpeningFcn(hObject, eventdata, handles, varargin)
global TDTX;
global currentServer;
global currentTank;
global currentBlock;
global currentEvent;
global currentEvent2;
global currentEvent3;
global currentEvent4;
global currentEvent5;
global tankTDT;
global blockTDT;
global eventTDT;
global event2TDT;
global event3TDT;
global event4TDT;
global event5TDT;

handles.output = hObject;   % Choose default command line output for TDTExtract_v10
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

% tankev = tankTDT.events
% blockev = blockTDT.events
% eventev = eventTDT.events
% 
% tankinv = tankTDT.invoke
% blockinv = blockTDT.invoke
% eventinv = eventTDT.invoke
% 
% tankget = tankTDT.get
% blockget = blockTDT.get
% eventget = eventTDT.get

% --- Outputs from this function are returned to the command line.
function varargout = TDTExtract_v10_OutputFcn(hObject, eventdata, handles) 
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
global currentServer;
global currentTank;
global currentBlock;
global currentEvent;
global currentEvent2;
global currentEvent3;
global currentEvent4;
global currentEvent5;
global eventType;

userChannelList = get(handles.channelList,'String');
userChunkSize = str2num(get(handles.chunkSize,'String'));
userT1 = str2num(get(handles.startTime,'String'));
userT2 = str2num(get(handles.endTime,'String'));
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
        case '257' %257 = Strobe+ (e.g. "Tick")
            disp('epoch data!')
                extractEpochEvents(currentTank,currentBlock,directorySave,filenameSave,userT1,userT2,eventType{2,i});
        case '258' %258 = strobe-   
        case '513' %513 = scalar??? 
        case '33025' %33025 = stream
            disp('stream data!')
            for definedChannel = inputChannels
                extractTuckerDavisRaw(currentTank,currentBlock,eventType{2,i},definedChannel,directorySave,filenameSave,userChunkSize,userT1,userT2);
            end
        case '33281' %33281 = snippet
            disp('snippet data!')
            extractSnippets(currentTank,currentBlock,eventType{2,i},inputChannels,directorySave,filenameSave,userT1,userT2);
        case '34817' %34817 = mark???
        case '32768' %32768 = hasdata?????
        case 'unused'
            disp('No event data!')
        otherwise % 0 = unknown?????
            error('Your data puzzles me. I cannot process it. [Data Type = Unknown]');
    end
end
