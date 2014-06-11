load('Q020611001-RH_SEARCH.mat','DSP12a','Errors_','Correct_','EyeX_','EyeY_','MFs','RFs','SAT_','SRT','Target_','Hemi','TrialStart_','newfile')


trials = plotSAT_summary('DSP12a');

f_


%%
time_index = -500:2500;
nTr = 10; %N for each sim
nSims = 100; %number of simulations
criterion = 6000;


diff_start = 200;

SDF = sSDF(DSP12a,Target_(:,1),[-500 2500]);


%model for slow made deadlines
%combine correct and errant responses
in = [trials.in.slow_correct_made_dead_RF ; trials.in.slow_errors_made_dead_RF];
out = [trials.out.slow_correct_made_dead_RF ; trials.out.slow_errors_made_dead_RF];


for run = 1:nSims
    cur_trls_in = randsample(in,nTr);
    cur_trls_out = randsample(out,nTr);
    
    cur_RTs_in = SRT(cur_trls_in,1);
    cur_RTs_out = SRT(cur_trls_out,1);
    
    Tinput = nanmean(SDF(cur_trls_in,:));
    Dinput = nanmean(SDF(cur_trls_out,:));
    
    Tinput(1:diff_start) = 0;
    Dinput(1:diff_start) = 0;
    
    
    for t = diff_start+1:length(Tinput)
        
        Tinput(t) = Tinput(t-1) + Tinput(t);
        Dinput(t) = Dinput(t-1) + Dinput(t);
        
    end
    
%     plot(-500:2500,Tinput,'r',-500:2500,Dinput,'--r')
%     pause
%     cla
     
    Tcross = find(Tinput > criterion,1,'first');
    Dcross = find(Dinput > criterion,1,'first');
    
    predRT(run) = min(Tcross,Dcross);
    
    if predRT(run) == Tcross
        predResp(run) = 1;
        pred_corr_RT(run) = predRT(run);
    elseif predRT(run) == Dcross
        predResp(run) = 0;
        pred_err_RT(run) = predRT(run);
    end
    
    clear Tinput Dinput
    
    
end

predACC = sum(predResp) / length(predResp);

obsRT_correct = SRT([trials.in.slow_correct_made_dead_RF ; trials.out.slow_correct_made_dead_RF],1);
obsRT_errors = SRT([trials.in.slow_errors_made_dead_RF ; trials.out.slow_errors_made_dead_RF],1);

hist_obs_cor = hist(obsRT_correct,-500:1000);
hist_obs_err = hist(obsRT_errors,-500:1000);

hist_pred_cor = hist(pred_corr_RT,-500:1000);
hist_pred_err = hist(pred_err_RT,-500:1000);
figure

plot(-500:1000,cumsum(hist_obs_cor),'or',-500:1000,cumsum(hist_pred_cor),'r')

%%