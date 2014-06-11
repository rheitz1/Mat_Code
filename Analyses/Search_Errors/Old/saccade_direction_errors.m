
%NOTE: Target_(:,11) == 0 = homogeneous
IncorrectTrials = find(Errors_(:,5) == 1);
IncorrectTrials_hom = find(Errors_(:,5) == 1 & Target_(:,11) == 0);
IncorrectTrials_het = find(Errors_(:,5) == 1 & Target_(:,11) == 1);

%Where were they supposed to look?
incrt_loc_all(:,1) = Target_(IncorrectTrials,2);
incrt_loc_hom(:,1) = Target_(IncorrectTrials_hom,2);
incrt_loc_het(:,1) = Target_(IncorrectTrials_het,2);

%Where did they actually look?
incrt_loc_all(:,2) = SaccDir_(IncorrectTrials);
incrt_loc_hom(:,2) = SaccDir_(IncorrectTrials_hom);
incrt_loc_het(:,2) = SaccDir_(IncorrectTrials_het);

%What was the set size (set size 8 provides best tests
incrt_loc_all(:,3) = Target_(IncorrectTrials,5);
incrt_loc_hom(:,3) = Target_(IncorrectTrials_hom,5);
incrt_loc_het(:,3) = Target_(IncorrectTrials_het,5);





for trl = 1:size(incrt_loc,1)
    if incrt_loc(trl,3) == 8

        if incrt_loc(trl,1) == 0
            subplot(3,3,6)
            plot(EyeX_(IncorrectTrials(trl),SRT(IncorrectTrials(trl)-50+500:SRT+50+500)),EyeY_(IncorrectTrials(trl),SRT(IncorrectTrials(trl)-50+500:SRT+50+500))

       
        end
    end
end
prop_opp = opposite / length(IncorrectTrials)
prop_near = nearby / length(IncorrectTrials)
