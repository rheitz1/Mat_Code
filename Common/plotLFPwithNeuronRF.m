%plot LFPs with neuron RFs
% RPH

cd '/volumes/Dump/Search_Data/'

batch_list = dir('*SEARCH.mat');

totalOverlap = 1;
totalNonOverlap = 1;
figure
fw
for sess = 1:length(batch_list)
    
    ChanStruct = loadChan(batch_list(sess).name,'LFP');
    if isempty(ChanStruct)
        disp('Missing LFPs')
        continue
    end
    
    LFPlist = fieldnames(ChanStruct);
    decodeChanStruct
    clear ChanStruct
    
    ChanStruct = loadChan(batch_list(sess).name,'DSP');
    if isempty(ChanStruct)
        disp('Missing Spikes')
        continue
    end
    DSPlist = fieldnames(ChanStruct);
    decodeChanStruct
    clear ChanStruct
    
    load(batch_list(sess).name,'Target_','RFs','Correct_','TrialStart_','SRT')
    
    
    
    for currDSP = 1:length(DSPlist)
        Spike = eval(DSPlist{currDSP});
        
        RF = RFs.(DSPlist{currDSP});
        antiRF = mod((RF+4),8);
        
        if isempty(RF)
            continue
        end
        
        in = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        out = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        
        SDF.in = spikedensityfunct(Spike,Target_(:,1),[-100 500],in,TrialStart_);
        SDF.out = spikedensityfunct(Spike,Target_(:,1),[-100 500],out,TrialStart_);
        
        TDT.spike = getTDT_SP(Spike,in,out);
        
        
        for currLFP = 1:length(LFPlist)
            LFP = eval(LFPlist{currLFP});
            
            TDT.LFP = getTDT_AD(LFP,in,out);
            
            subplot(1,2,1)
            plot(-100:500,SDF.in,'k',-100:500,SDF.out,'--k')
            xlim([-100 500])
            vline(TDT.spike,'k')
            
            subplot(1,2,2)
            plot(-500:2500,nanmean(LFP(in,:)),'k',-500:2500,nanmean(LFP(out,:)),'--k')
            axis ij
            xlim([-100 500])
            vline(TDT.LFP,'k')
            
            keeper = input('Keep?');
            
            if keeper == 1
                overlapping{totalOverlap,1} = batch_list(sess).name;
                overlapping{totalOverlap,2} = LFPlist{currLFP};
                overlapping{totalOverlap,3} = DSPlist{currDSP};
                totalOverlap = totalOverlap + 1;
            end
            
            if keeper == 2
                nonoverlapping{totalNonOverlap,1} = batch_list(sess).name;
                nonoverlapping{totalNonOverlap,2} = LFPlist{currLFP};
                nonoverlapping{totalNonOverlap,3} = DSPlist{currDSP};
                totalNonOverlap = totalNonOverlap + 1;
            end
            
            clear LFP
        end
        clear Spike
        
    end
    
    save('~/desktop/SFCkeep.mat','-mat')
    keep batch_list sess totalOverlap totalNonOverlap overlapping nonoverlapping
end
