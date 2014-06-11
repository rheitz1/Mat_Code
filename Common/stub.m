% cd '/volumes/Dump/Search_Data/'
% batch_list = dir('*SEARCH.mat');
%
% for file = 1:length(batch_list)
%     Search_Errors_Uber_amplitude_correlations(batch_list(file).name)
% end


% cd /volumes/Dump/Search_Data_SAT//
% batch_list = dir('S*_SEARCH.mat');
% 
% % Question: How did you correct RTs?  For missed hold time trials, wouldn't this be a negative RT?
% 
% for sess = 1:length(batch_list)
%     
%     fi = batch_list(sess).name
%     
%     bload(fi);
%     
%     [x,y] = saccade_velocity_SAT(0);
%     
%     %note time axis is: -249:250
%     allX(sess,1:500) = nanmean(x);
%     allY(sess,1:500) = nanmean(y);
%     
%     keep batch_list sess fi allX allY
%     
%     
% end


%sub for various uses; iterates through all search files

% cd '/volumes/Dump/Search_Data_longBase/'
% 
% batch_list = dir('S*SEARCH.mat');
% 
% for sess = 1:length(batch_list)
%     %batch_list(sess).name
%     batch_list(sess).name
%     
%     n_bins = 10;
%     
%     load(batch_list(sess).name,'Correct_','Errors_','Target_','SRT')
% 
%     ss2 = find(Target_(:,5) == 2);
%     ss4 = find(Target_(:,5) == 4);
%     ss8 = find(Target_(:,5) == 8);
%     
%     [RT_bins.ss2(sess,1:n_bins) ACC_bins.ss2(sess,1:n_bins)] = CAF(SRT,n_bins,0,ss2);
%     [RT_bins.ss4(sess,1:n_bins) ACC_bins.ss4(sess,1:n_bins)] = CAF(SRT,n_bins,0,ss4);
%     [RT_bins.ss8(sess,1:n_bins) ACC_bins.ss8(sess,1:n_bins)] = CAF(SRT,n_bins,0,ss8);
%    
%     keep batch_list sess RT_bins ACC_bins
%     
% end
% 
% figure
% plot(nanmean(RT_bins.ss2),nanmean(ACC_bins.ss2),'r',nanmean(RT_bins.ss4),nanmean(ACC_bins.ss4),'k',nanmean(RT_bins.ss8),nanmean(ACC_bins.ss8),'b')
% legend('SS2','SS4','SS8')
% xlabel('RT Bin')
% ylabel('ACC rate')







% 
% 
% cd '/volumes/Dump/Search_Data_SAT_longBase/'
% 
% batch_list = dir('Q*SEARCH.mat');
% 
% for sess = 1:length(batch_list)
%     %batch_list(sess).name
%     batch_list(sess).name
%     
%     n_bins = 10;
%     
%     load(batch_list(sess).name,'Correct_','Errors_','Target_','SRT','SAT_')
% 
%     getTrials_SAT
%     
%     [RT_bins.slow(sess,1:n_bins) ACC_bins.slow(sess,1:n_bins)] = CAF(SRT,n_bins,0,slow_all);
%     [RT_bins.med(sess,1:n_bins) ACC_bins.med(sess,1:n_bins)] = CAF(SRT,n_bins,0,med_all);
%     [RT_bins.fast(sess,1:n_bins) ACC_bins.fast(sess,1:n_bins)] = CAF(SRT,n_bins,0,fast_all_withCleared);
%     
%    
%     keep batch_list sess RT_bins ACC_bins
%     
% end
% 
% figure
% plot(nanmean(RT_bins.slow),nanmean(ACC_bins.slow),'r', ...
% nanmean(RT_bins.med),nanmean(ACC_bins.med),'k',nanmean(RT_bins.fast),nanmean(ACC_bins.fast),'g')
% legend('Slow',' Med','Fast')
% xlabel('RT Bin')
% ylabel('ACC rate')
% 
% 




% cd '/volumes/Dump/Search_Data_longBase/'
% 
% batch_list = dir('S*SEARCH.mat');
% 
% for sess = 1:length(batch_list)
%     %batch_list(sess).name
%     batch_list(sess).name
%     
%        
%     load(batch_list(sess).name,'Correct_','Errors_','Target_','SRT','SAT_')
% % 
% %     getTrials_SAT
% %    
% %     RT.all(sess,1) = nanmean(SRT([slow_all ; fast_all_withCleared],1));
% %     RT.slow(sess,1) = nanmean(SRT(slow_all,1));
% %     RT.fast(sess,1) = nanmean(SRT(fast_all_withCleared,1));
% %     ACC.all(sess,1) = length([slow_correct_made_missed ; fast_correct_made_missed_withCleared]) / length([slow_all ; fast_all_withCleared]);
% %     ACC.slow(sess,1) = length(slow_correct_made_missed) / length(slow_all);
% %     ACC.fast(sess,1) = length(fast_correct_made_missed_withCleared) / length(fast_all_withCleared);
% %    
% 
%     crt = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255);
%     err = find(Correct_(:,2) == 0 & Target_(:,2) ~= 255);
%     RT(sess,1) = nanmean(SRT([crt ; err],1));
%     ACC(sess,1) = length(crt) / (length(crt) + length(err));
%     keep batch_list sess RT ACC
%     
% end
% 
% scatter(RT,ACC)



% cd '/volumes/Dump/Search_Data_longBase/'
% 
% batch_list = dir('Q*SEARCH.mat');
% 
% for sess = 1:length(batch_list)
%     %batch_list(sess).name
%     batch_list(sess).name
%     
%        
%     load(batch_list(sess).name,'Correct_','Errors_','Target_','SRT','SAT_')
% % 
% %     getTrials_SAT
% %    
% %     RT.all(sess,1) = nanmean(SRT([slow_all ; fast_all_withCleared],1));
% %     RT.slow(sess,1) = nanmean(SRT(slow_all,1));
% %     RT.fast(sess,1) = nanmean(SRT(fast_all_withCleared,1));
% %     ACC.all(sess,1) = length([slow_correct_made_missed ; fast_correct_made_missed_withCleared]) / length([slow_all ; fast_all_withCleared]);
% %     ACC.slow(sess,1) = length(slow_correct_made_missed) / length(slow_all);
% %     ACC.fast(sess,1) = length(fast_correct_made_missed_withCleared) / length(fast_all_withCleared);
% %    
% 
%     trls = find(Target_(:,2) ~= 255);
%     [RT_bins(sess,1:10) ACC_bins(sess,1:10)] = CAF(SRT(trls,1),Correct_(trls,2),10,0);
%     keep batch_list sess RT_bins ACC_bins
%     
% end






% 
% cd '/Search_Data_longBase/'
% 
% batch_list = dir('*SEARCH.mat');
% 
% totalCount = 1;
% for sess = 1:length(batch_list)
%     batch_list(sess).name
% 
%     load(batch_list(sess).name,'Target_','Correct_','SRT','newfile','RFs')
%     loadChan(batch_list(sess).name,'DSP')
%     varlist = who;
%     SPKlist = varlist(strmatch('DSP',varlist));
% 
%     for currSPK = 1:length(SPKlist)
%         sig = eval(SPKlist{currSPK});
%         RF = RFs.(SPKlist{currSPK});
%         
%         SDF = sSDF(sig,Target_(:,1),[-400 800]);
%         inTrls = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF));
%         outTrls = find(Correct_(:,2) == 1 & ismember(Target_(:,2),mod((RF+4),8)));
% 
%         ss2 = find(Target_(:,5) == 2);
%         ss4 = find(Target_(:,5) == 4);
%         ss8 = find(Target_(:,5) == 8);
%         
%         in.ss2 = intersect(inTrls,ss2);
%         in.ss4 = intersect(inTrls,ss4);
%         in.ss8 = intersect(inTrls,ss8);
%         out.ss2 = intersect(outTrls,ss2);
%         out.ss4 = intersect(outTrls,ss4);
%         out.ss8 = intersect(outTrls,ss8);
%         
%         wf_all.in.ss2(totalCount,:) = nanmean(SDF(in.ss2,:));
%         wf_all.in.ss4(totalCount,:) = nanmean(SDF(in.ss4,:));
%         wf_all.in.ss8(totalCount,:) = nanmean(SDF(in.ss8,:));
%         wf_all.out.ss2(totalCount,:) = nanmean(SDF(out.ss2,:));
%         wf_all.out.ss4(totalCount,:) = nanmean(SDF(out.ss4,:));
%         wf_all.out.ss8(totalCount,:) = nanmean(SDF(out.ss8,:));
%         
%         TDT.ss2(totalCount,1) = getTDT_SP(sig,in.ss2,out.ss2);
%         TDT.ss4(totalCount,1) = getTDT_SP(sig,in.ss4,out.ss4);
%         TDT.ss8(totalCount,1) = getTDT_SP(sig,in.ss8,out.ss8);
%         
%         totalCount = totalCount + 1;
%         
%         clear sig RF SDF in* out* ss*
%     end
%     keep batch_list sess totalCount list wf_all TDT
% 
% end
% 
% % 
% % cd '/Search_Data/'
% % 
% % batch_list = dir('S*SEARCH.mat');
% % 
% % totalCount = 1;
% % for sess = 1:length(batch_list)
% %     batch_list(sess).name
% % 
% %     load(batch_list(sess).name,'Target_','Correct_','SRT','newfile','RFs','MFs')
% %     loadChan(batch_list(sess).name,'DSP')
% %     varlist = who;
% %     SPKlist = varlist(strmatch('DSP',varlist));
% % 
% %     for currSPK = 1:length(SPKlist)
% %         sig = eval(SPKlist{currSPK});
% %         RF = RFs.(SPKlist{currSPK});
% %         
% %         if ~isempty(RF)
% %             plotSDF_SS(SPKlist{currSPK});
% %             pause
% %             f_
% %         else
% %             continue
% %         end
% %         
% %         totalCount = totalCount + 1;
% %         
% %         clear sig RF SDF in* out* ss*
% %     end
% %     keep batch_list sess totalCount list wf_all
% % 
% % end
% % 
% % 
% % 
% 


% 
% cd '/volumes/Dump/Search_Data_longBase/'
% 
% batch_list = dir('*.mat');
% 
% q = '''';
% c = ',';
% qcq = [q c q];
% 
% for sess = 1:length(batch_list)
%     batch_list(sess).name
% 
%     load(batch_list(sess).name,'Correct_','Errors_','Target_','EyeX_','EyeY_','newfile')
%    
%     [~,saccLoc] = getSRT(EyeX_,EyeY_);
%     
%     eval(['save(' q batch_list(sess).name qcq 'saccLoc' qcq '-append' q ');'])
%     keep batch_list sess q c qcq
% 
% end

% 
% cd '/Search_Data/'
% 
% batch_list = dir('S*SEARCH.mat');
% 
% totalCount = 1;
% for sess = 1:length(batch_list)
%     batch_list(sess).name
% 
%     load(batch_list(sess).name,'Target_','Correct_','SRT','newfile','RFs','MFs')
%     loadChan(batch_list(sess).name,'DSP')
%     varlist = who;
%     SPKlist = varlist(strmatch('DSP',varlist));
% 
%     for currSPK = 1:length(SPKlist)
%         sig = eval(SPKlist{currSPK});
%         RF = RFs.(SPKlist{currSPK});
%         
%         if ~isempty(RF)
%             plotSDF_SS(SPKlist{currSPK});
%             pause
%             f_
%         else
%             continue
%         end
%         
%         totalCount = totalCount + 1;
%         
%         clear sig RF SDF in* out* ss*
%     end
%     keep batch_list sess totalCount list wf_all
% 
% end
% 
% 
% 







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





cd '/volumes/Dump/Search_Data_longBase/'

batch_list = dir('Q*SEARCH.mat');

for sess = 1:length(batch_list)
    batch_list(sess).name

    load(batch_list(sess).name,'Target_','Correct_','SRT','EyeX_','EyeY_','newfile')
    
    [SRT saccLoc SRT_end] = getSRT(EyeX_,EyeY_);
    
    p0 = find(Correct_(:,2) == 0 & Target_(:,2) == 0);
    p1 = find(Correct_(:,2) == 0 & Target_(:,2) == 1);
    p2 = find(Correct_(:,2) == 0 & Target_(:,2) == 2);
    p3 = find(Correct_(:,2) == 0 & Target_(:,2) == 3);
    p4= find(Correct_(:,2) == 0 & Target_(:,2) == 4);
    p5= find(Correct_(:,2) == 0 & Target_(:,2) == 5);
    p6= find(Correct_(:,2) == 0 & Target_(:,2) == 6);
    p7= find(Correct_(:,2) == 0 & Target_(:,2) == 7);
    
    [stats.p0] = getVec(EyeX_,EyeY_,SRT,0,0,p0);
    [stats.p1] = getVec(EyeX_,EyeY_,SRT,0,0,p1);
    [stats.p2] = getVec(EyeX_,EyeY_,SRT,0,0,p2);
    [stats.p3] = getVec(EyeX_,EyeY_,SRT,0,0,p3);
    [stats.p4] = getVec(EyeX_,EyeY_,SRT,0,0,p4);
    [stats.p5] = getVec(EyeX_,EyeY_,SRT,0,0,p5);
    [stats.p6] = getVec(EyeX_,EyeY_,SRT,0,0,p6);
    [stats.p7] = getVec(EyeX_,EyeY_,SRT,0,0,p7);
    
    r(sess,1:8) = [stats.p0.r stats.p1.r stats.p2.r ...
        stats.p3.r stats.p4.r stats.p5.r ...
        stats.p6.r stats.p7.r];
    
    alpha(sess,1:8) = [stats.p0.mean stats.p1.mean stats.p2.mean ...
        stats.p3.mean stats.p4.mean stats.p5.mean ...
        stats.p6.mean stats.p7.mean];


    keep batch_list sess r alpha 

end