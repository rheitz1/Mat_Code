function PlxAD2_mAD (file_path,filename, TrialStart_,TrialStart_TimeStamps,TimeStamps_Strobe_Events, outfile);
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
%         % MODIFIED 2-23-07 ADDING JOHNS MEX FUNCTION TO TRANSLATION
% Frequency at which the Analog channels will be stored at. 
lowerfrequency =250;
eyePosDelay=0.0115;
q='''';c=',';qcq=[q c q];
ADSTART=[];

disp ('EXEXUTING... \matcode\FinalTranslate\PlxAD2_mAD.m')
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
[n,names] = plx_adchan_names([file_path,filename]);

for i = 1:n
    if i==17
        adID {i,1}='EyeX_';
    elseif i==18
        adID {i,1}='EyeY_';
    else
        adID {i,1}=names(i,1:4);
    end
end

ADCHs={};

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
%         disp(names(ich+1,1:4)
%         disp(evcounts(300+ich))
    if ( evcounts(300+ich) > 0 )        
        % disp ('PLEASE BE PATIENT THE PROGRAM HAS NOT DIED')
        %disp([adID{ich+1},' gain: ', num2str(gains(ich+1)),' ADbits: ',num2str(SlowADResBits),' PkV:  ',num2str(SlowPeakV) ])
        % increment ad channel counter
        numads = numads + 1;
        % Store channel names in cell array
        ADCHs{numads} = adID{ich+1};
        
        % RETRIEVE CONTENTS OF ANALOG CHANNELS FROM PLX FILE
        %  if the output of the preamp was plugged in incorrectly: 
        eval([' [ adfreq, nad, tsad, fnad,' ,adID{ich+1},' ] = plx_ad(OpenedFilename, ich);'])

        % save sample frequency for each analog channel
        ADSAMPLEFREQUENCY (numads,1) = adfreq;
%         eval([' [ adfreq, nad, tsad, fnad,' ,adID{ich+1},' ] = plx_ad(OpenedFilename, ich+1);']) 
        % STORE ADVALUES IN REGISTER WITH TIMESTAMPS
%         delay = ceil(tsad(1)*1000);
%         temp = zeros(1,ceil(tsad(end)*1000)+fnad(end) );
%         temp = zeros(1,ceil(tsad(end)*adfreq)+fnad(end) );

        % MODIFIED 2-23-07 ADDING JOHNS MEX FUNCTION TO TRANSLATION
%         ['[temp]= ad_frag (', adID{ich+1},', tsad , , fnad);']
        
%         %LOCATION OF ADVALUES
        ADindex=1;
%         fragbegin =ceil(tsad.*1000);
%         fragend = ceil(tsad.*1000)+fnad-1;
%         adbegin= cumsum(fnad)-fnad+1;
%         adend= cumsum(fnad);
%         tempV(fragbegin:fragend) = AD01(adbegin:adend);
        
%:):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):)
%         UNCOMMENT IF USING EYE TRACKER :)
         if isequal ('EyeY_',adID{ich+1}) |isequal ('EyeX_',adID{ich+1})
            tsad=tsad-eyePosDelay;
         end
%:):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):):)


%         for curFrag = 1:length(tsad)
%             % TIMESTAMPS IN MILISECONDS OF THE ADVALUES IN THE CURRENT FRAGMENT
%             % curTS = ceil(tsad(curFrag)*1000):ceil(tsad(curFrag)*1000) + fnad(curFrag)-1;
%             curTS = ceil(tsad(curFrag)*adfreq):ceil(tsad(curFrag)*adfreq) + fnad(curFrag)-1;
%             
%             % this only is needed if the first analog sample happens less than 12ms after the start
%             % of the recording and the eye tracker is used to collect the eye position data.          
%             if curTS(1)<=0
%                 ADindex= ceil(tsad(curFrag+1)*adfreq);
%                 continue
%             end
%             
%             % REAL TIMESTAMPS SAME SIZE AS THE CURRENT CONTINUOUS CHANNEL 
%             % temp( curTS) = AD01( ADindex:ADindex+fnad(curFrag)-1);
%          	eval( ['temp( curTS) = ',adID{ich+1},'( ADindex:ADindex+fnad(curFrag)-1);'])
%             % INCREMENT THE CURRENT LOCATION BY THE SIZE OF THE FRAGMENT
%             ADindex=ADindex+fnad(curFrag);
%             
%         end


        %%%%%%%%%%
        eval( ['[temp] = ad_frag2array(tsad,' adID{ich+1} ', fnad, adfreq);']);
        %%%%%%%%%%
        % AD01=temp;
        
        eval ([adID{ich+1},' = temp;'])
        clear temp
        
        % CONVERSION FROM PLEXON AD(12BIT) TO VOLTAGE     
        % CONVERSION FROM PLEXON AD(12BIT) TO VOLTAGE
        if Version<103
            % LFP_1 = (LFP_1 .*3000 ) / (  2048 * gains(1));
            eval( [ adID{ich+1},' = (',adID{ich+1},'.*3000 ) / (  2048 * gains(ich+1));'])
        else
            % LFP_1 = (LFP_1 .*SlowPeakV ) / (  0.5*(2^SlowADResBits) * gains(1));
            eval( [ adID{ich+1},' = (',adID{ich+1},'.*SlowPeakV ) / (  0.5*(2^SlowADResBits) * gains(ich+1));'])
        end

        %Remove zero values in Analog: Makes it very easy to find real values in a zero padded matrix
        eval([adID{ich+1},' (',adID{ich+1},'==0) = range (',adID{ich+1},')/10000;'])

        %  Y eye channel in Tempo is multiplied by a factor of -1 and the values for the limits of the fixation and target window are in this reference frame. 
        %  it is easier to multiply the Y eye channnel are by -1.        
        if isequal ('EyeY_',adID{ich+1})
            eval ([adID{ich+1},' = ',adID{ich+1} ,'.* (-1);' ])
        end
        
        % Save the array of analog values to the _m file
        eval (['save  ([file_path,outfile]',c,q, adID{ich+1},qcq,'-append',q, ');'])
        % user feedback
        disp ([adID{ich+1},'....SAVED TO....',[file_path ,  outfile] ])
        % clear variables that are no longer needed
        eval(['clear ', adID{ich+1},' adfreq nad tsad fnad'])
        
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
    % Sample rate used to determine correct indicies
    curFrequency = ADSAMPLEFREQUENCY(curAD);
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
                % startcount=TrialStart_(curTrl);    endcount =TrialStart_(curTrl+1)-1;
                startcount= ceil(TrialStart_TimeStamps(curTrl)*curFrequency) ; endcount = ceil(TrialStart_TimeStamps(curTrl+1)*curFrequency)-1;
                % for debugging
                %                 disp([startcount,endcount])                
                eval (['tempAD(row,1:length(startcount:endcount))= ',curVar,'(startcount:endcount);'])
                row=row+1;
            else
                % startcount=TrialStart_(curTrl);    endcount =ceil(TimeStamps_Strobe_Events(end)*1000);
                startcount= ceil(TrialStart_TimeStamps(curTrl)*curFrequency) ; endcount = ceil(TimeStamps_Strobe_Events(end)*curFrequency);
                eval (['tempAD(row,1:length(startcount:endcount))= ',curVar,'(startcount:endcount);'])
                row=row+1;
            end
        end% for curTrl = curCHUNK*maxTrialNo+1:curCHUNK*maxTrialNo+NEXTSTEP

        % SAVE CHUNK TO TEMP FILE
        multifilename=multifilename+1;
        file = [ tempfilename , num2str(multifilename) ];

        %LOWERING SAMPLE RATE TO 250HZ
        %CALL TO FUNCTION ... lowerRate
        
        [tempAD, ADStart] = lowerRate (lowerfrequency, tempAD, curFrequency);
        
        % STORE ADStart will be used as first column in EmStart_
        % only needs to be done once so will do the last time
        if curAD==length (ADCHs)
            ADSTART = [ADSTART;ADStart];
        end
        
        %disp (['SAVING...',curVar,'...TO...', file])
        save(file,'tempAD','-mat');
        clear tempAD
    end % for curCHUNK = 0:multifilenameNo

    eval(['clear ',curVar])
    
       % default : for curCHUNK= 0:multifilenameNo
    for curCHUNK= 0:multifilenameNo
        if curCHUNK==multifilenameNo & residual ~=0
            NEXTSTEP=residual;
        else
            NEXTSTEP=maxTrialNo;
        end
        %load chunk into tempvar
        file = [tempfilename, num2str(curCHUNK+1)];
        %disp (['loading.....', curVar,' from......', file])
        load (file,'tempAD','-mat');
        % place chunk at end of variable
        eval ([curVar,'(curCHUNK*maxTrialNo+1:curCHUNK*maxTrialNo+size(tempAD,1),1:size(tempAD,2) )=tempAD;'])
        temp=[];
        delete(file)
        % pack
    end % for curCHUNK= 0:multifilenameNo

    disp (['SAVING...', curVar,'...TO...', file_path, outfile])
    save ([file_path, outfile], curVar, '-append')
    eval(['clear ',curVar])

    clear tempAD
end % for curAD = 1:length (ADCHs)

% store the ADSTART in the first column of EmStart
load ([file_path, outfile], 'EmStart_', '-mat')
EmStart_(:,1)=ADSTART;
save ([file_path, outfile], 'EmStart_', '-append')

fclose all