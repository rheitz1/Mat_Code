cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
% [filename1] = textread('SAT_Beh_NoMed_Q.txt','%s');
% [filename2] = textread('SAT_Beh_NoMed_S.txt','%s');
% [filename3] = textread('SAT_Beh_Med_Q.txt','%s');
% [filename4] = textread('SAT_Beh_Med_S.txt','%s');

[filename1] = textread('SAT2_Beh_NoMed_D.txt','%s');
[filename2] = textread('SAT2_Beh_NoMed_E.txt','%s');

filename = [filename1 ; filename2];

% [filename1] = textread('SAT2_Beh_NoMed_E.txt','%s');
% [filename2] = textread('SAT2_Beh_NoMed_D.txt','%s');
% 
% filename = [filename1 ; filename2];


include_med = 0;

for file = 1:length(filename)
    
    load(filename{file},'Target_','SRT','SAT_','Correct_','Errors_')
    filename{file}
    
            
    [RTs ACCs] = block_switch_RTs(0);

    
    slow_to_med(file,:) = nanmean(RTs.slow_to_med); %for sessions w/ neutral condition
    slow_to_fast(file,:) = nanmean(RTs.slow_to_fast); %for sessions w/o neutral condition
    med_to_fast(file,:) = nanmean(RTs.med_to_fast); %this is probably extraneous
    fast_to_slow(file,:) = nanmean(RTs.fast_to_slow); %will always be full; all sessions had this
    
    ACC.slow_to_fast(file,:) = nanmean(ACCs.slow_to_fast);
    ACC.fast_to_slow(file,:) = nanmean(ACCs.fast_to_slow);
    
%     if include_med
%        slow_to_med(file,:) = nanmean(RTs.slow_to_med);
%        med_to_fast(file,:) = nanmean(RTs.med_to_fast);
%        fast_to_slow(file,:) = nanmean(RTs.fast_to_slow);
%        
%     else
%     slow_to_fast(file,:) = nanmean(RTs.slow_to_fast);
%     fast_to_slow(file,:) = nanmean(RTs.fast_to_slow);
%     end
    
    keep filename file ACC slow_to_fast fast_to_slow slow_to_med med_to_fast include_med
end
    
    
figure
% 
% if include_med
%     sem.slow_to_med = sem(slow_to_med);
%     sem.med_to_fast = sem(med_to_fast);
%     sem.fast_to_slow = sem(fast_to_slow);
% else
%     sem.fast_to_slow = sem(fast_to_slow);
%     sem.slow_to_fast = sem(slow_to_fast)
% end

% plot(-2:2,nanmean(slow_to_fast),'g',-2:2,nanmean(slow_to_fast)-sem.slow_to_fast,'--g',-2:2,nanmean(slow_to_fast)+sem.slow_to_fast,'--g', ...
%     -2:2,nanmean(fast_to_slow),'r',-2:2,nanmean(fast_to_slow)-sem.fast_to_slow,'--r',-2:2,nanmean(fast_to_slow)+sem.fast_to_slow,'--r')

if include_med
    %designate slow_to_med as the same as slow_to_fast
    slow_to_fast(find(~isnan(slow_to_med(:,1))),:) = slow_to_med(find(~isnan(slow_to_med(:,1))),:);
end


plot(-2:2,slow_to_fast,'r',-2:2,fast_to_slow,'g')
hold on
plot(-2:2,nanmean(slow_to_fast),'k', ...
    -2:2,nanmean(fast_to_slow),'--k','linewidth',2)
ylim([200 1000])

