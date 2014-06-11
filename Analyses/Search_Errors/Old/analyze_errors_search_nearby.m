IncorrectTrials = find(Errors_(:,5) == 1);
incrt_loc(:,1) = Target_(IncorrectTrials,2);
%incrt_loc(:,2) = saccLoc(IncorrectTrials);
incrt_loc(:,2) = SaccDir_(IncorrectTrials);
incrt_loc(:,3) = Target_(IncorrectTrials,5);

opposite = 0;
nearby = 0;

%Target_(:,11) == 0 == homogeneous


for trl = 1:size(incrt_loc,1)
    if incrt_loc(trl,3) == 8

        if incrt_loc(trl,1) == 0 & incrt_loc(trl,2) == 4
            opposite = opposite + 1;
        elseif (incrt_loc(trl,1) == 0 & incrt_loc(trl,2) == 1) || (incrt_loc(trl,1) == 0 & incrt_loc(trl,2) == 7)
            nearby = nearby + 1;

        elseif incrt_loc(trl,1) == 1 & incrt_loc(trl,2) == 5
            opposite = opposite + 1;
        elseif (incrt_loc(trl,1) == 1 & incrt_loc(trl,2) == 0) || (incrt_loc(trl,1) == 1 & incrt_loc(trl,2) == 2)
            nearby = nearby + 1;

        elseif incrt_loc(trl,1) == 2 & incrt_loc(trl,2) == 6
            opposite = opposite + 1;
        elseif (incrt_loc(trl,1) == 2 & incrt_loc(trl,2) == 1) || (incrt_loc(trl,1) == 2 & incrt_loc(trl,2) == 3)
            nearby = nearby + 1;


        elseif incrt_loc(trl,1) == 3 & incrt_loc(trl,2) == 7
            opposite = opposite + 1;
        elseif (incrt_loc(trl,1) == 3 & incrt_loc(trl,2) == 2) || (incrt_loc(trl,1) == 3 & incrt_loc(trl,2) == 4)
            nearby = nearby + 1;


        elseif incrt_loc(trl,1) == 4 & incrt_loc(trl,2) == 0
            opposite = opposite + 1;
        elseif (incrt_loc(trl,1) == 4 & incrt_loc(trl,2) == 3) || (incrt_loc(trl,1) == 4 & incrt_loc(trl,2) == 5)
            nearby = nearby + 1;


        elseif incrt_loc(trl,1) == 5 & incrt_loc(trl,2) == 1
            opposite = opposite + 1;
        elseif (incrt_loc(trl,1) == 5 & incrt_loc(trl,2) == 4) || (incrt_loc(trl,1) == 1 & incrt_loc(trl,2) == 6)
            nearby = nearby + 1;


        elseif incrt_loc(trl,1) == 6 & incrt_loc(trl,2) == 2
            opposite = opposite + 1;
        elseif (incrt_loc(trl,1) == 6 & incrt_loc(trl,2) == 5) || (incrt_loc(trl,1) == 6 & incrt_loc(trl,2) == 7)
            nearby = nearby + 1;


        elseif incrt_loc(trl,1) == 7 & incrt_loc(trl,2) == 3
            opposite = opposite + 1;
        elseif (incrt_loc(trl,1) == 7 & incrt_loc(trl,2) == 0) || (incrt_loc(trl,1) == 7 & incrt_loc(trl,2) == 6)
            nearby = nearby + 1;

        end
    end
end
prop_opp = opposite / length(IncorrectTrials)
prop_near = nearby / length(IncorrectTrials)
