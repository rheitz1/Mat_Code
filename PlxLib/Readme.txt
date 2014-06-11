This package allows you to get data from Plexon Server
directly into Matlab.

The following functions are provided:

PL_InitClient - you need to call this function 
	before calling any other PL_* function

PL_GetPars - retrieves the parameters of the Plexon Server
	see PL_GetPars.m for details

PL_GetTS - gets the timestamps 
	see PL_GetTS.m for details

PL_GetWF - gets the waveforms 
	see PL_GetWF.m for details

PL_GetAD - gets the A/D data 
	see PL_GetAD.m for details

PL_Close - closes the connection to the Plexon Server

ADperieventGui - plots the perievent values of continuous AD variables

The test scripts test_pars.m, test_ts.m, 
test_wf.m, and test_ad.m provide the examples of
complete scripts that open connection to the server,
get some data and close the connection.


Before using any of the PL_XXX functions
you need to call PL_InitClient 
and use the value returned by PL_InitClient
in all PL_* calls.

For example: 

s = PL_InitClient(0);
pars = PL_GetPars(s);

You need to call PL_InitClient only ONCE
and use the value it returns in all the calls
to the PL_* functions:

s = PL_InitClient(0);
pars = PL_GetPars(s);
[num, ts] = PL_GetTS(s);
....


You need to call PL_Close(s) to close the connection
with the Plexon server:

PL_Close(s);
s = 0;

______________________________________

ADperieventGui.m is a matlab GUI (Graphical User Interface)
that displays continuous A-D variables around a specified 
event timestamp. 
 
ADperieventGui.m requires ADperieventGui.mat and perieventFns.m
to be in the Matlab path.

ADperieventGui_largefont is the same as ADperieventGui but for
systems using large fonts.


