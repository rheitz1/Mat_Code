cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1 unit1] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
[filename2 unit2] = textread('SAT_Move_NoMed_Q.txt','%s %s');
[filename3 unit3] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
[filename4 unit4] = textread('SAT_Move_NoMed_S.txt','%s %s');

filename = [filename1 ; filename2 ; filename3 ; filename4];
unit = [unit1 ; unit2 ; unit3 ; unit4];



for file = 1:length(filename)
    
    load(filename{file},unit{file},'Target_','SRT','SAT_','Correct_','Errors_')
    filename{file}
    
    
    
    SDF = block_switch(unit{file},0);
    
    slow_to_fast(file,:) = SDF.slow_to_fast;
    fast_to_slow(file,:) = SDF.fast_to_slow;
    
    
    keep filename file unit slow_to_fast fast_to_slow
end
    
    
figure

sem.fast_to_slow = nanstd(fast_to_slow,[],1) ./ sqrt(size(fast_to_slow,1));
sem.slow_to_fast = nanstd(slow_to_fast,[],1) ./ sqrt(size(slow_to_fast,1));

plot(-2:2,nanmean(slow_to_fast),'g',-2:2,nanmean(slow_to_fast)-sem.slow_to_fast,'--g',-2:2,nanmean(slow_to_fast)+sem.slow_to_fast,'--g', ...
    -2:2,nanmean(fast_to_slow),'r',-2:2,nanmean(fast_to_slow)-sem.fast_to_slow,'--r',-2:2,nanmean(fast_to_slow)+sem.fast_to_slow,'--r')

box off

%ylim([200 1000])

%plot each session, but subtract mean so that it is just a change
m_slow_to_fast = nanmean(slow_to_fast,2);
m_fast_to_slow = nanmean(fast_to_slow,2);

m_slow_to_fast = repmat(m_slow_to_fast,1,5);
m_fast_to_slow = repmat(m_fast_to_slow,1,5);

dif_slow_to_fast = slow_to_fast - m_slow_to_fast;
dif_fast_to_slow = fast_to_slow - m_fast_to_slow;


figure
plot(-2:2,dif_slow_to_fast,'g',-2:2,dif_fast_to_slow,'r')
% 
% for sess = 1:size(slow_to_fast,1)
%     plot(-2:2,dif_slow_to_fast(sess,:),'g',-2:2,dif_fast_to_slow(sess,:))
%     pause
%     cla
% end