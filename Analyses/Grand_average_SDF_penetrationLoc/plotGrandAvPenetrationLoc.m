cd ~/desktop/Mat_Code/Analyses/Grand_average_SDF_penetrationLoc/

[filename unit] = textread('ML0_P2.txt','%s %s');

normSDF = 0;

for file = 1:length(filename)
    file
    filename{file}
    load(filename{file},unit{file},'Correct_','Errors_','SRT','Target_','MFs','RFs')

    sig = eval(unit{file});
    
    RF = RFs.(unit{file});
    antiRF = mod((RF+4),8);
    
    in = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF));
    out = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF));
    
    SDF = sSDF(sig,Target_(:,1),[-400 800]);

    if normSDF;        SDF = normalize_SP(SDF); end

    SDFs.in(file,1:length(-400:800)) = nanmean(SDF(in,:));
    SDFs.out(file,1:length(-400:800)) = nanmean(SDF(out,:));
    
    %load(filename{file},unit{file},'Correct_','Target_','SRT','SAT_','Errors_','EyeX_','EyeY_','RFs','MFs','newfile')
    
    keep filename unit file SDFs normSDF
end

sems.in = sem(SDFs.in);
sems.out = sem(SDFs.out);

if normSDF
    yL_av = [0 1];
    yL_ind = [0 1];
else
    yL_av = [10 110];
    yL_ind = [0 250];
end

figure
subplot(121)
errorfill(-400:800,nanmean(SDFs.in),sems.in,'k')
hold on
errorfill(-400:800,nanmean(SDFs.out),sems.out,'r')
%ylim(yL_av)
xlim([-400 800])
title(['ML0 P2  N = ' mat2str(length(find(~isnan(sum(SDFs.in,2)))))])

subplot(122)
plot(-400:800,SDFs.in,'k',-400:800,SDFs.out,'r')
xlim([-400 800])
%ylim(yL_ind)
box off