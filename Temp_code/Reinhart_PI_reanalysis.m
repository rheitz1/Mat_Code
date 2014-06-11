% cd '/volumes/Dump/Search_Data/'
% batch_list = dir('*SEARCH.mat');
%
% for file = 1:length(batch_list)
%     Search_Errors_Uber_amplitude_correlations(batch_list(file).name)
% end


cd /volumes/Dump/Search_Data/
batch_list = dir('Q*_MG.mat');

% Question: How did you correct RTs?  For missed hold time trials, wouldn't this be a negative RT?

for sess = 1:length(batch_list)
    
    fi = batch_list(sess).name
    
    
    load(fi,'SRT','Correct_','Target_','Errors_')
    
    cSRT = SRT;
    cCorrect_ = Correct_;
    
    cSRT(find(Correct_(:,2) == 0),1) = NaN;
    cCorrect_(find(Correct_(:,2) == 0),2) = NaN;
    cSRT(find(SRT(:,1) < Target_(:,10)),1) = NaN;
    cCorrect_(find(SRT(:,1) < Target_(:,10)),2) = NaN;

    
    Correct_(find(Errors_(:,2) == 1),2) = 1;
    
    if size(SRT,1) > 30
        cRT(sess,1:30) = cSRT(1:30,1) - Target_(1:30,10);
        RT(sess,1:30) = SRT(1:30,1) - Target_(1:30,10);
        Cor(sess,1:30) = Correct_(1:30,2);
    else
        disp('Skipping')
        RT(sess,1:30) = NaN;
        Cor(sess,1:30) = NaN;
    end
    
    
    clear SRT Correct_ Target_ Errors_
    
    
end

figure
bar(nanmean(Cor))
xlim([0 10])
ylim([.4 1])
xlabel('Absolute Trial #')
ylabel('% Correct')

newax
plot(nanmean(RT),'-or','linewidth',2)
hold on
plot(nanmean(cRT),'--or','linewidth',2)
xlim([0 10])
ylabel('RT')

%sub for various uses; iterates through all search files

% cd '/volumes/Dump/Search_Data_SAT/'
%
% batch_list = dir('Q*SEARCH.mat');
%
% for sess = 1:length(batch_list)
%     %batch_list(sess).name
%
%     load(batch_list(sess).name,'SAT_')
%
%     deadSlow(sess,1) = nanmean(SAT_(find(SAT_(:,1) == 1),3));
%     deadFast(sess,1) = nanmean(SAT_(find(SAT_(:,1) == 3),3));
%
%     clear SAT_
% end





% cd '/volumes/Dump/Search_Data_Corrected/'
%
% batch_list = dir('*SEARCH.mat');
%
% totalCount = 1;
% for sess = 1:length(batch_list)
%     batch_list(sess).name
%
%     load(batch_list(sess).name,'Target_','Correct_','SRT','newfile')
%     loadChan(batch_list(sess).name,'LFP')
%     varlist = who;
%     LFPlist = varlist(strmatch('AD',varlist));
%
%     for currLFP = 1:length(LFPlist)
%         sig = eval(LFPlist{currLFP});
%         [~,~,~,~,~,~,TDT] = LFPtuning(sig);
%         if ~isnan(TDT) & TDT <= 350
%             list{totalCount,1} = newfile;
%             list{totalCount,2} = LFPlist{currLFP};
%             totalCount = totalCount + 1;
%         end
%
%     end
%     keep batch_list sess totalCount list
%
% end





%=============================================

% [file_name s1 s2] = textread('LFPLFP_overlap_uStim.txt', '%s %s %s');
%
% q = '''';
% c = ',';
% qcq = [q c q];
%
% saveFlag = 1;
%
% totalLFP = 0;
% totalDSP = 0;
%
% for sess = 1:length(file_name)
%     cell2mat(file_name(sess))
%
%     load(cell2mat(file_name(sess)), ...
%         'Target_')
%     clear Target_
% end




% %================================================
% if saveFlag == 1
%     save(['/volumes/Dump2/Coherence/Uber/LFP-LFP/' file_name{sess} '_' ...
%         sig1_name{sess} sig2_name{sess} '.mat'],'coh','f','tout','Sx','Sy', ...
%         'Pcoh','PSx','PSy','wf','TDT','Sx_noz','Sy_noz', ...
%         'PSx_noz','PSy_noz','-mat')
% end
%
%
% eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_errors.jpg',q])