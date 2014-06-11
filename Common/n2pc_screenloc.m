function [] = n2pc_screenloc(ADname)
%draws m-p2pc by screen location

AD = evalin('caller',ADname);
SRT = evalin('caller','SRT');
Correct_ = evalin('caller','Correct_');
Target_ = evalin('caller','Target_');
Hemi = evalin('caller','Hemi');

%baseline correct
AD = baseline_correct(AD,[Target_(1,1)-100 Target_(1,1)]);

%truncate 20 ms before saccade
AD = truncateAD_targ(AD,SRT);

if Hemi.(ADname) == 'L'
    RF = [7 0 1];
elseif Hemi.(ADname) == 'R'
    RF = [3 4 5];
end

f = figure;
for j = 0:7
    switch j
        case 0
            screenloc = 6;
        case 1
            screenloc = 3;
        case 2
            screenloc = 2;
        case 3
            screenloc = 1;
        case 4
            screenloc = 4;
        case 5
            screenloc = 7;
        case 6
            screenloc = 8;
        case 7
            screenloc = 9;
    end
    
    if ismember(j,RF)
        col = [1 0 0];
    elseif ismember(j,mod((RF+4),8))
        col = [0 0 1];
    else
        col = [0 0 0];
    end
    
    contra = find(Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & Target_(:,2) == mod((j+4),8));
    ipsi = find(Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & Target_(:,2) == j);
    
    subplot(3,3,screenloc)
    
    plot(-Target_(1,1):2500,nanmean(AD(ipsi,:)),'color',col,'linestyle','--')
    hold on
    plot(-Target_(1,1):2500,nanmean(AD(contra,:)),'color',col)
    axis ij
    xlim([-100 500])
    fon
    
    
end
[h ax] = suplabel('RED = screen locations CONTRA to electrode','t')
set(h,'fontsize',12,'fontweight','bold')

%  rescale_subplots(figure(f),[3 3],'y',5)
