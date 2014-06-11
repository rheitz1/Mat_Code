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
flipsign = 0;

if flipsign == 1; disp('Flipping phase angles....'); end

%what interval are you interested in?
startt = find(tout == 100);
endt = find(tout == 250);
timevec = startt:endt;

go = 1; %use just for code collapsing purposes.
%do you want to use only significant sessions?

highfreq = [0 10];
if go == 1
    
    %Phases weighted by coherence value
    %==========================================================
    tempang = angle(sum(sum(SFC(timevec,find(f >= highfreq(1) & f <= highfreq(2))))));
    
    if flipsign == 1
        tempang = tempang + pi;
        angs = tempang;
    else
        angs = tempang;
    end
end
angs0_10 = tempang;


highfreq = [11 20];
if go == 1
        
    %Phases weighted by coherence value
    %==========================================================
    tempang = angle(sum(sum(SFC(timevec,find(f >= highfreq(1) & f <= highfreq(2))))));

    if flipsign == 1
        tempang = tempang + pi;
        angs = tempang;
    else
        angs = tempang;
    end
end
angs11_20 = tempang;


highfreq = [21 30];
if go == 1
        
    %Phases weighted by coherence value
    %==========================================================
    tempang = angle(sum(sum(SFC(timevec,find(f >= highfreq(1) & f <= highfreq(2))))));

    if flipsign == 1
        tempang = tempang + pi;
        angs = tempang;
    else
        angs = tempang;
    end
end
angs21_30 = tempang;


highfreq = [31 40];
if go == 1
        
    %Phases weighted by coherence value
    %==========================================================
    tempang = angle(sum(sum(SFC(timevec,find(f >= highfreq(1) & f <= highfreq(2))))));

    if flipsign == 1
        tempang = tempang + pi;
        angs = tempang;
    else
        angs = tempang;
    end
end
angs31_40 = tempang;


highfreq = [41 50];
if go == 1
        
    %Phases weighted by coherence value
    %==========================================================
    tempang = angle(sum(sum(SFC(timevec,find(f >= highfreq(1) & f <= highfreq(2))))));

    if flipsign == 1
        tempang = tempang + pi;
        angs = tempang;
    else
        angs = tempang;
    end
end
angs41_50 = tempang;


highfreq = [51 60];
if go == 1
        
    %Phases weighted by coherence value
    %==========================================================
    tempang = angle(sum(sum(SFC(timevec,find(f >= highfreq(1) & f <= highfreq(2))))));

    if flipsign == 1
        tempang = tempang + pi;
        angs = tempang;
    else
        angs = tempang;
    end
end
angs51_60 = tempang;


highfreq = [61 70];
if go == 1
        
    %Phases weighted by coherence value
    %==========================================================
    tempang = angle(sum(sum(SFC(timevec,find(f >= highfreq(1) & f <= highfreq(2))))));

    if flipsign == 1
        tempang = tempang + pi;
        angs = tempang;
    else
        angs = tempang;
    end
end
angs61_70 = tempang;



highfreq = [71 80];
if go == 1
        
    %Phases weighted by coherence value
    %==========================================================
    tempang = angle(sum(sum(SFC(timevec,find(f >= highfreq(1) & f <= highfreq(2))))));

    if flipsign == 1
        tempang = tempang + pi;
        angs = tempang;
    else
        angs = tempang;
    end
end
angs71_80 = tempang;



highfreq = [81 90];
if go == 1
        
    %Phases weighted by coherence value
    %==========================================================
    tempang = angle(sum(sum(SFC(timevec,find(f >= highfreq(1) & f <= highfreq(2))))));

    if flipsign == 1
        tempang = tempang + pi;
        angs = tempang;
    else
        angs = tempang;
    end
end
angs81_90 = tempang;


highfreq = [91 100];
if go == 1
        
    %Phases weighted by coherence value
    %==========================================================
    tempang = angle(sum(sum(SFC(timevec,find(f >= highfreq(1) & f <= highfreq(2))))));

    if flipsign == 1
        tempang = tempang + pi;
        angs = tempang;
    else
        angs = tempang;
    end
end
angs91_100 = tempang;



mang0_10 = rad2deg(circ_mean(angs0_10(:)));
mang11_20 = rad2deg(circ_mean(angs11_20(:)));
mang21_30 = rad2deg(circ_mean(angs21_30(:)));
mang31_40 = rad2deg(circ_mean(angs31_40(:)));
mang41_50 = rad2deg(circ_mean(angs41_50(:)));
mang51_60 = rad2deg(circ_mean(angs51_60(:)));
mang61_70 = rad2deg(circ_mean(angs61_70(:)));
mang71_80 = rad2deg(circ_mean(angs71_80(:)));
mang81_90 = rad2deg(circ_mean(angs81_90(:)));
mang91_100 = rad2deg(circ_mean(angs91_100(:)));

figure
subplot(1,2,1)

circ_plot(angs0_10(:),'pretty','ro',true,'k')
circ_plot(angs11_20(:),'pretty','ro',true,'b')
circ_plot(angs21_30(:),'pretty','ro',true,'r')
circ_plot(angs31_40(:),'pretty','ro',true,'g')
circ_plot(angs41_50(:),'pretty','ro',true,'m')
circ_plot(angs51_60(:),'pretty','ro',true,'k')
circ_plot(angs61_70(:),'pretty','ro',true,'b')
circ_plot(angs71_80(:),'pretty','ro',true,'r')
circ_plot(angs81_90(:),'pretty','ro',true,'g')
circ_plot(angs91_100(:),'pretty','ro',true,'m')

subplot(1,2,2)
bar(5:10:95,[mang0_10 mang11_20 mang21_30 mang31_40 mang41_50 mang51_60 ...
    mang61_70 mang71_80 mang81_90 mang91_100])

ylim([-190 190])