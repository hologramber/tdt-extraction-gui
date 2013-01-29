function tankChange(varargin)
%varargin(#): 1 = com obj, 2 = ref #, 3 = tank name, 4 = server name
%TankChanged: 'void TankChanged(string ActTank, string ActServer)'

global tankTDT;
global blockTDT;
global eventTDT;
global event2TDT;
global event3TDT;
global event4TDT;
global event5TDT;
global currentTank;

currentTank = varargin{3};

blockTDT.UseTank = tankTDT.ActiveTank;
blockTDT.Refresh;

eventTDT.UseTank = tankTDT.ActiveTank;
eventTDT.UseBlock = '';
eventTDT.Refresh;

event2TDT.UseTank = tankTDT.ActiveTank;
event2TDT.UseBlock = '';
event2TDT.Refresh;

event3TDT.UseTank = tankTDT.ActiveTank;
event3TDT.UseBlock = '';
event3TDT.Refresh;

event4TDT.UseTank = tankTDT.ActiveTank;
event4TDT.UseBlock = '';
event4TDT.Refresh;

event5TDT.UseTank = tankTDT.ActiveTank;
event5TDT.UseBlock = '';
event5TDT.Refresh;

