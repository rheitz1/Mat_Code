% Repeated measures stats
% From Lorch & Myers, 1990 JEP:LMC
% Procedure:
%   1) Compute slope of regression line for each individual separately
%   2) submit all slopes to one-sample t-test against value of 0


%===========================================
% Q BEHAVIORAL EFFECTS; time-course = -400:800 ; test -300:0
%
% Q RT: sig
% Q ACC: sig
cd /volumes/Dump/Analyses/SAT/
load compileSAT_Beh_Q


pred = (0:2)';

ACCmat = [ACC.slow_made_dead' ; ACC.med' ; ACC.fast_made_dead_withCleared'];
RTmat = [RTs.slow_correct_made_dead' ; RTs.med_correct' ; RTs.fast_correct_made_dead_withCleared'];

for n = 1:size(ACCmat,2)
    [m(n) b(n) r(n)] = linreg(ACCmat(:,n),pred,0);
end

[a b c d] = ttest(m,0)


for n = 1:size(RTmat,2)
    [m(n) b(n) r(n)] = linreg(RTmat(:,n),pred,0);
end

[a b c d] = ttest(m,0)


c_


%===========================================
% S BEHAVIORAL EFFECTS; time-course = -400:800 ; test -300:0
%
% S RT: sig
% S ACC: sig
cd /volumes/Dump/Analyses/SAT/
load compileSAT_Beh_S


pred = (0:2)';

ACCmat = [ACC.slow_made_dead' ; ACC.med' ; ACC.fast_made_dead_withCleared'];
RTmat = [RTs.slow_correct_made_dead' ; RTs.med_correct' ; RTs.fast_correct_made_dead_withCleared'];

for n = 1:size(ACCmat,2)
    [m(n) b(n) r(n)] = linreg(ACCmat(:,n),pred,0);
end

[a b c d] = ttest(m,0)


for n = 1:size(RTmat,2)
    [m(n) b(n) r(n)] = linreg(RTmat(:,n),pred,0);
end

[a b c d] = ttest(m,0)


c_



%===========================================
% BASELINE EFFECTS; time-course = -400:800 ; test -300:0
% VIS + VISMOVE, Targ-aligned
%
% Together: sig
% Q: sig
% S: sig
cd /volumes/Dump/Analyses/SAT/
load compileSAT_baseline_vis_visMove_Med_NoMed

dif = basefast_made - baseslow_made;
issig.made_dead(1:length(dif),2) = 0;
issig.made_dead(find(issig.made_dead(:,1) < .05),2) = 1;

sigpos = find(dif > 0 & issig.made_dead(:,2) == 1);
signeg = find(dif < 0 & issig.made_dead(:,2) == 1);
signot = find(issig.made_dead(:,2) == 0);



sl = nanmean(allwf.slow_correct_made_dead(sigpos,100:400),2);
md = nanmean(allwf.med_correct(sigpos,100:400),2);
fs = nanmean(allwf.fast_correct_made_dead(sigpos,100:400),2);

sl = sl';
md = md';
fs = fs';
pred = (0:2)';

mat = [sl ; md ; fs];

for n = 1:size(mat,2)
    [m(n) b(n) r(n)] = linreg(mat(:,n),pred,0);
end

[a b c d] = ttest(m,0)


c_

%===========================================
% PURE MOVE CELLS: THRESHOLD; time-course = -2500:200 ; test -20:-10

% NOTE: not significant for each monkey when analyzed independently, but this is due to the noisy Neutral
% condition that wasn't alwasy present.  Main finding of Fast > Accurate highly significant for each
% monkey.
%
% Together: sig (p = .0478)
% Q: ns
% S: ns
cd /volumes/Dump/Analyses/SAT/Separate_Neuron_Type/
load compileSAT_Med_NoMed_Move_resp_longBase

sl = nanmean(allwf_move.in.slow_correct_made_dead(:,2480:2490),2);
md = nanmean(allwf_move.in.med_correct(:,2480:2490),2);
fs = nanmean(allwf_move.in.fast_correct_made_dead_withCleared(:,2480:2490),2);

sl = sl';
md = md';
fs = fs';
pred = (0:2)';

mat = [sl ; md ; fs];

for n = 1:size(mat,2)
    [m(n)] = linreg(mat(:,n),pred,0);
end

[a b c d] = ttest(m,0)


c_


%============================================
% PURE MOVE CELLS: THRESHOLD x nTile ; time-course = -2500:200 ; test -20:-10
%
% Note: here, non-significant is a GOOD thing
% Together: ns / ns / ns
% Q: ns / ns / ns
% S: ns / ns / ns
cd /volumes/Dump/Analyses/SAT/Separate_Neuron_Type/
load compileSAT_Med_NoMed_Move_resp_longBase

sl.slow = (nanmean(allwf_move.in.slow_correct_made_dead_binSLOW(:,2480:2490),2))';
sl.med = (nanmean(allwf_move.in.slow_correct_made_dead_binMED(:,2480:2490),2))';
sl.fast = (nanmean(allwf_move.in.slow_correct_made_dead_binFAST(:,2480:2490),2))';

md.slow = (nanmean(allwf_move.in.med_correct_binSLOW(:,2480:2490),2))';
md.med = (nanmean(allwf_move.in.med_correct_binMED(:,2480:2490),2))';
md.fast = (nanmean(allwf_move.in.med_correct_binFAST(:,2480:2490),2))';

fs.slow = (nanmean(allwf_move.in.fast_correct_made_dead_withCleared_binSLOW(:,2480:2490),2))';
fs.med = (nanmean(allwf_move.in.fast_correct_made_dead_withCleared_binMED(:,2480:2490),2))';
fs.fast = (nanmean(allwf_move.in.fast_correct_made_dead_withCleared_binFAST(:,2480:2490),2))';

pred = (0:2)';

mat1 = [sl.slow ; sl.med ; sl.fast];
mat2 = [md.slow ; md.med ; md.fast];
mat3 = [fs.slow ; fs.med ; fs.fast];




for n = 1:size(mat1,2)
    [m(n)] = linreg(mat1(:,n),pred,0);
end

[a b c d] = ttest(m,0)

clear m b r n a b c d


for n = 1:size(mat2,2)
    [m(n)] = linreg(mat2(:,n),pred,0);
end

[a b c d] = ttest(m,0)

clear m b r n a b c d


for n = 1:size(mat3,2)
    [m(n)] = linreg(mat3(:,n),pred,0);
end

[a b c d] = ttest(m,0)

clear m b r n a b c d

c_

%===========================================
% VIS-MOVE CELLS: THRESHOLD; time-course = -2500:200 ; test -20:-10
%
% Together: sig
% Q: sig
% S: sig
cd /volumes/Dump/Analyses/SAT/Separate_Neuron_Type/
load compileSAT_Med_NoMed_VisMove_resp_longBase

sl = nanmean(allwf_move.in.slow_correct_made_dead(:,2480:2490),2);
md = nanmean(allwf_move.in.med_correct(:,2480:2490),2);
fs = nanmean(allwf_move.in.fast_correct_made_dead_withCleared(:,2480:2490),2);

sl = sl';
md = md';
fs = fs';
pred = (0:2)';

mat = [sl ; md ; fs];

for n = 1:size(mat,2)
    [m(n)] = linreg(mat(:,n),pred,0);
end

[a b c d] = ttest(m,0)


c_



%============================================
% VIS-MOVE CELLS: THRESHOLD x nTile ; time-course = -2500:200 ; test -20:-10
%
% Note: here, non-significant is a GOOD thing
% Together: ns / ns / ns
% Q: ns / ns / ns
% S: ns / ns / ns

cd /volumes/Dump/Analyses/SAT/Separate_Neuron_Type/
load compileSAT_Med_NoMed_VisMove_resp_longBase

sl.slow = (nanmean(allwf_move.in.slow_correct_made_dead_binSLOW(:,2480:2490),2))';
sl.med = (nanmean(allwf_move.in.slow_correct_made_dead_binMED(:,2480:2490),2))';
sl.fast = (nanmean(allwf_move.in.slow_correct_made_dead_binFAST(:,2480:2490),2))';

md.slow = (nanmean(allwf_move.in.med_correct_binSLOW(:,2480:2490),2))';
md.med = (nanmean(allwf_move.in.med_correct_binMED(:,2480:2490),2))';
md.fast = (nanmean(allwf_move.in.med_correct_binFAST(:,2480:2490),2))';

fs.slow = (nanmean(allwf_move.in.fast_correct_made_dead_withCleared_binSLOW(:,2480:2490),2))';
fs.med = (nanmean(allwf_move.in.fast_correct_made_dead_withCleared_binMED(:,2480:2490),2))';
fs.fast = (nanmean(allwf_move.in.fast_correct_made_dead_withCleared_binFAST(:,2480:2490),2))';

pred = (0:2)';

mat1 = [sl.slow ; sl.med ; sl.fast];
mat2 = [md.slow ; md.med ; md.fast];
mat3 = [fs.slow ; fs.med ; fs.fast];




for n = 1:size(mat1,2)
    [m(n)] = linreg(mat1(:,n),pred,0);
end

[a b c d] = ttest(m,0)

clear m b r n a b c d


for n = 1:size(mat2,2)
    [m(n)] = linreg(mat2(:,n),pred,0);
end

[a b c d] = ttest(m,0)

clear m b r n a b c d


for n = 1:size(mat3,2)
    [m(n)] = linreg(mat3(:,n),pred,0);
end

[a b c d] = ttest(m,0)

clear m b r n a b c d

c_


%===========================================
% VIS + VISMOVE CELLS: Target Aligned: matched RT; time-course = -100:900 ; test 100:125 & 200:250
%
% Together:  earlier: ns    later: sig
% Q:         earlier: sig   later: sig
% S:         earlier: ns    later: sig
cd /volumes/Dump/Analyses/SAT/
load compileSAT_Med_NoMed_Vis_VisMove_targ

sl_1 = (nanmean(allwf_targ.in.slow_correct_match_med(:,200:225),2))';
md_1 = (nanmean(allwf_targ.in.med_correct_match_med(:,200:225),2))';
fs_1 = (nanmean(allwf_targ.in.fast_correct_match_med(:,200:225),2))';

sl_2 = (nanmean(allwf_targ.in.slow_correct_match_med(:,300:350),2))';
md_2 = (nanmean(allwf_targ.in.med_correct_match_med(:,300:350),2))';
fs_2 = (nanmean(allwf_targ.in.fast_correct_match_med(:,300:350),2))';


pred = (0:2)';

mat1 = [sl_1 ; md_1 ; fs_1];
mat2 = [sl_2 ; md_2 ; fs_2];

for n = 1:size(mat1,2)
    [m(n) b(n) r(n)] = linreg(mat1(:,n),pred,0);
end

[a b c d] = ttest(m,0)


for n = 1:size(mat2,2)
    [m(n) b(n) r(n)] = linreg(mat2(:,n),pred,0);
end

[a b c d] = ttest(m,0)

c_



%===========================================
% VISMOVE + MOVE CELLS: Response-aligned: matched RT; time-course = -2500:200 ; test -20:-10 before saccade
%
% Together: sig
% Q: ns
% S: sig
cd /volumes/Dump/Analyses/SAT/
load compileSAT_Med_NoMed_VisMove_Move_resp_longBase

sl = (nanmean(allwf_move.in.slow_correct_match_med(:,2480:2490),2))';
md = (nanmean(allwf_move.in.med_correct_match_med(:,2480:2490),2))';
fs = (nanmean(allwf_move.in.fast_correct_match_med(:,2480:2490),2))';




pred = (0:2)';

mat = [sl ; md ; fs];


for n = 1:size(mat,2)
    [m(n)] = linreg(mat(:,n),pred,0);
end

[a b c d] = ttest(m,0)



c_



%===================================================
% VIS + VIS-MOVE CELLS: ACTIVITY DIFFERENCES; time-course = -100:900 ; test 100:125 & 250:300
% Together:     Earlier: sig      Later: sig
% Q:            Earlier: sig      Later: sig
% S:            Earlier: sig      Later: sig
cd /volumes/Dump/Analyses/SAT/
load compileSAT_Med_NoMed_Vis_VisMove_targ

sl_1 = nanmean(allwf_targ.in.slow_correct_made_dead(:,200:225),2);
md_1 = nanmean(allwf_targ.in.med_correct(:,200:225),2);
fs_1 = nanmean(allwf_targ.in.fast_correct_made_dead_withCleared(:,200:225),2);

sl_2 = nanmean(allwf_targ.in.slow_correct_made_dead(:,350:400),2);
md_2 = nanmean(allwf_targ.in.med_correct(:,350:400),2);
fs_2 = nanmean(allwf_targ.in.fast_correct_made_dead_withCleared(:,350:400),2);

sl_1 = sl_1';
md_1 = md_1';
fs_1 = fs_1';

sl_2 = sl_2';
md_2 = md_2';
fs_2 = fs_2';

pred = (0:2)';

mat1 = [sl_1 ; md_1 ; fs_1];
mat2 = [sl_2 ; md_2 ; fs_2];

for n = 1:size(mat1,2)
    [m(n)] = linreg(mat1(:,n),pred,0);
end

[a b c d] = ttest(m,0)

clear m b r n a b c d

for n = 1:size(mat2,2)
    [m(n)] = linreg(mat2(:,n),pred,0);
end

[a b c d] = ttest(m,0)

c_


%======================================================
% MOVEMENT INTEGRATORS: PURE MOVE
% Note: here NON-SIGNIFICANT is a GOOD thing
%
% Together:     Made Dead:  ns    Missed Dead: ns
% Q:            Made Dead:  ns    Missed Dead: ns
% S:            Made Dead:  ns    Missed Dead: ns
cd /volumes/Dump/Analyses/SAT/Separate_Neuron_Type/
load compileSAT_move_integrators_changeLeak_move_only

sl_made = nanmean(leaky_integrated_in.slow_correct_made_dead(:,980:990,10),2);
md = nanmean(leaky_integrated_in.med_correct(:,980:990,10),2);
fs_made = nanmean(leaky_integrated_in.fast_correct_made_dead(:,980:990,10),2);
sl_miss = nanmean(leaky_integrated_in.slow_correct_missed_dead(:,980:990,10),2);
fs_miss = nanmean(leaky_integrated_in.fast_correct_missed_dead(:,980:990,10),2);

sl_made = sl_made';
sl_miss = sl_miss';
md = md';
fs_made = fs_made';
fs_miss = fs_miss';

mat1 = [sl_made ; md ; fs_made];
mat2 = [sl_miss ; md ; fs_miss];

pred = (0:2)';


for n = 1:size(mat1,2)
    [m(n)] = linreg(mat1(:,n),pred,0);
end

[a b c d] = ttest(m,0)

clear m b r n a b c d

for n = 1:size(mat2,2)
    [m(n)] = linreg(mat2(:,n),pred,0);
end

[a b c d] = ttest(m,0)

c_



%======================================================
% MOVEMENT INTEGRATORS: VISMOVE
% Note: here NON-SIGNIFICANT is a GOOD thing
%
% Together:     Made Dead:  ns    Missed Dead: ns
% Q:            Made Dead:  ns    Missed Dead: ns
% S:            Made Dead:  ns    Missed Dead: ns
cd /volumes/Dump/Analyses/SAT/Separate_Neuron_Type/
load compileSAT_move_integrators_changeLeak_vismove_only

sl_made = nanmean(leaky_integrated_in.slow_correct_made_dead(:,980:990,10),2);
md = nanmean(leaky_integrated_in.med_correct(:,980:990,10),2);
fs_made = nanmean(leaky_integrated_in.fast_correct_made_dead(:,980:990,10),2);
sl_miss = nanmean(leaky_integrated_in.slow_correct_missed_dead(:,980:990,10),2);
fs_miss = nanmean(leaky_integrated_in.fast_correct_missed_dead(:,980:990,10),2);

sl_made = sl_made';
sl_miss = sl_miss';
md = md';
fs_made = fs_made';
fs_miss = fs_miss';

mat1 = [sl_made ; md ; fs_made];
mat2 = [sl_miss ; md ; fs_miss];

pred = (0:2)';


for n = 1:size(mat1,2)
    [m(n)] = linreg(mat1(:,n),pred,0);
end

[a b c d] = ttest(m,0)

clear m b r n a b c d

for n = 1:size(mat2,2)
    [m(n)] = linreg(mat2(:,n),pred,0);
end

[a b c d] = ttest(m,0)

c_




%======================================================
% MOVEMENT INTEGRATORS x nTiles: PURE MOVE
% NOTE: Here non-significance is a GOOD thing
% Together:
%   Slow Made: ns  Miss: sig
%   Med: ns
%   Fast Made: sig  Miss: ns
%
% Q:
%   Slow Made: ns  Miss: ns
%   Med: ns
%   Fast Made: sig Miss: ns
% S:
%   Slow Made: ns Miss: sig
%   Med: ns
%   Fast Made: sig Miss: sig

cd /volumes/Dump/Analyses/SAT/Separate_Neuron_Type/
load compileSAT_move_integrators_changeLeak_move_only

sl_made_binSLOW = (nanmean(leaky_integrated_in.slow_correct_made_dead_binSlow(:,980:990,10),2))';
sl_made_binMED = (nanmean(leaky_integrated_in.slow_correct_made_dead_binMed(:,980:990,10),2))';
sl_made_binFAST = (nanmean(leaky_integrated_in.slow_correct_made_dead_binFast(:,980:990,10),2))';

sl_miss_binSLOW = (nanmean(leaky_integrated_in.slow_correct_missed_dead_binSlow(:,980:990,10),2))';
sl_miss_binMED = (nanmean(leaky_integrated_in.slow_correct_missed_dead_binMed(:,980:990,10),2))';
sl_miss_binFAST = (nanmean(leaky_integrated_in.slow_correct_missed_dead_binFast(:,980:990,10),2))';

md_binSLOW = (nanmean(leaky_integrated_in.med_correct_binSlow(:,980:990,10),2))';
md_binMED = (nanmean(leaky_integrated_in.med_correct_binMed(:,980:990,10),2))';
md_binFAST = (nanmean(leaky_integrated_in.med_correct_binFast(:,980:990,10),2))';

fs_made_binSLOW = (nanmean(leaky_integrated_in.fast_correct_made_dead_binSlow(:,980:990,10),2))';
fs_made_binMED = (nanmean(leaky_integrated_in.fast_correct_made_dead_binMed(:,980:990,10),2))';
fs_made_binFAST = (nanmean(leaky_integrated_in.fast_correct_made_dead_binFast(:,980:990,10),2))';

fs_miss_binSLOW = (nanmean(leaky_integrated_in.fast_correct_missed_dead_binSlow(:,980:990,10),2))';
fs_miss_binMED = (nanmean(leaky_integrated_in.fast_correct_missed_dead_binMed(:,980:990,10),2))';
fs_miss_binFAST = (nanmean(leaky_integrated_in.fast_correct_missed_dead_binFast(:,980:990,10),2))';


mat1 = [sl_made_binSLOW ; sl_made_binMED ; sl_made_binFAST];
mat2 = [sl_miss_binSLOW ; sl_miss_binMED ; sl_miss_binFAST];
mat3 = [md_binSLOW ; md_binMED ; md_binFAST];
mat4 = [fs_made_binSLOW ; fs_made_binMED ; fs_made_binFAST];
mat5 = [fs_miss_binSLOW ; fs_miss_binMED ; fs_miss_binFAST];

pred = (0:2)';


for n = 1:size(mat1,2)
    [m(n)] = linreg(mat1(:,n),pred,0);
end

[a b c d] = ttest(m,0)

clear m b r n a b c d

for n = 1:size(mat2,2)  %IS SIG @ p = .0315
    [m(n)] = linreg(mat2(:,n),pred,0);
end

[a b c d] = ttest(m,0)
clear m b r n a b c d

for n = 1:size(mat3,2)
    [m(n)] = linreg(mat3(:,n),pred,0);
end

[a b c d] = ttest(m,0)
clear m b r n a b c d

for n = 1:size(mat4,2)  % IS SIG @ p < 0.0001
    [m(n)] = linreg(mat4(:,n),pred,0);
end

[a b c d] = ttest(m,0)
clear m b r n a b c d

for n = 1:size(mat5,2)
    [m(n)] = linreg(mat5(:,n),pred,0);
end

[a b c d] = ttest(m,0)
clear m b r n a b c d


c_



%======================================================
% MOVEMENT INTEGRATORS x nTiles: PURE MOVE (LONG BASELINE)
% time-course = -2000:200 ; test -20:-10
cd /volumes/Dump/Analyses/SAT/Separate_Neuron_Type/
load compileSAT_move_integrators_changeLeak_move_only_longBase

sl_made_binSLOW = (nanmean(leaky_integrated_in.slow_correct_made_dead_binSlow(:,1980:1990,10),2))';
sl_made_binMED = (nanmean(leaky_integrated_in.slow_correct_made_dead_binMed(:,1980:1990,10),2))';
sl_made_binFAST = (nanmean(leaky_integrated_in.slow_correct_made_dead_binFast(:,1980:1990,10),2))';

sl_miss_binSLOW = (nanmean(leaky_integrated_in.slow_correct_missed_dead_binSlow(:,1980:1990,10),2))';
sl_miss_binMED = (nanmean(leaky_integrated_in.slow_correct_missed_dead_binMed(:,1980:1990,10),2))';
sl_miss_binFAST = (nanmean(leaky_integrated_in.slow_correct_missed_dead_binFast(:,1980:1990,10),2))';

md_binSLOW = (nanmean(leaky_integrated_in.med_correct_binSlow(:,1980:1990,10),2))';
md_binMED = (nanmean(leaky_integrated_in.med_correct_binMed(:,1980:1990,10),2))';
md_binFAST = (nanmean(leaky_integrated_in.med_correct_binFast(:,1980:1990,10),2))';

fs_made_binSLOW = (nanmean(leaky_integrated_in.fast_correct_made_dead_binSlow(:,1980:1990,10),2))';
fs_made_binMED = (nanmean(leaky_integrated_in.fast_correct_made_dead_binMed(:,1980:1990,10),2))';
fs_made_binFAST = (nanmean(leaky_integrated_in.fast_correct_made_dead_binFast(:,1980:1990,10),2))';

fs_miss_binSLOW = (nanmean(leaky_integrated_in.fast_correct_missed_dead_binSlow(:,1980:1990,10),2))';
fs_miss_binMED = (nanmean(leaky_integrated_in.fast_correct_missed_dead_binMed(:,1980:1990,10),2))';
fs_miss_binFAST = (nanmean(leaky_integrated_in.fast_correct_missed_dead_binFast(:,1980:1990,10),2))';


mat1 = [sl_made_binSLOW ; sl_made_binMED ; sl_made_binFAST];
mat2 = [sl_miss_binSLOW ; sl_miss_binMED ; sl_miss_binFAST];
mat3 = [md_binSLOW ; md_binMED ; md_binFAST];
mat4 = [fs_made_binSLOW ; fs_made_binMED ; fs_made_binFAST];
mat5 = [fs_miss_binSLOW ; fs_miss_binMED ; fs_miss_binFAST];

pred = (0:2)';


for n = 1:size(mat1,2)
    [m(n)] = linreg(mat1(:,n),pred,0);
end

[a b c d] = ttest(m,0)

clear m b r n a b c d

for n = 1:size(mat2,2) %IS SIG (borderline if bonferroni)... p = .0315
    [m(n)] = linreg(mat2(:,n),pred,0);
end

[a b c d] = ttest(m,0)
clear m b r n a b c d

for n = 1:size(mat3,2)
    [m(n)] = linreg(mat3(:,n),pred,0);
end

[a b c d] = ttest(m,0)
clear m b r n a b c d

for n = 1:size(mat4,2) % IS SIG... p = .00011209
    [m(n)] = linreg(mat4(:,n),pred,0);
end

[a b c d] = ttest(m,0)
clear m b r n a b c d

for n = 1:size(mat5,2)
    [m(n)] = linreg(mat5(:,n),pred,0);
end

[a b c d] = ttest(m,0)
clear m b r n a b c d


c_



%======================================================
% MOVEMENT INTEGRATORS x nTiles: VISMOVE
% NOTE: Here non-significance is a GOOD thing
% Together:
%   Slow Made: ns  Miss: ns
%   Med: sig
%   Fast Made: sig  Miss: ns
%
% Q:
%   Slow Made: ns  Miss: ns
%   Med: sig
%   Fast Made: sig Miss: sig
% S:
%   Slow Made: ns Miss: ns
%   Med: sig
%   Fast Made: sig Miss: ns

cd /volumes/Dump/Analyses/SAT/Separate_Neuron_Type/
load compileSAT_move_integrators_changeLeak_VisMove_only

sl_made_binSLOW = (nanmean(leaky_integrated_in.slow_correct_made_dead_binSlow(:,980:990,10),2))';
sl_made_binMED = (nanmean(leaky_integrated_in.slow_correct_made_dead_binMed(:,980:990,10),2))';
sl_made_binFAST = (nanmean(leaky_integrated_in.slow_correct_made_dead_binFast(:,980:990,10),2))';

sl_miss_binSLOW = (nanmean(leaky_integrated_in.slow_correct_missed_dead_binSlow(:,980:990,10),2))';
sl_miss_binMED = (nanmean(leaky_integrated_in.slow_correct_missed_dead_binMed(:,980:990,10),2))';
sl_miss_binFAST = (nanmean(leaky_integrated_in.slow_correct_missed_dead_binFast(:,980:990,10),2))';

md_binSLOW = (nanmean(leaky_integrated_in.med_correct_binSlow(:,980:990,10),2))';
md_binMED = (nanmean(leaky_integrated_in.med_correct_binMed(:,980:990,10),2))';
md_binFAST = (nanmean(leaky_integrated_in.med_correct_binFast(:,980:990,10),2))';

fs_made_binSLOW = (nanmean(leaky_integrated_in.fast_correct_made_dead_binSlow(:,980:990,10),2))';
fs_made_binMED = (nanmean(leaky_integrated_in.fast_correct_made_dead_binMed(:,980:990,10),2))';
fs_made_binFAST = (nanmean(leaky_integrated_in.fast_correct_made_dead_binFast(:,980:990,10),2))';

fs_miss_binSLOW = (nanmean(leaky_integrated_in.fast_correct_missed_dead_binSlow(:,980:990,10),2))';
fs_miss_binMED = (nanmean(leaky_integrated_in.fast_correct_missed_dead_binMed(:,980:990,10),2))';
fs_miss_binFAST = (nanmean(leaky_integrated_in.fast_correct_missed_dead_binFast(:,980:990,10),2))';


mat1 = [sl_made_binSLOW ; sl_made_binMED ; sl_made_binFAST];
mat2 = [sl_miss_binSLOW ; sl_miss_binMED ; sl_miss_binFAST];
mat3 = [md_binSLOW ; md_binMED ; md_binFAST];
mat4 = [fs_made_binSLOW ; fs_made_binMED ; fs_made_binFAST];
mat5 = [fs_miss_binSLOW ; fs_miss_binMED ; fs_miss_binFAST];

pred = (0:2)';


for n = 1:size(mat1,2)
    [m(n)] = linreg(mat1(:,n),pred,0);
end

[a b c d] = ttest(m,0)

clear m b r n a b c d

for n = 1:size(mat2,2)
    [m(n)] = linreg(mat2(:,n),pred,0);
end

[a b c d] = ttest(m,0)
clear m b r n a b c d

for n = 1:size(mat3,2) % IS SIG @ p = 0.000119
    [m(n)] = linreg(mat3(:,n),pred,0);
end

[a b c d] = ttest(m,0)
clear m b r n a b c d

for n = 1:size(mat4,2) % IS SIG @ p < 0.00000001
    [m(n)] = linreg(mat4(:,n),pred,0);
end

[a b c d] = ttest(m,0)
clear m b r n a b c d

for n = 1:size(mat5,2)
    [m(n)] = linreg(mat5(:,n),pred,0);
end

[a b c d] = ttest(m,0)
clear m b r n a b c d


c_