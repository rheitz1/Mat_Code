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
flipsign = 0;

if flipsign == 1; disp('Flipping phase angles....'); end

timevec = isbetween(tout,[150 300]);


newmat = Pcoh_all.in.all(timevec,:,:);

for sess = 1:size(newmat,3)
    for q = 1:size(newmat,2)
        temp = angle(newmat(:,q,sess));
        temp = temp(:);
        
        angs(q,sess) = circ_mean(temp);
        clear temp
    end
end


for sess = 1:size(angs,2)
    new_angs.low(sess) = circ_mean(angs(find(f<10),sess));
    new_angs.lowGamma(sess) = circ_mean(angs(find(f>=40 & f<=60),sess));
    new_angs.highGamma(sess) = circ_mean(angs(find(f>60),sess));
end

figure
circ_plot(new_angs.low,'pretty','ob',true,'b')
circ_plot(new_angs.lowGamma,'pretty','ob',true,'r')
circ_plot(new_angs.highGamma,'pretty','ob',true,'g')



time_delay.low = (phase2time(circ_mean(new_angs.low),5)*10000)/10;
time_delay.lowGamma = (phase2time(circ_mean(new_angs.lowGamma),50)*10000)/10;
time_delay.highGamma = (phase2time(circ_mean(new_angs.highGamma),80)*10000)/10;

% 
% 
% 
% figure
% bar(f(2:end),rad2deg(new_angs(2:end)))
% xlim([0 100])
% ylim([-100 100])
% 
% time_delays = (phase2time(new_angs,f)*10000)/10;
% newax
% plot(f(2:end),time_delays(2:end))
% xlim([0 100])
% ylim([-20 20])
% 
