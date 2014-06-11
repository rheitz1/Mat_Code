%function [] = Plx2_m_search_data (file_path,filename)
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

disp ('EXECUTING... \matcode\FinalTranslate\Plx2_m_search_data.m')
clear all
close all;

% CALL TO FUNCTION ... event_global
%event_global_search_data

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

Time_Task=TimeStamps_Strobe_Events(find(StrobeValues == 3003)+1);
Target_xxx_bid=StrobeValues(find(StrobeValues == 3003)+9);
tt=1;
% determine the block of trials per task
for i_task=1:length(Task)-1
    
    %%%% FIRST BLOCK ALWAYS START FROM THE FIRST TRIAL
    if i_task==1
    Block(tt,1)=Task(i_task); % Specify the task
    Block(tt,2)=i_task; % Specify the trial
    Block(tt,3)= Target_xxx_bid(i_task);
    Time_Task_START(tt)=0;  % Time =0 (used to search the minimal ongoing 1666
    
    tt=tt+1;
    end;
    
    %%%% NEXT BLOCK
    if i_task>1
    if Task(i_task)==Task(i_task-1)
%     Block(tt,1)=Task(i_task); % Specify the task
%     Block(tt,2)=i_task; % Specify the trial
%     Block(tt,3)= Target_xxx_bid(i_task);
%     Block(tt,4)=Task(i_task-1);
%     Block(tt,5)=0;
%     tt=tt+1;
    else
    Block(tt,1)=Task(i_task); % If the current Block is different from the next
    Block(tt,2)=i_task; % If the current Block is different from the next
    Block(tt,3)= Target_xxx_bid(i_task);
    Block(tt,4)=Task(i_task-1);
    Block(tt,5)=1;
    Time_Task_START(tt)=Time_Task(i_task-1); % Time = Time of Type of task from the previous trial
    % used to search the minimal ongoing 1666
    tt=tt+1;
    end;
    end;
end; 
%  save('bid','Block','Time_Task_START','Target_xxx_bid','Task')
% gfds=gsg
NB_TASK=size(Block,1);


clear i_task clear tt Task Block 



for i_t=1:NB_TASK % Loop for the different task
    refresh=[];
    target_on_Evt2=[];
    TrialStart_TimeStamps=[];
    TrialStart_TimeStamps=[];
    
    TrialStart_Strobe_value=1666;
    TrialStart_TimeStamps = TimeStamps_Strobe_Events(find( StrobeValues == TrialStart_Strobe_value )); % Find all the Trial Start Event
    

    
    if i_t<NB_TASK 
    TrialStart_TimeStamps = TrialStart_TimeStamps(find( TrialStart_TimeStamps >Time_Task_START(i_t) &   TrialStart_TimeStamps <Time_Task_START(i_t+1) ));                                                                                                % Restrict the Trial Start Event for the specific TASK
     
    elseif i_t==NB_TASK
    TrialStart_TimeStamps = TrialStart_TimeStamps(find(TrialStart_TimeStamps >= Time_Task_START(i_t))); % Restrict the Trial Start Event for the specific TASK

    end;     

    for ii_t=1:length(TrialStart_TimeStamps)
        refresh(ii_t)=TimeStamps_Strobe_Events_2(min(find(TimeStamps_Strobe_Events_2>TrialStart_TimeStamps(ii_t))))- TrialStart_TimeStamps(ii_t);
        target_on_Evt2(ii_t)=TimeStamps_Strobe_Events_2(min(find(TimeStamps_Strobe_Events_2>TrialStart_TimeStamps(ii_t))));
    
%         Time_Task_START(i_t+1)
%         Time_Task_START(i_t)
%     pause;
    
    end;

    outfile=[outfile '_' num2str(i_t)];
    %target_on_Evt2


    disp ([filename ,'...contains...',num2str(length(TrialStart_TimeStamps)),'...Trials'])


    % CALL TO FUNCTION ... PlxEvents2_m
    [TrialStart_ ,TimeStamps_Strobe_Events]= PlxEvents2_m_search_data (file_path,filename, TrialStart_TimeStamps , outfile,target_on_Evt2 );

    % CALL TO FUNCTION ...  PlxAD2_mAD
    PlxAD2_mAD_search (file_path, filename, TrialStart_ ,TimeStamps_Strobe_Events,outfile)

    % CALL TO FUNCTION ...  PlxSpike2_m
    PlxSpike_search_m( file_path, filename , TrialStart_ ,TimeStamps_Strobe_Events, outfile )

    fclose all
    
end; %for Task