% This draws the trajectories for the iLBA model with specified parameters
% 12/16/11
% RPH
c_



minimize = 1;
plotFlag = 1;
include_med = 1;
truncate_IQR = 1;
truncval = 1.5;
truncSim = 1;


%Bounds based on MEDIAN of MEDIAN RT +/- 1.5*IQR across sessions individually
simBound.slow = [430.25 776.5];
simBound.med = [153.88 412];
simBound.fast = [184 328.25];


A.slow = 149.7801;
A.med = 290.4910;
A.fast = 328.6359;

b = 254.0614;

b = b * 100;

v.slow = 0.7351;
v.med = 0.8294;
v.fast = 0.9172;

T0.slow = 273.1744;
T0.med = 99.3368;
T0.fast = 112.2567;

leakage = 0.0087;

%%% user leakage = 0.24 to graphically show more effect of leakage/decay
%leakage = .024

sd_rate = 0.27;

seed = 13;

nTrials = 250;


rand('seed',seed);
randn('seed',seed);
normrnd('seed',seed);


correct.slow(1:nTrials,1) = NaN;
correct.fast(1:nTrials,1) = NaN;

rt.slow(1:nTrials,1) = NaN;
rt.fast(1:nTrials,1) = NaN;

if include_med
    rt.med(1:nTrials,1) = NaN;
    correct.med(1:nTrials,1) = NaN;
end


    start1.slow = unifrnd(0,A.slow,nTrials,1);
    start1.med = unifrnd(0,A.med,nTrials,1);
    start1.fast = unifrnd(0,A.fast,nTrials,1);
    
    start2.slow = unifrnd(0,A.slow,nTrials,1);
    start2.med = unifrnd(0,A.med,nTrials,1);
    start2.fast = unifrnd(0,A.fast,nTrials,1);
    
    %use absolute value just in case negative drift rate is selected
    rate1.slow = abs(normrnd(v.slow,sd_rate,nTrials,1));
    rate1.med = abs(normrnd(v.med,sd_rate,nTrials,1));
    rate1.fast = abs(normrnd(v.fast,sd_rate,nTrials,1));
    
    rate1.slow(find(rate1.slow > 1)) = .9999;
    rate1.med(find(rate1.med > 1)) = .9999;
    rate1.fast(find(rate1.fast > 1)) = .9999;
    
    rate2.slow = abs(normrnd(1-v.slow,sd_rate,nTrials,1));
    rate2.med = abs(normrnd(1-v.med,sd_rate,nTrials,1));
    rate2.fast = abs(normrnd(1-v.fast,sd_rate,nTrials,1));
    
    
    
    
    
%% ACCURACY CONDITION

warning('off')
ballistic1 = NaN(nTrials,2001);
ballistic2 = NaN(nTrials,2001);
for n = 1:nTrials
    %n

    %generate starting point
    act1(n,1) = start1.slow(n,1);
    act2(n,1) = start2.slow(n,1);
    
    
    %create linear function
    ballistic1(n,:) = start1.slow(n,1):rate1.slow(n,1):start1.slow(n,1)+2000*rate1.slow(n,1);
    ballistic2(n,:) = start2.slow(n,1):rate2.slow(n,1):start2.slow(n,1)+2000*rate2.slow(n,1);
    %     if numel(ballistic2) == 0; disp(mat2str([rate1 rate2])); end
    
    for t = 2:1000
        act1(n,t) = act1(n,t-1) + ballistic1(n,t) - ( leakage * act1(n,t-1));
        act2(n,t) = act2(n,t-1) + ballistic2(n,t) - ( leakage * act2(n,t-1));
        
        
        if act1(n,t) > b | act2(n,t) > b
            rts(n,1) = t;
            if act1(n,t) > b
                cor(n,1) = 1;
            elseif act2(n,t) > b
                cor(n,1) = 0;
            else
                if act1(n,t) == act2(n,t)
                    if rand <= .5
                        cor(n,1) = 1;
                    else
                        cor(n,1) = 0;
                    end
                end
            end
            
            %         all_act1(n,1:length(act1)) = act1;
            %         all_act2(n,1:length(act2)) = act2;
            %        disp('hi')
            
            break
        else
            rts(n,1) = NaN;
            cor(n,1) = NaN;
        end
    end
    %     plot(act1,'k')
    %     hold on
    %     plot(act2,'r')
    %     pause
    %     cla
    
    
    %     if plot_trial_activity
    %         figure(f2)
    %         subplot(2,1,1)
    %         plot(ballistic1,'k')
    %         hold on
    %         plot(ballistic2,'r')
    %
    %         subplot(2,1,2)
    %         plot(act1,'k')
    %         hold on
    %         plot(act2,'r')
    %         pause
    %         cla
    %         subplot(2,1,1)
    %         cla
    %
    %     end
end

correct.slow = cor;
rt.slow = rts;

if truncSim
    disp(['Removing ' mat2str(length(find(rt.slow+T0.slow < simBound.slow(1)))) ' SLOW trials']);
    disp(['Removing ' mat2str(length(find(rt.slow+T0.slow > simBound.slow(2)))) ' SLOW trials']);
    correct.slow(find(rt.slow+T0.slow < simBound.slow(1))) = NaN;
    correct.slow(find(rt.slow+T0.slow > simBound.slow(2))) = NaN;
    rt.slow(find(rt.slow+T0.slow < simBound.slow(1))) = NaN;
    rt.slow(find(rt.slow+T0.slow > simBound.slow(2))) = NaN;
end
    
    
    
accumulators.slow.correct = act1;
accumulators.slow.errors = act2;

ballistic.slow.correct = ballistic1;
ballistic.slow.errors = ballistic2;
clear act1 act2 cor rts ballistic1 ballistic2




act1 = NaN(nTrials,1000);
act2 = act1;
ballistic1 = NaN(nTrials,2001);
ballistic2 = NaN(nTrials,2001);
for n = 1:nTrials
    %n
    
    
    
    %generate starting point
    act1(n,1) = start1.fast(n,1);
    act2(n,1) = start2.fast(n,1);
    
    
    %create linear function
    ballistic1(n,:) = start1.fast(n,1):rate1.fast(n,1):start1.fast(n,1)+2000*rate1.fast(n,1);
    ballistic2(n,:) = start2.fast(n,1):rate2.fast(n,1):start2.fast(n,1)+2000*rate2.fast(n,1);
    %     if numel(ballistic2) == 0; disp(mat2str([rate1 rate2])); end
    
    for t = 2:1000
        %PERFECT INTEGRATION
        %act1(t) = act1(t-1) + rate1 ;
        %act2(t) = act2(t-1) + rate2 ;
        
        %WITH LEAK
        %         act1(t) = act1(t-1) + rate1 - ( (1/leakage) * act1(t-1));
        %         act2(t) = act2(t-1) + rate2 - ( (1/leakage) * act2(t-1));
        
        act1(n,t) = act1(n,t-1) + ballistic1(n,t) - ( leakage * act1(n,t-1));
        act2(n,t) = act2(n,t-1) + ballistic2(n,t) - ( leakage * act2(n,t-1));
        
        %WITH LEAK AND GAIN
        %act1(t) = act1(t-1) + rate1 + (act1(t-1) * gain.slow) - (leakage * act1(t-1));
        %act2(t) = act2(t-1) + rate2 + (act2(t-1) * gain.slow) - (leakage * act2(t-1));
        
        if act1(n,t) > b | act2(n,t) > b
            rts(n,1) = t;
            if act1(n,t) > b
                cor(n,1) = 1;
            elseif act2(n,t) > b
                cor(n,1) = 0;
            else
                if act1(n,t) == act2(n,t)
                    if rand <= .5
                        cor(n,1) = 1;
                    else
                        cor(n,1) = 0;
                    end
                end
            end
            
            %         all_act1(n,1:length(act1)) = act1;
            %         all_act2(n,1:length(act2)) = act2;
            %        disp('hi')
            
            break
        end
    end
    
    %         all_act1(n,1:length(act1)) = act1;
    %         all_act2(n,1:length(act2)) = act2;
    %        disp('hi')
end

correct.fast = cor;
rt.fast = rts;

if truncSim
    disp(['Removing ' mat2str(length(find(rt.fast+T0.fast < simBound.fast(1)))) ' FAST trials']);
    disp(['Removing ' mat2str(length(find(rt.fast+T0.fast > simBound.fast(2)))) ' FAST trials']);
    correct.fast(find(rt.fast+T0.fast < simBound.fast(1))) = NaN;
    correct.fast(find(rt.fast+T0.fast > simBound.fast(2))) = NaN;
    rt.fast(find(rt.fast+T0.fast < simBound.fast(1))) = NaN;
    rt.fast(find(rt.fast+T0.fast > simBound.fast(2))) = NaN;
end



accumulators.fast.correct = act1;
accumulators.fast.errors = act2;
ballistic.fast.correct = ballistic1;
ballistic.fast.errors = ballistic2;
clear act1 act2 cor rts ballistic1 ballistic2




act1 = NaN(nTrials,1000);
act2 = act1;
ballistic1 = NaN(nTrials,2001);
ballistic2 = NaN(nTrials,2001);
for n = 1:nTrials
    %n
    
    %generate starting point
    act1(n,1) = start1.med(n,1);
    act2(n,1) = start2.med(n,1);
    
    
    %create linear function
    ballistic1(n,:) = start1.med(n,1):rate1.med(n,1):start1.med(n,1)+2000*rate1.med(n,1);
    ballistic2(n,:) = start2.med(n,1):rate2.med(n,1):start2.med(n,1)+2000*rate2.med(n,1);
    %     if numel(ballistic2) == 0; disp(mat2str([rate1 rate2])); end
    
    for t = 2:1000
        %PERFECT INTEGRATION
        %act1(t) = act1(t-1) + rate1 ;
        %act2(t) = act2(t-1) + rate2 ;
        
        %WITH LEAK
        %         act1(t) = act1(t-1) + rate1 - ( (1/leakage) * act1(t-1));
        %         act2(t) = act2(t-1) + rate2 - ( (1/leakage) * act2(t-1));
        
        
        act1(n,t) = act1(n,t-1) + ballistic1(n,t) - ( leakage * act1(n,t-1));
        act2(n,t) = act2(n,t-1) + ballistic2(n,t) - ( leakage * act2(n,t-1));
        
        %WITH LEAK AND GAIN
        %act1(t) = act1(t-1) + rate1 + (act1(t-1) * gain.slow) - (leakage * act1(t-1));
        %act2(t) = act2(t-1) + rate2 + (act2(t-1) * gain.slow) - (leakage * act2(t-1));
        
        
        if act1(n,t) > b | act2(n,t) > b
            rts(n,1) = t;
            if act1(n,t) > b
                cor(n,1) = 1;
            elseif act2(n,t) > b
                cor(n,1) = 0;
            else
                if act1(n,t) == act2(n,t)
                    if rand <= .5
                        cor(n,1) = 1;
                    else
                        cor(n,1) = 0;
                    end
                end
            end
            
            %         all_act1(n,1:length(act1)) = act1;
            %         all_act2(n,1:length(act2)) = act2;
            %        disp('hi')
            
            break
        end
    end
end

correct.med = cor;
rt.med = rts;

if truncSim
    disp(['Removing ' mat2str(length(find(rt.med+T0.med < simBound.med(1)))) ' NEUTRAL trials']);
    disp(['Removing ' mat2str(length(find(rt.med+T0.med > simBound.med(2)))) ' NEUTRAL trials']);
    correct.med(find(rt.fast+T0.fast < simBound.med(1))) = NaN;
    correct.med(find(rt.fast+T0.fast > simBound.med(2))) = NaN;
    rt.med(find(rt.med+T0.med < simBound.med(1))) = NaN;
    rt.med(find(rt.med+T0.med > simBound.med(2))) = NaN;
end


accumulators.med.correct = act1;
accumulators.med.errors = act2;
ballistic.med.correct = ballistic1;
ballistic.med.errors = ballistic2;
clear act1 act2 cor rts ballistic1 ballistic2


rt.slow = rt.slow + T0.slow;
rt.med = rt.med + T0.med;
rt.fast = rt.fast + T0.fast;


%set all 0's to NaN
accumulators.slow.correct(find(accumulators.slow.correct == 0)) = NaN;
accumulators.slow.errors(find(accumulators.slow.errors == 0)) = NaN;
accumulators.fast.correct(find(accumulators.fast.correct == 0)) = NaN;
accumulators.fast.errors(find(accumulators.fast.errors == 0)) = NaN;
accumulators.med.correct(find(accumulators.med.correct == 0)) = NaN;
accumulators.med.errors(find(accumulators.med.errors == 0)) = NaN;

resp_accumulators.slow.correct(1:size(accumulators.slow.correct,1),1:2001) = NaN;
resp_accumulators.slow.errors(1:size(accumulators.slow.errors,1),1:2001) = NaN;
resp_accumulators.fast.correct(1:size(accumulators.fast.correct,1),1:2001) = NaN;
resp_accumulators.fast.errors(1:size(accumulators.fast.errors,1),1:2001) = NaN;
resp_accumulators.med.correct(1:size(accumulators.med.correct,1),1:2001) = NaN;
resp_accumulators.med.errors(1:size(accumulators.med.errors,1),1:2001) = NaN;
%RESPONSE ALIGN
for trl = 1:size(accumulators.slow.correct,1)
    endt = find(~isnan(accumulators.slow.correct(trl,:)),1,'last');
    resp_accumulators.slow.correct(trl,2000-endt+1:2000) = accumulators.slow.correct(trl,1:endt);
    %ballistic_resp.slow.correct(trl,2000-endt+1:2000) = ballistic.slow.correct(trl,1:endt);
    
    endt = find(~isnan(accumulators.slow.errors(trl,:)),1,'last');
    resp_accumulators.slow.errors(trl,2000-endt+1:2000) = accumulators.slow.errors(trl,1:endt);
    %ballistic_resp.slow.errors(trl,2000-endt+1:2000) = ballistic.slow.errors(trl,1:endt);
    
    endt = find(~isnan(accumulators.fast.correct(trl,:)),1,'last');
    resp_accumulators.fast.correct(trl,2000-endt+1:2000) = accumulators.fast.correct(trl,1:endt);
    %ballistic_resp.fast.correct(trl,2000-endt+1:2000) = ballistic.fast.correct(trl,1:endt);
    
    endt = find(~isnan(accumulators.fast.errors(trl,:)),1,'last');
    resp_accumulators.fast.errors(trl,2000-endt+1:2000) = accumulators.fast.errors(trl,1:endt);
    %ballistic_resp.fast.errors(trl,2000-endt+1:2000) = ballistic.fast.errors(trl,1:endt);
    
    endt = find(~isnan(accumulators.med.correct(trl,:)),1,'last');
    resp_accumulators.med.correct(trl,2000-endt+1:2000) = accumulators.med.correct(trl,1:endt);
    %ballistic_resp.med.correct(trl,2000-endt+1:2000) = ballistic.med.correct(trl,1:endt);
    
    endt = find(~isnan(accumulators.med.errors(trl,:)),1,'last');
    resp_accumulators.med.errors(trl,2000-endt+1:2000) = accumulators.med.errors(trl,1:endt);
    %ballistic_resp.med.errors(trl,2000-endt+1:2000) = ballistic.med.errors(trl,1:endt);
end

fig1
hold on
plot(nanmean(ballistic.slow.correct(find(correct.slow),:))','r')
plot(nanmean(ballistic.med.correct(find(correct.med),:))','k')
plot(nanmean(ballistic.fast.correct(find(correct.fast),:))','g')
title('Linear Ballistic')

vline(nanmedian(rt.slow(find(correct.slow))-T0.slow),'r')
vline(nanmedian(rt.med(find(correct.med))-T0.med),'k')
vline(nanmedian(rt.fast(find(correct.fast))-T0.fast),'g')
xlim([0 500])
ylim([0 600])

fig2
plot(-2000:0,nanmean(resp_accumulators.slow.correct(find(correct.slow),:)),'r',-2000:0,nanmean(resp_accumulators.med.correct(find(correct.med),:)),'k', ...
    -2000:0,nanmean(resp_accumulators.fast.correct(find(correct.fast),:)),'g')
xlim([-2000 0])
title('Response Aligned accumulators')

fig3
hold on
plot(accumulators.slow.correct(find(correct.slow(1:200)),:)','r')
plot(accumulators.med.correct(find(correct.med(1:200)),:)','k')
plot(accumulators.fast.correct(find(correct.fast(1:200)),:)','g')
title('Accumulators')

fig4
plot(nanmean(accumulators.slow.correct(find(correct.slow),:)),'r')
hold on
plot(nanmean(accumulators.med.correct(find(correct.med),:)),'k')
plot(nanmean(accumulators.fast.correct(find(correct.fast),:)),'g')
% plot(nanmean(accumulators.slow.errors),'--r')
% plot(nanmean(accumulators.med.errors),'--k')
% plot(nanmean(accumulators.fast.errors),'--g')
title('Mean accumulator trajectories')




fig2
c.slow = histc(rt.slow(find(correct.slow==1)),[0:50:1000]);
c.fast = histc(rt.fast(find(correct.fast==1)),[0:20:500]);
hold on
bar(0:50:1000,c.slow./sum(c.slow),'barwidth',1);
bar(0:20:500,c.fast./sum(c.fast),'barwidth',1);