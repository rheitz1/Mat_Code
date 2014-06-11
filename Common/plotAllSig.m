% plots average t_in and D_in waveforms for all spike and AD signals
% along with TDT
% LFP and EEG use hemifield for RFs
% neurons use encoded RF, if any
% RED traces are truncated 20 ms before the saccade (but only for AD
% channels)

figure
fw
varlist = who;
A_list = varlist(strmatch('AD',varlist));
D_list = varlist(strmatch('DSP',varlist));
clear varlist


nPlots = length(A_list) + length(D_list);
if nPlots == 1
    nX = 1;
    nY = 1;
elseif nPlots == 2
    nX = 2;
    nY = 1;
elseif nPlots <= 4
    nX = 2;
    nY = 2;
elseif nPlots > 4 & nPlots <=6
    nX = 3;
    nY = 2;
elseif nPlots > 6 & nPlots <= 9
    nX = 3;
    nY = 3;
elseif nPlots > 9 & nPlots <= 12
    nX = 4;
    nY = 3;
elseif nPlots > 12 & nPlots <= 16
    nX = 4;
    nY = 4;
elseif nPlots > 16 & nPlots <= 25
    nX = 5;
    nY = 5;
else
    error('Too many signals')
end


%for spikes
totalPlotCount = 1;
for signal = 1:length(D_list)
    RF = RFs.(D_list{signal});
    antiRF = mod((RF+4),8);
    
    sig = eval(D_list{signal});
    
    if isempty(RF)
        disp('Empty RF')
        continue
    end
    
    
    in = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    SDF.in = spikedensityfunct(sig,Target_(:,1),[-100 500],in,TrialStart_);
    SDF.out = spikedensityfunct(sig,Target_(:,1),[-100 500],out,TrialStart_);
    
    TDT = getTDT_SP(sig,in,out);
    
    subplot(nY,nX,totalPlotCount)
    plot(-100:500,SDF.in,'k',-100:500,SDF.out,'--k')
    vline(TDT,'k')
    xlim([-50 350])
    title([D_list{signal} '  ' mat2str(TDT)])
    
    totalPlotCount = totalPlotCount + 1;
    
end

%for LFP & EEG (midline EEG electrodes use all screen pos)

for signal = 1:length(A_list)
    
    sig = eval(A_list{signal});
    sig = baseline_correct(sig,[400 500]);
    sig_trunc = truncateAD_targ(sig,SRT,20);
    
    if Hemi.(A_list{signal}) == 'L'
        RF = [7 0 1];
        antiRF = [3 4 5];
    elseif Hemi.(A_list{signal}) == 'R'
        RF = [3 4 5];
        antiRF = [7 0 1];
    elseif Hemi.(A_list{signal}) == 'M'
        RF = [0 1 2 3 4 5 6 7];
        antiRF = [0 1 2 3 4 5 6 7];
    end
    
    in = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    TDT = getTDT_AD(sig,in,out);
    TDT_trunc = getTDT_AD(sig_trunc,in,out);
    
    minval = findMin(nanmean(sig(in,400:900)),nanmean(sig(out,400:900)));
    maxval = findMax(nanmean(sig(in,400:900)),nanmean(sig(out,400:900)));
    
    subplot(nY,nX,totalPlotCount)
    plot(-500:2500,nanmean(sig(in,:)),'k',-500:2500,nanmean(sig(out,:)),'--k', ...
        -500:2500,nanmean(sig_trunc(in,:)),'r',-500:2500,nanmean(sig_trunc(out,:)),'--r')
    xlim([-50 350])
    ylim([minval maxval])
    axis ij
    vline(TDT,'k')
    vline(TDT_trunc,'r')
    title([A_list{signal} '  ' mat2str(TDT) ' / ' mat2str(TDT_trunc)])
    
    totalPlotCount = totalPlotCount + 1;
end

[ax h] = suplabel(newfile,'t');
