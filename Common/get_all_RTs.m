%sub for various uses; iterates through all search files

cd /volumes/Dump/Search_Data/
batch_list = dir('S*SEARCH.mat');

for sess = 1:length(batch_list)
    batch_list(sess).name
    
    load(batch_list(sess).name,'SRT','Target_','Correct_','Errors_')
    
    fixErrors
    
    %only use if >= 500 trials
%             if size(Target_,1) < 500
%                 disp('Too few trials...skipping')
%                 continue
%             end
    
    %only use if NO CATCH TRIALS PRESENT IN TASK
    %     if length(find(Target_(:,2) == 255)) > 10
    %         disp('catch trials...')
    %         continue
    %     end
    
    correct.all = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    errors.all = find(Errors_(:,5) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50);
        
    correct_ss2 = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    correct_ss4 = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    correct_ss8 = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    errors_ss2 = find(Errors_(:,5) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    errors_ss4 = find(Errors_(:,5) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    errors_ss8 = find(Errors_(:,5) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    total.all = find(Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    total_ss2 = find(Target_(:,2) ~= 255 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    total_ss4 = find(Target_(:,2) ~= 255 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    total_ss8 = find(Target_(:,2) ~= 255 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
   
    RT.correct.all(sess,1) = nanmean(SRT(correct.all,1));
    RT.correct.ss2(sess,1) = nanmean(SRT(correct_ss2,1));
    RT.correct.ss4(sess,1) = nanmean(SRT(correct_ss4,1));
    RT.correct.ss8(sess,1) = nanmean(SRT(correct_ss8,1));
    
        
    RT.errors.all(sess,1) = nanmean(SRT(errors.all,1));
    RT.errors.ss2(sess,1) = nanmean(SRT(errors_ss2,1));
    RT.errors.ss4(sess,1) = nanmean(SRT(errors_ss4,1));
    RT.errors.ss8(sess,1) = nanmean(SRT(errors_ss8,1));
    
 
    ACC.overall(sess,1) = length(correct.all) / length(total.all);
    ACC.ss2(sess,1) = length(correct_ss2) / length(total_ss2);
    ACC.ss4(sess,1) = length(correct_ss4) / length(total_ss4);
    ACC.ss8(sess,1) = length(correct_ss8) / length(total_ss8);
    
  
    
    %catch trials
    
    allcatch = find(Target_(:,2) == 255);
    catch_noresp = find(Correct_(:,2) == 1 & Target_(:,2) == 255 & isnan(SRT(:,1)));
    catch_errors_in = find(Correct_(:,2) == 0 & Target_(:,2) == 255 & ~isnan(SRT(:,1)));
    catch_correct_in = find(Correct_(:,2) == 1 & Target_(:,2) == 255 & ~isnan(SRT(:,1)));
    
    
    if length(allcatch > 10)
        ACC.percent_noresp(sess,1) = length(catch_noresp) / length(allcatch);
        ACC.percent_errors_in(sess,1) = length(catch_errors_in) / length(allcatch);
        ACC.percent_correct_in(sess,1) = length(catch_correct_in) / length(allcatch);
    else
        
        ACC.percent_noresp(sess,1) = NaN;
        ACC.percent_errors_in(sess,1) = NaN;
        ACC.percent_correct_in(sess,1) = NaN;
    end
    
    if length(catch_errors_in) > 10
        RT.catch_errors_in(sess,1) = nanmean(SRT(catch_errors_in,1));
    else
        RT.catch_errors_in(sess,1) = NaN;
    end
    
    if length(catch_correct_in) > 10
        RT.catch_correct_in(sess,1) = nanmean(SRT(catch_correct_in,1));
    else
        RT.catch_correct_in(sess,1) = NaN;
    end
    
    
%     
%     
%     %probabilities
%     %p(error)
%     p.errors(sess,1) = length(find(Errors_(:,5) == 1)) / size(Correct_,1);
%     %p(corr)
%     p.correct(sess,1) = length(find(Correct_(:,2) == 1)) / size(Correct_,1);
%     
%     % p(error | correct on trial n-1 )  = p(errors & correct) / p(correct)
%     %and
%     % p(errors | error on trial n-1)
%     
%     p.EgivenC(sess,1) = (length(c_e) / size(Correct_,1)) / p.correct(sess,1);
%     p.EgivenE(sess,1) = (length(e_e) / size(Correct_,1)) / p.errors(sess,1);
%     
%     p.EandC(sess,1) = length(c_e) / size(Correct_,1);
%     p.EandE(sess,1) = length(e_e) / size(Correct_,1);
%     
%     
%     %p(error on trial n-1) * p(correct on trial n)
%     
%     %     proberr_n_minus_one = (length(e_c) + length(e_e)) / size(Correct_,1);
%     %     probcorr_n_minus_one = (length(c_e) + length(c_c)) / size(Correct_,1);
%     %     proberr_n = (length(c_e) + length(e_e)) / size(Correct_,1);
%     %
%     %
%     %     p.pEpC(sess,1) = proberr_n * probcorr_n_minus_one;
%     %     p.pEpE(sess,1) = proberr_n * proberr_n_minus_one;
%     %
%     
%     
%     
%     %binomial probabilities over time
%     
%     p.binomial(sess,1:100) = NaN;
%     %only do if >= 500 trials
%     if size(Correct_,1) >= 500
%         
%         
%         %preallocate
%         
%         
%         window = 100;
%         baseProbErr = length(find(Errors_(:,5) == 1)) / size(Correct_,1);
%         s = 1;
%         
%         for seq = 1:window:size(Errors_,1)-window
%             sequence = Errors_(seq:seq+window-1,5);
%             numErr = length(find(sequence == 1));
%             
%             prob(s) = 1 - binocdf(numErr,window,baseProbErr);
%             clear sequence
%             s = s + 1;
%         end
%         
%         p.binomial(sess,1:length(prob)) = prob;
%     end
%     % figure
%     % plot(1:window:size(Errors_,1)-window,prob)
    
    
   % keep p RT ACC sess batch_list
    keep RT ACC sess batch_list
end


RT.correct.all(find(RT.correct.all == 0)) = [];
RT.correct.ss2(find(RT.correct.ss2 == 0)) = [];
RT.correct.ss4(find(RT.correct.ss4 == 0)) = [];
RT.correct.ss8(find(RT.correct.ss8 == 0)) = [];

RT.errors.all(find(RT.errors.all == 0)) = [];
RT.errors.ss2(find(RT.errors.ss2 == 0)) = [];
RT.errors.ss4(find(RT.errors.ss4 == 0)) = [];
RT.errors.ss8(find(RT.errors.ss8 == 0)) = [];


nbins = 50;
%Plotting
[bins.correct.all cdf.correct.all] = getCDF(RT.correct.all,nbins);
[bins.correct.ss2 cdf.correct.ss2] = getCDF(RT.correct.ss2,nbins);
[bins.correct.ss4 cdf.correct.ss4] = getCDF(RT.correct.ss4,nbins);
[bins.correct.ss8 cdf.correct.ss8] = getCDF(RT.correct.ss8,nbins);

[bins.errors.all cdf.errors.all] = getCDF(RT.errors.all,nbins);
[bins.errors.ss2 cdf.errors.ss2] = getCDF(RT.errors.ss2,nbins);
[bins.errors.ss4 cdf.errors.ss4] = getCDF(RT.errors.ss4,nbins);
[bins.errors.ss8 cdf.errors.ss8] = getCDF(RT.errors.ss8,nbins);


[bins.catch_errors_in cdf.catch_errors_in] = getCDF(RT.catch_errors_in,nbins);
[bins.catch_correct_in cdf.catch_correct_in] = getCDF(RT.catch_correct_in,nbins);


figure
set(gcf,'color','white')

subplot(2,2,1)
plot(bins.correct.all,cdf.correct.all,'k',bins.errors.all,cdf.errors.all,'--k')
legend('Correct','Errors')

subplot(2,2,2)
plot(bins.correct.ss2,cdf.correct.ss2,'b',bins.correct.ss4,cdf.correct.ss4,'r', ...
    bins.correct.ss8,cdf.correct.ss8,'g',bins.errors.ss2,cdf.errors.ss2,'--b', ...
    bins.errors.ss4,cdf.errors.ss4,'--r',bins.errors.ss8,cdf.errors.ss8,'--g')


%calculate SEMs for ACC rates
sem.acc.overall = nanstd(ACC.overall) / sqrt(length(ACC.overall));
sem.acc.ss2 = nanstd(ACC.ss2) / sqrt(length(ACC.ss2));
sem.acc.ss4 = nanstd(ACC.ss4) / sqrt(length(ACC.ss4));
sem.acc.ss8 = nanstd(ACC.ss8) / sqrt(length(ACC.ss8));

sem.rt.correct.overall = nanstd(RT.correct.all) / sqrt(length(RT.correct.all));
sem.rt.correct.ss2 = nanstd(RT.correct.ss2) / sqrt(length(RT.correct.ss2));
sem.rt.correct.ss4 = nanstd(RT.correct.ss4) / sqrt(length(RT.correct.ss4));
sem.rt.correct.ss8 = nanstd(RT.correct.ss8) / sqrt(length(RT.correct.ss8));

sem.rt.errors.overall = nanstd(RT.errors.all) / sqrt(length(RT.errors.all));
sem.rt.errors.ss2 = nanstd(RT.errors.ss2) / sqrt(length(RT.errors.ss2));
sem.rt.errors.ss4 = nanstd(RT.errors.ss4) / sqrt(length(RT.errors.ss4));
sem.rt.errors.ss8 = nanstd(RT.errors.ss8) / sqrt(length(RT.errors.ss8));

subplot(2,2,3)
bar(1:4,[nanmean(ACC.overall) nanmean(ACC.ss2) nanmean(ACC.ss4) nanmean(ACC.ss8)])
hold
errorbar(1:4,[nanmean(ACC.overall) nanmean(ACC.ss2) nanmean(ACC.ss4) nanmean(ACC.ss8)], ...
    [sem.acc.overall sem.acc.ss2 sem.acc.ss4 sem.acc.ss8],'r')

subplot(2,2,4)
bar([nanmean(RT.correct.all) nanmean(RT.correct.ss2) nanmean(RT.correct.ss4) nanmean(RT.correct.ss8) ; ...
    nanmean(RT.errors.all) nanmean(RT.errors.ss2) nanmean(RT.errors.ss4) nanmean(RT.errors.ss8)])
