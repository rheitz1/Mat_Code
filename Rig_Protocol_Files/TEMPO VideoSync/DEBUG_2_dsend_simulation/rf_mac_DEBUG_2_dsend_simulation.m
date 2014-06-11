% These parameters are used when DEBUG = 2.
clear tempo_simulation;
start = GetSecs; % Defines the start time of videoTempoNet.
i = 1; % Start i = 1 and increment for as many uncommented lines below.  Easier than always changign the indexing.
tempo_simulation(i) = struct('command','fb1;','start',1.0,'flag',0); i = i + 1;
tempo_simulation(i) = struct('command','fb0;','start',2.0,'flag',0); i = i + 1;
tempo_simulation(i) = struct('command','return_main_loop_mac;','start',3.0,'flag',0); i = i + 1;
