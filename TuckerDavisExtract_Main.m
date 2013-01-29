%TuckerDavisExtract_Main
clc; clear all; close all;

global tankTDT;
global blockTDT;
global eventTDT;
global event2TDT;
global event3TDT;
global event4TDT;
global event5TDT;
global currentServer;
currentServer = 'Local';
global currentTank;
global currentBlock;
global currentEvent;
global currentEvent2;
global currentEvent3;
global currentEvent4;
global currentEvent5;
global TDTX;
global eventType;

handlerTDTExtract = TDTExtract_v10;

TDTX = actxcontrol('TTank.X', [0 0 5 5], handlerTDTExtract);

%waveform
%snippet
%epoch
%other
