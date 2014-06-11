function [] = osx_ADTranslator_longBase_noChunk(file_path,filename,TrialStart_,TimeStamps_Strobe_Events,outfile)
%long baseline period version

%AD Translator
dat = evalin('caller','dat');

if filename(1) == 'D' || filename(1) == 'E' %new naming convention: year/month/day
    year=str2double(filename(4:5));
    month=str2double(filename(6:7));
else
    year=str2double(filename(6:7));
    month=str2double(filename(2:3));
end

%INITIALIZE VARIABLE NAMES
ADCHs={};

if year >= 14
    adID = {'AD01','AD02','AD03','AD04','AD05','AD06','AD07','AD08', 'AD09','AD10','AD11','AD12','AD13','AD14','AD15', 'AD16','AD17', 'AD18', 'AD19' ...
    ,'AD20','AD21','AD22','AD23','AD24','AD25','AD26','AD27','AD28', 'AD29', 'AD30', 'AD31','AD32','AD33','AD34','AD35','AD36','AD37','AD38'...
    ,'AD39','AD40','AD41','AD42','AD43','AD44','AD45','AD46','AD47','AD48', 'AD49','AD50','AD51','AD52','AD53','AD54','AD55','AD56','AD57'...
    , 'AD58','AD59','AD60','AD61','AD62','AD63','AD64','EyeX_','EyeY_','Pupil_','uStim_','Juice_','AD70','AD71','AD72','AD73','AD74','AD75','AD76' ...
    , 'AD77','AD78','AD79','AD80','AD81','AD82','AD83','AD84','AD85','AD86','AF87','AD88','AD89','AD90','AD91','AD92','AD93','AD94','AD95' ...
    , 'AD96','AD97','AD98','AD99','AD100','AD101','AD102','AD103','AD104','AD105','AD106','AD107','AD108','AD109','AD110','AD111','AD112','AD113' ...
    , 'AD114','AD115','AD116','AD117','AD118','AD119','AD120','AD121','AD122','AD123','AD124','AD125','AD126','AD127','AD128'};
elseif year>10||(year==10&&month>2)
adID = {'AD01','AD02','AD03','AD04','AD05','AD06','AD07','AD08', 'AD09','AD10','AD11','AD12','AD13','AD14','AD15', 'AD16','AD17', 'AD18', 'AD19' ...
    ,'AD20','AD21','AD22','AD23','AD24','AD25','AD26','AD27','AD28', 'AD29', 'AD30', 'AD31','AD32','AD33','AD34','AD35','AD36','AD37','AD38'...
    ,'AD39','AD40','AD41','AD42','AD43','uStim','Pupil_','AD46','EyeX_','EyeY_', 'AD49','AD50','AD51','AD52','AD53','AD54','AD55','AD56','AD57'...
    , 'AD58','AD59','AD60','AD61','AD62','AD63','AD64'};
else
adID = {'AD01','AD02','AD03','AD04','AD05','AD06','AD07','AD08', 'AD09','AD10','AD11','AD12','AD13','AD14','AD15', 'AD16','AD17', 'EyeX_', 'EyeY_' ...
    ,'AD20','AD21','AD22','AD23','AD24','AD25','AD26','AD27','AD28', 'AD29','AD30','AD31','AD32','AD33','AD34','AD35','AD36','AD37','AD38'...
    ,'AD39','AD40','AD41','AD42','AD43','AD44','AD45','AD46','AD47','AD48', 'AD49','AD50','AD51','AD52','AD53','AD54','AD55','AD56','AD57'...
    , 'AD58','AD59','AD60','AD61','AD62','AD63','AD64'};   
end



numads = 0;
%for ich = 46:47
for ich = 1:size(dat.ContinuousChannels,1)

    if size(dat.ContinuousChannels(ich).Values,1) > 0
       eval([adID{ich} '= (double(dat.ContinuousChannels(ich).Values));']);
       
       convFactor = 1 / (409.6 * dat.ContinuousChannels(ich).ADGain);
       eval([adID{ich} ' = ' adID{ich} ' .* convFactor;']);
       
       disp ([adID{ich},' LOADED',[file_path ,  outfile] ])

       numads = numads + 1;
       ADCHs{numads} = adID{ich};
    end
end


% clear Comment Duration NPW OpenedfilenameName  Version  Freq  Comment  Trodalness  NPW  ...
%     PreTresh  SpikePeakV  SpikeADResBits  SlowPeakV  SlowADResBits  Duration  DateTime n ...
%     gains tscounts  wfcounts  evcounts  ich delay


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for curAD = 1:length (ADCHs)
   
    curVar = char(ADCHs{curAD});
    disp (['CUTTING UP TRIALS FOR...',curVar])
    eval (['ADlength = length(',curVar,');'])

    tempAD = NaN(length(TrialStart_),6001); %preallocate

      for curTrl = 1:size(TrialStart_,1)
            if curTrl ~= size(TrialStart_,1)
                startcount=TrialStart_(curTrl);    endcount = startcount + 6000;%endcount =TrialStart_(curTrl+1)-1;

                %limit length of data to 6 seconds
                if (endcount-startcount)>6000%10000
                    endcount=TrialStart_(curTrl)+6000;%10000;
                end;

                if startcount < 1
                    disp('STARTCOUNT HAS BEEN EDITED...BELOW 0!!')
                    startcount = 1;
                end

                eval ([' tempAD(curTrl,1:length(startcount:endcount))= ',curVar,'(startcount:endcount);'])
       
            else
                startcount=TrialStart_(curTrl);    endcount =ceil(TimeStamps_Strobe_Events(end)*1000);
                if (endcount-startcount)>6000%10000
                    endcount=TrialStart_(curTrl)+6000;%10000;
                end;

                eval ([' tempAD(curTrl,1:length(startcount:endcount))= ',curVar,'(startcount:endcount);'])
            end
        end

        eval([curVar ' = tempAD;']);
        clear tempAD

end

disp (['SAVING...TO...', file_path, outfile])
save ([file_path, outfile], 'AD*','EyeX_','EyeY_', '-append','-mat')

if exist('Pupil_')
    disp (['SAVING...Pupil_...', file_path, outfile])
    save ([file_path, outfile], 'Pupil_', '-append','-mat')
end