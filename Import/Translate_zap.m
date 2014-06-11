%function[] = Translate_zap(file_path,filename)
%Translation file from .plx to .mat
%Written to handle search data
%Edited by Richard P. Heitz
%9/5/07
c__
tic
disp('Executing...')

%If no filename or path provided, request user input

    [filename,file_path] = uigetfile('*.plx');


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
TrialStart_TimeStamps = Strobe_Times(find(Strobe_Values == 7013));

%========================
% TEMPORARY FIX FOR PROBLEM FILE
%TrialStart_TimeStamps = Strobe_Times(find(Strobe_Values >=9000 & Strobe_Values <=9009)+1);
%TrialStart_TimeStamps = TrialStart_TimeStamps(1:length(TrialStart_TimeStamps)-2);
%========================



% for ii_t = 1:length(TrialStart_TimeStamps)
%     %index through EV2 timestamps until you find the value just
%     %greater than the single value recorded as the start time
%     %for that trial (in TrialStart_TimeStamps)
%     target_on_Evt2(ii_t) = Strobe_Times_2(min(find(Strobe_Times_2 > TrialStart_TimeStamps(ii_t))));
% 
%     refresh(ii_t) = target_on_Evt2(ii_t) - TrialStart_TimeStamps(ii_t);
%     
%     %FixOn_time(ii_t,1) = (max(FixOn_TimeStamps(find(FixOn_TimeStamps < target_on_Evt2(ii_t)))) - target_on_Evt2(ii_t)) * 1000;
% end
% 
% disp([filename ,'...contains...',num2str(length(TrialStart_TimeStamps)),'...Trials'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            CALL TO FUNCTIONS              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%To avoid memory errors, pass Trial Events and Event Times relevent
%only to current block
Times_to_pass = Strobe_Times;
Events_to_pass = Strobe_Values;

%GET EVENTS
%[TrialStart_] = EventTranslator_zap(file_path,filename,TrialStart_TimeStamps,outfile,target_on_Evt2,Times_to_pass,Events_to_pass);
%CUT UP AD CHANNEL
%get date
if filename(1) == 'D' || filename(1) == 'E' %new naming convention: year/month/day
    year=str2double(filename(4:5));
    month=str2double(filename(6:7));
else
    year=str2double(filename(6:7));
    month=str2double(filename(2:3));
end

%INITIALIZE VARIABLE NAMES
ADCHs={};

if year>10||(year==10&&month>2)
adID = {'AD01','AD02','AD03','AD04','AD05','AD06','AD07','AD08', 'AD09','AD10','AD11','AD12','AD13','AD14','AD15', 'AD16','AD17', 'AD18', 'AD19' ...
    ,'AD20','AD21','AD22','AD23','AD24','AD25','AD26','AD27','AD28', 'AD29','AD31','AD32','AD33','AD34','AD35','AD36','AD37','AD38'...
    ,'AD39','AD40','AD41','AD42','AD43','AD44','AD45','Pupil_','AD47','EyeX_', 'EyeY_','AD50','AD51','AD52','AD53','AD54','AD55','AD56','AD57'...
    , 'AD58','AD59','AD60','AD61','AD62','AD63','AD64'};
else
adID = {'AD01','AD02','AD03','AD04','AD05','AD06','AD07','AD08', 'AD09','AD10','AD11','AD12','AD13','AD14','AD15', 'AD16','AD17', 'EyeX_', 'EyeY_' ...
    ,'AD20','AD21','AD22','AD23','AD24','AD25','AD26','AD27','AD28', 'AD29','AD31','AD32','AD33','AD34','AD35','AD36','AD37','AD38'...
    ,'AD39','AD40','AD41','AD42','AD43','AD44','AD45','AD46','AD47','AD48', 'AD49','AD50','AD51','AD52','AD53','AD54','AD55','AD56','AD57'...
    , 'AD58','AD59','AD60','AD61','AD62','AD63','AD64'};   
end

    [tscounts, wfcounts, evcounts, contcounts] = plx_info([file_path,filename],1);

    % JH - make evcounts look like evcounts produced by legacy mexPlex.dll
    evcounts(300:(299+length(contcounts))) = contcounts;
    
    %for ich = 46:47
for ich = 0:60
    if ( evcounts(300+ich) > 0 )
        % RETRIEVE CONTENTS OF ANALOG CHANNELS FROM PLX FILE
        eval([' [ adfreq, nad, tsad, fnad,' ,adID{ich+1},' ] = plx_ad_v([file_path filename], ich);'])
        % STORE ADVALUES IN REGISTER WITH TIMESTAMPS
        temp = zeros(1,ceil(tsad(end)*1000)+fnad(end) );
    end
end

%varlist = who;
%sig = eval(varlist{strmatch('AD',varlist)});

%Zap_times = floor(Strobe_Times*1000);
Zap_times = floor(TrialStart_TimeStamps*1000);

for z = 1:length(Zap_times)
    X(z,1:701) = EyeX_(Zap_times(z)-200:Zap_times(z)+500);
    Y(z,1:701) = EyeY_(Zap_times(z)-200:Zap_times(z)+500);
end

%avSig = filtSig(avSig,60,'notch');

% load('exampleEEG.mat')
% 
% figure
% subplot(3,1,1)
% plot(-200:500,nanmean(avSig))
% xlim([-200 500])
% axis ij
% sc = ylim;
% xlabel('Time (ms)')
% ylabel('mV')
% title('Your Data')
% box off
% 
% subplot(3,1,2)
% plot(-500:2500,nanmean(Q_AD02),'k')
% xlim([-200 500])
% axis ij
% ylim(sc)
% xlabel('Time (ms)')
% ylabel('mV')
% title('Real Data with same scaling as Fake data')
% box off
% 
% subplot(3,1,3)
% plot(-500:2500,nanmean(Q_AD02),'k')
% xlim([-200 500])
% axis ij
% xlabel('Time (ms)')
% ylabel('mV')
% title('Real Data with appropriate scaling')
% box off