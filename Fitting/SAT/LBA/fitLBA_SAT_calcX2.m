function [X2] = fitLBA_SAT_calcX2(param,Trial_Mat)

show_minimization = evalin('caller','show_minimization'); %do you want to view the minimization? (takes longer)

FreeFix = evalin('caller','FreeFix');
A = param(evalin('caller','1:length(A)'));
b = param(evalin('caller','length(A)+1:length(A)+length(b)'));
v = param(evalin('caller','length(A)+length(b)+1:length(A)+length(b)+length(v)'));
T0 = param(evalin('caller','length(A)+length(b)+length(v)+1:length(param)'));
include_med = evalin('caller','include_med');


if include_med
    FixParamTile = 3;
else
    FixParamTile = 2;
end

%The code below always assumes there are
if FreeFix(1) == 1; A = repmat(A,1,FixParamTile); end
if FreeFix(2) == 1; b = repmat(b,1,FixParamTile); end
if FreeFix(3) == 1; v = repmat(v,1,FixParamTile); end
if FreeFix(4) == 1; T0 = repmat(T0,1,FixParamTile); end
s = repmat(.1,1,FixParamTile);


%Find Trials
slow.err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 1);
slow.correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 1);
med.err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 2);
med.correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 2);
fast.err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 3);
fast.correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 3);


%Get N's
N.slow.correct = length(slow.correct);
N.slow.err = length(slow.err);
N.slow.all = N.slow.correct + N.slow.err;

N.med.correct = length(med.correct);
N.med.err = length(med.err);
N.med.all = N.med.correct + N.med.err;

N.fast.correct = length(fast.correct);
N.fast.err = length(fast.err);
N.fast.all = N.fast.correct + N.fast.err;


if include_med
    %Calculate the Defective CDF of the LBA for current set of parameters
    winner.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),v(1),s(1)) .* (1-linearballisticCDF(1:2000,A(1),b(1),1-v(1),s(1))));
    loser.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),1-v(1),s(1)) .* (1-linearballisticCDF(1:2000,A(1),b(1),v(1),s(1))));
    t.slow = (1:2000) + T0(1);
    
    winner.med = cumsum(linearballisticPDF(1:2000,A(2),b(2),v(2),s(2)) .* (1-linearballisticCDF(1:2000,A(2),b(2),1-v(2),s(2))));
    loser.med = cumsum(linearballisticPDF(1:2000,A(2),b(2),1-v(2),s(2)) .* (1-linearballisticCDF(1:2000,A(2),b(2),v(2),s(2))));
    t.med = (1:2000) + T0(2);
    
    winner.fast = cumsum(linearballisticPDF(1:2000,A(3),b(3),v(3),s(3)) .* (1-linearballisticCDF(1:2000,A(3),b(3),1-v(3),s(3))));
    loser.fast = cumsum(linearballisticPDF(1:2000,A(3),b(3),1-v(3),s(3)) .* (1-linearballisticCDF(1:2000,A(3),b(3),v(3),s(3))));
    t.fast = (1:2000) + T0(3);
    
else
    winner.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),v(1),s(1)) .* (1-linearballisticCDF(1:2000,A(1),b(1),1-v(1),s(1))));
    loser.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),1-v(1),s(1)) .* (1-linearballisticCDF(1:2000,A(1),b(1),v(1),s(1))));
    t.slow = (1:2000) + T0(1);
    
    winner.fast = cumsum(linearballisticPDF(1:2000,A(2),b(2),v(2),s(2)) .* (1-linearballisticCDF(1:2000,A(2),b(2),1-v(2),s(2))));
    loser.fast = cumsum(linearballisticPDF(1:2000,A(2),b(2),1-v(2),s(2)) .* (1-linearballisticCDF(1:2000,A(2),b(2),v(2),s(2))));
    t.fast = (1:2000) + T0(2);
end

%Calculate the observed frequencies and quantiles at the 10th, 30th 50th 70th 90th and 100th percentiles to account for
%100% of the RTs
quantiles = [.1 .2 .2 .2 .2 .1];
obs_freq.slow.correct = quantiles * N.slow.correct;
obs_freq.slow.err = quantiles .* N.slow.err;
ntiles.slow.correct = prctile(Trial_Mat(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 1),4),cumsum(quantiles * 100));
ntiles.slow.err = prctile(Trial_Mat(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 1),4),cumsum(quantiles * 100));

obs_freq.med.correct = quantiles * N.med.correct;
obs_freq.med.err = quantiles .* N.med.err;
ntiles.med.correct = prctile(Trial_Mat(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 2),4),cumsum(quantiles * 100));
ntiles.med.err = prctile(Trial_Mat(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 2),4), cumsum(quantiles * 100));

obs_freq.fast.correct = quantiles * N.fast.correct;
obs_freq.fast.err = quantiles .* N.fast.err;
ntiles.fast.correct = prctile(Trial_Mat(find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 3),4),cumsum(quantiles * 100));
ntiles.fast.err = prctile(Trial_Mat(find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 3),4), cumsum(quantiles * 100));


% To get the predicted frequencies, we have to use the predicted defective CDF:
% First, find the proportion of data predicted within each quantile.  Do this by subtracting proportion x
% from proportion x + 1

%need to add first 0 manually so that next diff operation gives us a useable proportion. Note that we are
%subtracting T0 before getting the prediction because the LBA assumes RTs have been corrected.
pred_prop.slow.correct = diff([0 winner.slow(round(ntiles.slow.correct - T0(1)))]);
pred_prop.slow.err = diff([0 loser.slow(round(ntiles.slow.err - T0(1)))]);

if include_med
    pred_prop.med.correct = diff([0 winner.med(round(ntiles.med.correct - T0(2)))]);
    pred_prop.med.err = diff([0 loser.med(round(ntiles.med.err - T0(2)))]);
    
    pred_prop.fast.correct = diff([0 winner.fast(round(ntiles.fast.correct - T0(3)))]);
    pred_prop.fast.err = diff([0 loser.fast(round(ntiles.fast.err - T0(3)))]);
else
    pred_prop.fast.correct = diff([0 winner.fast(round(ntiles.fast.correct - T0(2)))]);
    pred_prop.fast.err = diff([0 loser.fast(round(ntiles.fast.err - T0(2)))]);
end

% Multiply by .all here because winner.slow and loser.slow were based on the defective CDFs.  If they
% were not, and the CDFs were normalized to 1, you would multiply by N.correct and N.slow so make sure
% you were limited to the actually amount of data in each condition.
pred_freq.slow.correct = pred_prop.slow.correct * N.slow.all;
pred_freq.slow.err = pred_prop.slow.err * N.slow.all;
pred_freq.fast.correct = pred_prop.fast.correct * N.fast.all;
pred_freq.fast.err = pred_prop.fast.err * N.fast.all;

if include_med
    pred_freq.med.correct = pred_prop.med.correct * N.med.all;
    pred_freq.med.err = pred_prop.med.err * N.med.all;
end

% Now calculate the empirical, observed defective CDF for plotting.  If the above has been done
% correctly, then defective CDF will be identical to plotting:
%   plot(ntiles.slow.correct,cumsum(quantiles) .* (N.slow.correct / N.slow.all))
CDF.slow = getDefectiveCDF(slow.correct,slow.err,Trial_Mat(:,4));
CDF.fast = getDefectiveCDF(fast.correct,fast.err,Trial_Mat(:,4));

if include_med
    CDF.med = getDefectiveCDF(med.correct,med.err,Trial_Mat(:,4));
end

% Calculate X^2
if include_med
    all_pred = [pred_freq.slow.correct pred_freq.slow.err pred_freq.med.correct pred_freq.med.err ...
        pred_freq.fast.correct pred_freq.fast.err];
    all_obs = [obs_freq.slow.correct obs_freq.slow.err obs_freq.med.correct obs_freq.med.err ...
        obs_freq.fast.correct obs_freq.fast.err];
else
    all_pred = [pred_freq.slow.correct pred_freq.slow.err ...
        pred_freq.fast.correct pred_freq.fast.err];
    all_obs = [obs_freq.slow.correct obs_freq.slow.err  ...
        obs_freq.fast.correct obs_freq.fast.err];
end

X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) );



if show_minimization
    
    
    subplot(1,3,1)
    %plot(t.slow,winner.slow,'k',t.slow,loser.slow,'r')
    plot(ntiles.slow.correct,cumsum(pred_prop.slow.correct),'-xk',ntiles.slow.err,cumsum(pred_prop.slow.err),'-xr')
    hold on
    plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'ok',CDF.slow.err(:,1),CDF.slow.err(:,2),'or')
    %plot(CDF.slow.correct(:,1),prop_pred.correct_slow,'dk',CDF.slow.err(:,1),prop_pred.err_slow,'dr')
    ylim([0 1])
    xlim([0 1600])
    text(100,.95,['A = ' mat2str(round(A(1)*100)/100)])
    text(100,.90,['b = ' mat2str(round(b(1)*100)/100)])
    text(100,.85,['v = ' mat2str(round(v(1)*100)/100)])
    text(100,.80,['s = ' mat2str(round(s(1)*100)/100)])
    text(100,.75,['T0 = ' mat2str(round(T0(1)*100)/100)])
    title('ACCURATE')
    box off
    set(gca,'xminortick','on')
    
    if ~include_med
        
        subplot(1,3,3)
        %plot(t.fast,winner.fast,'k',t.fast,loser.fast,'r')
        plot(ntiles.fast.correct,cumsum(pred_prop.fast.correct),'--xk',ntiles.fast.err,cumsum(pred_prop.fast.err),'--xr')
        hold on
        plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok',CDF.fast.err(:,1),CDF.fast.err(:,2),'or')
        %plot(CDF.fast.correct(:,1),prop_pred.correct_fast,'dk',CDF.fast.err(:,1),prop_pred.err_fast,'dr')
        ylim([0 1])
        xlim([0 1600])
        text(100,.95,['A = ' mat2str(round(A(2)*100)/100)])
        text(100,.90,['b = ' mat2str(round(b(2)*100)/100)])
        text(100,.85,['v = ' mat2str(round(v(2)*100)/100)])
        text(100,.80,['s = ' mat2str(round(s(2)*100)/100)])
        text(100,.75,['T0 = ' mat2str(round(T0(2)*100)/100)])
        title(['FAST   X2 = ' mat2str(X2)])
        box off
        set(gca,'xminortick','on')
        
    elseif include_med
        subplot(1,3,2)
        %plot(t.med,winner.med,'k',t.med,loser.med,'r')
        plot(ntiles.med.correct,cumsum(pred_prop.med.correct),'-xk',ntiles.med.err,cumsum(pred_prop.med.err),'-xr')
        hold on
        plot(CDF.med.correct(:,1),CDF.med.correct(:,2),'ok',CDF.med.err(:,1),CDF.med.err(:,2),'or')
        ylim([0 1])
        xlim([0 1600])
        text(100,.95,['A = ' mat2str(round(A(2)*100)/100)])
        text(100,.90,['b = ' mat2str(round(b(2)*100)/100)])
        text(100,.85,['v = ' mat2str(round(v(2)*100)/100)])
        text(100,.80,['s = ' mat2str(round(s(2)*100)/100)])
        text(100,.75,['T0 = ' mat2str(round(T0(2)*100)/100)])
        title(['NEUTRAL'])
        box off
        set(gca,'xminortick','on')
        
        subplot(1,3,3)
        %plot(t.fast,winner.fast,'k',t.fast,loser.fast,'r')
        
        hold on
        plot(ntiles.fast.correct,cumsum(pred_prop.fast.correct),'--xk',ntiles.fast.err,cumsum(pred_prop.fast.err),'--xr')
        ylim([0 1])
        xlim([0 1600])
        text(100,.95,['A = ' mat2str(round(A(3)*100)/100)])
        text(100,.90,['b = ' mat2str(round(b(3)*100)/100)])
        text(100,.85,['v = ' mat2str(round(v(3)*100)/100)])
        text(100,.80,['s = ' mat2str(round(s(3)*100)/100)])
        text(100,.75,['T0 = ' mat2str(round(T0(3)*100)/100)])
        title(['FAST   X2 = ' mat2str(X2)])
        box off
        set(gca,'xminortick','on')
    end
    
    pause(.001)
    cla
    subplot(1,2,1)
    cla
    
end