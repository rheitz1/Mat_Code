cd /Volumes/Dump2/Coherence/screenloc/Matrices/notnormalized/LFP-LFP/

batch_list = dir('S*.mat');
plotFlag = 0;


for sess = 1:length(batch_list)
    batch_list(sess).name
    
    load(batch_list(sess).name,'Pcoh_targ','tout_targ','f_targ')
    
    SallCoh_notNormalized(1:281,1:83,sess) = Pcoh_targ.all;
    
    %keep baseline corrected version too
    basewindow = find(tout_targ >= -300 & tout_targ <= -100);
    SallCoh_notNormalized_bc(1:281,1:83,sess) = baseline_correct(abs(Pcoh_targ.all)',basewindow)';
    
    clear Pcoh_targ
end


if plotFlag
    figure
    imagesc(tout_targ,f_targ,nanmean(abs(SallCoh_notNormalized),3)')
    title('S Not Normalized')
    axis xy
    ylim([0 50])
    xlim([-200 500])
    colorbar
end


batch_list = dir('Q*.mat');

for sess = 1:length(batch_list)
    batch_list(sess).name
    
    load(batch_list(sess).name,'Pcoh_targ','tout_targ','f_targ')
    
    QallCoh_notNormalized(1:281,1:83,sess) = Pcoh_targ.all;
    QallCoh_notNormalized_bc(1:281,1:83,sess) = baseline_correct(abs(Pcoh_targ.all)',basewindow)';
    clear Pcoh_targ
end

if plotFlag
    figure
    imagesc(tout_targ,f_targ,nanmean(abs(QallCoh_notNormalized),3)')
    title('Q Not Normalized')
    axis xy
    ylim([0 50])
    xlim([-200 500])
    colorbar
end



cd /Volumes/Dump2/Coherence/screenloc/Matrices/normalized/LFP-LFP/

batch_list = dir('S*.mat');


for sess = 1:length(batch_list)
    batch_list(sess).name
    
    load(batch_list(sess).name,'Pcoh_targ','tout_targ','f_targ')
    
    SallCoh_Normalized(1:281,1:83,sess) = Pcoh_targ.all;
    SallCoh_Normalized_bc(1:281,1:83,sess) = baseline_correct(abs(Pcoh_targ.all)',basewindow)';
    
    clear Pcoh_targ
end

if plotFlag
    figure
    imagesc(tout_targ,f_targ,nanmean(abs(SallCoh_Normalized),3)')
    title('S Normalized')
    axis xy
    ylim([0 50])
    xlim([-200 500])
    colorbar
end



batch_list = dir('Q*.mat');

for sess = 1:length(batch_list)
    batch_list(sess).name
    
    load(batch_list(sess).name,'Pcoh_targ','tout_targ','f_targ')
    
    QallCoh_Normalized(1:281,1:83,sess) = Pcoh_targ.all;
    QallCoh_Normalized_bc(1:281,1:83,sess) = baseline_correct(abs(Pcoh_targ.all)',basewindow)';
    
    clear Pcoh_targ
end

if plotFlag
    figure
    imagesc(tout_targ,f_targ,nanmean(abs(QallCoh_Normalized),3)')
    title('Q Normalized')
    axis xy
    ylim([0 50])
    xlim([-200 500])
    colorbar
end


keep plotFlag tout_targ f_targ QallCoh_notNormalized QallCoh_Normalized ...
    SallCoh_notNormalized SallCoh_Normalized ...
    QallCoh_notNormalized_bc QallCoh_Normalized_bc ...
    SallCoh_notNormalized_bc SallCoh_Normalized_bc
