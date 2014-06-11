function [BS_Activity] = bootStrapActivity (TrialList,SpikeArrayBeg,SpikeArrayEnd,numboot)

if ~isempty(TrialList)    
    p_global
    mintrials=3;
    for i=1:length(TrialList)
        p_spik(TrialList(i));  % spike alignment routine to get raw histogram.
        try
            Activity(i,:)=Hist_raw(SpikeArrayBeg:SpikeArrayEnd)'; % Hist_raw: Raw spike train of an idividual trial
        catch
            disp(strcat('Problem in spike data for trial number= ',num2str(TrialList(i))));
        end
    end
    if (size(Activity,1)>mintrials)
        BS_Activity=bootstrpSDF(Activity,numboot);
    else
        BS_Activity=[];
    end
else
    BS_Activity=[];
end