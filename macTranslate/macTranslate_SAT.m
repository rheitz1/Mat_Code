% TRANSLATION CODE FOR T/L SEARCH + SPEED-ACCURACY TRADEOFF
% LONG BASELINE VERSION
% SEE COMMENTS FOR DETAILS
%
% FIRST EDITED 9/5/07 FROM E. EMERIC VERSION
% LAST MODIFIED 8/8/13
%
% RPH

function[] = macTranslate_SAT(file_path,filename)


USE_PHOTO_DIODE = 1;

if USE_PHOTO_DIODE
    disp('Using Photo Diode for timing')
else
    disp('Using TEMPO for timing')
end

tic
disp('Executing...')

%If no filename or path provided, request user input
if nargin < 2
%     file_path = 'C:\Data\ToTranslate\';
%     cd 'C:\Data\ToTranslate\'
 %%%   file_path = '/volumes/Dump2/PLX_SAT/';
 %%%   cd /volumes/Dump2/PLX_SAT/
 
 file_path = '~/desktop/';
 dsk
    
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

dat = readPLXFileC([file_path filename],'all');

%Get Strobed Events from PLX file. struct array 17 is chan 257
%dat.EventChannels(17).Name %is "Strobed" channel

Strobe_Values = dat.EventChannels(17).Values;
Strobe_Times = (double(dat.EventChannels(17).Timestamps)) / dat.ADFrequency; %convert uint32 to double precision

if USE_PHOTO_DIODE
    Strobe_Times_2 = (double(dat.EventChannels(2).Timestamps)) / dat.ADFrequency;
end
% % 
% % %Find Tempo generated time stamps and events
% % %uses: mexPlex(3,filename, ch);
% % % CHANNEL 257 STORES STROBED EVENT CODES (WORDS)
% % [nStrobes,Strobe_Times,Strobe_Values] = plx_event_ts([file_path,filename], 257);
% % 
% % if USE_PHOTO_DIODE
% %     % CHANNEL 2 STORES PHOTODIODE STROBED EVENTS
% %     [nStrobes_2,Strobe_Times_2, Strobe_Values_2] = plx_event_ts([file_path,filename], 2);
% % end

% % %The Task code follows the strobe "3003" and will be:
% % %0: fixation    1: detection    2: search
% % Tasks = Strobe_Values(find(Strobe_Values == 3003)+1);
% % 
% % %Find the timestamps for each task marker
% % Time_Task = Strobe_Times(find(Strobe_Values == 3003)+1);

refresh = []; %this is the difference between Tempo trial onset time and onset time determined with Event002 (diode)
target_on_Evt2 = [];
TrialStart_TimeStamps = [];

% FIND ARBITRARY START TIMES FOR EACH TRIAL. THIS WILL BE USED TO FIND THE
% PHOTODIODE EVENTS.
TrialStart_TimeStamps = Strobe_Times(find(Strobe_Values == 1666));

%========================
% TEMPORARY FIX FOR PROBLEM FILE
% NOTE NOTE NOTE:  I'VE HAD TROUBLE GETTING CATCH TRIALS OUT USING THE
% BELOW 'FIX'
% TrialStart_TimeStamps = Strobe_Times(find(Strobe_Values >=9000 & Strobe_Values <=9009)+1);
% TrialStart_TimeStamps = TrialStart_TimeStamps(1:length(TrialStart_TimeStamps)-2);
%========================

for ii_t = 1:length(TrialStart_TimeStamps)
    %index through EV2 timestamps until you find the value just
    %greater than the single value recorded as the start time
    %for that trial (in TrialStart_TimeStamps)
    if USE_PHOTO_DIODE
        target_on_Evt2(ii_t) = Strobe_Times_2(min(find(Strobe_Times_2 > TrialStart_TimeStamps(ii_t))));
        refresh(ii_t) = target_on_Evt2(ii_t) - TrialStart_TimeStamps(ii_t);
    else
        target_on_Evt2(ii_t) = TrialStart_TimeStamps(ii_t);
    end

    %Do not have fixation strobe for monkeys other than D & E
    if (outfile(1) == 'D' || outfile(1) == 'E')
        cur_fixon_time = Strobe_Times(max(find(Strobe_Values == 30 & Strobe_Times < TrialStart_TimeStamps(ii_t))));
    
        %what is the earliest Diode time stamp after this
        if USE_PHOTO_DIODE
            fix_on_Evt2(ii_t) = Strobe_Times_2(min(find(Strobe_Times_2 > cur_fixon_time)));
        else
            fix_on_Evt2(ii_t) = cur_fixon_time;
        end
        
        clear cur_fixon_time
    else
        fix_on_Evt2(ii_t) = NaN;
    end

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
[TrialStart_] = osx_EventTranslator_SAT_longBase_noChunk(file_path,filename,TrialStart_TimeStamps,outfile,target_on_Evt2,fix_on_Evt2,Times_to_pass,Events_to_pass);

%======================
% CUT UP AD CHANNELS
osx_ADTranslator_longBase_noChunk(file_path,filename,TrialStart_,Strobe_Times,outfile)


%======================
% CUT UP SPIKE CHANNELS
osx_SpikeTranslator_longBase(file_path,filename,TrialStart_,Strobe_Times,outfile)


keep fileID file_path outfile

%================================
% OPTIONAL: SAVE SPIKE WAVEFORMS?
% NOT YET WORKING FOR OS-X VERSION OF TRANSLATION CODE!!!
%getWaves(file_path, fileID, outfile)

%================================
% PARSES UP ALL TRIALS INTO SEPARATE FILES FOR DIFFERENT TASKS
% _DET = DETECTION (VISUALLY GUIDED SACCADE) TASK
% _MG = MEMORY GUIDED SACCADE TASK
% _SEARCH = VISUAL SEARCH (INCLUDES BASIC T/L, POP-OUT, AND T/L WITH SAT)
osx_breakFiles(file_path, fileID, outfile)


fclose all
disp(['Translation ran for ' mat2str((toc/60)) ' minutes'])


