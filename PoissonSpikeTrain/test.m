% Get exact Poisson probabilitie
%inTrain = 1:10:1000;

inTrain = nonzeros(DSP10a(1,:));

Signif=0.05;UserSI=-log(Signif);
duration = max(inTrain) - min(inTrain);
MU = length(inTrain) / duration;
anchor = 150;
minSpkInBurst = 3;
Burst_Index = 1;

% Find poisson probabilities and Surprise Index (SI) for entire Train.
% Use to find regions of interest.  When SI decreases, call that a possible
% end of burst and examine train leading up to that (from last end of
% burst).
Start_Index = 1;




while Start_Index < length(inTrain)
    ISI = diff(inTrain(Start_Index:end));
    cISI=cumsum(ISI(Start_Index:length(ISI)))+anchor;
    p=(poisscdf([1:length(cISI)]', cISI.*MU));
    p=(1-p);SI=-log(p);
    %find decreasing SI values
    EOB = find(diff(SI)<0,1);
    
    %Check to see if spikes leading up to current EOB is a burst. But only
    run = cumsum(ISI(Start_Index:EOB));
    p=(poisscdf([1:length(run)]',run.*MU));
    run_p = (1-p); SI = -log(p);
    
    
    MaxSI=-log(1-(poisscdf(EOB-Start_Index,(inTrain(EOB)-inTrain(Start_Index))*MU)));
    MaxSI
    if (length(run) > minSpkInBurst) & MaxSI > UserSI
        BOB(Burst_Index,1) = Start_Index;
        Start_Index = Start_Index + EOB + 1;
    else
        Start_Index = Start_Index + 1;
    end
    
    
    
end