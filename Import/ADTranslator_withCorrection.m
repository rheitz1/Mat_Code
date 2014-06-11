function [] = ADTranslator(file_path,filename,TrialStart_,TimeStamps_Strobe_Events,outfile)
%AD Translator with correction for phase shift induced by head stage

q='''';c=',';qcq=[q c q];

%get global filename info
[OpenedFilename, Version, Freq, Comment, Trodalness, NPW, PreTresh, SpikePeakV, SpikeADResBits, ...
    SlowPeakV, SlowADResBits, Duration, DateTime] = plx_information([file_path,filename]);


%INITIALIZE VARIABLE NAMES
ADCHs={};
adID = {'AD01','AD02','AD03','AD04','AD05','AD06','AD07','AD08', 'AD09','AD10','AD11','AD12','AD13','AD14','AD15', 'AD16','AD17', 'EyeX_', 'EyeY_' ...
    ,'AD20','AD21','AD22','AD23','AD24','AD25','AD26','AD27','AD28', 'AD29','AD31','AD32','AD33','AD34','AD35','AD36','AD37','AD38'...
    ,'AD39','AD40','AD41','AD42','AD43','AD44','AD45','AD46','AD47','AD48', 'AD49','AD50','AD51','AD52','AD53','AD54','AD55','AD56','AD57'...
    , 'AD58','AD59','AD60','AD61','AD62','AD63','AD64'};

v = evalc('ver');
OS = v(170:200);

if ~isempty(strfind(OS,'XP'))
    %get AD gains for conversion
    [n,gains] = plx_adchan_gains([file_path,filename]);

    % get counts of timestamps in all channels
    [tscounts, wfcounts, evcounts] = plx_info([file_path,filename],0);

else
    % get counts of timestamps in all channels
    [tscounts, wfcounts, evcounts, contcounts] = plx_info([file_path,filename],1);

    % JH - make evcounts look like evcounts produced by legacy mexPlex.dll
    evcounts(300:(299+length(contcounts))) = contcounts;

end

numads = 0;
for ich = 0:64
    if ( evcounts(300+ich) > 0 )
        % RETRIEVE CONTENTS OF ANALOG CHANNELS FROM PLX FILE
        eval([' [ adfreq, nad, tsad, fnad,' ,adID{ich+1},' ] = plx_ad_v(OpenedFilename, ich);'])
        % STORE ADVALUES IN REGISTER WITH TIMESTAMPS
        temp = zeros(1,ceil(tsad(end)*1000)+fnad(end) );

        
        
        
        %===========================================================
% Matt's LFP correction
% check date of file to see if we were using low impedance or high
% impedance head stage.
% high impedance head stage uses transfer function stored in 'TF_Amp28.mat'
% use this for all EEG, and for LFPs w/ high impedance head stage
% for low impedance head stage, use transfer function stored in 'CombinedTF_Amp28ACMedImp.mat'
        
%what date was file recorded?
    mo = str2num(filename(2:3));
    dy = str2num(filename(4:5));
    yr = str2num(filename(6:7));
    monk = filename(1);
    %high impedance head stage used beginning 7/30/08
    
    %what is channel number?
    channum = cell2mat(adID(ich+1));
    channum = str2num(channum(3:4));
    
    %if AD < 9 & monkey is S, then we know is EEG; use high impedance head
    %stage correction
    if monk == 'S' & channum < 9
        headstage = 'H';
        disp('Correcting for High Impedance Headstage')
        eval([adID{ich+1} ' = masterCorrect(' adID{ich+1} ',headstage);'])
        %if AD >= 9 & monkey is S, then we know is LFP; check date
    elseif monk == 'S' & channum >= 9
        if yr < 8
            headstage = 'L';
            disp('Correcting for Low Impedance Headstage')
            eval([adID{ich+1} ' = masterCorrect(' adID{ich+1} ',headstage);'])
        elseif yr == 8 & mo < 7
            headstage = 'L';
            disp('Correcting for Low Impedance Headstage')
            eval([adID{ich+1} ' = masterCorrect(' adID{ich+1} ',headstage);'])
        else
            headstage = 'H';
            disp('Correcting for High Impedance Headstage')
            eval([adID{ich+1} ' = masterCorrect(' adID{ich+1} ',headstage);'])
        end
        %if AD < 4 & monkey is Q, then we know is EEG. Use high impedance
        %correction
    elseif monk == 'Q' & channum < 4
        headstage = 'H';
        disp('Correcting for High Impedance Headstage')
        eval([adID{ich+1} ' = masterCorrect(' adID{ich+1} ',headstage);'])
        %if AD >= 4 & monkey is Q, then we know is LFP; check date
    elseif monk == 'Q' & channum >= 4
        if yr < 8
            headstage = 'L';
            disp('Correcting for Low Impedance Headstage')
            eval([adID{ich+1} ' = masterCorrect(' adID{ich+1} ',headstage);'])
        elseif yr == 8 & mo < 7
            headstage = 'L';
            disp('Correcting for Low Impedance Headstage')
            eval([adID{ich+1} ' = masterCorrect(' adID{ich+1} ',headstage);'])
        else
            headstage = 'H';
            disp('Correcting for High Impedance Headstage')
            eval([adID{ich+1} ' = masterCorrect(' adID{ich+1} ',headstage);'])
        end
    end
%==========================================================================


    eval( ['[temp] = ad_frag2array(tsad,' adID{ich+1} ', fnad, adfreq);']);
    eval ([adID{ich+1},' = temp;'])
    clear temp

        eval([adID{ich+1},' (',adID{ich+1},'==0) = range (',adID{ich+1},')/10000;'])
        save([file_path outfile],cell2mat(adID(ich+1)),'-append','-mat')
        disp ([adID{ich+1},'....SAVED TO....',[file_path ,  outfile] ])
        eval(['clear ', adID{ich+1},' adfreq nad tsad fnad'])
        numads = numads + 1;
        ADCHs{numads} = adID{ich+1};
    end
end


clear Comment Duration NPW OpenedfilenameName  Version  Freq  Comment  Trodalness  NPW  ...
    PreTresh  SpikePeakV  SpikeADResBits  SlowPeakV  SlowADResBits  Duration  DateTime n ...
    gains tscounts  wfcounts  evcounts  ich delay

% %***WRITE TO MULTIPLE filenameS IF TRIAL #  EXCEEDS PRESET VALUES***
maxTrialNo=100;
MultifilenameFlag=0;
multifilename=0;
tempfilename=[file_path,'temp'];
MULTIfilename=[num2str(multifilename),' separate continuous channel filenames that are merged'];
% %****************************************************************
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Configure loop structure
if size(TrialStart_,1) > maxTrialNo
    MultifilenameFlag=1;
end
multifilenameNo=floor( size(TrialStart_,1) /maxTrialNo);
residual=size(TrialStart_,1) - (multifilenameNo*maxTrialNo);
if residual == 0
    %refers to how many *extra* files we'll do.  Thus, if n = 100,
    %multifilenameNo == 0.  See below: for loop begins with 0.
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

                %limit length of data to 3 seconds
                if (endcount-startcount)>3000%10000
                    endcount=TrialStart_(curTrl)+3000;%10000;
                end;

                if startcount < 1
                    disp('STARTCOUNT HAS BEEN EDITED...BELOW 0!!')
                    startcount = 1;
                end

                eval ([' tempAD(row,1:length(startcount:endcount))= ',curVar,'(startcount:endcount);'])
                row=row+1;
            else
                startcount=TrialStart_(curTrl);    endcount =ceil(TimeStamps_Strobe_Events(end)*1000);


                if (endcount-startcount)>3000%10000
                    endcount=TrialStart_(curTrl)+3000;%10000;
                end;

                eval ([' tempAD(row,1:length(startcount:endcount))= ',curVar,'(startcount:endcount);'])
                row=row+1;
            end
        end

        % SAVE CHUNK TO TEMP FILE
        multifilename=multifilename+1;
        file = [ tempfilename , num2str(multifilename) ];

        disp (['SAVING...',curVar,'...TO...', file])
        save(file,'tempAD','-mat');
        clear tempAD
    end 

    eval(['clear ',curVar])

    %put chunks back together again
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
    end

    disp (['SAVING...', curVar,'...TO...', file_path, outfile])
    save ([file_path, outfile], curVar, '-append','-mat')
    eval(['clear ',curVar])

end

