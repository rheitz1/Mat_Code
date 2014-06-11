% This draws the trajectories for the basic LBA model with specified parameters
% 12/16/11
% RPH
c_

rand('seed',5150);
randn('seed',5150);
normrnd('seed',5150);

minimize = 1;
plotFlag = 1;
include_med = 1;
truncate_IQR = 1;
truncval = 1.5;



% A.slow = 181.396;
% A.med = 100;
% %A.fast = 86.629;
% A.fast = 350.396;
% 
% b = 203.13;
% %b = 9948.081;
% b = b * 100;
% 
% v.slow = .696;
% v.med = .5;
% v.fast = .85;
% 
% T0.slow = 285.169;
% %T0.med = 4.745;
% T0.med = 50;
% T0.fast = 100.169;
% 
% leakage = .013;
A.slow = 64.7;
A.med = 64.7;
%A.fast = 86.629;
A.fast = 64.7;

b.slow = 320.6;
b.med = 121.3;
b.fast = 105.8;
%b = 9948.081;
%b = b * 100;

v.slow = .57;
v.med = .57;
v.fast = .57;

T0.slow = 285.169;
%T0.med = 4.745;
T0.med = 50;
T0.fast = 100.169;

leakage = .013;


sd_rate = .10;

nTrials = 500;

% act1 = NaN(nTrials,1000);
% act2 = act1;

correct.slow(1:nTrials,1) = NaN;
correct.fast(1:nTrials,1) = NaN;

rt.slow(1:nTrials,1) = NaN;
rt.fast(1:nTrials,1) = NaN;

if include_med
    rt.med(1:nTrials,1) = NaN;
    correct.med(1:nTrials,1) = NaN;
end

%% ACCURACY CONDITION

warning('off')
ballistic1 = NaN(nTrials,2001);
ballistic2 = NaN(nTrials,2001);
for n = 1:nTrials
    n
    start1 = unifrnd(0,A.slow);
    start2 = unifrnd(0,A.slow);
    
    %use absolute value just in case negative drift rate is selected
    rate1 = abs(normrnd(v.slow,sd_rate));
    if rate1 > 1; rate1 = .9999; end
    
    rate2 = abs(normrnd(1-v.slow,sd_rate));
    
    
    %generate starting point
    act1(n,1) = start1;
    act2(n,1) = start2;
    
    
    %create linear function
    ballistic1(n,:) = start1:rate1:start1+2000*rate1;
    ballistic2(n,:) = start2:rate2:start2+2000*rate2;
    %     if numel(ballistic2) == 0; disp(mat2str([rate1 rate2])); end
    
    for t = 2:1500
        
        %PERFECT INTEGRATION
        act1(n,t) = act1(n,t-1) + rate1 ;
        act2(n,t) = act2(n,t-1) + rate2 ;
        
        %WITH LEAK
        %         act1(t) = act1(t-1) + rate1 - ( (1/leakage) * act1(t-1));
        %         act2(t) = act2(t-1) + rate2 - ( (1/leakage) * act2(t-1));
        
        %act1(n,t) = act1(n,t-1) + ballistic1(n,t) - ( leakage * act1(n,t-1));
        %act2(n,t) = act2(n,t-1) + ballistic2(n,t) - ( leakage * act2(n,t-1));
        
        
        %WITH LEAK AND GAIN
        %act1(t) = act1(t-1) + rate1 + (act1(t-1) * gain.slow) - (leakage * act1(t-1));
        %act2(t) = act2(t-1) + rate2 + (act2(t-1) * gain.slow) - (leakage * act2(t-1));
        
        
        
        if act1(n,t) > b.slow | act2(n,t) > b.slow
            rts(n,1) = t;
            if act1(n,t) > b.slow
                cor(n,1) = 1;
            elseif act2(n,t) > b.slow
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
    n
    start1 = unifrnd(0,A.fast);
    start2 = unifrnd(0,A.fast);
    
    %use absolute value just in case negative drift rate is selected
    rate1 = abs(normrnd(v.fast,sd_rate));
    if rate1 > 1; rate1 = .9999; end
    
    rate2 = abs(normrnd(1-v.fast,sd_rate));
    
    
    %generate starting point
    act1(n,1) = start1;
    act2(n,1) = start2;
    
    
    %create linear function
    ballistic1(n,:) = start1:rate1:start1+2000*rate1;
    ballistic2(n,:) = start2:rate2:start2+2000*rate2;
    %     if numel(ballistic2) == 0; disp(mat2str([rate1 rate2])); end
    
    for t = 2:1500
        %PERFECT INTEGRATION
        act1(n,t) = act1(n,t-1) + rate1 ;
        act2(n,t) = act2(n,t-1) + rate2 ;
        
        %WITH LEAK
        %         act1(t) = act1(t-1) + rate1 - ( (1/leakage) * act1(t-1));
        %         act2(t) = act2(t-1) + rate2 - ( (1/leakage) * act2(t-1));
        
        %act1(n,t) = act1(n,t-1) + ballistic1(n,t) - ( leakage * act1(n,t-1));
        %act2(n,t) = act2(n,t-1) + ballistic2(n,t) - ( leakage * act2(n,t-1));
        
        %WITH LEAK AND GAIN
        %act1(t) = act1(t-1) + rate1 + (act1(t-1) * gain.slow) - (leakage * act1(t-1));
        %act2(t) = act2(t-1) + rate2 + (act2(t-1) * gain.slow) - (leakage * act2(t-1));
        
        if act1(n,t) > b.fast | act2(n,t) > b.fast
            rts(n,1) = t;
            if act1(n,t) > b.fast
                cor(n,1) = 1;
            elseif act2(n,t) > b.fast
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
    n
    start1 = unifrnd(0,A.med);
    start2 = unifrnd(0,A.med);
    
    %use absolute value just in case negative drift rate is selected
    rate1 = abs(normrnd(v.med,sd_rate));
    if rate1 > 1; rate1 = .9999; end
    
    rate2 = abs(normrnd(1-v.med,sd_rate));
    
    
    %generate starting point
    act1(n,1) = start1;
    act2(n,1) = start2;
    
    
    %create linear function
    ballistic1(n,:) = start1:rate1:start1+2000*rate1;
    ballistic2(n,:) = start2:rate2:start2+2000*rate2;
    %     if numel(ballistic2) == 0; disp(mat2str([rate1 rate2])); end
    
    for t = 2:1500
        %PERFECT INTEGRATION
        act1(n,t) = act1(n,t-1) + rate1 ;
        act2(n,t) = act2(n,t-1) + rate2 ;
        
        %WITH LEAK
        %         act1(t) = act1(t-1) + rate1 - ( (1/leakage) * act1(t-1));
        %         act2(t) = act2(t-1) + rate2 - ( (1/leakage) * act2(t-1));
        
        
        %act1(n,t) = act1(n,t-1) + ballistic1(n,t) - ( leakage * act1(n,t-1));
        %act2(n,t) = act2(n,t-1) + ballistic2(n,t) - ( leakage * act2(n,t-1));
        
        %WITH LEAK AND GAIN
        %act1(t) = act1(t-1) + rate1 + (act1(t-1) * gain.slow) - (leakage * act1(t-1));
        %act2(t) = act2(t-1) + rate2 + (act2(t-1) * gain.slow) - (leakage * act2(t-1));
        
        
        if act1(n,t) > b.med | act2(n,t) > b.med
            rts(n,1) = t;
            if act1(n,t) > b.med
                cor(n,1) = 1;
            elseif act2(n,t) > b.med
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
    
    endt = find(~isnan(accumulators.slow.errors(trl,:)),1,'last');
    resp_accumulators.slow.errors(trl,2000-endt+1:2000) = accumulators.slow.errors(trl,1:endt);
    
    endt = find(~isnan(accumulators.fast.correct(trl,:)),1,'last');
    resp_accumulators.fast.correct(trl,2000-endt+1:2000) = accumulators.fast.correct(trl,1:endt);
    
    endt = find(~isnan(accumulators.fast.errors(trl,:)),1,'last');
    resp_accumulators.fast.errors(trl,2000-endt+1:2000) = accumulators.fast.errors(trl,1:endt);
    
    endt = find(~isnan(accumulators.med.correct(trl,:)),1,'last');
    resp_accumulators.med.correct(trl,2000-endt+1:2000) = accumulators.med.correct(trl,1:endt);
    
    endt = find(~isnan(accumulators.med.errors(trl,:)),1,'last');
    resp_accumulators.med.errors(trl,2000-endt+1:2000) = accumulators.med.errors(trl,1:endt);
end

fig1
hold on
plot(ballistic.slow.correct','r')
plot(ballistic.med.correct','k')
plot(ballistic.fast.correct','g')
title('Linear Ballistic')

fig2
plot(-2000:0,nanmean(resp_accumulators.slow.correct),'r',-2000:0,nanmean(resp_accumulators.med.correct),'k', ...
    -2000:0,nanmean(resp_accumulators.fast.correct),'g')
xlim([-2000 0])
title('Response Aligned accumulators')

fig3
hold on
plot(accumulators.slow.correct','r')
plot(accumulators.med.correct','k')
plot(accumulators.fast.correct','g')
title('Accumulators')

fig4
plot(nanmean(accumulators.slow.correct),'r')
hold on
plot(nanmean(accumulators.med.correct),'k')
plot(nanmean(accumulators.fast.correct),'g')
plot(nanmean(accumulators.slow.errors),'--r')
plot(nanmean(accumulators.med.errors),'--k')
plot(nanmean(accumulators.fast.errors),'--g')
title('Mean accumulator trajectories')