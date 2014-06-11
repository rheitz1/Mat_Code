neuron_cDex = 1;
neuron_eDex = 1;
LFP_cDex = 1;
LFP_eDex = 1;
EEG_cDex = 1;
EEG_eDex = 1;

cd /volumes/Dump/Analyses/Errors/subsample/
batch_list = dir('*.mat');

for i = 1:length(batch_list);
    batch_list(i).name
    load(batch_list(i).name)
    
    allfields = fields(TDT);
    
    if batch_list(i).name(1) == 'Q'
        monkey(i,1) = 'Q';
    elseif batch_list(i).name(1) == 'S'
        monkey(i,1) = 'S';
    end
    
    %Neuron TDTs
    neuronlist = allfields(strmatch('DSP',allfields));
    
    
    for f = 1:size(neuronlist,1)
        if ~isempty(strfind(neuronlist{f},'correct'))
            try
                neuronTDT.correct(neuron_cDex,1) = TDT.(neuronlist{f});
            catch
                neuronTDT.correct(neuron_cDex,1) = NaN;
            end
            
            allRTs.neuron.correct(neuron_cDex,1) = nanmean(RTs.correct);
            allwf.neuron.in_correct(neuron_cDex,1:601) = wf.(neuronlist{f}).in;
            allwf.neuron.out_correct(neuron_cDex,1:601) = wf.(neuronlist{f}).out;
            alln.neuron.in_correct(neuron_cDex,1) = n.(neuronlist{f}).in;
            alln.neuron.out_correct(neuron_cDex,1) = n.(neuronlist{f}).out;
            
            if ~isnan(valence.(neuronlist{f}))
                neuronValence.correct(neuron_cDex,1) = str2num(valence.(neuronlist{f}));
            end
            neuron_cDex = neuron_cDex + 1;
            
            
        elseif ~isempty(strfind(neuronlist{f},'errors'))
            try
                neuronTDT.errors(neuron_eDex,1) = TDT.(neuronlist{f});
            catch
                neuronTDT.errors(neuron_eDex,1) = NaN;
            end
            
            allRTs.neuron.errors(neuron_eDex,1) = nanmean(RTs.errors);
            allwf.neuron.in_errors(neuron_eDex,1:601) = wf.(neuronlist{f}).in;
            allwf.neuron.out_errors(neuron_eDex,1:601) = wf.(neuronlist{f}).out;
            alln.neuron.in_errors(neuron_eDex,1) = n.(neuronlist{f}).in;
            alln.neuron.out_errors(neuron_eDex,1) = n.(neuronlist{f}).out;
            
            
            if ~isnan(valence.(neuronlist{f}))
                neuronValence.errors(neuron_eDex,1) = str2num(valence.(neuronlist{f}));
            end
            neuron_eDex = neuron_eDex + 1;
            
        else
            disp('Something wrong...')
        end
    end
    
    
    %EEG TDTs
    ORlist = allfields(strmatch('OR',allfields));
    OLlist = allfields(strmatch('OL',allfields));
    
    EEGlist = [ORlist;OLlist];
    
    
    for f = 1:size(EEGlist,1)
        if ~isempty(strfind(EEGlist{f},'correct'))
            try
                EEGTDT.correct(EEG_cDex,1) = TDT.(EEGlist{f});
            catch
                EEGTDT.correct(EEG_cDex,1) = NaN;
            end
            
            allRTs.EEG.correct(EEG_cDex,1) = nanmean(RTs.correct);
            allwf.EEG.contra_correct(EEG_cDex,1:3001) = wf.(EEGlist{f}).contra;
            allwf.EEG.ipsi_correct(EEG_cDex,1:3001) = wf.(EEGlist{f}).ipsi;
            alln.EEG.contra_correct(EEG_cDex,1) = n.(EEGlist{f}).contra;
            alln.EEG.ipsi_correct(EEG_cDex,1) = n.(EEGlist{f}).ipsi;
            
            if ~isnan(valence.(EEGlist{f}))
                EEGValence.correct(EEG_cDex,1) = str2num(valence.(EEGlist{f}));
            end
            EEG_cDex = EEG_cDex + 1;
            
        elseif ~isempty(strfind(EEGlist{f},'errors'))
            try
                EEGTDT.errors(EEG_eDex,1) = TDT.(EEGlist{f});
            catch
                EEGTDT.errors(EEG_eDex,1) = NaN;
            end
            
            allRTs.EEG.errors(EEG_eDex,1) = nanmean(RTs.errors);
            allwf.EEG.contra_errors(EEG_eDex,1:3001) = wf.(EEGlist{f}).contra;
            allwf.EEG.ipsi_errors(EEG_eDex,1:3001) = wf.(EEGlist{f}).ipsi;
            alln.EEG.contra_errors(EEG_eDex,1) = n.(EEGlist{f}).contra;
            alln.EEG.ipsi_errors(EEG_eDex,1) = n.(EEGlist{f}).ipsi;
            
            
            if ~isnan(valence.(EEGlist{f}))
                EEGValence.errors(EEG_eDex,1) = str2num(valence.(EEGlist{f}));
            end
            EEG_eDex = EEG_eDex + 1;
            
        else
            disp('Something wrong...')
        end
    end
    
    %find what's left over
    done1 = strmatch('DSP',allfields);
    done2 = strmatch('OL',allfields);
    done3 = strmatch('OR',allfields);
    
    done = [done1;done2;done3];
    clear done1 done2 done3
    
    x = 1:size(allfields,1);
    %difference in sets gives what indices have not been done yet
    
    
    LFPlist = allfields(setdiff(x,done));
    
    
    for f = 1:size(LFPlist,1)
        if ~isempty(strfind(LFPlist{f},'correct'))
            try
                LFPTDT.correct(LFP_cDex,1) = TDT.(LFPlist{f});
            catch
                LFPTDT.correct(LFP_cDex,1) = NaN;
            end
            
            allRTs.LFP.correct(LFP_cDex,1) = nanmean(RTs.correct);
            allwf.LFP.in_correct(LFP_cDex,1:3001) = wf.(LFPlist{f}).in;
            allwf.LFP.out_correct(LFP_cDex,1:3001) = wf.(LFPlist{f}).out;
            alln.LFP.in_correct(LFP_cDex,1) = n.(LFPlist{f}).in;
            alln.LFP.out_correct(LFP_cDex,1) = n.(LFPlist{f}).out;
            
            
            
            if ~isnan(valence.(LFPlist{f}))
                LFPValence.correct(LFP_cDex,1) = str2num(valence.(LFPlist{f}));
            end
            
            LFP_cDex = LFP_cDex + 1;
            
        elseif ~isempty(strfind(LFPlist{f},'errors'))
            try
                LFPTDT.errors(LFP_eDex,1) = TDT.(LFPlist{f});
            catch
                LFPTDT.errors(LFP_eDex,1) = NaN;
            end
            
            allRTs.LFP.errors(LFP_eDex,1) = nanmean(RTs.errors);
            allwf.LFP.in_errors(LFP_eDex,1:3001) = wf.(LFPlist{f}).in;
            allwf.LFP.out_errors(LFP_eDex,1:3001) = wf.(LFPlist{f}).out;           
            alln.LFP.in_errors(LFP_eDex,1) = n.(LFPlist{f}).in;
            alln.LFP.out_errors(LFP_eDex,1) = n.(LFPlist{f}).out;
            
            
            if ~isnan(valence.(LFPlist{f}))
                LFPValence.errors(LFP_eDex,1) = str2num(valence.(LFPlist{f}));
            end
            LFP_eDex = LFP_eDex + 1;
            
        else
            disp('Something wrong...')
        end
    end
    
    allRTD.correct(1:length(RTs.correct),i) = RTs.correct;
    allRTD.errors(1:length(RTs.errors),i) = RTs.errors;
    
    keep neuronTDT LFPTDT EEGTDT neuronValence LFPValence EEGValence allRTs ...
        neuron_cDex neuron_eDex LFP_cDex LFP_eDex EEG_cDex EEG_eDex ...
        allRTD batch_list allwf alln monkey
    
end
