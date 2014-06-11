% plots spike signals from all screen locations together, color coded
% disregards correct/error.
%
% User can also input specific screen locations to plot as a vector of
% screen positions

% RPH

function [allpos] = plotSDF_screenloc(name,pos)

Target_ = evalin('caller','Target_');
SRT = evalin('caller','SRT');
Correct_ = evalin('caller','Correct_');
sig = evalin('caller',name);

SDF = sSDF(sig,Target_(:,1),[-100 800]);
SDF_r = sSDF(sig,SRT(:,1)+Target_(1,1),[-400 200]);

pos0 = find(Target_(:,2) == 0 & Correct_(:,2) == 1);
pos1 = find(Target_(:,2) == 1 & Correct_(:,2) == 1);
pos2 = find(Target_(:,2) == 2 & Correct_(:,2) == 1);
pos3 = find(Target_(:,2) == 3 & Correct_(:,2) == 1);
pos4 = find(Target_(:,2) == 4 & Correct_(:,2) == 1);
pos5 = find(Target_(:,2) == 5 & Correct_(:,2) == 1);
pos6 = find(Target_(:,2) == 6 & Correct_(:,2) == 1);
pos7 = find(Target_(:,2) == 7 & Correct_(:,2) == 1);

%return all positions if desired.
allpos.pos0 = pos0;
allpos.pos1 = pos1;
allpos.pos2 = pos2;
allpos.pos3 = pos3;
allpos.pos4 = pos4;
allpos.pos5 = pos5;
allpos.pos6 = pos6;
allpos.pos7 = pos7;

%if exactly 2 locations being plotted, get the TDT
if nargin >= 2 & length(pos) == 2
    in = find(Target_(:,2) == pos(1) & Correct_(:,2) == 1);
    out = find(Target_(:,2) == pos(2) & Correct_(:,2) == 1);
    TDT = getTDT_SP(sig,in,out);
end

if nargin < 2
    
    f = figure;
    set(f,'position',[1112 736 1400 589]);
    set(gcf,'color','white')
    subplot(1,2,1)
    plot(-100:800,nanmean(SDF(pos0,:)),-100:800,nanmean(SDF(pos1,:)),-100:800,nanmean(SDF(pos2,:)), ...
        -100:800,nanmean(SDF(pos3,:)),-100:800,nanmean(SDF(pos4,:)),-100:800,nanmean(SDF(pos5,:)), ...
        -100:800,nanmean(SDF(pos6,:)),-100:800,nanmean(SDF(pos7,:)))
    xlim([-100 800])
    legend('Pos0','Pos1','Pos2','Pos3','Pos4','Pos5','Pos6','Pos7','location','northwest')
    
    subplot(1,2,2)
    plot(-400:200,nanmean(SDF_r(pos0,:)),-400:200,nanmean(SDF_r(pos1,:)),-400:200,nanmean(SDF_r(pos2,:)), ...
        -400:200,nanmean(SDF_r(pos3,:)),-400:200,nanmean(SDF_r(pos4,:)),-400:200,nanmean(SDF_r(pos5,:)), ...
        -400:200,nanmean(SDF_r(pos6,:)),-400:200,nanmean(SDF_r(pos7,:)))
    xlim([-400 200])
    vline(0,'k')

else
    figure
    set(gcf,'color','white')
    subplot(1,2,1)
    hold on
    
    color = {'k','b','r','g','m','y','b','r','g','k','m','y'};
    for cur_pos = 1:length(pos)
        pos_trls = find(Target_(:,2) == pos(cur_pos) & Correct_(:,2) == 1);
        plot(-100:800,nanmean(SDF(pos_trls,:)),color{cur_pos})
        xlim([-100 800])
    end
    
    %plot TDT if exactly two locations were plotted
    if length(pos) == 2
        vline(TDT,'r')
    end
    
    title(['TDT = ' mat2str(TDT) ])
    
    subplot(1,2,2)
    hold on
    for cur_pos = 1:length(pos)
        pos_trls = find(Target_(:,2) == pos(cur_pos) & Correct_(:,2) == 1);
        plot(-400:200,nanmean(SDF_r(pos_trls,:)),color{cur_pos})
        xlim([-400 200])
    end
    vline(0,'k')
    
    title(['Screen Locations: ' mat2str(pos) ])
    
end
