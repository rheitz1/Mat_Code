%Compute and plot error-related negativity for each AD channel in file

[file_name] = textread('temp.txt', '%s');
%batch_list = dir('/volumes/Dump/Search_Data/*_SEARCH.mat');
%batch_list = dir('~/desktop/*_SEARCH.mat');
%batch_list = dir('/volumes/dump2/analyses/JPSTC/JPSTC_matrices/reg/correct_vs_errors_postsaccade/LFP-LFP/*.mat');
%batch_list2 = dir('/volumes/dump/analyses/JPSTC_Final/JPSTC_matrices/reg/LFP-LFP/WithinHemi/Bad-Spurious/*.mat');
%batch_list = cat(1,batch_list1,batch_list2);

%because there are more channels than there are sessions, we need an
%independent index to keep track of all correct and error ERPs across
%all possible LFPs
indexAD = 0;

q = '''';
c = ',';
qcq = [q c q];

plotFlag = 1;
printFlag = 0;
findOnset = 0;

%Initialize sess-by-sess variable
ERN.Oz.correct = NaN;
ERN.Oz.correct_early = NaN;
ERN.Oz.correct_mid = NaN;
ERN.Oz.correct_late = NaN;

ERN.Oz.errors = NaN;
ERN.Oz.errors_early = NaN;
ERN.Oz.errors_mid = NaN;
ERN.Oz.errors_late = NaN;

ERN.Oz.diffwave = NaN;
ERN.Oz.diffwave_early = NaN;
ERN.Oz.diffwave_mid = NaN;
ERN.Oz.diffwave_late = NaN;
Ozcount = 0;


ERN.T6.correct = NaN;
ERN.T6.correct_early = NaN;
ERN.T6.correct_mid = NaN;
ERN.T6.correct_late = NaN;

ERN.T6.errors = NaN;
ERN.T6.errors_early = NaN;
ERN.T6.errors_mid = NaN;
ERN.T6.errors_late = NaN;

ERN.T6.diffwave = NaN;
ERN.T6.diffwave_early = NaN;
ERN.T6.diffwave_mid = NaN;
ERN.T6.diffwave_late = NaN;
T6count = 0;



ERN.T5.correct = NaN;
ERN.T5.correct_early = NaN;
ERN.T5.correct_mid = NaN;
ERN.T5.correct_late = NaN;

ERN.T5.errors = NaN;
ERN.T5.errors_early = NaN;
ERN.T5.errors_mid = NaN;
ERN.T5.errors_late = NaN;

ERN.T5.diffwave = NaN;
ERN.T5.diffwave_early = NaN;
ERN.T5.diffwave_mid = NaN;
ERN.T5.diffwave_late = NaN;
T5count = 0;



ERN.C4.correct = NaN;
ERN.C4.correct_early = NaN;
ERN.C4.correct_mid = NaN;
ERN.C4.correct_late = NaN;

ERN.C4.errors = NaN;
ERN.C4.errors_early = NaN;
ERN.C4.errors_mid = NaN;
ERN.C4.errors_late = NaN;

ERN.C4.diffwave = NaN;
ERN.C4.diffwave_early = NaN;
ERN.C4.diffwave_mid = NaN;
ERN.C4.diffwave_late = NaN;
C4count = 0;



ERN.C3.correct = NaN;
ERN.C3.correct_early = NaN;
ERN.C3.correct_mid = NaN;
ERN.C3.correct_late = NaN;

ERN.C3.errors = NaN;
ERN.C3.errors_early = NaN;
ERN.C3.errors_mid = NaN;
ERN.C3.errors_late = NaN;

ERN.C3.diffwave = NaN;
ERN.C3.diffwave_early = NaN;
ERN.C3.diffwave_mid = NaN;
ERN.C3.diffwave_late = NaN;
C3count = 0;



ERN.F4.correct = NaN;
ERN.F4.correct_early = NaN;
ERN.F4.correct_mid = NaN;
ERN.F4.correct_late = NaN;

ERN.F4.errors = NaN;
ERN.F4.errors_early = NaN;
ERN.F4.errors_mid = NaN;
ERN.F4.errors_late = NaN;

ERN.F4.diffwave = NaN;
ERN.F4.diffwave_early = NaN;
ERN.F4.diffwave_mid = NaN;
ERN.F4.diffwave_late = NaN;
F4count = 0;



ERN.F3.correct = NaN;
ERN.F3.correct_early = NaN;
ERN.F3.correct_mid = NaN;
ERN.F3.correct_late = NaN;

ERN.F3.errors = NaN;
ERN.F3.errors_early = NaN;
ERN.F3.errors_mid = NaN;
ERN.F3.errors_late = NaN;

ERN.F3.diffwave = NaN;
ERN.F3.diffwave_early = NaN;
ERN.F3.diffwave_mid = NaN;
ERN.F3.diffwave_late = NaN;
F3count = 0;



ERN.LFP.correct = NaN;
ERN.LFP.correct_early = NaN;
ERN.LFP.correct_mid = NaN;
ERN.LFP.correct_late = NaN;

ERN.LFP.errors = NaN;
ERN.LFP.errors_early = NaN;
ERN.LFP.errors_mid = NaN;
ERN.LFP.errors_late = NaN;

ERN.LFP.diffwave = NaN;
ERN.LFP.diffwave_early = NaN;
ERN.LFP.diffwave_mid = NaN;
ERN.LFP.diffwave_late = NaN;
LFPcount = 0;




for sess = 1:size(file_name,1)
    file_name(sess)
    
    if plotFlag == 1
        f = figure;
        set(gcf,'color','white')
        orient landscape
    end
    
    %Load LFPs only
    ChanStruct = loadChan(cell2mat(file_name(sess)),'AD');
    decodeChanStruct
    
    %Load supporting variables
    load(cell2mat(file_name(sess)),'Target_','SRT','Correct_','Errors_','RFs','Decide_','newfile','-mat')
    
    %find # of channels loaded
    
    varlist = who;
    chanlist = varlist(strmatch('AD',varlist));
    clear varlist
    
    fixErrors
    %set correct and direction error trials
    mLim = ceil(size(Target_,1)*.33);
    lLim = mLim + mLim;
    
    correct = find(Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 100 & Target_(:,2) ~= 255);
    correct_early = find(Correct_(1:mLim,2) == 1 & SRT(1:mLim,1) < 2000 & SRT(1:mLim,1) > 100 & Target_(1:mLim,2) ~= 255);
    correct_mid = find(Correct_(mLim+1:lLim,2) == 1 & SRT(mLim+1:lLim,1) < 2000 & SRT(mLim+1:lLim,1) > 100 & Target_(mLim+1:lLim,2) ~= 255);
    correct_late = find(Correct_(lLim+1:end,2) == 1 & SRT(lLim+1:end,1) < 2000 & SRT(lLim+1:end,1) > 100 & Target_(lLim+1:end,2) ~= 255);
    
    
    errors = find(Errors_(:,5) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 100 & Target_(:,2) ~=255);
    errors_early = find(Errors_(1:mLim,5) == 1 & SRT(1:mLim,1) < 2000 & SRT(1:mLim,1) > 100 & Target_(1:mLim,2) ~= 255);
    errors_mid = find(Errors_(mLim+1:lLim,5) == 1 & SRT(mLim+1:lLim,1) < 2000 & SRT(mLim+1:lLim,1) > 100 & Target_(mLim+1:lLim,2) ~= 255);
    errors_late = find(Errors_(lLim+1:end,5) == 1 & SRT(lLim+1:end,1) < 2000 & SRT(lLim+1:end,1) > 100 & Target_(lLim+1:end,2) ~= 255);
    
    n.correct(sess,1) = length(correct);
    n.correct_early(sess,1) = length(correct_early);
    n.correct_mid(sess,1) = length(correct_mid);
    n.correct_late(sess,1) = length(correct_late);
    n.errors(sess,1) = length(errors);
    n.errors_early(sess,1) = length(errors_early);
    n.errors_mid(sess,1) = length(errors_mid);
    n.errors_late(sess,1) = length(errors_late);
    
    %equalize number of trials to hold constant signal-to-noise ratio
    if length(correct) > length(errors)
        correct = correct(randperm(length(errors)));
    elseif length(errors) > length(correct)
        errors = errors(randperm(length(correct)));
    end
    
    if length(correct_early) > length(errors_early)
        correct_early = correct_early(randperm(length(errors_early)));
    elseif length(errors_early) > length(correct_early)
        errors_early = errors_early(randperm(length(correct_early)));
    end
    
    if length(correct_mid) > length(errors_mid)
        correct_mid = correct_mid(randperm(length(errors_mid)));
    elseif length(errors_mid) > length(correct_mid)
        errors_mid = errors_mid(randperm(length(correct_mid)));
    end
    
    if length(correct_late) > length(errors_late)
        correct_late = correct_late(randperm(length(errors_late)));
    elseif length(errors_late) > length(correct_late)
        errors_late = errors_late(randperm(length(correct_late)));
    end
    
    
    
    %For error signal truncation, get SecondSaccade RT, if it exists
    %only needs to be run once per session
    getMonk
    
    Plot_Time = [-100 300];
    
    for chan = 1:length(chanlist)
        sig = eval(cell2mat(chanlist(chan)));
        
        %response align and truncate @ 2nd saccade (flag)
        sig_resp = response_align(sig,SRT,Plot_Time,1);
        
        %for response-aligned baseline (-200:-`00) from response onset
        base = nanmean(sig_resp(:,1:100),2);
        
        
        
        %on occassion, the signals were saturated at that time point.  To
        %prevent against skewing data by subtracting out saturated data,
        %set them to 0.
        %first find saturation value
        %         sat1 = min(min(sig));
        %         sat2 = max(max(sig));
        %         sat = max(abs(sat1),abs(sat2));
        %         sig_temp = sig;
        %         sig_temp(find(abs(sig_temp)) == abs(sat)) = 0;
        %
        %
        %for target-aligned baseline (-200:0) from target onset
        %base = nanmean(sig(:,400:500),2);
        
        basemat = repmat(base,1,length(Plot_Time(1):Plot_Time(2)));
        
        %baseline correct all trials
        sig_resp_bc = sig_resp - basemat;
        
        
        %set up signals
        sig_correct_resp_bc = sig_resp_bc(correct,:);
        sig_correct_resp_bc_early = sig_resp_bc(correct_early,:);
        sig_correct_resp_bc_mid = sig_resp_bc(correct_mid,:);
        sig_correct_resp_bc_late = sig_resp_bc(correct_late,:);
        
        sig_errors_resp_bc = sig_resp_bc(errors,:);
        sig_errors_resp_bc_early = sig_resp_bc(errors_early,:);
        sig_errors_resp_bc_mid = sig_resp_bc(errors_mid,:);
        sig_errors_resp_bc_late = sig_resp_bc(errors_late,:);
        
        diffwave = nanmean(sig_errors_resp_bc) - nanmean(sig_correct_resp_bc);
        diffwave_early = nanmean(sig_errors_resp_bc_early) - nanmean(sig_correct_resp_bc_early);
        diffwave_mid = nanmean(sig_errors_resp_bc_mid) - nanmean(sig_correct_resp_bc_mid);
        diffwave_late = nanmean(sig_errors_resp_bc_late) - nanmean(sig_correct_resp_bc_late);
        
        %         sig_correct_all_targbase(indexAD,1:length(plottime)) = nanmean(sig_correct_targ_bc);
        %         sig_errors_all_targbase(indexAD,1:length(plottime)) = nanmean(sig_errors_targ_bc);
        %         sig_correct_all_respbase(indexAD,1:length(plottime)) = nanmean(sig_correct_resp_bc);
        %         sig_errors_all_respbase(indexAD,1:length(plottime)) = nanmean(sig_errors_resp_bc);
        %         sig_correct_targ_all(indexAD,1:3001) = nanmean(sig_correct_targ);
        %         sig_errors_targ_all(indexAD,1:3001) = nanmean(sig_errors_targ);
        %         BEH(indexAD,1) = nanmean(SRT(correct));
        %         BEH(indexAD,2) = nanmean(SRT(errors));
        %         BEH(indexAD,3) = length(correct) / (length(correct) + length(errors));
        %         filename_all{indexAD,1} = newfile;
        %         filename_all{indexAD,2} = chanlist(chan);
        
        
        %Name channels and save
        %note that AD04 will be LFP if Quincy and EEG if Seymour
        if strmatch(cell2mat(chanlist(chan)),'AD01') == 1
            name = 'Oz';
            Ozcount = Ozcount + 1;
            ERN.Oz.correct(Ozcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc);
            ERN.Oz.correct_early(Ozcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_early);
            ERN.Oz.correct_mid(Ozcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_mid);
            ERN.Oz.correct_late(Ozcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_late);
            
            ERN.Oz.errors(Ozcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc);
            ERN.Oz.errors_early(Ozcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_early);
            ERN.Oz.errors_mid(Ozcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_mid);
            ERN.Oz.errors_late(Ozcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_late);
            
            ERN.Oz.diffwave(Ozcount,1:length(Plot_Time(1):Plot_Time(2))) = diffwave;
            ERN.Oz.diffwave_early(Ozcount,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_early;
            ERN.Oz.diffwave_mid(Ozcount,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_mid;
            ERN.Oz.diffwave_late(Ozcount,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_late;
            
        elseif strmatch(cell2mat(chanlist(chan)),'AD02') == 1
            name = 'T6';
            T6count = T6count + 1;
            ERN.T6.correct(T6count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc);
            ERN.T6.correct_early(T6count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_early);
            ERN.T6.correct_mid(T6count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_mid);
            ERN.T6.correct_late(T6count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_late);
            
            ERN.T6.errors(T6count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc);
            ERN.T6.errors_early(T6count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_early);
            ERN.T6.errors_mid(T6count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_mid);
            ERN.T6.errors_late(T6count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_late);
            
            ERN.T6.diffwave(T6count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave;
            ERN.T6.diffwave_early(T6count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_early;
            ERN.T6.diffwave_mid(T6count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_mid;
            ERN.T6.diffwave_late(T6count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_late;
            
            
        elseif strmatch(cell2mat(chanlist(chan)),'AD03') == 1
            name = 'T5';
            T5count = T5count + 1;
            ERN.T5.correct(T5count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc);
            ERN.T5.correct_early(T5count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_early);
            ERN.T5.correct_mid(T5count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_mid);
            ERN.T5.correct_late(T5count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_late);
            
            ERN.T5.errors(T5count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc);
            ERN.T5.errors_early(T5count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_early);
            ERN.T5.errors_mid(T5count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_mid);
            ERN.T5.errors_late(T5count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_late);
            
            ERN.T5.diffwave(T5count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave;
            ERN.T5.diffwave_early(T5count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_early;
            ERN.T5.diffwave_mid(T5count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_mid;
            ERN.T5.diffwave_late(T5count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_late;
            
            
            
        elseif strmatch(cell2mat(chanlist(chan)),'AD04') == 1 & monkey == 'S'
            name = 'C4';
            C4count = C4count + 1;
            ERN.C4.correct(C4count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc);
            ERN.C4.correct_early(C4count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_early);
            ERN.C4.correct_mid(C4count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_mid);
            ERN.C4.correct_late(C4count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_late);
            
            ERN.C4.errors(C4count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc);
            ERN.C4.errors_early(C4count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_early);
            ERN.C4.errors_mid(C4count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_mid);
            ERN.C4.errors_late(C4count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_late);
            
            ERN.C4.diffwave(C4count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave;
            ERN.C4.diffwave_early(C4count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_early;
            ERN.C4.diffwave_mid(C4count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_mid;
            ERN.C4.diffwave_late(C4count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_late;
            
            
        elseif strmatch(cell2mat(chanlist(chan)),'AD04') == 1 & monkey == 'Q'
            name = 'LFP';
            LFPcount = LFPcount + 1;
            ERN.LFP.correct(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc);
            ERN.LFP.correct_early(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_early);
            ERN.LFP.correct_mid(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_mid);
            ERN.LFP.correct_late(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_late);
            
            ERN.LFP.errors(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc);
            ERN.LFP.errors_early(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_early);
            ERN.LFP.errors_mid(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_mid);
            ERN.LFP.errors_late(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_late);
            
            ERN.LFP.diffwave(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = diffwave;
            ERN.LFP.diffwave_early(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_early;
            ERN.LFP.diffwave_mid(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_mid;
            ERN.LFP.diffwave_late(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_late;
            
            
        elseif strmatch(cell2mat(chanlist(chan)),'AD05') == 1
            name = 'C3';
            C3count = C3count + 1;
            ERN.C3.correct(C3count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc);
            ERN.C3.correct_early(C3count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_early);
            ERN.C3.correct_mid(C3count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_mid);
            ERN.C3.correct_late(C3count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_late);
            
            ERN.C3.errors(C3count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc);
            ERN.C3.errors_early(C3count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_early);
            ERN.C3.errors_mid(C3count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_mid);
            ERN.C3.errors_late(C3count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_late);
            
            ERN.C3.diffwave(C3count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave;
            ERN.C3.diffwave_early(C3count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_early;
            ERN.C3.diffwave_mid(C3count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_mid;
            ERN.C3.diffwave_late(C3count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_late;
            
            
        elseif strmatch(cell2mat(chanlist(chan)),'AD06') == 1
            name = 'F4';
            F4count = F4count + 1;
            ERN.F4.correct(F4count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc);
            ERN.F4.correct_early(F4count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_early);
            ERN.F4.correct_mid(F4count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_mid);
            ERN.F4.correct_late(F4count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_late);
            
            ERN.F4.errors(F4count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc);
            ERN.F4.errors_early(F4count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_early);
            ERN.F4.errors_mid(F4count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_mid);
            ERN.F4.errors_late(F4count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_late);
            
            ERN.F4.diffwave(F4count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave;
            ERN.F4.diffwave_early(F4count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_early;
            ERN.F4.diffwave_mid(F4count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_mid;
            ERN.F4.diffwave_late(F4count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_late;
            
            
        elseif strmatch(cell2mat(chanlist(chan)),'AD07') == 1
            name = 'F3';
            F3count = F3count + 1;
            ERN.F3.correct(F3count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc);
            ERN.F3.correct_early(F3count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_early);
            ERN.F3.correct_mid(F3count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_mid);
            ERN.F3.correct_late(F3count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_late);
            
            ERN.F3.errors(F3count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc);
            ERN.F3.errors_early(F3count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_early);
            ERN.F3.errors_mid(F3count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_mid);
            ERN.F3.errors_late(F3count,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_late);
            
            ERN.F3.diffwave(F3count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave;
            ERN.F3.diffwave_early(F3count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_early;
            ERN.F3.diffwave_mid(F3count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_mid;
            ERN.F3.diffwave_late(F3count,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_late;
            
            
        else
            name = 'LFP';
            LFPcount = LFPcount + 1;
            ERN.LFP.correct(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc);
            ERN.LFP.correct_early(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_early);
            ERN.LFP.correct_mid(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_mid);
            ERN.LFP.correct_late(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_resp_bc_late);
            
            ERN.LFP.errors(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc);
            ERN.LFP.errors_early(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_early);
            ERN.LFP.errors_mid(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_mid);
            ERN.LFP.errors_late(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_resp_bc_late);
            
            ERN.LFP.diffwave(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = diffwave;
            ERN.LFP.diffwave_early(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_early;
            ERN.LFP.diffwave_mid(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_mid;
            ERN.LFP.diffwave_late(LFPcount,1:length(Plot_Time(1):Plot_Time(2))) = diffwave_late;
            
            
        end
        
        
        %find ylims based on max of mean voltage between times -100:300
        %         t = abs(Plot_Time(1))-100:abs(Plot_Time(1))+300;
        %
        %         t_cor = nanmean(sig_correct_resp_bc);
        %         t_err = nanmean(sig_errors_resp_bc);
        %
        %         max_cor = max(abs(t_cor(t)));
        %         max_err = max(abs(t_err(t)));
        %
        %         newmax = max(max_cor,max_err);
        
        
        if plotFlag == 1
            if length(chanlist) <= 4
                subplot(2,2,chan)
                plot(Plot_Time(1):Plot_Time(2),nanmean(sig_correct_resp_bc_early),'b',Plot_Time(1):Plot_Time(2),nanmean(sig_errors_resp_bc_early),'--b',Plot_Time(1):Plot_Time(2),nanmean(sig_correct_resp_bc_mid),'r',Plot_Time(1):Plot_Time(2),nanmean(sig_errors_resp_bc_mid),'--r',Plot_Time(1):Plot_Time(2),nanmean(sig_correct_resp_bc_late),'k',Plot_Time(1):Plot_Time(2),nanmean(sig_errors_resp_bc_late),'--k')
                axis ij
                xlim([Plot_Time(1) Plot_Time(2)])
                %        ylim([-newmax newmax])
                title(name,'fontsize',13,'fontweight','bold')
            elseif length(chanlist) > 4 & length(chanlist) <= 6
                subplot(2,3,chan)
                plot(Plot_Time(1):Plot_Time(2),nanmean(sig_correct_resp_bc_early),'b',Plot_Time(1):Plot_Time(2),nanmean(sig_errors_resp_bc_early),'--b',Plot_Time(1):Plot_Time(2),nanmean(sig_correct_resp_bc_mid),'r',Plot_Time(1):Plot_Time(2),nanmean(sig_errors_resp_bc_mid),'--r',Plot_Time(1):Plot_Time(2),nanmean(sig_correct_resp_bc_late),'k',Plot_Time(1):Plot_Time(2),nanmean(sig_errors_resp_bc_late),'--k')
                axis ij
                xlim([Plot_Time(1) Plot_Time(2)])
                %       ylim([-newmax newmax])
                title(name,'fontsize',13,'fontweight','bold')
            elseif length(chanlist) > 6 & length(chanlist) <= 9
                subplot(3,3,chan)
                plot(Plot_Time(1):Plot_Time(2),nanmean(sig_correct_resp_bc_early),'b',Plot_Time(1):Plot_Time(2),nanmean(sig_errors_resp_bc_early),'--b',Plot_Time(1):Plot_Time(2),nanmean(sig_correct_resp_bc_mid),'r',Plot_Time(1):Plot_Time(2),nanmean(sig_errors_resp_bc_mid),'--r',Plot_Time(1):Plot_Time(2),nanmean(sig_correct_resp_bc_late),'k',Plot_Time(1):Plot_Time(2),nanmean(sig_errors_resp_bc_late),'--k')
                axis ij
                xlim([Plot_Time(1) Plot_Time(2)])
                %      ylim([-newmax newmax])
                title(name,'fontsize',13,'fontweight','bold')
            elseif length(chanlist) > 9
                subplot(4,4,chan)
                plot(Plot_Time(1):Plot_Time(2),nanmean(sig_correct_resp_bc_early),'b',Plot_Time(1):Plot_Time(2),nanmean(sig_errors_resp_bc_early),'--b',Plot_Time(1):Plot_Time(2),nanmean(sig_correct_resp_bc_mid),'r',Plot_Time(1):Plot_Time(2),nanmean(sig_errors_resp_bc_mid),'--r',Plot_Time(1):Plot_Time(2),nanmean(sig_correct_resp_bc_late),'k',Plot_Time(1):Plot_Time(2),nanmean(sig_errors_resp_bc_late),'--k')
                axis ij
                xlim([Plot_Time(1) Plot_Time(2)])
                %      ylim([-newmax newmax])
                title(name,'fontsize',13,'fontweight','bold')
            end
            
            %clear channel when done
            eval(['clear ' cell2mat(chanlist(chan))])
        end
        
        
        
        %clear old signals for safety
        clear sig_resp_correct sig_resp_errors basemat_correct basemat_errors ...
            sig_correct_bc sig_errors_bc
    end
    
    [ax h1] =           suplabel(['nCorrect = ' mat2str(length(correct)) ' nErrors = ' mat2str(length(errors))]);
    set(h1,'fontsize',13,'fontweight','bold')
    [ax h1] = suplabel(mat2str(cell2mat(file_name(sess))),'t');
    set(h1,'fontsize',13,'fontweight','bold')
    
    %     keep sig_correct_all_targbase sig_errors_all_targbase sig_correct_all_respbase ...
    %         sig_errors_all_respbase filename_all sig_correct_targ_all ...
    %         sig_correct_targ_all sig_errors_targ_all BEH indexAD plottime batch_list i plotFlag
    %
    if printFlag == 1
        eval(['print -dpdf ',q,'/volumes/Dump/Analyses/ERN/Early_Mid_Late/',cell2mat(file_name(sess)),'_ERN.pdf',q])
        close(f)
    end
    
    
    keep ERN *count file_name i q c qcq printFlag plotFlag findOnset Plot_Time n
end



%find ERN onset times
if findOnset == 1
    
    Monkey = 'Q';
    
    if Monkey == 'S'
        %For Seymour
        %std's will be artificially increased by artifacts at end of trace. Thus,
        %when computing, include only data -300:400
        Oz_std_diff = nanstd(ERN.Oz.diffwave(:,1:701),0,2);
        T5_std_diff = nanstd(ERN.T5.diffwave(:,1:701),0,2);
        T6_std_diff = nanstd(ERN.T6.diffwave(:,1:701),0,2);
        C3_std_diff = nanstd(ERN.C3.diffwave(:,1:701),0,2);
        C4_std_diff = nanstd(ERN.C4.diffwave(:,1:701),0,2);
        F3_std_diff = nanstd(ERN.F3.diffwave(:,1:701),0,2);
        F4_std_diff = nanstd(ERN.F4.diffwave(:,1:701),0,2);
        LFP_std_diff = nanstd(ERN.LFP.diffwave(:,1:701),0,2);
    elseif Monkey == 'Q'
        Oz_std_diff = nanstd(ERN.Oz.diffwave(:,1:701),0,2);
        T5_std_diff = nanstd(ERN.T5.diffwave(:,1:701),0,2);
        T6_std_diff = nanstd(ERN.T6.diffwave(:,1:701),0,2);
        LFP_std_diff = nanstd(ERN.LFP.diffwave(:,1:701),0,2);
    end
    
    
    Plot_Time = [-300 600];
    
    %crossing threshold for difference wave in sd
    
    crit = 1
    
    %dipoles seem to be flipped for Seymour.  For Quincy, criterion will be
    %negative (more negative difference wave)
    if Monkey == 'Q'
        crit = crit * -1;
    end
    
    
    if Monkey == 'S'
        for sess = 1:size(ERN.Oz.diffwave,1)
            if ~isempty(find(ERN.Oz.diffwave(sess,:) > crit*Oz_std_diff(sess),1))
                sigindex = ERN.Oz.diffwave(sess,:) > crit*Oz_std_diff(sess);
                %use findRuns function to locate 50 consecutive significant
                %time bins. First of these will be onset time
                sigtimes = min(findRuns(sigindex,50));
                
                %convert to real time values and subtract to account for
                %baseline.
                
                if ~isempty(sigtimes)
                    onset.Oz(sess,1) = sigtimes - abs(Plot_Time(1));
                else
                    onset.Oz(sess,1) = NaN;
                end
                
            else
                onset.Oz(sess,1) = NaN;
            end
        end
        
        for sess = 1:size(ERN.T5.diffwave,1)
            if ~isempty(find(ERN.T5.diffwave(sess,:) > crit*T5_std_diff(sess),1))
                sigindex = ERN.T5.diffwave(sess,:) > crit*T5_std_diff(sess);
                %use findRuns function to locate 50 consecutive significant
                %time bins. First of these will be onset time
                sigtimes = min(findRuns(sigindex,50));
                
                %convert to real time values and subtract to account for
                %baseline.
                
                if ~isempty(sigtimes)
                    onset.T5(sess,1) = sigtimes - abs(Plot_Time(1));
                else
                    onset.T5(sess,1) = NaN;
                end
                
            else
                onset.T5(sess,1) = NaN;
            end
        end
        
        for sess = 1:size(ERN.T6.diffwave,1)
            if ~isempty(find(ERN.T6.diffwave(sess,:) > crit*T6_std_diff(sess),1))
                sigindex = ERN.T6.diffwave(sess,:) > crit*T6_std_diff(sess);
                %use findRuns function to locate 50 consecutive significant
                %time bins. First of these will be onset time
                sigtimes = min(findRuns(sigindex,50));
                
                %convert to real time values and subtract to account for
                %baseline.
                
                if ~isempty(sigtimes)
                    onset.T6(sess,1) = sigtimes - abs(Plot_Time(1));
                else
                    onset.T6(sess,1) = NaN;
                end
                
            else
                onset.T6(sess,1) = NaN;
            end
        end
        
        for sess = 1:size(ERN.C3.diffwave,1)
            if ~isempty(find(ERN.C3.diffwave(sess,:) > crit*C3_std_diff(sess),1))
                sigindex = ERN.C3.diffwave(sess,:) > crit*C3_std_diff(sess);
                %use findRuns function to locate 50 consecutive significant
                %time bins. First of these will be onset time
                sigtimes = min(findRuns(sigindex,50));
                
                %convert to real time values and subtract to account for
                %baseline.
                
                if ~isempty(sigtimes)
                    onset.C3(sess,1) = sigtimes - abs(Plot_Time(1));
                else
                    onset.C3(sess,1) = NaN;
                end
                
            else
                onset.C3(sess,1) = NaN;
            end
        end
        
        for sess = 1:size(ERN.C4.diffwave,1)
            if ~isempty(find(ERN.C4.diffwave(sess,:) > crit*C4_std_diff(sess),1))
                sigindex = ERN.C4.diffwave(sess,:) > crit*C4_std_diff(sess);
                %use findRuns function to locate 50 consecutive significant
                %time bins. First of these will be onset time
                sigtimes = min(findRuns(sigindex,50));
                
                %convert to real time values and subtract to account for
                %baseline.
                
                if ~isempty(sigtimes)
                    onset.C4(sess,1) = sigtimes - abs(Plot_Time(1));
                else
                    onset.C4(sess,1) = NaN;
                end
                
            else
                onset.C4(sess,1) = NaN;
            end
        end
        
        for sess = 1:size(ERN.F3.diffwave,1)
            if ~isempty(find(ERN.F3.diffwave(sess,:) > crit*F3_std_diff(sess),1))
                sigindex = ERN.F3.diffwave(sess,:) > crit*F3_std_diff(sess);
                %use findRuns function to locate 50 consecutive significant
                %time bins. First of these will be onset time
                sigtimes = min(findRuns(sigindex,50));
                
                %convert to real time values and subtract to account for
                %baseline.
                
                if ~isempty(sigtimes)
                    onset.F3(sess,1) = sigtimes - abs(Plot_Time(1));
                else
                    onset.F3(sess,1) = NaN;
                end
                
            else
                onset.F3(sess,1) = NaN;
            end
        end
        
        for sess = 1:size(ERN.F4.diffwave,1)
            if ~isempty(find(ERN.F4.diffwave(sess,:) > crit*F4_std_diff(sess),1))
                sigindex = ERN.F4.diffwave(sess,:) > crit*F4_std_diff(sess);
                %use findRuns function to locate 50 consecutive significant
                %time bins. First of these will be onset time
                sigtimes = min(findRuns(sigindex,50));
                
                %convert to real time values and subtract to account for
                %baseline.
                
                if ~isempty(sigtimes)
                    onset.F4(sess,1) = sigtimes - abs(Plot_Time(1));
                else
                    onset.F4(sess,1) = NaN;
                end
                
            else
                onset.F4(sess,1) = NaN;
            end
        end
        
        for sess = 1:size(ERN.LFP.diffwave,1)
            if ~isempty(find(ERN.LFP.diffwave(sess,:) > crit*LFP_std_diff(sess),1))
                sigindex = ERN.LFP.diffwave(sess,:) > crit*LFP_std_diff(sess);
                %use findRuns function to locate 50 consecutive significant
                %time bins. First of these will be onset time
                sigtimes = min(findRuns(sigindex,50));
                
                %convert to real time values and subtract to account for
                %baseline.
                
                if ~isempty(sigtimes)
                    onset.LFP(sess,1) = sigtimes - abs(Plot_Time(1));
                else
                    onset.LFP(sess,1) = NaN;
                end
                
            else
                onset.LFP(sess,1) = NaN;
            end
        end
        
        
        
        
        
    elseif Monkey == 'Q'
        for sess = 1:size(ERN.Oz.diffwave,1)
            if ~isempty(find(ERN.Oz.diffwave(sess,:) < crit*Oz_std_diff(sess),1))
                sigindex = ERN.Oz.diffwave(sess,:) < crit*Oz_std_diff(sess);
                %use findRuns function to locate 50 consecutive significant
                %time bins. First of these will be onset time
                sigtimes = min(findRuns(sigindex,50));
                
                %convert to real time values and subtract to account for
                %baseline.
                
                if ~isempty(sigtimes)
                    onset.Oz(sess,1) = sigtimes - abs(Plot_Time(1));
                else
                    onset.Oz(sess,1) = NaN;
                end
                
            else
                onset.Oz(sess,1) = NaN;
            end
        end
        
        for sess = 1:size(ERN.T5.diffwave,1)
            if ~isempty(find(ERN.T5.diffwave(sess,:) < crit*T5_std_diff(sess),1))
                sigindex = ERN.T5.diffwave(sess,:) < crit*T5_std_diff(sess);
                %use findRuns function to locate 50 consecutive significant
                %time bins. First of these will be onset time
                sigtimes = min(findRuns(sigindex,50));
                
                %convert to real time values and subtract to account for
                %baseline.
                
                if ~isempty(sigtimes)
                    onset.T5(sess,1) = sigtimes - abs(Plot_Time(1));
                else
                    onset.T5(sess,1) = NaN;
                end
                
            else
                onset.T5(sess,1) = NaN;
            end
        end
        
        for sess = 1:size(ERN.T6.diffwave,1)
            if ~isempty(find(ERN.T6.diffwave(sess,:) < crit*T6_std_diff(sess),1))
                sigindex = ERN.T6.diffwave(sess,:) < crit*T6_std_diff(sess);
                %use findRuns function to locate 50 consecutive significant
                %time bins. First of these will be onset time
                sigtimes = min(findRuns(sigindex,50));
                
                %convert to real time values and subtract to account for
                %baseline.
                
                if ~isempty(sigtimes)
                    onset.T6(sess,1) = sigtimes - abs(Plot_Time(1));
                else
                    onset.T6(sess,1) = NaN;
                end
                
            else
                onset.T6(sess,1) = NaN;
            end
        end
        
        for sess = 1:size(ERN.LFP.diffwave,1)
            if ~isempty(find(ERN.LFP.diffwave(sess,:) < crit*LFP_std_diff(sess),1))
                sigindex = ERN.LFP.diffwave(sess,:) < crit*LFP_std_diff(sess);
                %use findRuns function to locate 50 consecutive significant
                %time bins. First of these will be onset time
                sigtimes = min(findRuns(sigindex,50));
                
                %convert to real time values and subtract to account for
                %baseline.
                
                if ~isempty(sigtimes)
                    onset.LFP(sess,1) = sigtimes - abs(Plot_Time(1));
                else
                    onset.LFP(sess,1) = NaN;
                end
                
            else
                onset.LFP(sess,1) = NaN;
            end
        end
        
    end
    
    keep ERN *onset *_diff n
end
