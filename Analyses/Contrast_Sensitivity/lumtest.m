
cd '/volumes/Dump/Search_Data_with_Bursts/'

batch_list = dir('*_MG.mat.mat');

for sess = 1:length(batch_list)
    
    batch_list(sess).name
    
    load(batch_list(sess).name)
    
    %first set all values to NaN
    Target_(:,13) = NaN;
    
    %set critical values in each of three groups to categorical numbers
    Target_(find(Target_(:,3) >= 140 & Target_(:,3) < 160),13) = 1;
    Target_(find(Target_(:,3) >= 160 & Target_(:,3) < 190),13) = 2;
    Target_(find(Target_(:,3) >= 190),13) = 3;
    
    alllums = unique(Target_(find(Target_(:,3) > 1),3));
    
    
    NeuronList = fields(RFs);
    
    for neuron = 1:length(NeuronList)
        
        name = NeuronList{neuron};
        num = name(end-2:end-1);
        
        
        try
            LFP = eval(['AD' num]);
            LFP = baseline_correct(LFP,[400 500]);
            isLFP = 1;
        catch
            isLFP = 0;
        end
        
        if ~isempty(NeuronList{neuron})
            RF = RFs.(NeuronList{neuron});
            sig = eval(NeuronList{neuron});
            
            
            in.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF));
            in.low = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,13) == 1);
            in.med = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,13) == 2);
            in.high = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,13) == 3);
            
            BurstTimes = BurstStartTimes.(NeuronList{neuron});
            BurstTimes(find(BurstTimes == 0)) = NaN;
            BurstTImes = BurstTimes(:,1);
            
            
            for lum = 1:length(alllums)
                temp = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,3) == alllums(lum));
                SDF_all.bylums(1:length(-200:500),lum,sess) = spikedensityfunct(sig,Target_(:,1),[-200 500],nonzeros(temp),TrialStart_);
                Bursts_all.mean.bylum(1,lum,sess) = nanmean(BurstTimes(temp));
                Bursts_all.mode.bylum(1,lum,sess) = mode(BurstTimes(temp));
                RT_all.bylums(1,lum,sess) = nanmean(SRT(temp,1));
                
                if isLFP == 1
                    LFP_all.bylums(1:length(-500:2500),lum,sess) = nanmean(LFP(temp,:));
                else
                    LFP_all.bylums(1:length(-500:2500),lum,sess) = NaN;
                end
                clear temp
            end
            
            
            Bursts_all.mean.all(1,1,sess) = nanmean(BurstTimes(in.all));
            Bursts_all.mean.high(1,1,sess) = nanmean(BurstTimes(in.high));
            Bursts_all.mean.med(1,1,sess) = nanmean(BurstTimes(in.med));
            Bursts_all.mean.low(1,1,sess) = nanmean(BurstTimes(in.low));
            
            Bursts_all.mode.all(1,1,sess) = mode(BurstTimes(in.all));
            Bursts_all.mode.high(1,1,sess) = mode(BurstTimes(in.high));
            Bursts_all.mode.med(1,1,sess) = mode(BurstTimes(in.med));
            Bursts_all.mode.low(1,1,sess) = mode(BurstTimes(in.low));
            
            SDF_all.all(1:length(-200:500),1,sess) = spikedensityfunct(sig,Target_(:,1),[-200 500],in.all,TrialStart_);
            SDF_all.high(1:length(-200:500),1,sess) = spikedensityfunct(sig,Target_(:,1),[-200 500],in.high,TrialStart_);
            SDF_all.med(1:length(-200:500),1,sess) = spikedensityfunct(sig,Target_(:,1),[-200 500],in.med,TrialStart_);
            SDF_all.low(1:length(-200:500),1,sess) = spikedensityfunct(sig,Target_(:,1),[-200 500],in.low,TrialStart_);
            
            if isLFP
                LFP_all.all(1:length(-500:2500),1,sess) = nanmean(LFP(in.all,:));
                LFP_all.low(1:length(-500:2500),1,sess) = nanmean(LFP(in.low,:));
                LFP_all.med(1:length(-500:2500),1,sess) = nanmean(LFP(in.med,:));
                LFP_all.high(1:length(-500:2500),1,sess) = nanmean(LFP(in.high,:));
            else
                LFP_all.all(1:length(-500:2500),1,sess) = NaN;
                LFP_all.low(1:length(-500:2500),1,sess) = NaN;
                LFP_all.med(1:length(-500:2500),1,sess) = NaN;
                LFP_all.high(1:length(-500:2500),1,sess) = NaN;
            end
            
            RT_all.all(1,1,sess) = nanmean(SRT(in.all,1));
            RT_all.high(1,1,sess) = nanmean(SRT(in.high,1));
            RT_all.med(1,1,sess) = nanmean(SRT(in.med,1));
            RT_all.low(1,1,sess) = nanmean(SRT(in.low,1));
            
            file_name{sess,1} = batch_list(sess).name;
            unit_name{sess,neuron} = NeuronList{neuron};
            
        else
            disp('No RF')
        end
        
        clear sig RF in BurstTimes
    end
    
    keep Bursts_all LFP_all SDF_all RT_all batch_list sess file_name unit_name
end