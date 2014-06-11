%reformat cmanding data for ERN analysis

%reorganize vector into matrix

%find AD channels
[file_name chan_name] = textread('UptonSEF.txt', '%s %s');
Plot_Time = [-300 600];
plotFlag = 1;

indexAD = 0;
for sess = 1:length(file_name)
    file_name(sess)
    
    
    %Load supporting variables
    load(cell2mat(file_name(sess)),cell2mat(chan_name(sess)),'GOCorrect','NOGOWrong','Sacc_of_interest','SecondSacc','Target_','TrialStart_','-mat')
    
    
    SRT = Sacc_of_interest(:,1) - Target_(:,1);
    
    %reformat only if AD channel is vector
    if size(eval([eval('cell2mat(chan_name(sess))')]),1) == 1
        for trl = 1:length(TrialStart_)
            %trl
            if ~isnan(TrialStart_(trl,1)) && ~isnan(Target_(trl,1))
                if trl ~= length(TrialStart_)
                    %find trial values and include 500 ms baseline period
                    temp(trl,1:3001) = eval([eval('cell2mat(chan_name(sess))') '((TrialStart_(trl,1) + Target_(trl,1) - 500):(TrialStart_(trl,1) + Target_(trl,1) + 2500))']);
                    %saccade align
                    if SRT(trl,1) > 0
                        temp_sac(trl,1:901) = temp(trl,SRT(trl,1) + (Plot_Time(1) + 500):SRT(trl,1) + (Plot_Time(2) + 500));
                    else
                        temp_sac(trl,1:901) = NaN;
                    end
                else
                    lgth = eval(['length(' eval('cell2mat(chan_name(sess))') ')']);
                    temp(trl,1:length(TrialStart_(trl,1)+Target_(trl,1)-500:lgth)) = eval([eval('cell2mat(chan_name(sess))') '((TrialStart_(trl,1) + Target_(trl,1) - 500):lgth)']);
                    if SRT(trl,1) > 0
                        temp_sac(trl,1:901) = temp(trl,SRT(trl,1) + (Plot_Time(1) + 500):SRT(trl,1) + Plot_Time(2) + 500);
                    else
                        temp_sac(trl,1:901) = NaN;
                    end
                end
            else
                temp(trl,1:3001) = NaN;
                temp_sac(trl,1:901) = NaN;
            end
        end
    else
        temp = eval([eval('cell2mat(chan_name(sess));')]);
        temp_sac = response_align(temp,SRT,Plot_Time);
    end
    
    eval([eval('cell2mat(chan_name(sess))') '=temp;']);
    eval([eval('cell2mat(chan_name(sess))') '_sac = temp_sac;'])
    
    indexAD = indexAD + 1;
    diffwave(indexAD,1:901) = nanmean(temp_sac(nonzeros(NOGOWrong),:)) - nanmean(temp_sac(nonzeros(GOCorrect),:));
    sig_correct_targ(indexAD,1:3001) = nanmean(temp(nonzeros(GOCorrect),1:3001));
    sig_errors_targ(indexAD,1:3001) = nanmean(temp(nonzeros(NOGOWrong),1:3001));
    sig_correct_sacc(indexAD,1:901) = nanmean(temp_sac(nonzeros(GOCorrect),:));
    sig_errors_sacc(indexAD,1:901) = nanmean(temp_sac(nonzeros(NOGOWrong),:));
    
    
    keep diffwave sig_correct_targ sig_errors_targ sig_correct_sacc ...
        sig_errors_sacc indexAD file_name chan_name Plot_Time plotFlag
end

%estimate onset times
std_diff = nanstd(diffwave,0,2);


crit = 1;
for sess = 1:size(diffwave,1)
    sigindex = diffwave(sess,:) < (crit*std_diff(sess))*-1;
      
    %use findRuns function to locate 50 consecutive significant
    %time bins. First of these will be onset time
    sigtimes = min(findRuns(sigindex,50));
        
    %convert to real time values and subtract by baseline
    if ~isempty(sigtimes)
        onset(sess,1) = sigtimes - abs(Plot_Time(1));
    else
        onset(sess,1) = NaN;
    end
        
    
    %plot for each session
    if plotFlag == 1
        plot(Plot_Time(1):Plot_Time(2),sig_correct_sacc(sess,:),'b',Plot_Time(1):Plot_Time(2),sig_errors_sacc(sess,:),'--b',Plot_Time(1):Plot_Time(2),diffwave(sess,:),'k')
        line([-300 600],[crit*std_diff(sess)*-1 crit*std_diff(sess)*-1])
        line([onset(sess,1) onset(sess,1)],[-.05 .05])
        xlim([Plot_Time(1) Plot_Time(2)])
        
        pause
        %sess_to_keep(sess,1) = input('keep?')
        cla
    end
    
    clear sigindex sigtimes
end