function getSpikeWavesHeap(filename)
%
% Gets all spike waveforms for each sorted unit but does not take into
% account SEARCH vs MG or any other trial distinction.


q='''';c=',';qcq=[q c q];

%initialize spike channel name cell array
SPKCH={};

% get  tscounts, number of spike counts in each channel
% organized :  tscount ( unit, channel)
[tscounts, wfcounts, evcounts] = plx_info(filename,1);
DSP = 'DSP';
UnitID = {'i','a','b','c','d','e','f','g','h','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','aa'};
ChanID = {'01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17'};
[nunits1, nchannels1] = size( tscounts );
[ unit chan ] = find(tscounts~=0);
[n,names] = plx_chan_names(filename);


fileID = filename(1:end-4);
newfile = [fileID '_waves'];
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

%get rid of extraneous variables
clear evcounts n nchannels1 nunits1 tscounts wfcounts
dex = 1;
for curUnit = 1:length(unit)
    if UnitID{unit(curUnit)} ~= 'i'
        disp(['DSP' ChanID{chan(curUnit)-1} UnitID{unit(curUnit)}])
        [n_wave npw_wave ts_waves waves] = plx_waves_v(filename,chan(curUnit)-1,unit(curUnit)-1);
        eval(['DSP' ChanID{chan(curUnit)-1} UnitID{unit(curUnit)} '_waves = waves;'])
        
        if exist([newfile '.mat']) == 0
            eval(['save(' q newfile '.mat' qcq 'DSP' ChanID{chan(curUnit)-1} UnitID{unit(curUnit)} '_waves' qcq '-mat' q ')'])
        elseif exist([newfile '.mat']) == 2
            eval(['save(' q newfile '.mat' qcq 'DSP' ChanID{chan(curUnit)-1} UnitID{unit(curUnit)} '_waves' qcq '-append' qcq '-mat' q ')'])
        end
        
        eval(['clear DSP' ChanID{chan(curUnit)-1} UnitID{unit(curUnit)} '_waves'])
        clear waves tswaves


    end
end