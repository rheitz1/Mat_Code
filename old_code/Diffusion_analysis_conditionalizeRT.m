%use to integrate differences between targ_in and targ_out

%set parameters
numgroups = 3;
SRT = Saccade_(:,1) - Target_(:,1);
Align_Time_ = TrialType_(:,5);
Plot_Time=[-500 2000];


%get list of neurons
varlist = who;
cellID = varlist(strmatch('DSP',varlist));



%calculate cutoffs
low_cut = nanmedian(SRT(find(SRT < nanmedian(SRT))));
high_cut = nanmedian(SRT(find(SRT >= nanmedian(SRT))));

loc_antiloc = [0 1 2 3 4 5 6 7;4 5 6 7 0 1 2 3];

counter = 1;
    for ii = 1:length(loc_antiloc)
        if ismember(loc_antiloc(1,ii),RFs)
            antiRFs(counter) = loc_antiloc(2,ii);
            counter = counter + 1;
        end
    end

    
    for cell = 1:length(cellID)

        currcell = eval(cell2mat(cellID(cell)));
        
              
        triallist_low = find(Correct_(:,2) == 1 & SRT < low_cut & ismember(Target_(:,2),RFs));
        triallist_med = find(Correct_(:,2) == 1 & SRT >= low_cut & SRT < high_cut & ismember(Target_(:,2),RFs));
        triallist_high = find(Correct_(:,2) == 1 & SRT >= high_cut & ismember(Target_(:,2),RFs));

        triallist_low_anti = find(Correct_(:,2) == 1 & SRT < low_cut & ismember(Target_(:,2),antiRFs));
        triallist_med_anti = find(Correct_(:,2) == 1 & SRT >= low_cut & SRT < high_cut & ismember(Target_(:,2),antiRFs));
        triallist_high_anti = find(Correct_(:,2) == 1 & SRT >= high_cut & ismember(Target_(:,2),antiRFs));

              
        [SDF_low_in] = spikedensityfunct_contrast(currcell, Align_Time_, Plot_Time, triallist_low, TrialStart_);
        [SDF_med_in] = spikedensityfunct_contrast(currcell, Align_Time_, Plot_Time, triallist_med, TrialStart_);
        [SDF_high_in] = spikedensityfunct_contrast(currcell, Align_Time_, Plot_Time, triallist_high, TrialStart_);
        
        [SDF_low_out] = spikedensityfunct_contrast(currcell, Align_Time_, Plot_Time, triallist_low_anti, TrialStart_);
        [SDF_med_out] = spikedensityfunct_contrast(currcell, Align_Time_, Plot_Time, triallist_low_anti, TrialStart_);
        [SDF_high_out] = spikedensityfunct_contrast(currcell, Align_Time_, Plot_Time, triallist_low_anti, TrialStart_);
        
        figure
        subplot(3,1,1)
        plot(Plot_Time(1):Plot_Time(2),SDF_low_in,Plot_Time(1):Plot_Time(2),SDF_low_out)
        subplot(3,1,2)
        plot(Plot_Time(1):Plot_Time(2),SDF_med_in,Plot_Time(1):Plot_Time(2),SDF_med_out)
        subplot(3,1,3)
        plot(Plot_Time(1):Plot_Time(2),SDF_high_in,Plot_Time(1):Plot_Time(2),SDF_high_out)
        title(cell2mat(cellID(cell)));
        set(gcf,'Color','white');
        
    end
