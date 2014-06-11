function[] = Translate(file_path,filename)


%FOR USE WITH SESSIONS THAT INCLUDE ONLY FIXATION TRIALS, NO SEARCH, NO
%FIXATION, NO DETECTION





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
        %ofile_ = '_m';
         fileID = filename(1:end-4);
%         outfile = strcat(fileID,ofile_);
        outfile = [filename(1:end-4) '_all'];
    end
    %otherwise, if file path and file name
elseif nargin == 2
    disp(['File...',filename,'...accepted'])
%     ofile_ = '_m.';
     fileID = filename(1:end-4);
%     outfile = strcat(fileID,ofile_);
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

%Find time stamps and events based off of photo diode
%channel 2 contains the photodiode strobe (Plexon just
%takes Event002 (the dtiode) as a TTL pulse.
%that channel is then just named "Event002".  See Rasputin user manual, p.
%2-89 through 2-90.
%[nStrobes_2,Strobe_Times_2, Strobe_Values_2] = plx_event_ts([file_path,filename], 2);


%Find the number of individual tasks recorded in current file.
%Ideally, we would want to PAUSE the .plx recording when
%switching between tasks, but when this does not happen,
%we will want to create separate files for each task run.  Note that if
%we repeat tasks after running some other task inbetween (e.g.,
%det-search-det), there will be 2 files for detection.

%The Task code follows the strobe "3003" and will be:
%0: fixation    1: detection    2: search
Tasks = Strobe_Values(find(Strobe_Values == 3003)+1);

%Find the timestamps for each task marker
Time_Task = Strobe_Times(find(Strobe_Values == 3003)+1);

%tt is a counter that increments only when a new block
%of trials is found
%the counter "i_task" will step through each trial
%in the experiment.
tt = 1;




%get rid of unneeded variables
%clear i_task tt Tasks Block

refresh = []; %this is the difference between Tempo trial onset time and onset time determined with Event002 (diode)
target_on_Evt2 = [];
TrialStart_TimeStamps = [];

%Find trial starting times via Tempo
TrialStart_TimeStamps = Strobe_Times(find(Strobe_Values == 2727));
TrialStart_TimeStamps = ceil(TrialStart_TimeStamps*1000);
% for ii_t = 1:length(TrialStart_TimeStamps)
%     %index through EV2 timestamps until you find the value just
%     %greater than the single value recorded as the start time
%     %for that trial (in TrialStart_TimeStamps)
%     target_on_Evt2(ii_t) = Strobe_Times_2(min(find(Strobe_Times_2 > TrialStart_TimeStamps(ii_t))));
% 
%     %Next, subtract the Trial Startime from Tempo to calculate
%     %the "refresh" or the residual
%     refresh(ii_t) = target_on_Evt2(ii_t) - TrialStart_TimeStamps(ii_t);
% end



%display the number of trials in current Task Block

%NOTE
%There seems to be more 3003's and 1667's (trial ends) than there
%are trial starts (1666's).  
%However, this code filters out those lost trials because it
%Searches for trials based on Event002; The total number of EVT2's
%will = total number of 3003's and 1667's.  Thus, whatever they
%are, they should not matter.


%SO, Total number of trials in given block (e.g., 394
% minus filtered number of trials in block (e.g., 350)
%plus other differences from other blocks (e.g., 1571 - 1379)
% == difference between 3003's and 1666's [Reference file:
% dat071105001]
disp([filename ,'...contains...',num2str(length(TrialStart_TimeStamps)),'...Trials'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            CALL TO FUNCTIONS              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Translate trial events and write to file
%Returns Trial Start Times and Strobe Times ***how does the function
%change them?? (i.e., we wouldn't need to return them back unless the
%function altered them in some way...)

%To avoid memory errors, pass Trial Events and Event Times relevent
%only to current block
% Times_to_pass = Strobe_Times;
% Events_to_pass = Strobe_Values;

%GET EVENTS
%[TrialStart_,Strobe_Times] = EventTranslator(file_path,filename,TrialStart_TimeStamps,outfile,target_on_Evt2,Times_to_pass,Events_to_pass);
% [TrialStart_] = EventTranslator_fixation(file_path,filename,TrialStart_TimeStamps,outfile,target_on_Evt2,Times_to_pass,Events_to_pass);

%CUT UP AD CHANNEL
ADTranslator_fixation(file_path,filename,TrialStart_TimeStamps,Strobe_Times,outfile)

% %Cut Up Spikes
% SpikeTranslator(file_path,filename,TrialStart_,Strobe_Times,outfile)
% 
% %Get Spike Waveforms
% keep fileID file_path outfile
%getWaves(file_path, fileID, outfile)


%Break into separate files for DET, MG, and SEARCH trials.
% breakFiles(file_path, fileID, outfile)


fclose all
toc


