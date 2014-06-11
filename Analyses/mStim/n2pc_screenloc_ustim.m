function [] = n2pc_screenloc_ustim(AD)
%draws m-p2pc by screen location for stim and non-
%stim trials. contra will always be the location 
%directly opposite to current screen location

Correct_ = evalin('caller','Correct_');
Target_ = evalin('caller','Target_');
SRT = evalin('caller','SRT');
MStim_ = evalin('caller','MStim_');

%baseline correct window is 1 - 100 post target
%because of stimulation
AD = baseline_correct(AD,[501 601]);

f = figure; %for non-stim
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
        
        
        contra = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & Target_(:,2) == mod((j+4),8));
        ipsi = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & Target_(:,2) == j);
        
        subplot(3,3,screenloc)
        plot(-500:2500,nanmean(AD(ipsi,:)),'--r',-500:2500,nanmean(AD(contra,:)),'r')
        xlim([-100 500])
        axis ij
        fon
end
        rescale_subplots(figure(f),[3 3],'y',5)
        [ax h] = suplabel('Non Stim','t');
        set(h,'fontsize',14,'fontweight','bold')
        
        
        f = figure; %for stim
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
        
        
        contra = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & Target_(:,2) == mod((j+4),8));
        ipsi = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & Target_(:,2) == j);
        
        subplot(3,3,screenloc)
        plot(-500:2500,nanmean(AD(ipsi,:)),'--r',-500:2500,nanmean(AD(contra,:)),'r')
        xlim([-100 500])
        axis ij
        fon
end
        rescale_subplots(figure(f),[3 3],'y',5)
        [ax h] = suplabel('Stim','t');
        set(h,'fontsize',14,'fontweight','bold')