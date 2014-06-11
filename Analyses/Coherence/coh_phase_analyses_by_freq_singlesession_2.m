%phase x frequency, single session

%Need to have pre-calculated SFC

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: some phases need to be corrected by 180 degrees if the LFP was not
% inverted prior to calculating coherence.  This applies to the original
% 'allTL_shuff' data
%
% RPH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%this does the phase analysis over sessions and by frequency. It is a
%butchered and hacked version of coh_phase_analysis so it is inelegant and
%brute force


%what interval are you interested in?
timevec = isbetween(tout,[100 250]);

newmat = SFC(timevec,:);

for q = 1:size(newmat,2)
    
angs(q) = rad2deg(circ_mean(angle(newmat(:,q))));
end

figure
plot(f,angs)