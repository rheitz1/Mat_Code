%Plots SDF aligned to fixation, broken by N ntile bins
function [SDF Fano real_time] = plotSDF_fix_ntiles(sig,FixTimes,n_ntiles_desired)

if nargin < 3; n_ntiles_desired = 3; end
n_ntiles = n_ntiles_desired + 1; %the last prctile is 100%, and there will be nothing greater. E.g., if you want 4, have to ask for 5

Target_ = evalin('caller','Target_');

Plot_Time_Fix = [-50 3000];
Calc_Fano = 1;

if any(FixTimes < 0) %If using Fixation Acquire Times, values will be negative.  If using Tempo's estimate of Fixation Hold Time, values will be positive. Must be handled differently depending.
    disp('Inverting Values')
    FixTimes = -FixTimes;
end
    
fix_ntiles = prctile(FixTimes,[round(100/n_ntiles:100/n_ntiles:100)]);

SDF_fix = sSDF(sig,Target_(:,1)-FixTimes,Plot_Time_Fix);

for s = 1:n_ntiles
    
    %do 1st and last by hand
    if s == 1
        trials = find(FixTimes <= fix_ntiles(1));
    elseif s == n_ntiles
        trials = find(FixTimes > fix_ntiles(n_ntiles));
    else
        trials = find(FixTimes > fix_ntiles(s-1) & FixTimes <= fix_ntiles(s));
    end
    
    SDF(s,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_fix(trials,:));
    
    if Calc_Fano
        FixTime_Jit_ = FixTimes; %Fano function expects this variable name
        
        if s == 1 %real_time variable fails on last iteration
            [Fano(s,:) real_time] = getFano_fix(sig,50,10,[Plot_Time_Fix(1) Plot_Time_Fix(2)],trials);
        else
            [Fano(s,:)] = getFano_fix(sig,50,10,[Plot_Time_Fix(1) Plot_Time_Fix(2)],trials);
        end
    end
end

graylines
fig1
plot(Plot_Time_Fix(1):Plot_Time_Fix(2),SDF)
xlim([-50 3000])
box off

if Calc_Fano
    fig2
    plot(real_time,Fano)
    xlim([min(real_time) max(real_time)])
    box off
end
colorlines