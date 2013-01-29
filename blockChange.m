function blockChange(varargin)
%'void BlockChanged(string ActBlock, string ActTank, string ActServer)'

global tankTDT;
global blockTDT;
global eventTDT;
global event2TDT;
global event3TDT;
global event4TDT;
global event5TDT;
global currentBlock;
currentBlock = varargin{3};

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