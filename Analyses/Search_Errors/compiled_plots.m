% Plots for compiled error analyses
%s == session 117:end
pdfFlag = 0;

%fix missing values
LFPValence.errors(164) = NaN;
LFPValence.errors(165) = NaN;

%mark as 'keeper' any condition with >= 20 trials
for sess = 1:size(alln.neuron.in_correct,1)
    if alln.neuron.in_correct(sess) >= 20 & neuronTDT.correct(sess) < allRTs.neuron.correct(sess)
        keeper.neuron.in_correct(sess,1) = 1;
    else
        keeper.neuron.in_correct(sess,1) = 0;
    end
    
    if alln.neuron.out_correct(sess) >= 20 & neuronTDT.correct(sess) < allRTs.neuron.correct(sess)
        keeper.neuron.out_correct(sess,1) = 1;
    else
        keeper.neuron.out_correct(sess,1) = 0;
    end
    
    if alln.neuron.in_errors(sess) >= 20 & neuronTDT.errors(sess) < allRTs.neuron.errors(sess)
        keeper.neuron.in_errors(sess,1) = 1;
    else
        keeper.neuron.in_errors(sess,1) = 0;
    end
    
    if alln.neuron.out_errors(sess) >= 20 & neuronTDT.errors(sess) < allRTs.neuron.errors(sess)
        keeper.neuron.out_errors(sess,1) = 1;
    else
        keeper.neuron.out_errors(sess,1) = 0;
    end
end

for sess = 1:size(alln.LFP.in_correct,1) 
    if alln.LFP.in_correct(sess) >= 20 & LFPTDT.correct(sess) < allRTs.LFP.correct(sess)
        keeper.LFP.in_correct(sess,1) = 1;
    else
        keeper.LFP.in_correct(sess,1) = 0;
    end
    
    if alln.LFP.out_correct(sess) >= 20 & LFPTDT.correct(sess) < allRTs.LFP.correct(sess)
        keeper.LFP.out_correct(sess,1) = 1;
    else
        keeper.LFP.out_correct(sess,1) = 0;
    end
    
    if alln.LFP.in_errors(sess) >= 20 & LFPTDT.errors(sess) < allRTs.LFP.errors(sess)
        keeper.LFP.in_errors(sess,1) = 1;
    else
        keeper.LFP.in_errors(sess,1) = 0;
    end
    
    if alln.LFP.out_errors(sess) >= 20 & LFPTDT.errors(sess) < allRTs.LFP.errors(sess)
        keeper.LFP.out_errors(sess,1) = 1;
    else
        keeper.LFP.out_errors(sess,1) = 0;
    end
end


for sess = 1:size(alln.EEG.contra_correct,1) 
    if alln.EEG.contra_correct(sess) >= 20 & EEGTDT.correct(sess) < allRTs.EEG.correct(sess)
        keeper.EEG.contra_correct(sess,1) = 1;
    else
        keeper.EEG.contra_correct(sess,1) = 0;
    end
    
    if alln.EEG.ipsi_correct(sess) >= 20 & EEGTDT.correct(sess) < allRTs.EEG.correct(sess)
        keeper.EEG.ipsi_correct(sess,1) = 1;
    else
        keeper.EEG.ipsi_correct(sess,1) = 0;
    end
    
    if alln.EEG.contra_errors(sess) >= 20 & EEGTDT.errors(sess) < allRTs.EEG.errors(sess)
        keeper.EEG.contra_errors(sess,1) = 1;
    else
        keeper.EEG.contra_errors(sess,1) = 0;
    end
    
    if alln.EEG.ipsi_errors(sess) >= 20 & EEGTDT.errors(sess) < allRTs.EEG.errors(sess)
        keeper.EEG.ipsi_errors(sess,1) = 1;
    else
        keeper.EEG.ipsi_errors(sess,1) = 0;
    end
end

keepers_correct = find(keeper.neuron.in_correct == 1 & keeper.neuron.out_correct == 1);
keepers_errors = find(keeper.neuron.in_errors == 1 & keeper.neuron.out_errors == 1);
neuron_trials = intersect(keepers_correct,keepers_errors);

keepers_correct = find(keeper.LFP.in_correct == 1 & keeper.LFP.out_correct == 1);
keepers_errors = find(keeper.LFP.in_errors == 1 & keeper.LFP.out_errors == 1);
LFP_trials = intersect(keepers_correct,keepers_errors);

keepers_correct = find(keeper.EEG.contra_correct == 1 & keeper.EEG.ipsi_correct == 1);
keepers_errors = find(keeper.EEG.contra_errors ==1  & keeper.EEG.ipsi_errors == 1);
EEG_trials = intersect(keepers_correct,keepers_errors);

clear keepers_correct keepers_errors

%get proportion valence
propSelect.neuron_correct = length(nonzeros(neuronValence.correct(neuron_trials))) / length(neuron_trials);
propSelect.neuron_errors = length(nonzeros(neuronValence.errors(neuron_trials))) / length(neuron_trials);
propValence.neuron_correct = length(find(neuronValence.correct(neuron_trials) == 1)) / (length(find(neuronValence.correct(neuron_trials) == 1)) + length(find(neuronValence.correct(neuron_trials) == -1)));
propValence.neuron_errors = length(find(neuronValence.errors(neuron_trials) == 1)) / (length(find(neuronValence.errors(neuron_trials) == 1)) + length(find(neuronValence.errors(neuron_trials) == -1)));

propSelect.LFP_correct = length(nonzeros(LFPValence.correct(LFP_trials))) / length(LFP_trials);
propSelect.LFP_errors = length(nonzeros(LFPValence.errors(LFP_trials))) / length(LFP_trials);
propValence.LFP_correct = length(find(LFPValence.correct(LFP_trials) == 1)) / (length(find(LFPValence.correct(LFP_trials) == 1)) + length(find(LFPValence.correct(LFP_trials) == -1)));
propValence.LFP_errors = length(find(LFPValence.errors(LFP_trials) == 1)) / (length(find(LFPValence.errors(LFP_trials) == 1)) + length(find(LFPValence.errors(LFP_trials) == -1)));

propSelect.EEG_correct = length(nonzeros(EEGValence.correct(EEG_trials))) / length(EEG_trials);
propSelect.EEG_errors = length(nonzeros(EEGValence.errors(EEG_trials))) / length(EEG_trials);
propValence.EEG_correct = length(find(EEGValence.correct(EEG_trials) == 1)) / (length(find(EEGValence.correct(EEG_trials) == 1)) + length(find(EEGValence.correct(EEG_trials) == -1)));
propValence.EEG_errors = length(find(EEGValence.errors(EEG_trials) == 1)) / (length(find(EEGValence.errors(EEG_trials) == 1)) + length(find(EEGValence.errors(EEG_trials) == -1)));



%Get mean TDTs, but exclude outliers (TDT > 1000 ms)
meanTDT.neuron_correct = nanmean(neuronTDT.correct(find(neuronTDT.correct < 1000 & neuronTDT.correct > 100 & keeper.neuron.in_correct == 1 & keeper.neuron.out_correct == 1)));
meanTDT.neuron_errors = nanmean(neuronTDT.errors(find(neuronTDT.errors < 1000 & neuronTDT.errors > 100 & keeper.neuron.in_errors == 1 & keeper.neuron.out_errors == 1)));
meanTDT.LFP_correct = nanmean(LFPTDT.correct(find(LFPTDT.correct < 1000 & LFPTDT.correct > 100 & keeper.LFP.in_correct == 1 & keeper.LFP.out_correct == 1)));
meanTDT.LFP_errors = nanmean(LFPTDT.errors(find(LFPTDT.errors < 1000 & LFPTDT.errors > 100 & keeper.LFP.in_errors == 1 & keeper.LFP.out_errors == 1)));
meanTDT.EEG_correct = nanmean(EEGTDT.correct(find(EEGTDT.correct < 1000 & EEGTDT.correct > 100 & keeper.EEG.contra_correct == 1 & keeper.EEG.ipsi_correct == 1)));
meanTDT.EEG_errors = nanmean(EEGTDT.errors(find(EEGTDT.errors < 1000 & EEGTDT.errors > 100 & keeper.EEG.contra_errors == 1 & keeper.EEG.ipsi_errors == 1)));


%get CDFs for MEAN RTs
for sess = 1:size(allRTD.correct,2)
    meanRT.correct(sess) = nanmean(nonzeros(allRTD.correct(:,sess)));
    meanRT.errors(sess) = nanmean(nonzeros(allRTD.errors(:,sess)));
end

%collapsing across monkey...
[bins_RTs.correct counts_RTs.correct] = getCDF(meanRT.correct,30);
[bins_RTs.errors counts_RTs.errors] = getCDF(meanRT.errors,30);
[bins_neuron.correct counts_neuron.correct] = getCDF(neuronTDT.correct(find(neuronTDT.correct < 1000 & neuronTDT.correct > 100 & keeper.neuron.in_correct == 1 & keeper.neuron.out_correct == 1)),30);
[bins_neuron.errors counts_neuron.errors] = getCDF(neuronTDT.errors(find(neuronTDT.errors < 1000 & neuronTDT.errors > 100 & keeper.neuron.in_errors == 1 & keeper.neuron.out_errors == 1)),30);
[bins_LFP.correct counts_LFP.correct] = getCDF(LFPTDT.correct(find(LFPTDT.correct < 1000 & LFPTDT.correct > 100 & keeper.LFP.in_correct == 1 & keeper.LFP.out_correct == 1)),30);
[bins_LFP.errors counts_LFP.errors] = getCDF(LFPTDT.errors(find(LFPTDT.errors < 1000 & LFPTDT.errors > 100 & keeper.LFP.in_errors == 1 & keeper.LFP.out_errors == 1)),30);
[bins_EEG.correct counts_EEG.correct] = getCDF(EEGTDT.correct(find(EEGTDT.correct < 1000 & EEGTDT.correct > 100 & keeper.EEG.contra_correct == 1 & keeper.EEG.ipsi_correct == 1)),30);
[bins_EEG.errors counts_EEG.errors] = getCDF(EEGTDT.errors(find(EEGTDT.errors < 1000 & EEGTDT.errors > 100 & keeper.EEG.contra_errors == 1 & keeper.EEG.ipsi_errors == 1)),30);

%for Q
[Qbins_RTs.correct Qcounts_RTs.correct] = getCDF(meanRT.correct(find(monkey == 'Q')),30);
[Qbins_RTs.errors Qcounts_RTs.errors] = getCDF(meanRT.errors(find(monkey == 'Q')),30);

%for S
[Sbins_RTs.correct Scounts_RTs.correct] = getCDF(meanRT.correct(find(monkey == 'S')),30);
[Sbins_RTs.errors Scounts_RTs.errors] = getCDF(meanRT.errors(find(monkey == 'S')),30);

%=====================
%calulate correlations, remove TDT == exactly 100 because this is likely
%artifactual
trials = find(neuronTDT.correct > 100 & ~isnan(neuronTDT.correct) & ~isnan(allRTs.neuron.correct) & keeper.neuron.in_correct == 1 & keeper.neuron.out_correct == 1);
[r.Neuron_correct r.Neuron_correct_p] = corr(neuronTDT.correct(trials),allRTs.neuron.correct(trials));

trials = find(neuronTDT.errors > 100 & ~isnan(neuronTDT.errors) & ~isnan(allRTs.neuron.errors) & keeper.neuron.in_errors == 1 & keeper.neuron.out_errors == 1);
[r.Neuron_errors r.Neuron_errors_p] = corr(neuronTDT.errors(trials),allRTs.neuron.errors(trials));

trials = find(LFPTDT.correct > 100 & ~isnan(LFPTDT.correct) & ~isnan(allRTs.LFP.correct) & keeper.LFP.in_correct == 1 & keeper.LFP.out_correct == 1);
[r.LFP_correct r.LFP_correct_p] = corr(LFPTDT.correct(trials),allRTs.LFP.correct(trials));

trials = find(LFPTDT.errors > 100 & ~isnan(LFPTDT.errors) & ~isnan(allRTs.LFP.errors) & keeper.LFP.in_errors == 1 & keeper.LFP.out_errors == 1);
[r.LFP_errors r.LFP_errors_p] = corr(LFPTDT.errors(trials),allRTs.LFP.errors(trials));

trials = find(EEGTDT.correct > 100 & ~isnan(EEGTDT.correct) & ~isnan(allRTs.EEG.correct) & keeper.EEG.contra_correct == 1 & keeper.EEG.ipsi_correct == 1);
[r.EEG_correct r.EEG_correct_p] = corr(EEGTDT.correct(trials),allRTs.EEG.correct(trials));

trials = find(EEGTDT.errors > 100 & ~isnan(EEGTDT.errors) & ~isnan(allRTs.EEG.errors) & keeper.EEG.contra_errors == 1 & keeper.EEG.ipsi_errors == 1);
[r.EEG_errors r.EEG_errors_p] = corr(EEGTDT.errors(trials),allRTs.EEG.errors(trials));
%=====================





%====================
% 1.  Scatter plot for neuron TDT correct vs errors

figure


scatter(neuronTDT.correct(neuron_trials),neuronTDT.errors(neuron_trials),'r','filled')
fon
maxVal = ceil(findMax(neuronTDT.correct,neuronTDT.errors) / 100) * 100;
minVal = floor(findMin(neuronTDT.correct,neuronTDT.errors) / 100) * 100;

xlim([minVal maxVal])
ylim([minVal maxVal])
line([minVal maxVal],[minVal maxVal],'color','k','linewidth',2,'linestyle','--')
xlabel('Correct')
ylabel('Errors')
title('Neuron TDT')

if pdfFlag == 1
    print -dpdf /volumes/Dump/Analyses/Errors/ErrorFigs/neuron_scatter_corr_vs_err.pdf
end
%=====================


%=====================
% 2.  Scatter plot for LFP TDT correct vs Errors

figure


scatter(LFPTDT.correct(LFP_trials),LFPTDT.errors(LFP_trials),'b','filled')
fon
%maxVal = ceil(findMax(LFPTDT.correct,LFPTDT.errors) / 100) * 100;
%minVal = floor(findMin(LFPTDT.correct,LFPTDT.errors) / 100) * 100;

xlim([minVal maxVal])
ylim([minVal maxVal])
line([minVal maxVal],[minVal maxVal],'color','k','linewidth',2,'linestyle','--')
xlabel('Correct')
ylabel('Errors')
title('LFP TDT')


if pdfFlag == 1
    print -dpdf /volumes/Dump/Analyses/Errors/ErrorFigs/LFP_scatter_corr_vs_err.pdf
end
%=====================

%=====================
% 3.  Scatter plot for EEG TDT correct vs Errors

figure



scatter(EEGTDT.correct(EEG_trials),EEGTDT.errors(EEG_trials),'k','filled')
fon
%maxVal = ceil(findMax(EEGTDT.correct,EEGTDT.errors) / 100) * 100;
%minVal = floor(findMin(EEGTDT.correct,EEGTDT.errors) / 100) * 100;

xlim([minVal maxVal])
ylim([minVal maxVal])
line([minVal maxVal],[minVal maxVal],'color','k','linewidth',2,'linestyle','--')
xlabel('Correct')
ylabel('Errors')
title('EEG TDT')


if pdfFlag == 1
    print -dpdf /volumes/Dump/Analyses/Errors/ErrorFigs/EEG_scatter_corr_vs_err.pdf
end
%=====================


%=====================
% 4.  Scatter plot correct vs errors for neuron, LFP, and EEG
figure
hold
scatter(neuronTDT.correct(neuron_trials),neuronTDT.errors(neuron_trials),'r','filled')
scatter(LFPTDT.correct(LFP_trials),LFPTDT.errors(LFP_trials),'b','filled')
scatter(EEGTDT.correct(EEG_trials),EEGTDT.errors(EEG_trials),'k','filled')
line([minVal maxVal],[minVal maxVal],'color','k','linewidth',2,'linestyle','--')
fon

xlim([minVal maxVal])
ylim([minVal maxVal])

xlabel('Correct')
ylabel('Errors')
title('Neuron, LFP, and EEG TDT')

if pdfFlag == 1
    print -dpdf /volumes/Dump/Analyses/Errors/ErrorFigs/all_scatter_corr_vs_err.pdf
end



%==========================
% 5. Scatter plot neuron TDT vs RTs, correct & errors
figure
subplot(1,2,1)
hold


plot(neuronTDT.correct(neuron_trials),allRTs.neuron.correct(neuron_trials),'or','markerfacecolor','r')
plot(LFPTDT.correct(LFP_trials),allRTs.LFP.correct(LFP_trials),'ob','markerfacecolor','b')
plot(EEGTDT.correct(EEG_trials),allRTs.EEG.correct(EEG_trials),'ok','markerfacecolor','k')
l = lsline;
set(l,'linewidth',2)

fon
xlabel('TDT')
ylabel('Reaction Time')
title('Correct')
xlim([100 400])
ylim([200 400])


subplot(1,2,2)
hold
plot(neuronTDT.errors(neuron_trials),allRTs.neuron.errors(neuron_trials),'or','markerfacecolor','r')
plot(LFPTDT.errors(LFP_trials),allRTs.LFP.errors(LFP_trials),'ob','markerfacecolor','b')
plot(EEGTDT.errors(EEG_trials),allRTs.EEG.errors(EEG_trials),'ok','markerfacecolor','k')
l = lsline;
set(l,'linewidth',2)
 
fon
xlabel('TDT')
ylabel('Reaction Time')
title('Errors')
xlim([100 400])
ylim([200 400])

%==========================
% 6. Scatter plot neuron TDT vs RTs, correct & errors, separately for each
figure
subplot(3,2,1)
plot(neuronTDT.correct(neuron_trials),allRTs.neuron.correct(neuron_trials),'or','markerfacecolor','r')
l = lsline;
set(l,'linewidth',2)
fon
title(['Neuron Correct, r = ' mat2str(roundoff(r.Neuron_correct,2))])
xlim([100 350])
ylim([200 400])

subplot(3,2,3)
plot(LFPTDT.correct(LFP_trials),allRTs.LFP.correct(LFP_trials),'ob','markerfacecolor','b')
l = lsline;
set(l,'linewidth',2)
fon
title(['LFP Correct, r = ' mat2str(roundoff(r.LFP_correct,2))])
xlim([100 350])
ylim([200 400])
ylabel('Reaction Time')

subplot(3,2,5)
plot(EEGTDT.correct(EEG_trials),allRTs.EEG.correct(EEG_trials),'ok','markerfacecolor','k')
l = lsline;
set(l,'linewidth',2)
fon
title(['m-P2pc Correct, r = ' mat2str(roundoff(r.EEG_correct,2))])
xlim([100 350])
ylim([200 400])

subplot(3,2,2)
plot(neuronTDT.errors(neuron_trials),allRTs.neuron.errors(neuron_trials),'or','markerfacecolor','r')
l = lsline;
set(l,'linewidth',2)
fon
title(['Neuron Errors, r = ' mat2str(roundoff(r.Neuron_errors,2))])
xlim([100 350])
ylim([200 400])

subplot(3,2,4)
plot(LFPTDT.errors(LFP_trials),allRTs.LFP.errors(LFP_trials),'ob','markerfacecolor','b')
l = lsline;
set(l,'linewidth',2)
fon
title(['LFP Errors, r = ' mat2str(roundoff(r.LFP_errors,2))])
xlim([100 350])
ylim([200 400])

subplot(3,2,6)
plot(EEGTDT.errors(EEG_trials),allRTs.EEG.errors(EEG_trials),'ok','markerfacecolor','k')
l = lsline;
set(l,'linewidth',2)
fon
title(['EEG Errors, r = ' mat2str(roundoff(r.EEG_errors,2))])
xlim([100 350])
ylim([200 400])


[ax h] = suplabel('TDT');
set(h,'fontsize',14,'fontweight','bold')

% %====================
% subplot(1,2,2)
% hold
% plot(neuronTDT.errors(neuron_trials),allRTs.neuron.errors(neuron_trials),'or','markerfacecolor','r')
% plot(LFPTDT.errors(LFP_trials),allRTs.LFP.errors(LFP_trials),'ob','markerfacecolor','b')
% plot(EEGTDT.errors(EEG_trials),allRTs.EEG.errors(EEG_trials),'ok','markerfacecolor','k')
% l = lsline;
% set(l,'linewidth',2)



%========================
% Histogram of proportion of sessions that had significant selection times
select = [propSelect.neuron_correct;propSelect.LFP_correct;propSelect.EEG_correct;propSelect.neuron_errors;propSelect.LFP_errors;propSelect.EEG_errors];
figure
bar(select)
set(gca,'xticklabels',['Neu Cor';'LFP Cor';'EEG Cor';'Neu Err';'LFP Err';'EEG Err'])
fon
xlabel('Signal Condition')
ylabel('Proportion')
title('Proportion of sessions with significant selection times')

if pdfFlag == 1
    print -dpdf /volumes/Dump/Analyses/Errors/ErrorFigs/selectivity_hist.pdf
end


%======================
% Histogram of proportion of sessions with POSITIVE selectivity (i.e.,
% activity/voltage for correct trials was GREATER than for error trials.
% This takes into account ONLY THOSE SESSIONS THAT HAD SELECTIVITY and also
% conditions with > 20 observations
val = [propValence.neuron_correct;propValence.neuron_errors;propValence.LFP_correct;propValence.LFP_errors;propValence.EEG_correct;propValence.EEG_errors];
figure
bar(val)
set(gca,'xticklabels',['Neu Cor';'Neu Err';'LFP Cor';'LFP Err';'EEG Cor';'EEG Err'])
fon
xlabel('Signal Condition')
ylabel('Proportion')
title('Proportion of sessions where selectivity was positive (Greater / More Positive for Correct Trials)')

if pdfFlag == 1
    print -dpdf /volumes/Dump/Analyses/Errors/ErrorFigs/valence_hist.pdf
end



%======================
% CDFs for TDT and RT
figure
plot(bins_neuron.correct,counts_neuron.correct,'r',bins_LFP.correct,counts_LFP.correct,'b',bins_EEG.correct,counts_EEG.correct,'k',bins_neuron.errors,counts_neuron.errors,'--r',bins_LFP.errors,counts_LFP.errors,'--b',bins_EEG.errors,counts_EEG.errors,'--k',bins_RTs.correct,counts_RTs.correct,'m',bins_RTs.errors,counts_RTs.errors,'--m','linewidth',2)
fon
xlabel('Mean Selection Time / Reaction Time')
ylabel('Proportion')

%===================
% Plot grand averages with average TDTs
figure
plot(-100:500,nanmean(allwf.neuron.in_correct(neuron_trials,:)),'b',-100:500,nanmean(allwf.neuron.out_correct(neuron_trials,:)),'--b',-100:500,nanmean(allwf.neuron.in_errors(neuron_trials,:)),'r',-100:500,nanmean(allwf.neuron.out_errors(neuron_trials,:)),'--r','linewidth',2)
vline(nanmean(neuronTDT.correct(neuron_trials)),'b')
vline(nanmean(neuronTDT.errors(neuron_trials)),'r')
fon
xlabel('Time from Target Onset')
ylabel('Spikes/s')

figure
plot(-500:2500,nanmean(allwf.LFP.in_correct(LFP_trials,:)),'b',-500:2500,nanmean(allwf.LFP.out_correct(LFP_trials,:)),'--b',-500:2500,nanmean(allwf.LFP.in_errors(LFP_trials,:)),'r',-500:2500,nanmean(allwf.LFP.out_errors(LFP_trials,:)),'--r','linewidth',2)
vline(nanmean(LFPTDT.correct(LFP_trials)),'b')
vline(nanmean(LFPTDT.errors(LFP_trials)),'r')
fon
axis ij
xlim([-100 500])
xlabel('Time from Target Onset')
ylabel('mV')


figure
plot(-500:2500,nanmean(allwf.EEG.contra_correct(EEG_trials,:)),'b',-500:2500,nanmean(allwf.EEG.ipsi_correct(EEG_trials,:)),'--b',-500:2500,nanmean(allwf.EEG.contra_errors(EEG_trials,:)),'r',-500:2500,nanmean(allwf.EEG.ipsi_errors(EEG_trials,:)),'--r','linewidth',2)
vline(nanmean(EEGTDT.correct(EEG_trials)),'b')
vline(nanmean(EEGTDT.errors(EEG_trials)),'r')
fon
axis ij
xlim([-100 500])
xlabel('Time from Target Onset')
ylabel('mV')

%=====================
% Calculate proportion of session in which Correct & Error responses are
% in opposite directions.  Limit to sessions that DID select, and also
% limit to valid sessions (# of observations > 20, TDT < 1000, etc.) for
% BOTH correct and error trials

for sess = 1:length(neuron_trials)
    if neuronValence.correct(neuron_trials(sess)) == 0 | neuronValence.errors(neuron_trials(sess)) == 0
        match.neuron(sess,1) = NaN;
        continue
    elseif neuronValence.correct(neuron_trials(sess)) == neuronValence.errors(neuron_trials(sess))
        match.neuron(sess,1) = 1;
    elseif neuronValence.correct(neuron_trials(sess)) ~= neuronValence.errors(neuron_trials(sess))
        match.neuron(sess,1) = 0;
    end
end

for sess = 1:length(LFP_trials)
    if LFPValence.correct(LFP_trials(sess)) == 0 | LFPValence.errors(LFP_trials(sess)) == 0
        match.LFP(sess,1) = NaN;
        continue
    elseif LFPValence.correct(LFP_trials(sess)) == LFPValence.errors(LFP_trials(sess))
        match.LFP(sess,1) = 1;
    elseif LFPValence.correct(LFP_trials(sess)) ~= LFPValence.errors(LFP_trials(sess))
        match.LFP(sess,1) = 0;
    end
end

for sess = 1:length(EEG_trials)
    if EEGValence.correct(EEG_trials(sess)) == 0 | EEGValence.errors(EEG_trials(sess)) == 0
        match.EEG(sess,1) = NaN;
        continue
    elseif EEGValence.correct(EEG_trials(sess)) == EEGValence.errors(EEG_trials(sess))
        match.EEG(sess,1) = 1;
    elseif EEGValence.correct(EEG_trials(sess)) ~= EEGValence.errors(EEG_trials(sess))
        match.EEG(sess,1) = 0;
    end
end


% plot proportion of sessions where errors selected opposite to that of
% correct trials
figure
bar([1-nanmean(match.neuron);1-nanmean(match.LFP);1-nanmean(match.EEG)])

