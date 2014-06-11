neuron_cDex = 1;
neuron_eDex = 1;
LFP_cDex = 1;
LFP_eDex = 1;
EEG_cDex = 1;
EEG_eDex = 1;


cd /volumes/Dump/Analyses/Errors/
batch_list = dir('*.mat');

for i = 1:length(batch_list);
    batch_list(i).name
    load(batch_list(i).name)
    
    allfields = fields(TDT);
    
    
    %Neuron TDTs
    neuronlist = allfields(strmatch('DSP',allfields));
    
    
    for f = 1:size(neuronlist,1)
        if ~isempty(strfind(neuronlist{f},'correct'))
            neuronTDT.correct(neuron_cDex,1) = TDT.(neuronlist{f});
            allRTs.neuron.correct_Tin(neuron_cDex,1) = nanmean(RTs.correct_Tin);
            
            
            if ~isnan(valence.(neuronlist{f}))
                neuronValence.correct(neuron_cDex,1) = str2num(valence.(neuronlist{f}));
            end
            neuron_cDex = neuron_cDex + 1;
            
            
        elseif ~isempty(strfind(neuronlist{f},'errors'))
            neuronTDT.errors(neuron_eDex,1) = TDT.(neuronlist{f});
            allRTs.neuron.errors_Din(neuron_eDex,1) = nanmean(RTs.errors_Din);
            
            if ~isnan(valence.(neuronlist{f}))
                neuronValence.errors(neuron_eDex,1) = str2num(valence.(neuronlist{f}));
            end
            neuron_eDex = neuron_eDex + 1;
            
        else
            disp('Something wrong...')
        end
    end
    
    
    %EEG TDTs
    AD02list = allfields(strmatch('AD02',allfields));
    AD03list = allfields(strmatch('AD03',allfields));
    
    EEGlist = [AD02list;AD03list];
    
    
    for f = 1:size(EEGlist,1)
        if ~isempty(strfind(EEGlist{f},'correct'))
            EEGTDT.correct(EEG_cDex,1) = TDT.(EEGlist{f});
            allRTs.EEG.correct_Tin(EEG_cDex,1) = nanmean(RTs.correct_Tin);
            
            if ~isnan(valence.(EEGlist{f}))
                EEGValence.correct(EEG_cDex,1) = str2num(valence.(EEGlist{f}));
            end
            EEG_cDex = EEG_cDex + 1;
            
        elseif ~isempty(strfind(EEGlist{f},'errors'))
            EEGTDT.errors(EEG_eDex,1) = TDT.(EEGlist{f});
            allRTs.EEG.errors_Din(EEG_eDex,1) = nanmean(RTs.errors_Din);
            
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
    done2 = strmatch('AD02',allfields);
    done3 = strmatch('AD03',allfields);
    
    done = [done1;done2;done3];
    clear done1 done2 done3
    
    x = 1:size(allfields,1);
    %difference in sets gives what indices have not been done yet
    
    
    LFPlist = allfields(setdiff(x,done));
    
    
    for f = 1:size(LFPlist,1)
        if ~isempty(strfind(LFPlist{f},'correct'))
            LFPTDT.correct(LFP_cDex,1) = TDT.(LFPlist{f});
            allRTs.LFP.correct_Tin(LFP_cDex,1) = nanmean(RTs.correct_Tin);
            
            if ~isnan(valence.(LFPlist{f}))
                LFPValence.correct(LFP_cDex,1) = str2num(valence.(LFPlist{f}));
            end
            
            LFP_cDex = LFP_cDex + 1;
            
        elseif ~isempty(strfind(LFPlist{f},'errors'))
            LFPTDT.errors(LFP_eDex,1) = TDT.(LFPlist{f});
            allRTs.LFP.errors_Din(LFP_eDex,1) = nanmean(RTs.errors_Din);
            
            if ~isnan(valence.(LFPlist{f}))
                LFPValence.errors(LFP_eDex,1) = str2num(valence.(LFPlist{f}));
            end
            LFP_eDex = LFP_eDex + 1;
            
        else
            disp('Something wrong...')
        end
    end
    
    allRTD.correct_Tin(1:length(RTs.correct_Tin),i) = RTs.correct_Tin;
    allRTD.errors_Din(1:length(RTs.errors_Din),i) = RTs.errors_Din;
    
    keep neuronTDT LFPTDT EEGTDT neuronValence LFPValence EEGValence allRTs ...
        neuron_cDex neuron_eDex LFP_cDex LFP_eDex EEG_cDex EEG_eDex ...
        allRTD batch_list
    
end
