% Plots T/in D/in SDF along with TDT for a given neuron
% input should be given as a string of the name of the unit you want to
% plot

% RPH
%

function [] = plotSDF(name,rasterFlag)

if nargin < 2; rasterFlag = 0; end

% Get variables from workspace

Spike = evalin('caller',name);
Correct_ = evalin('caller','Correct_');
Target_ = evalin('caller','Target_');
MStim_ = evalin('caller','MStim_');
saccLoc = evalin('caller','saccLoc');

SRT = evalin('caller','SRT');
RFs = evalin('caller','RFs');
MFs = evalin('caller','MFs');

RF = RFs.(name);
MF = MFs.(name);

RFisMF = 0; %if no RF, are we using the MF instead so we have something to plot?
MFisRF = 0; %if no MF, are we using the RF instead so we have something to plot?
% 
% if isempty(RF) %if no RF, check for an MF for move cells
%     if ~isempty(MF)
%         RF = MFs.(name);
%         RFisMF = 1;
%     else
%         error('No RF or MF')
%     end
% end

try
    JuiceOn_ = evalin('caller','JuiceOn_');
catch
    disp('Missing JuiceOn_ variable')
end

if isempty(RF) & isempty(MF);    error('No RF or MF'); end

if isempty(MF)
    MF = RFs.(name);
    MFisRF = 1;
end

if isempty(RF)
    RF = MFs.(name);
    RFisMF = 1;
end


antiRF = mod((RF+4),8);
antiMF = mod((MF+4),8);

all_correct = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & isnan(MStim_(:,1)));
all_error = find(Correct_(:,2) == 0 & Target_(:,2) ~= 255 & isnan(MStim_(:,1)));
error_into_RF = find(Correct_(:,2) == 0 & Target_(:,2) ~= 255 & ismember(saccLoc,RF));
error_outof_RF = find(Correct_(:,2) == 0 & Target_(:,2) ~= 255 & ismember(saccLoc,antiRF));

in_RF = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & isnan(MStim_(:,1)) & ismember(Target_(:,2),RF));
out_RF = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & isnan(MStim_(:,1)) & ismember(Target_(:,2),antiRF));

in_MF = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & isnan(MStim_(:,1)) & ismember(Target_(:,2),MF));
out_MF = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & isnan(MStim_(:,1)) & ismember(Target_(:,2),antiMF));


SDF = sSDF(Spike,Target_(:,1),[-100 800]);
SDF_resp = sSDF(Spike,SRT(:,1)+Target_(1,1),[-400 200]);
SDF_resp_err = sSDF(Spike,SRT(:,1)+Target_(1,1),[-50 2000]);

if exist('JuiceOn_')
    SDF_juice = sSDF(Spike,JuiceOn_(:,1)+Target_(1,1),[-800 800]);
end

TDT = getTDT_SP(Spike,in_RF,out_RF);


%use different colors if RF/MF is "borrowed" due to absense (pure vis or pure move)
if RFisMF
    tcol = 'b';
else
    tcol = 'k';
end

if MFisRF
    rcol = 'b';
else
    rcol = 'k';
end

if rasterFlag tLineWidth = 2; else tLineWidth = 1; end


figure
set(gcf,'position',[1101 868 1239 385],'color','white')

subplot(1,4,1)
plot(-100:800,nanmean(SDF(in_RF,:)),tcol,-100:800,nanmean(SDF(out_RF,:)),['--' tcol],'linewidth',tLineWidth);
vline(TDT,'r')
xlim([-100 800])
xlabel('Time from Target Onset','fontweight','bold')
ylabel('Spikes/sec','fontweight','bold')
title('Target Aligned','fontweight','bold')
box off
text(.05,.75,['TDT = ' mat2str(TDT)],'units','normalized','rotation',90,'color','r','fontweight','bold')
if RFisMF; text(.5,.05,'No RF; using MF','units','normalized','color','b','fontweight','bold'); end

subplot(1,4,2)
plot(-400:200,nanmean(SDF_resp(in_MF,:)),rcol,-400:200,nanmean(SDF_resp(out_MF,:)),['--' rcol],'linewidth',1)
xlim([-400 200])
vline(0,'r')
xlabel('Time from Saccade Onset','fontweight','bold')
title('Saccade Aligned','fontweight','bold')
box off
if MFisRF; text(.5,.05,'No MF; using RF','units','normalized','color','b','fontweight','bold'); end

if exist('JuiceOn_')
    subplot(143)
    plot(-800:800,nanmean(SDF_juice(in_RF,:)),'k',-800:800,nanmean(SDF_juice(out_RF,:)),'--k','linewidth',1)
    xlim([-800 800])
    vline(0,'r')
    xlabel('Time from Juice Onset','fontweight','bold')
    title('Reward Aligned','fontweight','bold')
    box off
end

subplot(144)
plot(-50:2000,nanmean(SDF_resp_err(in_RF,:)),'k',-50:2000,nanmean(SDF_resp_err(all_correct,:)),'b', ...
    -50:2000,nanmean(SDF_resp_err(all_error,:)),'r',-50:2000,nanmean(SDF_resp_err(error_into_RF,:)),'--r', ...
    -50:2000,nanmean(SDF_resp_err(error_outof_RF,:)),'--g','linewidth',1)
xlim([-50 2000])
xlabel('Time from Saccade Onset','fontweight','bold')
title('Saccade Aligned','fontweight','bold')
box off
%vline(nanmedian(JuiceOn_ - SRT(:,1)),'m')
ax = legend('Correct inRF','Correct All','Error All','Error into RF','Error outof RF');
LEG = findobj(ax,'type','text');
set(LEG,'fontsize',12)

[ax h] = suplabel(name,'t');
set(h,'fontweight','bold');

%equate_y

%==============
%Plot Raster
if rasterFlag
    subplot(1,3,1)
    newax
    
    %Sort trials by SRT
    [sorted_SRT sorted_index] = sort(SRT(:,1),1,'ascend');
    
    [bins cdf] = getCDF(SRT(:,1),30);
    
    for trl = 1:length(sorted_index)
        trlSpike = Spike(sorted_index(trl),find(Spike(sorted_index(trl),:)-Target_(1,1) >= -100 & Spike(sorted_index(trl),:)-Target_(1,1) <= 800));
        if ~isempty(trlSpike)
            plot(trlSpike-Target_(1,1),trl,'k');
        end
    end
    
    %turn off tick labels on secondary axes
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    
    %plot CDF
    lim = get(gca,'ylim');
    plot(bins,(lim(2).*cdf),'--b','linewidth',2)
    xlim([-100 800])
end
