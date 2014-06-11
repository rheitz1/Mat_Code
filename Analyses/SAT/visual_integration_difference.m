%integrate Tin - Din for target-aligned visual cells
%load and use grand averages

cd /volumes/Dump/Analyses/SAT/
load compileSAT_Med_NoMed_Vis_VisMove_targ.mat

%leak = .001:.001:.1;
%leak = .010
% leak = .001:.001:.01;
% leak = .011:.001:.02;
% leak = .021:.001:.03;
% leak = .031:.001:.04;
% leak = .041:.001:.05;
% leak = .051:.001:.06;
% leak = .061:.001:.07;
% leak = .071:.001:.08;
% leak = .081:.001:.09;
% leak = .091:.001:.10;

%create session-by-session Tin - Din
slow_diff = allwf_targ.in.slow_correct_made_dead - allwf_targ.out.slow_correct_made_dead;
med_diff = allwf_targ.in.med_correct - allwf_targ.out.med_correct;
fast_diff = allwf_targ.in.fast_correct_made_dead_withCleared - allwf_targ.out.fast_correct_made_dead_withCleared;

%set up integrators.  Start 100 ms before target on for now
integ.slow(1:size(allwf_targ.in.slow_correct_made_dead,1),1:1301) = 0;
integ.med(1:size(allwf_targ.in.slow_correct_made_dead,1),1:1301) = 0;
integ.fast(1:size(allwf_targ.in.slow_correct_made_dead,1),1:1301) = 0;


leak = .01;
gate = 0;%.001:.001:.1;

for g = 1:length(gate)
    
    for sess = 1:size(allwf_targ.in.slow_correct_made_dead,1)
        %for each cell, integrate from -100 to mean RT for correct, made deadlines in that condition.  Note
        %that we cannot really do this trial-by-trial without repeated random sampling
        
        curr_slow_diff = slow_diff(sess,:) - gate(g);
        curr_med_diff = med_diff(sess,:) - gate(g);
        curr_fast_diff = fast_diff(sess,:) - gate(g);
        
%         curr_slow_diff(find(curr_slow_diff < 0)) = 0;
%         curr_med_diff(find(curr_med_diff < 0)) = 0;
%         curr_fast_diff(find(curr_fast_diff < 0)) = 0;
        
        %implement gate
        %curr_slow_diff(find(curr_slow_diff
        
        for t = 2:RTs.slow_correct_made_dead(sess)+100 %add 100 because we have a 100 ms baseline period
            integ.slow(sess,t,g) = integ.slow(sess,t-1) + curr_slow_diff(t)  - (leak .* integ.slow(t-1));
        end
        
        if isnan(RTs.med_correct(sess))
            integ.med(sess,1:1301,g) = NaN;
        else
            for t = 2:RTs.med_correct(sess)+100
                integ.med(sess,t,g) = integ.med(sess,t-1) + curr_med_diff(t) - (leak .* integ.med(t-1));
            end
        end
        
        for t = 2:RTs.fast_correct_made_dead_withCleared(sess)+100
            integ.fast(sess,t,g) = integ.fast(sess,t-1) + curr_fast_diff(t) - (leak .* integ.fast(t-1));
        end
    end
end

figure
plot(-100:1200,squeeze(nanmean(nanmean(integ.slow,1),3)),'r',-100:1200,squeeze(nanmean(nanmean(integ.med,1),3)),'k',-100:1200,squeeze(nanmean(nanmean(integ.fast,1),3)),'g')