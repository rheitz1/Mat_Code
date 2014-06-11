function [] = Plx2_m_search_data (file_path,filename)
% TRANSLATES THE EVENTS, CONTINUOUS SIGNALS, AND SPIKES OCCURING DURING A 
%  COUNTERMANDING .PLX FILE TO AN _M FILE 
%
% INPUT: 
%   FILE_PATH: FOLDER YOU WOULD LIKE TO COMENCE SEARCHING FOR FILES TO PROCESS AND SAVE 
%                       THE RESULTS TO. MUST BE A STRING  I.E., 'C:\DATA\BASIC\'
%   FILENAME: PLX FILENAME. MUST BE A STRING
%   
%  
%  CREATED BY: erik.emeric@vanderbilt.edu & 
%                       pierre.pouget@vanderbilt.edu
%                           6-24-2005

disp ('EXEXUTING... \matcode\FinalTranslate\Plx2_m_search_data.m')
clear all;
close all;

% CALL TO FUNCTION ... event_global
event_global_search_data

%IF NO FILENAME OR FILE_PATH IS PROVIDED...
if nargin <2
        file_path ='C:\data\Search_data\data\';
    %     filename = 'lucbeh001.plx';
    q='''';c=',';qcq=[q c q];
    [filename,file_path] = uigetfile([file_path,'*.plx'],'Choose MATLAB File to Process');
    if isequal(filename,0)|isequal(file_path,0)
        disp('File not found')
    else
        % file output name
        disp(['File...',filename,'....found'])
        ofile_ = strcat('_m.');        
        fileID= filename(7:end-4);
        outfile=strcat(filename(1:6), ofile_, fileID);
        disp (['Begininng conversion to...',outfile])
        % end
    end
elseif nargin == 2
        ofile_ = strcat('_m.');        
        fileID= filename(7:end-4);
        outfile=strcat(filename(1:6), ofile_, fileID);
end

if ~filename
   disp ('Translation Aborted')
    return
end

%GET STROBED EVENTS FROM PLX FILE
% CALL TO FUNCTION ... plx_event_ts
[TotalStrobe_Events, TimeStamps_Strobe_Events, StrobeValues] = plx_event_ts([file_path,filename], 257);

[TotalStrobe_Events_2, TimeStamps_Strobe_Events_2, StrobeValues_2] = plx_event_ts([file_path,filename], 2);

% need to modified the outfile as function of the task 0:Fixation // 1: Detection // 2: Search

%%%% Find the number of task in this recording 

Task=StrobeValues(find(StrobeValues == 3003)+1);


List_trial_task_0=find(Task==0);
List_trial_task_1=find(Task==1);
List_trial_task_2=find(Task==2);


% for i_t=1:3 % Loop for the different task

vcz=fdsa




TrialStart_Strobe_value=1666;
TrialStart_TimeStamps = TimeStamps_Strobe_Events(find( StrobeValues == TrialStart_Strobe_value ));

for ii_t=1:length(TrialStart_TimeStamps)
refresh(ii_t)=TimeStamps_Strobe_Events_2(min(find(TimeStamps_Strobe_Events_2>TrialStart_TimeStamps(ii_t))))- TrialStart_TimeStamps(ii_t);
target_on_Evt2(ii_t)=TimeStamps_Strobe_Events_2(min(find(TimeStamps_Strobe_Events_2>TrialStart_TimeStamps(ii_t))));
end;


disp ([filename ,'...contains...',num2str(length(TrialStart_TimeStamps)),'...Trials'])

% CALL TO FUNCTION ... PlxEvents2_m
[TrialStart_ ,TimeStamps_Strobe_Events]= PlxEvents2_m_search_data (file_path,filename, TrialStart_TimeStamps , outfile,target_on_Evt2 );

% CALL TO FUNCTION ...  PlxAD2_mAD
PlxAD2_mAD_search (file_path, filename, TrialStart_ ,TimeStamps_Strobe_Events,outfile)

% CALL TO FUNCTION ...  PlxSpike2_m
PlxSpike2_m( file_path, filename , TrialStart_ ,TimeStamps_Strobe_Events, outfile )

fclose all

% end; %for Task 