function saccLoc = dir2loc(EyeX_,EyeY_,saccDir,SRT,Target_)
%converts saccade direction in degrees to screen location

plotFlag = 0;

%implement gain correction from Temo
%SEYMOUR:
EyeX_gain = EyeX_* 14;
EyeY_gain = EyeY_* 12;

%QUINCY
%EyeX_gain = EyeX_* 14;
%EyeY_gain = EyeY_* 14;

for trl = 1:size(EyeX_,1)

    if saccDir(trl) > 337.5 || saccDir(trl) <= 22.5
        saccLoc(trl,1) = 0;
    elseif saccDir(trl) > 22.5 && saccDir(trl) <= 67.5
        saccLoc(trl,1) = 1;
    elseif saccDir(trl) > 67.5 && saccDir(trl) <= 112.5
        saccLoc(trl,1) = 2;
    elseif saccDir(trl) > 112.5 && saccDir(trl) <= 157.5
        saccLoc(trl,1) = 3;
    elseif saccDir(trl) > 157.5 && saccDir(trl) <= 202.5
        saccLoc(trl,1) = 4;  
    elseif saccDir(trl) > 202.5 && saccDir(trl) <= 247.5
        saccLoc(trl,1) = 5;
    elseif saccDir(trl) > 247.5 && saccDir(trl) <= 292.5
        saccLoc(trl,1) = 6;
    elseif saccDir(trl) > 292.5 && saccDir(trl) <= 337.5
        saccLoc(trl,1) = 7;
    else
        saccLoc(trl,1) = NaN;
    end

%more stringent calculation
% 
%     if saccDir(trl) > 340 || saccDir(trl) <= 20
%         saccLoc(trl,1) = 0;
%     elseif saccDir(trl) > 25 && saccDir(trl) <= 65
%         saccLoc(trl,1) = 1;
%     elseif saccDir(trl) > 70 && saccDir(trl) <= 110
%         saccLoc(trl,1) = 2;
%     elseif saccDir(trl) > 115 && saccDir(trl) <= 155
%         saccLoc(trl,1) = 3;
%     elseif saccDir(trl) > 160 && saccDir(trl) <= 200
%         saccLoc(trl,1) = 4;  
%     elseif saccDir(trl) > 205 && saccDir(trl) <= 245
%         saccLoc(trl,1) = 5;
%     elseif saccDir(trl) > 250 && saccDir(trl) <= 290
%         saccLoc(trl,1) = 6;
%     elseif saccDir(trl) > 295 && saccDir(trl) <= 335
%         saccLoc(trl,1) = 7;
%     else
%         saccLoc(trl,1) = NaN;
%     end
    
    
%for all trials
    if plotFlag == 1
        figure
        seekwindow = 150;
        endtime = SRT(trl) + 500 + 12.5;
        plot(EyeX_gain(trl,endtime-seekwindow:endtime+seekwindow),EyeY_gain(trl,endtime-seekwindow:endtime+seekwindow))

        %line([mean(EyeX_(CorrectTrials(trl),450:550)),mean(EyeX_(CorrectTrials(trl),endtime-50:endtime+50))],[mean(EyeY_(CorrectTrials(trl),450:550)),mean(EyeY_(CorrectTrials(trl),endtime-50:endtime+50))])
        xlim([min(min(EyeX_gain(endtime-seekwindow:endtime+seekwindow))) max(max(EyeX_gain(endtime-seekwindow:endtime+seekwindow)))])
        ylim([min(min(EyeY_gain(endtime-seekwindow:endtime+seekwindow))) max(max(EyeY_gain(endtime-seekwindow:endtime+seekwindow)))])

        title(['Trial: ' mat2str(trl) 'Crt Loc: ' mat2str(Target_(trl,2)) '  Dir:' mat2str(saccLoc(trl))])
        pause
        close all
    end
end
