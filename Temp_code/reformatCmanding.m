%reformat cmanding data for ERN analysis

%reorganize vector into matrix

%find AD channels
varlist = who;
list = cell2mat(varlist(strmatch('AD',varlist)));

SRT = Sacc_of_interest(:,1) - Target_(:,1);

indexAD = 1;
for chan = 1:length(list)
    for trl = 1:length(TrialStart_)
        trl
        if ~isnan(TrialStart_(trl,1)) & ~isnan(Target_(trl,1))
             if trl ~= length(TrialStart_)
                temp(trl,1:3001) = eval([eval('list(chan,:)') '((TrialStart_(trl,1) + Target_(trl,1) - 500):(TrialStart_(trl,1) + Target_(trl,1) + 2500))']);
                %saccade align
                if SRT(trl) > 0
                    temp_sac(trl,1:901) = temp(trl,SRT(trl) + 200:SRT(trl)+1100);
                else
                    temp_sac(trl,1:901) = NaN;
                end
            else
                lgth = eval(['length(' eval('list(chan,:)') ')']);
                temp(trl,1:length(TrialStart_(trl,1)+Target_(trl,1)-500:lgth)) = eval([eval('list(chan,:)') '((TrialStart_(trl,1) + Target_(trl,1) - 500):lgth)']);
                if SRT(trl) > 0
                    temp_sac(trl,1:901) = temp(trl,SRT(trl) + 200:SRT(trl)+1100);
                else
                    temp_sac(trl,1:901) = NaN;
                end
            end
        else
            temp(trl,1:3001) = NaN;
            temp_sac(trl,1:901) = NaN;
        end
    end
    eval([eval('list(chan,:)') '=temp;']);
    eval([eval('list(chan,:)') '_sac = temp_sac;'])
    
    
    diffwave(indexAD,1:901) = nanmean(temp_sac(nonzeros(NOGOWrong),:)) - nanmean(temp_sac(nonzeros(GOCorrect),:));
    indexAD = indexAD + 1;
    clear temp temp_sac
end
clear list varlist
