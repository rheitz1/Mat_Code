cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
% [filename1 unit1] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
% [filename2 unit2] = textread('SAT_VisMove_Med_Q.txt','%s %s');
% [filename3 unit3] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
% [filename4 unit4] = textread('SAT_VisMove_Med_S.txt','%s %s');
[filename5 unit5] = textread('SAT_Move_NoMed_Q.txt','%s %s');
[filename6 unit6] = textread('SAT_Move_Med_Q.txt','%s %s');
[filename7 unit7] = textread('SAT_Move_NoMed_S.txt','%s %s');
[filename8 unit8] = textread('SAT_Move_Med_S.txt','%s %s');

 filename = [filename5 ; filename6 ; filename7 ; filename8];
 unit = [unit5 ; unit6 ; unit7 ; unit8];

include_med = 1;

for file = 1:length(filename)
    
    load(filename{file},unit{file},'Target_','SRT','SAT_','Correct_','Errors_')
    filename{file}
    
    
    
    SDF = block_switch_thresh(unit{file},0);
    
    slow_to_fast(file,:) = SDF.slow_to_fast;
    fast_to_slow(file,:) = SDF.fast_to_slow;
    
    if include_med & isnan(slow_to_fast(file,1))
        %designate slow_to_med as the same as slow_to_fast
        slow_to_fast(file,:) = SDF.slow_to_med;
    end
    
    
    keep filename file unit slow_to_fast fast_to_slow include_med
end
    
    
figure

sem.fast_to_slow = nanstd(fast_to_slow,[],1) ./ sqrt(size(fast_to_slow,1));
sem.slow_to_fast = nanstd(slow_to_fast,[],1) ./ sqrt(size(slow_to_fast,1));

plot(-2:2,nanmean(slow_to_fast),'g',-2:2,nanmean(slow_to_fast)-sem.slow_to_fast,'--g',-2:2,nanmean(slow_to_fast)+sem.slow_to_fast,'--g', ...
    -2:2,nanmean(fast_to_slow),'r',-2:2,nanmean(fast_to_slow)-sem.fast_to_slow,'--r',-2:2,nanmean(fast_to_slow)+sem.fast_to_slow,'--r')

box off

%ylim([200 1000])

%plot each session, but subtract mean so that it is just a change
correction = mean([fast_to_slow slow_to_fast],2);
cfast_to_slow = fast_to_slow - repmat(correction,1,5);
cslow_to_fast = slow_to_fast - repmat(correction,1,5);


figure
plot(-2:2,cslow_to_fast,'g',-2:2,cfast_to_slow,'r')
hold on
plot(-2:2,nanmean(cslow_to_fast),'k',-2:2,nanmean(cfast_to_slow),'--k','linewidth',3)
ylim([-.3 .3])
box off

% 
% for sess = 1:size(slow_to_fast,1)
%     plot(-2:2,dif_slow_to_fast(sess,:),'g',-2:2,dif_fast_to_slow(sess,:))
%     pause
%     cla
% end