%goes through each and every signal and returns the log10 power spectra
%using the contralateral hemifield.
function [] = resting_state_vampire(file)

path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/Data/')

plotFlag = 0;
pdfFlag = 0;
saveFlag = 1;
q = '''';
c = ',';
qcq = [q c q];


PDFdir = '~/desktop/temp/PDF/';
MATdir = '~/desktop/temp/Matrices/';

% PDFdir = '//scratch/heitzrp/Output/Resting_State/JPG/';
% MATdir = '//scratch/heitzrp/Output/Resting_State/Matrices/';




tapers = PreGenTapers([.2 5]);


ChanStruct = loadChan(file,'AD');
chanlist = fieldnames(ChanStruct);
decodeChanStruct


clear ChanStruct

%load Target_ & Correct_ variable
eval(['load(' q file qcq 'Hemi' qcq 'RFs' qcq 'newfile' qcq 'Errors_' qcq 'SRT' qcq 'Target_' qcq 'Correct_' qcq 'TrialStart_' qcq '-mat' q ')']);


for chan = 1:length(chanlist)
    sig = eval(cell2mat(chanlist(chan)));
    
    if Hemi.(cell2mat(chanlist(chan))) == 'R'
        RF = [3 4 5];
        antiRF = [7 0 1];
    elseif Hemi.(cell2mat(chanlist(chan))) == 'L'
        RF = [7 0 1];
        antiRF = [3 4 5];
    else
        disp('Undefined or Midline Hemifield...skipping')
        continue
    end
    
    
    inTrials = find(Correct_(:,2) & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    outTrials = find(Correct_(:,2) & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    wf.(cell2mat(chanlist(chan))).in = nanmean(sig(inTrials,:));
    wf.(cell2mat(chanlist(chan))).out = nanmean(sig(outTrials,:));
    
    [spec.(cell2mat(chanlist(chan))).in,f,tout] = LFPSpec(sig(inTrials,:),tapers,1000,.01,[0 200],0,-500,0,4);
    [spec.(cell2mat(chanlist(chan))).out,f,tout] = LFPSpec(sig(outTrials,:),tapers,1000,.01,[0 200],0,-500,0,4);
    
    
    %transpose matrices so is easier to work with
    specplot.in = spec.(cell2mat(chanlist(chan))).in';
    specplot.out = spec.(cell2mat(chanlist(chan))).out';
    
    %find frequency and time spaces to plot
    freqspace_0_20 = find(f <= 20);
    freqspace_21_40 = find(f > 20 & f <= 40);
    freqspace_41_80 = find(f > 40 & f <= 80);
    
    timespace_early = find(tout < 0 & tout >= -300);
    timespace_midway = find(tout >=0 & tout <= 300);
    timespace_late = find(tout>300 & tout < 600);
    
    early_low.in = nanmean(specplot.in(freqspace_0_20,timespace_early),1);
    midway_low.in = nanmean(specplot.in(freqspace_0_20,timespace_midway),1);
    late_low.in = nanmean(specplot.in(freqspace_0_20,timespace_late),1);
    
    early_med.in = nanmean(specplot.in(freqspace_21_40,timespace_early),1);
    midway_med.in = nanmean(specplot.in(freqspace_21_40,timespace_midway),1);
    late_med.in = nanmean(specplot.in(freqspace_21_40,timespace_late),1);
    
    early_high.in = nanmean(specplot.in(freqspace_41_80,timespace_early),1);
    midway_high.in = nanmean(specplot.in(freqspace_41_80,timespace_midway),1);
    late_high.in = nanmean(specplot.in(freqspace_41_80,timespace_late),1);
    
    early_low.out = nanmean(specplot.out(freqspace_0_20,timespace_early),1);
    midway_low.out = nanmean(specplot.out(freqspace_0_20,timespace_midway),1);
    late_low.out = nanmean(specplot.out(freqspace_0_20,timespace_late),1);
    
    early_med.out = nanmean(specplot.out(freqspace_21_40,timespace_early),1);
    midway_med.out = nanmean(specplot.out(freqspace_21_40,timespace_midway),1);
    late_med.out = nanmean(specplot.out(freqspace_21_40,timespace_late),1);
    
    early_high.out = nanmean(specplot.out(freqspace_41_80,timespace_early),1);
    midway_high.out = nanmean(specplot.out(freqspace_41_80,timespace_midway),1);
    late_high.out = nanmean(specplot.out(freqspace_41_80,timespace_late),1);
    
    
    
    figure
    plot(tout(timespace_early),log10(early_low.in),'k', ...
        tout(timespace_early),log10(early_low.out),'--k', ...
        tout(timespace_early),log10(early_med.in),'b', ...
        tout(timespace_early),log10(early_med.out),'--b', ...
        tout(timespace_early),log10(early_high.in),'r', ...
        tout(timespace_early),log10(early_high.out),'--r')
    
    figure
    plot(tout(timespace_midway),log10(midway_low.in),'k', ...
        tout(timespace_midway),log10(midway_low.out),'--k', ...
        tout(timespace_midway),log10(midway_med.in),'b', ...
        tout(timespace_midway),log10(midway_med.out),'--b', ...
        tout(timespace_midway),log10(midway_high.in),'r', ...
        tout(timespace_midway),log10(midway_high.out),'--r')
    
    
    fi = figure;
    subplot(3,2,[1 2])
    plot(-500:2500,wf.(cell2mat(chanlist(chan))).in,'k',-500:2500,wf.(cell2mat(chanlist(chan))).out,'--k')
    xlim([-300 500])
    axis ij
    legend('InTrials','OutTrials','location','northwest')
    
    
    subplot(3,2,3)
    imagesc(tout,f,log10(spec.(cell2mat(chanlist(chan))).in)')
    xlim([-300 500])
    ylim([0 100])
    colorbar
    axis xy
    x = get(gca,'clim');
    title('inTrials')
    
    subplot(3,2,4)
    imagesc(tout,f,log10(spec.(cell2mat(chanlist(chan))).out)')
    xlim([-300 500])
    ylim([0 100])
    colorbar
    axis xy
    set(gca,'clim',x)
    title('outTrials')
    
    subplot(3,2,5)
    
    
    
    if plotFlag == 1
        eval(['print -dpdf ' PDFdir file '_' chanlist{chan} '.pdf'])
        close(fi)
    end
    
    
end