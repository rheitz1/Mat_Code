% this script tests PL_GetPars function

% before using any of the PL_XXX functions
% you need to call PL_InitClient ONCE
% and use the value returned by PL_InitClient
% in all PL_XXX calls
s = PL_InitClient(0);
if s == 0
   return
end

% call PL_GetPars and print out the parameters
% see PL_GetPars.m for details
pars = PL_GetPars(s);

fprintf('Server Parameters:\n\n', pars(1));
fprintf('DSP channels: %.0f\n', pars(1));
fprintf('Timestamp Tick (in usec): %.0f\n', pars(2));
fprintf('Number of Points in Waveform: %.0f\n', pars(3));
fprintf('Number of Points before Threshold: %.0f\n', pars(4));
fprintf('Maximum Number of Words In Waveform: %.0f\n', pars(5));
fprintf('Total Number of A/D channels: %.0f\n', pars(6));
fprintf('Number of active A/D channels: %.0f\n', pars(7));
fprintf('A/D Frequency (for non-DSP channels, Hz): %.0f\n', pars(8));
fprintf('Server Polling Interval (ms): %.0f\n\n', pars(9));

% you need to call PL_Close(s) to close the connection
% with the Plexon server
PL_Close(s);
s = 0;

