% These parameters are used when DEBUG = 2.
clear tempo_simulation;
start = GetSecs; % Defines the start time of videoTempoNet.
i = 1; % Start i = 1 and increment for as many uncommented lines below.  Easier than always changign the indexing.
if (1)
    tempo_simulation(i) = struct('command','eall2;','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(1,1,0,0,10,1,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(2,2,0,0,10,1,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(3,2,0,0,10,1,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(3,14,203,0,26,1,0,0);','start',1.0,'flag',0); i = i + 1;
    %     tempo_simulation(i) = struct('command','nprepSrch(3,0,203,1,26,0,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(3,22,203,2,26,1,0,0);','start',1.0,'flag',0); i = i + 1;
    %     tempo_simulation(i) = struct('command','nprepSrch(3,0,203,3,26,0,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(3,14,203,4,26,1,0,0);','start',1.0,'flag',0); i = i + 1;
    %     tempo_simulation(i) = struct('command','nprepSrch(3,0,203,5,26,0,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(3,14,203,6,26,1,0,0);','start',1.0,'flag',0); i = i + 1;
    %     tempo_simulation(i) = struct('command','nprepSrch(3,0,203,7,26,0,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(4,2,0,0,10,1,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(4,14,203,0,26,1,0,0);','start',1.0,'flag',0); i = i + 1;
    %     tempo_simulation(i) = struct('command','nprepSrch(4,0,203,1,26,0,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(4,22,203,2,26,1,0,0);','start',1.0,'flag',0); i = i + 1;
    %     tempo_simulation(i) = struct('command','nprepSrch(4,0,203,3,26,0,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(4,14,203,4,26,1,0,0);','start',1.0,'flag',0); i = i + 1;
    %     tempo_simulation(i) = struct('command','nprepSrch(4,0,203,5,26,0,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(4,14,203,6,26,1,0,0);','start',1.0,'flag',0); i = i + 1;
    %     tempo_simulation(i) = struct('command','nprepSrch(4,0,203,7,26,0,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(9,1,0,0,10,1,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(9,14,203,0,26,1,0,0);','start',1.0,'flag',0); i = i + 1;
    %     tempo_simulation(i) = struct('command','nprepSrch(9,0,203,1,26,0,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(9,22,203,2,26,1,0,0);','start',1.0,'flag',0); i = i + 1;
    %     tempo_simulation(i) = struct('command','nprepSrch(9,0,203,3,26,0,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(9,14,203,4,26,1,0,0);','start',1.0,'flag',0); i = i + 1;
    %     tempo_simulation(i) = struct('command','nprepSrch(9,0,203,5,26,0,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(9,14,203,6,26,1,0,0);','start',1.0,'flag',0); i = i + 1;
    %     tempo_simulation(i) = struct('command','nprepSrch(9,0,203,7,26,0,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(8,2,0,0,10,1,0,0);','start',1.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','nprepSrch(8,22,203,2,26,1,0,0);','start',1.0,'flag',0); i = i + 1;

    tempo_simulation(i) = struct('command','f1;','start',7.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','f2;','start',8.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','f3;','start',9.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','f4;','start',10.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','f5;','start',11.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','f6;','start',12.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','f7;','start',13.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','f9;','start',14.0,'flag',0); i = i + 1;
    tempo_simulation(i) = struct('command','f8;','start',15.0,'flag',0); i = i + 1;
end
