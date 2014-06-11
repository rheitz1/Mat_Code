function PlxAD2_mAD_search (file_path,filename, TrialStart_,TimeStamps_Strobe_Events, outfile);
% TRANSLATES THE CONTINUOUS SIGNSLS OCCURING DURING A COUNTERMANDING .PLX FILE TO AN _M FILE
% INPUT:
%   FILE_PATH: FOLDER YOU WOULD LIKE TO COMENCE SEARCHING FOR FILES TO PROCESS AND SAVE
%                       THE RESULTS TO. MUST BE A STRING  I.E., 'C:\DATA\BASIC\'
%   FILENAME: PLX FILENAME. MUST BE A STRING
%   TRIALSTART_ : TIME OF TRIALSTART RELATIVE TO BEGINNING OF RECORDING.
%   TIMESTAMPS_STROBE_EVENTS : AN ARRAY OF ALL OF THE STROBES OCCURING DURING THE RECORDING IN SECOND
%   OUTFILE: THE OUTPUT FILE NAME OF THE RESULTING FILE
%
%   OUTPUT:  SAVES VARIABLES BELOW TO [FILE_PATH, FILENAME]
%
%           ADXX ,  EyeX_ ,  EyeY_
%
%           XX= AD CHANNEL               XX CAN BE 01-16 and 19-64
%           EyeX_  and   EyeY_  ARE STORED IN CHANNELS 17 AND 18 IN THE .PLX FILE
%           ALL CONTINUOUS SIGNALS ARE STORED IN THE _M FILE AT A SAMPLE RATE OF 250HZ
%
%  CREATED BY: erik.emeric@vanderbilt.edu &
%                       pierre.pouget@vanderbilt.edu
%                           6-24-2005
%
%  TO DO:
%      THIS SHOULD ACTUALLY BE DONE AFTER TRANSLATION, BUT BEFORE CSTANDARD,
%       GET CALIBRATION FILE TO CONVERT EYE X AND Y VOLTAGE TO DEGREES
%       ALSO NEEDS TO BE APPLIED TO FIX AND TARGET WINDOWS
%
%  PROBLEMS TO FIX:
%        PROBLEM: lucall060605cRS.plx CONTAINS 172 TRIALS BUT ANALOG CHANNELS ENDS IN THE MIDDLE OF
%        TRIAL # 171. THERE ARE STROBE EVENTS IN TRIAL #172. NOT SURE WHY ANALOG SIGNAL ENDS BUT STROBES CONTINUE
%        DEFINITE DISCREPANCY BETWEEN NEX AND MATLAB VALUES....
%

q='''';c=',';qcq=[q c q];

%get global filename info
[OpenedFilename, Version, Freq, Comment, Trodalness, NPW, PreTresh, SpikePeakV, SpikeADResBits, ...
    SlowPeakV, SlowADResBits, Duration, DateTime] = plx_information([file_path,filename]);

% Comment contains recording info which is saved in RecordingInfo_
[token, rem] = strtok(Comment); ct=1;
if ~isempty(token)
    RecordingInfo_{ct,1} = token;
end
while ~isempty(rem)
    ct=ct+1;
    token=rem;
    [token, rem] = strtok(token);
    RecordingInfo_{ct,1} = token;
end
if exist('RecordingInfo_')
    save ([file_path, outfile] , 'RecordingInfo_','-append')
end


%SOMETIMES THIS INFO IS NOT PRESENT
%DEFAULT VALUES
if SlowPeakV==0
    SlowPeakV=5000;
end
if SlowADResBits==0
    SlowADResBits=12;
end

%INITIALIZE VARIABLE NAMES
ADCHs={};
adID = {'AD01','AD02','AD03','AD04','AD05','AD06','AD07','AD08', 'AD09','AD10','AD11','AD12','AD13','AD14','AD15', 'AD16','EyeX_', 'EyeY_'...
    ,'AD19','AD20','AD21','AD22','AD23','AD24','AD25','AD26','AD27','AD28', 'AD29','AD31','AD32','AD33','AD34','AD35','AD36','AD37','AD38'...
    ,'AD39','AD40','AD41','AD42','AD43','AD44','AD45','AD46','AD47','AD48', 'AD49','AD50','AD51','AD52','AD53','AD54','AD55','AD56','AD57'...
    , 'AD58','AD59','AD60','AD61','AD62','AD63','AD64'};

%get AD gains for conversion
[n,gains] = plx_adchan_gains([file_path,filename]);

% get counts of timestamps in all channels
[tscounts, wfcounts, evcounts] = plx_info([file_path,filename],0);

% get the a/d data into a cell array also.
% This is complicated by channel numbering.
% The presence/absence of slow analog data can be seen by looking at the
% evcounts array at indexes 300-363. E.g. the number of samples for
% analog channel 0 is stored at evcounts(300).
% Note that analog ch numbering starts at 0, not 1 in the data, but the
% 'allad' cell array is indexed by ich+1
numads = 0;
for ich = 0:63
    if ( evcounts(300+ich) > 0 )
        % RETRIEVE CONTENTS OF ANALOG CHANNELS FROM PLX FILE
        eval([' [ adfreq, nad, tsad, fnad,' ,adID{ich+1},' ] = plx_ad(OpenedFilename, ich);'])
        % STORE ADVALUES IN REGISTER WITH TIMESTAMPS
%         delay = ceil(tsad(1)*1000);
        temp = zeros(1,ceil(tsad(end)*1000)+fnad(end) );
        %LOCATION OF ADVALUES
        ADindex=1;
%         for curFrag = 1:length(tsad)
%             % TIMESTAMPS IN MILISECONDS OF THE ADVALUES IN THE CURRENT FRAGMENT
%             curTS = ceil(tsad(curFrag)*1000):ceil(tsad(curFrag)*1000) + fnad(curFrag)-1;
%             %REAL TIMESTAMPS SAME SIZE AS THE CURRENT CONTINUOUS CHANNEL 
% %            temp( curTS) = AD01( ADindex:ADindex+fnad(curFrag)-1);
%           eval( ['temp( curTS) = ',adID{ich+1},'( ADindex:ADindex+fnad(curFrag)-1);'])
%             % INCREMENT THE CURRENT LOCATION BY THE SIZE OF THE FRAGMENT
%             ADindex=ADindex+fnad(curFrag);
%         end
% %         AD01=temp;
        eval( ['[temp] = ad_frag2array(tsad,' adID{ich+1} ', fnad, adfreq);']);
        eval ([adID{ich+1},' = temp;'])
        clear temp
        
        % CONVERSION FROM PLEXON AD(12BIT) TO VOLTAGE
        eval( [ adID{ich+1},' = (',adID{ich+1},'.*SlowPeakV ) / (  0.5*(2^SlowADResBits) * gains(ich+1));'])
        %TO ACCOUNT FOR A DELAY BETWEEN THE START OF THE RECORDING AND THE FIRST AD TIMESTAMP...
%         delay = zeros(ceil(tsad(1)*1000),1);
%         eval([adID{ich+1},' = [delay ;',adID{ich+1},'];'])
        %Remove zero values in Analog: Makes it very easy to find real values in a zero padded matrix
        eval([adID{ich+1},' (',adID{ich+1},'==0) = range (',adID{ich+1},')/10000;'])
%         disp (['Delay between the start of recording and 1st AD timestamp...', num2str(length(delay)),'ms'])
        % this is neccessary because the input analog values to tempo for the Y eye channnel are multiplied by a factor
        % of -1.
        if isequal ('EyeY_',adID{ich+1})
            eval ([adID{ich+1},' = ',adID{ich+1} ,'.* (-1);' ])
        end
        eval (['save  ([file_path,outfile]',c,q, adID{ich+1},qcq,'-append',q, ');'])
        disp ([adID{ich+1},'....SAVED TO....',[file_path ,  outfile] ])
        eval(['clear ', adID{ich+1},' adfreq nad tsad fnad'])
        numads = numads + 1;
        ADCHs{numads} = adID{ich+1};
    end
end

clear Comment Duration NPW OpenedfilenameName  Version  Freq  Comment  Trodalness  NPW  ...
    PreTresh  SpikePeakV  SpikeADResBits  SlowPeakV  SlowADResBits  Duration  DateTime n ...
    gains tscounts  wfcounts  evcounts  ich delay

%***WRITE TO MULTIPLE filenameS IF TRIAL #  EXCEEDS PRESET VALUES***
maxTrialNo=100;
MultifilenameFlag=0;
multifilename=0;
tempfilename=[file_path,'temp'];
MULTIfilename=[num2str(multifilename),' separate continuous channel filenames that are merged'];
%****************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Configure loop structure
if size(TrialStart_,1) > maxTrialNo
    MultifilenameFlag=1;
end
multifilenameNo=floor( size(TrialStart_,1) /maxTrialNo);
residual=size(TrialStart_,1) - (multifilenameNo*maxTrialNo);
if residual == 0
    multifilenameNo = multifilenameNo -1;
    residual = maxTrialNo;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for curAD = 1:length (ADCHs)
    multifilename=0;
    curVar = char(ADCHs{curAD});
    eval (['load ([file_path,outfile]',c,q, curVar,qcq,'-mat',q, ');'])
    disp (['CUTTING UP TRIALS FOR...',curVar])
    eval (['ADlength = length(',curVar,');'])

    for curCHUNK = 0:multifilenameNo
        row=1;
        if curCHUNK==multifilenameNo & residual ~=0
            NEXTSTEP=residual;
        else
            NEXTSTEP=maxTrialNo;
        end

        for curTrl = curCHUNK*maxTrialNo+1:curCHUNK*maxTrialNo+NEXTSTEP
            if curTrl ~= size(TrialStart_,1)
                startcount=TrialStart_(curTrl);    endcount =TrialStart_(curTrl+1)-1;
                eval ([' tempAD(row,1:length(startcount:endcount))= ',curVar,'(startcount:endcount);'])
                row=row+1;
            else
                startcount=TrialStart_(curTrl);    endcount =ceil(TimeStamps_Strobe_Events(end)*1000);

                %                 if endcount < ADlength
                %                     endcount =ceil(TimeStamps_Strobe_Events(end)*1000);
                %                 else
                %                     endcount =ADlength ;
                %                 end

                eval ([' tempAD(row,1:length(startcount:endcount))= ',curVar,'(startcount:endcount);'])
                row=row+1;
            end
        end% for curTrl = curCHUNK*maxTrialNo+1:curCHUNK*maxTrialNo+NEXTSTEP

        % SAVE CHUNK TO TEMP FILE
        multifilename=multifilename+1;
        file = [ tempfilename , num2str(multifilename) ];

        %LOWERING SAMPLE RATE TO 250HZ
        %CALL TO FUNCTION ... lowerRate
        [tempAD] = lowerRate ( tempAD);

        disp (['SAVING...',curVar,'...TO...', file])
        save(file,'tempAD','-mat');
        clear tempAD
    end % for curCHUNK = 0:multifilenameNo

    eval(['clear ',curVar])

    for curCHUNK= 0:multifilenameNo
        if curCHUNK==multifilenameNo & residual ~=0
            NEXTSTEP=residual;
        else
            NEXTSTEP=maxTrialNo;
        end
        %load chunk into tempvar
        file = [tempfilename, num2str(curCHUNK+1)];
        disp (['loading.....', curVar,' from......', file])
        load (file,'tempAD','-mat');
        eval ([curVar,'(curCHUNK*maxTrialNo+1:curCHUNK*maxTrialNo+size(tempAD,1),1:size(tempAD,2) )=tempAD;'])
        temp=[];
        delete(file)
        pack
    end % for curCHUNK= 0:multifile-2

    disp (['SAVING...', curVar,'...TO...', file_path, outfile])
    save ([file_path, outfile], curVar, '-append')
    eval(['clear ',curVar])

end % for curAD = 1:length (ADCHs)

