%script setAlign

%set up alignment options for SDF
if Align_ == 's'
    Align_Time(1:length(Correct_),1) = 500;
    Plot_Time = [-200 800];
elseif Align_ == 'r'
    Align_Time = SRT(:,1);
    Plot_Time = [-400 200];
    %When Saccade aligned, still have 500 ms baseline + SRT.
    Align_Time = Align_Time + 500;
end