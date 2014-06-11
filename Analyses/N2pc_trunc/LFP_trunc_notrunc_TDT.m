%Shows the difference in calculated TDT for LFP signals between truncated
%and non-truncated signals.  Correct trials only.
% RF uses hemifields!!
cd /volumes/Dump/Search_Data/
batch_list = dir('*SEARCH.mat');
plotFlag = 1;


totalTDT = 0;
for i = 1:length(batch_list)
    
    batch_list(i).name
    
    ChanStruct = loadChan(batch_list(i).name,'LFP');
    
    if ~isempty(ChanStruct)
        LFPList = fields(ChanStruct);
    else
        disp('No Channels Found...')
        continue
    end
    
    decodeChanStruct
    
    load(batch_list(i).name,'Hemi','Correct_','Target_','SRT')
    
    for LFPnum = 1:length(LFPList)
        totalTDT = totalTDT + 1;
        
        LFP = eval(LFPList{LFPnum});
        
        
        %baseline correct
        LFP = baseline_correct(LFP,[400 500]);
        
        % remove saturated signals
        LFP = fixClipped(LFP);
        
        %truncate 20 ms before saccade
        LFP_trunc = truncateAD_targ(LFP,SRT);
        
        
        if Hemi.(LFPList{LFPnum}) == 'R'
            correct_in = find(Correct_(:,2) & ismember(Target_(:,2),[3 4 5]));
            correct_out = find(Correct_(:,2) & ismember(Target_(:,2),[7 0 1]));
        elseif Hemi.(LFPList{LFPnum}) == 'L'
            correct_in = find(Correct_(:,2) & ismember(Target_(:,2),[7 0 1]));
            correct_out = find(Correct_(:,2) & ismember(Target_(:,2),[3 4 5]));
        end
        
        TDT = getTDT_AD(LFP,correct_in,correct_out);
        TDT_trunc = getTDT_AD(LFP_trunc,correct_in,correct_out);
        
        if TDT > nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255)),1)
            disp('TDT too late...writing NaN')
            TDT = NaN;
        end
        
        if TDT_trunc > nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255)),1)
            disp('Truncated TDT too late...writing NaN')
            TDT_trunc = NaN;
        end
        
        
        if plotFlag == 1
            figure
            subplot(1,2,1)
            orient landscape
            set(gcf,'color','white')
            
            subplot(1,2,1)
            plot(-500:2500,nanmean(LFP(correct_in,:)),'b',-500:2500,nanmean(LFP(correct_out,:)),'--b')
            axis ij
            xlim([-50 300])
            title(['TDT = ' mat2str(TDT)],'fontsize',12,'fontweight','bold')
            ylabel('mV','fontsize',12,'fontweight','bold')
            xlabel('Time from Target','fontsize',12,'fontweight','bold')
            vline(TDT,'b')
            
            subplot(1,2,2)
            plot(-500:2500,nanmean(LFP_trunc(correct_in,:)),'b',-500:2500,nanmean(LFP_trunc(correct_out,:)),'--b')
            axis ij
            xlim([-50 300])
            title(['TDT = ' mat2str(TDT_trunc)],'fontsize',12,'fontweight','bold')
            ylabel('mV','fontsize',12,'fontweight','bold')
            xlabel('Time from Target','fontsize',12,'fontweight','bold')
            vline(TDT_trunc,'b')
            eval(['print -dpdf /volumes/Dump/Analyses/LFP_trunc_notrunc/' batch_list(i).name '.pdf'])
        end
        
        
        
        
        %keep track of all TDTs
        TDT_all.trunc(totalTDT,1) = TDT_trunc;
        TDT_all.notrunc(totalTDT,1) = TDT;
        
        
    end
end

save('/volumes/Dump/Analyses/LFP_trunc_notrunc/TDT.mat','TDT_all','-mat')