%truncate target-aligned SDF 20 ms before saccade
function [sSDF] = truncateSP_targ(sSDF,SRT,Plot_Time,span)

if size(sSDF,1) <= 1
    disp('Requires trial-by-trial matrix of SDFs...')
    return
end

if nargin < 4; span = 20; end


disp(['Truncating ' mat2str(span) ' ms before saccade...'])

for trl = 1:size(sSDF,1)
    if ~isnan(SRT(trl,1))
        sSDF(trl,(abs(Plot_Time(1))+round(SRT(trl,1))-span):end) = NaN;
    else
        sSDF(trl,1:length(Plot_Time(1):Plot_Time(2))) = NaN;
    end
end