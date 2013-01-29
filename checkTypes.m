function checkTypes()

global currentServer;
global currentTank;
global currentBlock;
global currentEvent;
global currentEvent2;
global currentEvent3;
global currentEvent4;
global currentEvent5;
global TDTX;
global eventType;

if TDTX.ConnectServer('Local','Me') == 0 error('Error: Cannot connect to TDT Local Server.'); end
if TDTX.OpenTank(currentTank,'R') == 0 error('Error: Cannot open selected TDT Tank.'); end
if TDTX.SelectBlock(currentBlock);
    blockNotes = TDTX.CurBlockNotes;
    %pull out event stores
    textStore = 'NAME=StoreName;TYPE=\w;VALUE=\w{4}';
    findStore = regexp(blockNotes,textStore,'match');
    eventNames = regexprep(findStore,'(............................)','');
    
    %pull out ev types
    dataStore = 'NAME=TankEvType;TYPE=\w;VALUE=\d{1,}';
    findEv = regexp(blockNotes,dataStore,'match');
    eventEvTypes = regexprep(findEv,'(.............................)','');

    eventType{1,1} = eventEvTypes(1,find(strcmp(currentEvent,eventNames)));
    eventType{1,2} = eventEvTypes(1,find(strcmp(currentEvent2,eventNames)));
    eventType{1,3} = eventEvTypes(1,find(strcmp(currentEvent3,eventNames)));
    eventType{1,4} = eventEvTypes(1,find(strcmp(currentEvent4,eventNames)));
    eventType{1,5} = eventEvTypes(1,find(strcmp(currentEvent5,eventNames)));
    eventType{2,1} = currentEvent;
    eventType{2,2} = currentEvent2;
    eventType{2,3} = currentEvent3;
    eventType{2,4} = currentEvent4;
    eventType{2,5} = currentEvent5;
end
