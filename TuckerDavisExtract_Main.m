% TuckerDavisExtract_Main
% Run this .m to load the extraction GUI.
clc; clear all; close all; format long;

global currentServer;
currentServer = 'Local';
global TDTX;
TDTX = actxcontrol('TTank.X', [0 0 5 5], TDTExtract_GUI);