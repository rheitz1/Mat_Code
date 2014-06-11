%plots all tuning curves for LFPs and Spikes

%for LFP


%sub for various uses; iterates through all search files

%cd /volumes/Dump/Search_Data/
cd /Search_Data/

batch_list = dir('*SEARCH.mat');

keeper_index = 1;
for sess = 1:length(batch_list)
    batch_list(sess).name
    
    load(batch_list(sess).name,'Target_','SRT','Correct_','TrialStart_')
    
    
    if size(Target_,1) <= 500
        disp('too few trials...')
        continue
    end
    
    Bundle.SRT = SRT;
    Bundle.Correct_ = Correct_;
    Bundle.Target_ = Target_;
    Bundle.TrialStart_ = TrialStart_;
    
    
    %for LFPs
    ChanStruct = loadChan(batch_list(sess).name,'LFP')
    
    if isempty(ChanStruct)
        disp('no Channels')
        
    else
        
        LFPchans = fields(ChanStruct);
        decodeChanStruct
        clear ChanStruct
        
        for chan = 1:length(LFPchans)
            sig = eval(cell2mat(LFPchans(chan)));
            
            tuning = getTuning_AD(sig,Bundle,[0 400],[.05 10]);
            set(1,'position',[1000 1500 700 500])
            
            tuning = getTuning_AD(sig,Bundle,[0 400],[30 55]);
            set(2,'position',[1000 0 700 500])
            %standardize ylims
            subplot(2,2,4)
            %ylim([0 .1])
            
            
            
            keeper = input('Keep? ');
            
            if keeper == 1
                keeper_info{keeper_index,1} = [batch_list(sess).name '_' cell2mat(LFPchans(chan))];
                
                keeper_info{keeper_index,2} = input('RF: ');
                
                keeper_index = keeper_index + 1;
            end
            
            f_
        end
    end
    
    
% % %     %for Spikes
% % %     ChanStruct = loadChan(batch_list(sess).name,'DSP')
% % %     
% % %     if isempty(ChanStruct)
% % %         disp('no Channels')
% % %         
% % %     else
% % %         DSPchans = fields(ChanStruct);
% % %         decodeChanStruct
% % %         clear ChanStruct
% % %         
% % %         for chan = 1:length(DSPchans)
% % %             sig = eval(cell2mat(DSPchans(chan)));
% % %             
% % %             align(1:size(sig,1),1) = 500;
% % %             
% % %             tuning = getTuning_SP(sig,Bundle);
% % %             
% % %             keeper = input('Keep? ');
% % %             
% % %             if keeper == 1
% % %                 keeper_info{keeper_index,1} = [batch_list(sess).name '_' cell2mat(DSPchans(chan))];
% % %                 
% % %                 keeper_info{keeper_index,2} = input('RF: ');
% % %                 
% % %                 keeper_index = keeper_index + 1;
% % %             end
% % %             
% % %             f_
% % %         end
% % %     end
    
    keep sess batch_list keeper_index  keeper_info
end

keep keeper_info
