function SpikeTranslator_longBase( file_path, filename , TrialStart_ ,TimeStamps_Strobe_Events, outfile )
%long baseline period version

% PlxSpike2_m( file_path, filename , TrialStart_ ,TimeStamps_Strobe_Events, outfile )
%
% TRANSLATES THE SPIKES OCCURING DURING A COUNTERMANDING .PLX FILE TO AN _M FILE
% INPUT:
%   FILE_PATH: FOLDER YOU WOULD LIKE TO COMENCE SEARCHING FOR FILES TO PROCESS AND SAVE
%                       THE RESULTS TO. MUST BE A STRING  I.E., 'C:\DATA\BASIC\'
%   FILENAME: PLX FILENAME. MUST BE A STRING
%   TIMESTAMPS: ARRAY OF TRIALSTART EVENTS TIMESTAMPS IN SECONDS
%   TRIALSTART_ : TIME OF TRIALSTART RELATIVE TO BEGINNING OF RECORDING.
%   TIMESTAMPS_STROBE_EVENTS : AN ARRAY OF ALL OF THE STROBES OCCURING DURING THE RECORDING IN SECOND
%   OUTFILE: THE OUTPUT FILE NAME OF THE RESULTING FILE
%
%   OUTPUT:  SAVES VARIABLES BELOW TO [FILE_PATH, FILENAME]
%
%           DSPXXy
%
%           XX= SPIKE CHANNEL               XX CAN BE 01-17
%           y = SINGLE UNIT                     y CAN BE i FOR UNSORTED UNITS, OR  a-z FOR SORTED UNITS
%
%  CREATED BY: erik.emeric@vanderbilt.edu &
%                       pierre.pouget@vanderbilt.edu
%                           6-24-2005

% shortcut strings for quotation marks and comas
dat = evalin('caller','dat');
q='''';c=',';qcq=[q c q];

%initialize spike channel name cell array
SPKCH={};

% get  tscounts, number of spike counts in each channel
% organized :  tscount ( unit, channel)
%[tscounts, wfcounts, evcounts] = plx_info([file_path, filename],1);
DSP = 'DSP';
UnitID = {'i','a','b','c','d','e','f','g','h','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','aa'};
%ChanID = {'01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17'};
ChanID = {'01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24', ...
    '25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49', ...
    '50','51','52','53','54','55','56','57','58','59','60','61','62','63','64'};
% [nunits1, nchannels1] = size( tscounts );
% [ unit chan ] = find(tscounts~=0);
% [n,names] = plx_chan_names([file_path, filename]);
% % we will read in the timestamps of all units,channels into a two-dim cell
% % array named allts, with each cell containing the timestamps for a unit,channel.
% % Note that allts second dim is indexed by the 1-based channel number.
% for iunit = 0:nunits1-1   % starting with unit 0 (unsorted)
%     for ich = 1:nchannels1-1
%         if ( tscounts( iunit+1 , ich+1 ) > 0 )
%             % get the timestamps for this channel and unit
%             [nts, allts{iunit+1,ich}] = plx_ts([file_path, filename], ich , iunit );
%          end
%     end
% end

% dex = 1;
% for curUnit = 1:length(unit)
%     if UnitID{unit(curUnit)} ~= 'i'
%         eval( ['[nts,',[DSP,ChanID{chan(curUnit)-1},UnitID{unit(curUnit)}],' ] =  plx_ts([file_path, filename], chan(curUnit) - 1 , unit(curUnit) - 1 );'] )
%         %     [nts, curSpk]  =  plx_ts([file_path, filename], chan(curUnit) - 1 , unit(curUnit) - 1 );
%         eval (['save  ([file_path,outfile]',c,q, [DSP,ChanID{chan(curUnit)-1},UnitID{unit(curUnit)}] ,qcq,'-append',qcq,'-mat',q ');'])
%         %        eval (['save  ([file_path,outfile]',c,q, [DSP,ChanID{chan(curUnit)-1},UnitID{unit(curUnit)}] ,qcq,'-append',q ');'])
%         disp ([[DSP,ChanID{chan(curUnit)-1},UnitID{unit(curUnit)}],'....SAVED TO....',[file_path ,  outfile] ])
%         eval(['clear ', [DSP,ChanID{chan(curUnit)-1},UnitID{unit(curUnit)}] ])
%         SPKCH{dex} = [DSP,ChanID{chan(curUnit)-1},UnitID{unit(curUnit)}] ;
%         dex = dex + 1;
%     end
% end %for curUnit = 1:length(unit)

%h = waitbar(0,'Sorting...');
dex = 1;
for ich = 1:size(dat.SpikeChannels,1)
%     if ( evcounts(300+ich) > 0 )
%         % RETRIEVE CONTENTS OF ANALOG CHANNELS FROM PLX FILE
%         eval([' [ adfreq, nad, tsad, fnad,' ,adID{ich+1},' ] = plx_ad_v(OpenedFilename, ich);'])
%         % STORE ADVALUES IN REGISTER WITH TIMESTAMPS
%         temp = zeros(1,ceil(tsad(end)*1000)+fnad(end) );
% 
%         eval( ['[temp] = ad_frag2array(tsad,' adID{ich+1} ', fnad, adfreq);']);
%         eval ([adID{ich+1},' = temp;'])
%         clear temp
% 
%        % Remove zero values in Analog: Makes it very easy to find real values in a zero padded matrix
%         eval([adID{ich+1},' (',adID{ich+1},'==0) = range (',adID{ich+1},')/10000;'])
% 
%         save([file_path outfile],cell2mat(adID(ich+1)),'-append','-mat')
%         disp ([adID{ich+1},'....SAVED TO....',[file_path ,  outfile] ])
%         eval(['clear ', adID{ich+1},' adfreq nad tsad fnad'])
%         numads = numads + 1;
%         ADCHs{numads} = adID{ich+1};
%     end

    if dat.SpikeChannels(ich).NUnits > 0
       %eval([adID{ich} '= (double(dat.ContinuousChannels(ich).Values) / dat.ADFrequency);']);
       %
       % NOTE: Conversion factor is (1/40000) 
     
    
       for currUnit = 1:dat.SpikeChannels(ich).NUnits %start at 2 to disregard channel i (unsorted)
           %Note: Unit ID (e.g., a, b, c) is stored in .Units structure.  .Unit == 0 is i. Correct for
           %this below by adding 1 as needed
           eval(['DSP' ChanID{ich} UnitID{currUnit+1} ' =  double(dat.SpikeChannels(ich).Timestamps(find(dat.SpikeChannels(ich).Units == currUnit))) ./ 40000;'])
           
           SPKCH{dex} = [DSP,ChanID{ich},UnitID{currUnit+1}] ;
           save([file_path outfile],SPKCH{dex},'-append','-mat')
           disp ([[DSP,ChanID{ich},UnitID{currUnit+1}],'....SAVED TO....',[file_path ,  outfile] ])
           eval(['clear ', [DSP,ChanID{ich},UnitID{currUnit+1}] ])
           
           dex = dex + 1;
       end
    end
end


for currUnit = 1:length(SPKCH)
    eval (['load  ([file_path,outfile]',c,q,SPKCH{currUnit} ,qcq,'-mat',q, ');'])


    nTrials = length(TrialStart_);
    tempfilename=[file_path,'temp'];
    multifilename = 0;
    maxTrialNo = 100;
    multifilenameNo=floor( nTrials / maxTrialNo);
    residual= nTrials - (multifilenameNo*maxTrialNo);
    if residual == 0
        %refers to how many *extra* files we'll do.  Thus, if n = 100,
        %multifilenameNo == 0.  See below: for loop begins with 0.
        multifilenameNo = multifilenameNo -1;
        residual = maxTrialNo;
    end


    for curCHUNK = 0:multifilenameNo

        if curCHUNK==multifilenameNo & residual ~=0
            NEXTSTEP=residual;
        else
            NEXTSTEP=maxTrialNo;
        end

        nTrials = curCHUNK*maxTrialNo+NEXTSTEP;

        newindex = 1;
        for curTrl = curCHUNK*maxTrialNo+1:curCHUNK*maxTrialNo+NEXTSTEP
            if curTrl ~= size(TrialStart_,1)
                startcount=(TrialStart_(curTrl)/1000);   endcount = startcount + 6000;% endcount =(TrialStart_(curTrl+1)- 1)/1000;

                %truncate spikes at 3 seconds to control matrix sizes
                if endcount - startcount > 6
                    endcount = startcount + 6;
                end
            else
                %add 500ms before trial start
                startcount=(TrialStart_(curTrl)/1000);    endcount =ceil(TimeStamps_Strobe_Events(end)*1000);

                %truncate spikes at 3 seconds to control matrix sizes
                if endcount - startcount > 6
                    endcount = startcount + 6;
                end
            end
            %         trlSpks = find( DSP01i > startcount & DSP01i < endcount );
            eval(  ['trlSpks = find(', SPKCH{currUnit},'  > startcount & ',SPKCH{currUnit},'  < endcount );']        )
            %         temp(curTrl,1:length(trlSpks)) = ceil (DSP01i (trlSpks)*1000) -TrialStart_(curTrl,1) ;
            %%%%
            %%%%RPH: the below line alters the spike times so that they include a 
            %%%%ms baseline.  By subtracting TrialStart_, which was altered in the
            %%%%calling script, a baseline is built in.
            eval(   ['tempSPK(newindex,1:length(trlSpks)) = ceil (', SPKCH{currUnit}, ' (trlSpks)*1000) - TrialStart_(curTrl,1) ;'])
            newindex = newindex + 1;
        end % for curTrl = 1:size(TrialStart_,1)


        % SAVE CHUNK TO TEMP FILE
        multifilename=multifilename+1;
        file = [ tempfilename , num2str(multifilename) ];

        disp (['SAVING...',SPKCH{currUnit},'...TO...', file])
        save(file,'tempSPK','-mat');
        clear tempSPK
    end
    eval(['clear ',SPKCH{currUnit}])
    %put chunks back together
    for curCHUNK= 0:multifilenameNo
        if curCHUNK==multifilenameNo & residual ~=0
            NEXTSTEP=residual;
        else
            NEXTSTEP=maxTrialNo;
        end
        %load chunk into tempvar
        file = [tempfilename, num2str(curCHUNK+1)];
        disp (['loading from......', file])
        load (file,'tempSPK','-mat');
        eval ([SPKCH{currUnit},'(curCHUNK*maxTrialNo+1:curCHUNK*maxTrialNo+size(tempSPK,1),1:size(tempSPK,2) )=tempSPK;'])
        tempSPK=[];
        delete(file)
    end
    disp (['SAVING...', SPKCH{currUnit},'...TO...', file_path, outfile])
    save ([file_path, outfile], SPKCH{currUnit}, '-append','-mat')
    eval(['clear ',SPKCH{currUnit}])


end

