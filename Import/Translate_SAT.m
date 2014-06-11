function[] = Translate_SAT(file_path,filename)
%Translation file from .plx to .mat
%Written to handle search data
%Edited by Richard P. Heitz
%9/5/07
tic
disp('Executing...')

%If no filename or path provided, request user input
if nargin < 2
    file_path = 'C:\Data\ToTranslate\';
    cd 'C:\Data\ToTranslate\'
    [filename,file_path] = uigetfile([file_path,'*.plx']);
    if isequal(filename,0) | isequal(file_path,0)
        disp('File not found')
    else
        disp(['File...',filename,'...found'])
        fileID = filename(1:end-4);
        outfile = [filename(1:end-4) '_all'];
    end
elseif nargin == 2
    disp(['File...',filename,'...accepted'])
    fileID = filename(1:end-4);
    outfile = [filename(1:end-4) '_all'];
end

if ~filename
    disp('Translation Aborted')
    return
end


%Get Strobed Events from PLX file
%Call  plx_event_ts

%Find Tempo generated time stamps and events
%uses: mexPlex(3,filename, ch);
%channel is where data are to be found.  Strobes stored in ch 257
[nStrobes,Strobe_Times,Strobe_Values] = plx_event_ts([file_path,filename], 257);

[nStrobes_2,Strobe_Times_2, Strobe_Values_2] = plx_event_ts([file_path,filename], 2);


%The Task code follows the strobe "3003" and will be:
%0: fixation    1: detection    2: search
Tasks = Strobe_Values(find(Strobe_Values == 3003)+1);

%Find the timestamps for each task marker
Time_Task = Strobe_Times(find(Strobe_Values == 3003)+1);

refresh = []; %this is the difference between Tempo trial onset time and onset time determined with Event002 (diode)
target_on_Evt2 = [];
TrialStart_TimeStamps = [];

%Find trial starting times via Tempo
TrialStart_TimeStamps = Strobe_Times(find(Strobe_Values == 1666));
%FixOn_TimeStamps = Strobe_Times(find(Strobe_Values == 1111));
FixTime_Jit_ = Strobe_Values(find(Strobe_Values == 3026)+1);
%========================
% TEMPORARY FIX FOR PROBLEM FILE
%TrialStart_TimeStamps = Strobe_Times(find(Strobe_Values >=9000 & Strobe_Values <=9009)+1);
%TrialStart_TimeStamps = TrialStart_TimeStamps(1:length(TrialStart_TimeStamps)-2);
%========================



for ii_t = 1:length(TrialStart_TimeStamps)
    %index through EV2 timestamps until you find the value just
    %greater than the single value recorded as the start time
    %for that trial (in TrialStart_TimeStamps)
    target_on_Evt2(ii_t) = Strobe_Times_2(min(find(Strobe_Times_2 > TrialStart_TimeStamps(ii_t))));

    refresh(ii_t) = target_on_Evt2(ii_t) - TrialStart_TimeStamps(ii_t);
    
    %FixOn_time(ii_t,1) = (max(FixOn_TimeStamps(find(FixOn_TimeStamps < target_on_Evt2(ii_t)))) - target_on_Evt2(ii_t)) * 1000;
end

disp([filename ,'...contains...',num2str(length(TrialStart_TimeStamps)),'...Trials'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            CALL TO FUNCTIONS              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%To avoid memory errors, pass Trial Events and Event Times relevent
%only to current block
Times_to_pass = Strobe_Times;
Events_to_pass = Strobe_Values;

%GET EVENTS
[TrialStart_] = EventTranslator_SAT(file_path,filename,TrialStart_TimeStamps,outfile,target_on_Evt2,Times_to_pass,Events_to_pass);

%File started already, now append FixOn_time
%save([file_path outfile],'FixOn_time','-append','-mat')
save([file_path outfile],'FixTime_Jit_','-append','-mat')
%CUT UP AD CHANNEL
ADTranslator(file_path,filename,TrialStart_,Strobe_Times,outfile)

%Cut Up Spikes
SpikeTranslator(file_path,filename,TrialStart_,Strobe_Times,outfile)

%Get Spike Waveforms
keep fileID file_path outfile
%getWaves(file_path, fileID, outfile)

%Break into separate files for DET, MG, and SEARCH trials.
breakFiles(file_path, fileID, outfile)


fclose all
disp(['Translation ran for ' mat2str(round(toc/60)) ' minutes'])


