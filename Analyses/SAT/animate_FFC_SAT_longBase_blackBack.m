% Plays an animation of the eye on a given trial or set of trials
% Target and distractor windows are estimated based on the metrics
% recorded; they are not based off of tempo settings

% If a Spike unit is included in the input, matlab will show the rasters for that
% trial as well as play the sound through the default speaker
%
% NOTE: SPIKE UNIT MUST BE SENT IN SINGLE QUOTES

%  Calls:
%  baseline_correct [heitz/common]
%  response_align   [heitz/common]
%  MySpike2Cont     [heitz/Coherence]
%  vline            [heitz/common]
%  getTDT_SP        [heitz/common]
%  sSDF             [heitz/common]

% Richard P. Heitz
% Vanderbilt
% 11/30/09

function [F] = animate_FFC_SAT_longBase_blackBack(trls,AD1,AD2)
clear_Fast_at_missed_dead = 0;
record_movie = 0;


%Find target identity and location
Stimuli_ = evalin('caller','Stimuli_');
Target_ = evalin('caller','Target_');
Correct_ = evalin('caller','Correct_');

getStim

%get Trial-by-trial Spectra
tapers = PreGenTapers([.2 5]);
parfor tr = 1:length(trls)
    [all_spec1(:,:,tr),~,~,all_Pspec1(:,:,tr)] = LFPSpec(AD1(trls(tr),:),tapers,1000,.01,100,0,-Target_(1,1),2,4);
    [all_spec2(:,:,tr),~,~,all_Pspec2(:,:,tr)] = LFPSpec(AD2(trls(tr),:),tapers,1000,.01,100,0,-Target_(1,1),2,4);
end

%one last time to get correct tout and f variables
[~,f,tout] = LFPSpec(AD1(trls(1),:),tapers,1000,.01,100,0,-Target_(1,1),2,4);

%Now get partial coherence 

% [~,~,Pcoh.trls] = getFFC(AD1,AD2,trls);
% [~,~,Pcoh.all] = getFFC(AD1,AD2,1:size(AD1,1));
% [~,~,Pcoh.correct] = getFFC(AD1,AD2,find(Correct_(:,2) == 1));
Pcoh.trls = NaN;
Pcoh.all = NaN;
Pcoh.correct = NaN;

if strmatch(orien,'Right')
    Orien = 90;
elseif strmatch(orien,'Down')
    Orien = 180;
elseif strmatch(orien,'Left')
    Orien = 270;
elseif strmatch(orien,'Up')
    Orien = 0;
end


%inverse speed; how do you want to downsample? 2 = 500 Hz, 4 = 250Hz, etc.
% speed = 4 or 5 (200 Hz) is a good value for making movies.
%speed = 4;
speed = 30;

%try to get Gains variable, if it exists
try
    Gains_EyeX = evalin('base','Gains_EyeX');
    Gains_EyeY = evalin('base','Gains_EyeY');
end
try
    Gains_EyeX = evalin('caller','Gains_EyeX');
    Gains_EyeY = evalin('caller','Gains_EyeY');
end


%retrieve variables from calling workspace
try
    EyeX_ = evalin('base','EyeX_');
    EyeY_ = evalin('base','EyeY_');
    Correct_ = evalin('base','Correct_');
    Target_ = evalin('base','Target_');
    SRT = evalin('base','SRT');
    TrialStart_ = evalin('base','TrialStart_');
    Stimuli_ = evalin('base','Stimuli_');
    SAT_ = evalin('base','SAT_');
catch
    EyeX_ = evalin('caller','EyeX_');
    EyeY_ = evalin('caller','EyeY_');
    Correct_ = evalin('caller','Correct_');
    Target_ = evalin('caller','Target_');
    SRT = evalin('caller','SRT');
    TrialStart_ = evalin('caller','TrialStart_');
    Stimuli_ = evalin('caller','Stimuli_');
    SAT_ = evalin('caller','SAT_');
end


if nargin == 2
    try
        Spike = evalin('base',SpikeName);
        RFs = evalin('base','RFs');
        RF = RFs.(SpikeName);
    catch
        Spike = evalin('caller',SpikeName);
        RFs = evalin('caller','RFs');
        RF = RFs.(SpikeName);
    end
end

if nargin < 1; trls = 1:size(EyeX_,1); end


%determine target stimulus so we can plot it
Ts = nonzeros(Stimuli_(find(Stimuli_ < 20)));
Ls = nonzeros(Stimuli_(find(Stimuli_ > 20)));

if length(unique(Ts)) == 1
    TargStim = unique(Ts);
elseif length(unique(Ls)) == 1
    TargStim = unique(Ls);
end

figure
    scrsz = get(0,'ScreenSize');
    %full screen
    figure('Position',[1 scrsz(4) scrsz(4) scrsz(4)])
    
set(gcf,'color','black')

%maximize

%if spike channel included and it has an RF, draw
% if nargin == 2 && ~isempty(RF)
%     in = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF));
%     out = find(Correct_(:,2) == 1 & ismember(Target_(:,2),mod((RF+4),8)));
%     
%     SDF.in = spikedensityfunct(Spike,Target_(:,1),[-100 500],in,TrialStart_);
%     SDF.out = spikedensityfunct(Spike,Target_(:,1),[-100 500],out,TrialStart_);
%     TDT = getTDT_SP(Spike,in,out);
%     
%     subplot(5,4,[4 8])
%     plot(-100:500,SDF.in,'k',-100:500,SDF.out,'--k','linewidth',2)
%     xlim([-100 500])
%     vline(TDT,'k')
%     title(['RF = ' mat2str(RF)])
%     set(gca,'yaxislocation','right')
%     
%     
%     Spike(find(Spike == 0)) = NaN;
%     %Alter spike times so they are in register for raster displays and
%     %sound
%     Spike = Spike - Target_(1,1);
%     
% end


%get saccade trajectory information
[stats pos alpha] = getVec(EyeX_,EyeY_,SRT,0,0);
clear stats pos

%check to see if any eye signals need to be inverted
% NOTE: we need to do this AFTER the getVec call or trajectories will
% forever be inverted! %

if exist('Gains_EyeX') == 1
    if Gains_EyeX(1) < 0
        disp('Inverting X Eye channel')
        EyeX_ = -EyeX_;
    end
    
    if Gains_EyeY(1) < 0
        disp('Inverting Y Eye channel')
        EyeY_ = -EyeY_;
    end
end


%baseline correct so all eye traces appear to begin at 0/0
EyeX_ = baseline_correct(EyeX_,[Target_(1,1)-100 Target_(1,1)]);
EyeY_ = baseline_correct(EyeY_,[Target_(1,1)-100 Target_(1,1)]);

%need response aligned to estimate, for given session, where eyes tend to
%fall on correct trials.

EyeX_resp = response_align(EyeX_,SRT,[0 200]);
EyeY_resp = response_align(EyeY_,SRT,[0 200]);

%anchor is amount of time post saccade onset to take X and Y voltage value
%(baseline corrected).
anchor = 35; %35 ms post saccade onset detection
x.pos0 = nanmedian(EyeX_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 0),anchor));
x.pos1 = nanmedian(EyeX_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 1),anchor));
x.pos2 = nanmedian(EyeX_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 2),anchor));
x.pos3 = nanmedian(EyeX_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 3),anchor));
x.pos4 = nanmedian(EyeX_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 4),anchor));
x.pos5 = nanmedian(EyeX_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 5),anchor));
x.pos6 = nanmedian(EyeX_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 6),anchor));
x.pos7 = nanmedian(EyeX_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 7),anchor));

%Size of boxes is a scaled function of the standard deviation of the endpoint
%scatter.
scale = 4;
xstd(1) = scale*nanstd(EyeX_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 0),anchor));
xstd(2) = scale*nanstd(EyeX_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 1),anchor));
xstd(3) = scale*nanstd(EyeX_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 2),anchor));
xstd(4) = scale*nanstd(EyeX_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 3),anchor));
xstd(5) = scale*nanstd(EyeX_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 4),anchor));
xstd(6) = scale*nanstd(EyeX_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 5),anchor));
xstd(7) = scale*nanstd(EyeX_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 6),anchor));
xstd(8) = scale*nanstd(EyeX_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 7),anchor));

y.pos0 = nanmedian(EyeY_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 0),anchor));
y.pos1 = nanmedian(EyeY_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 1),anchor));
y.pos2 = nanmedian(EyeY_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 2),anchor));
y.pos3 = nanmedian(EyeY_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 3),anchor));
y.pos4 = nanmedian(EyeY_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 4),anchor));
y.pos5 = nanmedian(EyeY_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 5),anchor));
y.pos6 = nanmedian(EyeY_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 6),anchor));
y.pos7 = nanmedian(EyeY_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 7),anchor));

ystd(1) = scale*nanstd(EyeY_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 0),anchor));
ystd(2) = scale*nanstd(EyeY_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 1),anchor));
ystd(3) = scale*nanstd(EyeY_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 2),anchor));
ystd(4) = scale*nanstd(EyeY_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 3),anchor));
ystd(5) = scale*nanstd(EyeY_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 4),anchor));
ystd(6) = scale*nanstd(EyeY_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 5),anchor));
ystd(7) = scale*nanstd(EyeY_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 6),anchor));
ystd(8) = scale*nanstd(EyeY_resp(find(Correct_(:,2) == 1 & Target_(:,2) == 7),anchor));

%box widths is the average of the values across screen positions
boxwidth = nanmean(xstd);
boxheight = nanmean(ystd);

FrameCount = 0;

for trl = 1:length(trls)
    %pause(1) %Mimick ITI

    didDraw = 0; %did you draw stimuli yet?
    
    if isnan(SAT_(trls(trl),1)); continue; end
%     
%     %draw detected saccade trajectory from getVec
%     subplot(5,4,[12 16])
%     circ_plot(alpha(trls(trl)),'pretty','bo','true','linewidth',2);
%     axis off
    
    %Draw Spectra
    subplot(5,4,1:2)
    imagesc(tout,f,log10(all_spec1(:,:,trl)')); %Note: we only calculated the spectra for relevant trials
    axis xy
    %colorbar
    plotBW
    %Put marker line at time = 0
    q = vline(0,'--w');
    qq = vline(SRT(trls(trl),1),'--w');
    set(q,'linewidth',3)
    set(qq,'linewidth',3)
    box off    
    lim = get(gca,'clim');
    
    subplot(5,4,3:4)
    imagesc(tout,f,log10(all_spec2(:,:,trl)'));
    axis xy
    %colorbar
    plotBW
    %Put marker line at time = 0
    q = vline(0,'--w');
    qq = vline(SRT(trls(trl),1),'--w');
    set(q,'linewidth',3)
    set(qq,'linewidth',3)
    box off    
    set(gca,'clim',lim);
    
    subplot(5,4,5:6)
    plot(-Target_(1,1):2500,AD1(trls(trl),:),'b')
    axis ij
    plotBW
    q = vline(0,'--w');
    qq = vline(SRT(trls(trl),1),'--w');
    set(q,'linewidth',3);
    set(qq,'linewidth',3);
    box off
    lim = ylim;
    xlim([tout(1) tout(end)])
    
    subplot(5,4,7:8)
    plot(-Target_(1,1):2500,AD2(trls(trl),:),'b')
    axis ij
    plotBW
    q = vline(0,'--w');
    qq = vline(SRT(trls(trl),1),'--w');
    set(q,'linewidth',3);
    set(qq,'linewidth',3);
    box off
    ylim(lim);
    xlim([tout(1) tout(end)])

    
    %Draw Coherence
    subplot(5,4,[12])
    imagesc(tout,f,abs(Pcoh.trls'))
    axis xy
    q = vline(0,'--w');
    set(q,'linewidth',3)
    box off
    title('Pcoh current trials')
    plotBW
    
    subplot(5,4,16)
    imagesc(tout,f,abs(Pcoh.all'))
    axis xy
    q = vline(0,'--w');
    set(q,'linewidth',3)
    box off
    title('Pcoh all trials')
    plotBW
    
    subplot(5,4,20)
    imagesc(tout,f,abs(Pcoh.correct'))
    axis xy
    q = vline(0,'w');
    set(q,'linewidth',3)
    box off
    title('Pcoh all correct')
    plotBW
    
    %mark response deadline and color based on condition
    if SAT_(trls(trl),1) == 1
        v = vline(SAT_(trls(trl),3),'r');
    elseif SAT_(trls(trl),1) == 2
        v = vline(SAT_(trls(trl),3),'k');
    elseif SAT_(trls(trl),1) == 3
        v = vline(SAT_(trls(trl),3),'g');
    end
    
    set(v,'linewidth',3)
    
    set(gca,'yticklabel',[])
    %title(['Trial = ' mat2str(trls(trl))])
    
    %NOTE TRIAL TYPE
%     subplot(5,4,4)
%     set(gca,'fontsize',40)
%     set(gca,'color','k')
%     if SAT_(trls(trl),1) == 1
%         text(.1,.5,'ACCURATE','fontsize',40,'fontweight','bold','color','r')
%     elseif SAT_(trls(trl),1) == 2
%         text(.1,.5,'NEUTRAL','fontsize',40,'fontweight','bold','color','white')
%     elseif SAT_(trls(trl),1) == 3
%         text(.1,.5,'FAST','fontsize',40,'fontweight','bold','color','g')
%     end
%     axis off
    
    
    %plot raster if there were spikes on this trial
    if nargin == 2 && ~isempty(RF) && ~isempty(Spike(trl,find(Spike(trl,:) <= 2500)))
        subplot(5,4,5:7)
        SPlines = vline(Spike(trl,find(Spike(trl,:) <= 2500)));
        ylim([-2 3])
        set(gca,'xticklabel',[])
        set(gca,'yticklabel',[])
    end
    
    %draw Eye X/Y positions
    subplot(5,4,[9:11 13:15 17:19])
    set(gca,'fontsize',12)
    set(gca,'color','k')
    box on
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    set(gca,'linewidth',10)
    
    %if catch trial, note
    if Target_(trls(trl),2) == 255 && Correct_(trls(trl),2) == 1 && isnan(SRT(trls(trl),1))
        xlabel('CATCH TRIAL CORRECT','color','r','fontweight','bold','fontsize',14)
    elseif Target_(trls(trl),2) == 255 && Correct_(trls(trl),2) == 1 && ~isnan(SRT(trls(trl),1))
        xlabel('CATCH TRIAL LATE RESPONSE','color','r','fontweight','bold','fontsize',14)
    elseif Target_(trls(trl),2) == 255 && Correct_(trls(trl),2) == 0 && ~isnan(SRT(trls(trl),1))
        xlabel('CATCH TRIAL ERROR','color','r','fontweight','bold','fontsize',14)
    else
        xlabel('')
    end
    
    hold on
    
    %create target windows
    targpos = Target_(trls(trl),2);

    p0 = [x.pos0-.5*boxwidth,y.pos0-.5*boxheight,boxwidth,boxheight];
    p1 = [x.pos1-.5*boxwidth,y.pos1-.5*boxheight,boxwidth,boxheight];
    p2 = [x.pos2-.5*boxwidth,y.pos2-.5*boxheight,boxwidth,boxheight];
    p3 = [x.pos3-.5*boxwidth,y.pos3-.5*boxheight,boxwidth,boxheight];
    p4 = [x.pos4-.5*boxwidth,y.pos4-.5*boxheight,boxwidth,boxheight];
    p5 = [x.pos5-.5*boxwidth,y.pos5-.5*boxheight,boxwidth,boxheight];
    p6 = [x.pos6-.5*boxwidth,y.pos6-.5*boxheight,boxwidth,boxheight];
    p7 = [x.pos7-.5*boxwidth,y.pos7-.5*boxheight,boxwidth,boxheight];
    
    %scale plots by extent of eye movements in cardinal positions
    xlim([-1*max(abs(x.pos0),abs(x.pos4))-boxwidth max(abs(x.pos0),abs(x.pos4))+boxwidth])
    ylim([-1*max(abs(y.pos2),abs(y.pos6))-boxheight max(abs(y.pos2),abs(y.pos6))+boxheight])
    
    setsize = Target_(trls(trl),5);
    
    %draw all windows
%     switch setsize
%         case 2
%             switch targpos
%                 case 0
%                     rectangle('position',p4,'edgecolor','r','linewidth',2)
%                 case 1
%                     rectangle('position',p5,'edgecolor','r','linewidth',2)
%                 case 2
%                     rectangle('position',p6,'edgecolor','r','linewidth',2)
%                 case 3
%                     rectangle('position',p7,'edgecolor','r','linewidth',2)
%                 case 4
%                     rectangle('position',p0,'edgecolor','r','linewidth',2)
%                 case 5
%                     rectangle('position',p1,'edgecolor','r','linewidth',2)
%                 case 6
%                     rectangle('position',p2,'edgecolor','r','linewidth',2)
%                 case 7
%                     rectangle('position',p3,'edgecolor','r','linewidth',2)
%             end
%             
%         case 4
%             switch targpos
%                 case 0
%                     rectangle('position',p2,'edgecolor','r','linewidth',2)
%                     rectangle('position',p4,'edgecolor','r','linewidth',2)
%                     rectangle('position',p6,'edgecolor','r','linewidth',2)
%                 case 1
%                     rectangle('position',p3,'edgecolor','r','linewidth',2)
%                     rectangle('position',p5,'edgecolor','r','linewidth',2)
%                     rectangle('position',p7,'edgecolor','r','linewidth',2)
%                 case 2
%                     rectangle('position',p4,'edgecolor','r','linewidth',2)
%                     rectangle('position',p6,'edgecolor','r','linewidth',2)
%                     rectangle('position',p0,'edgecolor','r','linewidth',2)
%                 case 3
%                     rectangle('position',p5,'edgecolor','r','linewidth',2)
%                     rectangle('position',p7,'edgecolor','r','linewidth',2)
%                     rectangle('position',p1,'edgecolor','r','linewidth',2)
%                 case 4
%                     rectangle('position',p6,'edgecolor','r','linewidth',2)
%                     rectangle('position',p0,'edgecolor','r','linewidth',2)
%                     rectangle('position',p2,'edgecolor','r','linewidth',2)
%                 case 5
%                     rectangle('position',p7,'edgecolor','r','linewidth',2)
%                     rectangle('position',p1,'edgecolor','r','linewidth',2)
%                     rectangle('position',p3,'edgecolor','r','linewidth',2)
%                 case 6
%                     rectangle('position',p0,'edgecolor','r','linewidth',2)
%                     rectangle('position',p2,'edgecolor','r','linewidth',2)
%                     rectangle('position',p4,'edgecolor','r','linewidth',2)
%                 case 7
%                     rectangle('position',p1,'edgecolor','r','linewidth',2)
%                     rectangle('position',p3,'edgecolor','r','linewidth',2)
%                     rectangle('position',p5,'edgecolor','r','linewidth',2)
%             end
%             
%         case 8
%             %draw square at all locations first and let target draw
%             %over it
%             rectangle('position',p0,'edgecolor','r')
%             rectangle('position',p1,'edgecolor','r')
%             rectangle('position',p2,'edgecolor','r')
%             rectangle('position',p3,'edgecolor','r')
%             rectangle('position',p4,'edgecolor','r')
%             rectangle('position',p5,'edgecolor','r')
%             rectangle('position',p6,'edgecolor','r')
%             rectangle('position',p7,'edgecolor','r')
%     end
    
    % now draw target position
%     switch targpos
%         case 0
%             rectangle('position',p0,'linewidth',10,'edgecolor','white')
%             %arrow([p0(1)+boxwidth*.5 p0(2)-boxwidth*.5],[p0(1)+boxwidth*.5 p0(2)],'linewidth',3,'edgecolor','r','facecolor','r')
%         case 1
%             rectangle('position',p1,'linewidth',10,'edgecolor','white')
%             %arrow([p1(1)+boxwidth*.5 p1(2)-boxwidth*.5],[p1(1)+boxwidth*.5 p1(2)],'linewidth',3,'edgecolor','r','facecolor','r')
%         case 2
%             rectangle('position',p2,'linewidth',10,'edgecolor','white')
%             %arrow([p2(1)+boxwidth*.5 p2(2)-boxwidth*.5],[p2(1)+boxwidth*.5 p2(2)],'linewidth',3,'edgecolor','r','facecolor','r')
%         case 3
%             rectangle('position',p3,'linewidth',10,'edgecolor','white')
%             %arrow([p3(1)+boxwidth*.5 p3(2)-boxwidth*.5],[p3(1)+boxwidth*.5 p3(2)],'linewidth',3,'edgecolor','r','facecolor','r')
%         case 4
%             rectangle('position',p4,'linewidth',10,'edgecolor','white')
%             %arrow([p4(1)+boxwidth*.5 p4(2)-boxwidth*.5],[p4(1)+boxwidth*.5 p4(2)],'linewidth',3,'edgecolor','r','facecolor','r')
%         case 5
%             rectangle('position',p5,'linewidth',10,'edgecolor','white')
%             %arrow([p5(1)+boxwidth*.5 p5(2)-boxwidth*.5],[p5(1)+boxwidth*.5 p5(2)],'linewidth',3,'edgecolor','r','facecolor','r')
%         case 6
%             rectangle('position',p6,'linewidth',10,'edgecolor','white')
%             %arrow([p6(1)+boxwidth*.5 p6(2)-boxwidth*.5],[p6(1)+boxwidth*.5 p6(2)],'linewidth',3,'edgecolor','r','facecolor','r')
%         case 7
%             rectangle('position',p7,'linewidth',10,'edgecolor','white')
%             %arrow([p7(1)+boxwidth*.5 p7(2)-boxwidth*.5],[p7(1)+boxwidth*.5 p7(2)],'linewidth',3,'edgecolor','r','facecolor','r')
%     end

[circX,circY] = cylinder(.3,100);

    switch targpos
        case 0
            plot(circX(1,:)+x.pos0,circY(1,:)+y.pos0,'--','linewidth',5,'color',[.2,.2,.2])
            %arrow([p0(1)+boxwidth*.5 p0(2)-boxwidth*.5],[p0(1)+boxwidth*.5 p0(2)],'linewidth',3,'edgecolor','r','facecolor','r')
        case 1
             plot(circX(1,:)+x.pos1,circY(1,:)+y.pos1,'--','linewidth',5,'color',[.2,.2,.2])
            %arrow([p1(1)+boxwidth*.5 p1(2)-boxwidth*.5],[p1(1)+boxwidth*.5 p1(2)],'linewidth',3,'edgecolor','r','facecolor','r')
        case 2
             plot(circX(1,:)+x.pos2,circY(1,:)+y.pos2,'--','linewidth',5,'color',[.2,.2,.2])
            %arrow([p2(1)+boxwidth*.5 p2(2)-boxwidth*.5],[p2(1)+boxwidth*.5 p2(2)],'linewidth',3,'edgecolor','r','facecolor','r')
        case 3
             plot(circX(1,:)+x.pos3,circY(1,:)+y.pos3,'--','linewidth',5,'color',[.2,.2,.2])
            %arrow([p3(1)+boxwidth*.5 p3(2)-boxwidth*.5],[p3(1)+boxwidth*.5 p3(2)],'linewidth',3,'edgecolor','r','facecolor','r')
        case 4
             plot(circX(1,:)+x.pos4,circY(1,:)+y.pos4,'--','linewidth',5,'color',[.2,.2,.2])
            %arrow([p4(1)+boxwidth*.5 p4(2)-boxwidth*.5],[p4(1)+boxwidth*.5 p4(2)],'linewidth',3,'edgecolor','r','facecolor','r')
        case 5
             plot(circX(1,:)+x.pos5,circY(1,:)+y.pos5,'--','linewidth',5,'color',[.2,.2,.2])
            %arrow([p5(1)+boxwidth*.5 p5(2)-boxwidth*.5],[p5(1)+boxwidth*.5 p5(2)],'linewidth',3,'edgecolor','r','facecolor','r')
        case 6
             plot(circX(1,:)+x.pos6,circY(1,:)+y.pos6,'--','linewidth',5,'color',[.2,.2,.2])
            %arrow([p6(1)+boxwidth*.5 p6(2)-boxwidth*.5],[p6(1)+boxwidth*.5 p6(2)],'linewidth',3,'edgecolor','r','facecolor','r')
        case 7
             plot(circX(1,:)+x.pos7,circY(1,:)+y.pos7,'--','linewidth',5,'color',[.2,.2,.2])
            %arrow([p7(1)+boxwidth*.5 p7(2)-boxwidth*.5],[p7(1)+boxwidth*.5 p7(2)],'linewidth',3,'edgecolor','r','facecolor','r')
    end
    
    
    % now draw a fixation point square at mean location of fixation
    if SAT_(trls(trl),1) == 1; r = rectangle('position',[-.25,-.25,.4,.4],'edgecolor','r','facecolor','r','linewidth',10); end
    if SAT_(trls(trl),1) == 2; r = rectangle('position',[-.25,-.25,.4,.4],'edgecolor','white','facecolor','white','linewidth',10); end
    if SAT_(trls(trl),1) == 3; r = rectangle('position',[-.25,-.25,.4,.4],'edgecolor','g','facecolor','g','linewidth',10); end
    
    if nargin == 2 && ~isempty(RF)
        %change spike train to continuous signal for playing
        if ~isempty(Spike(trl,find(Spike(trl,:) <= 2500)))
            contSpike = mySpk2Cont(Spike(trl,find(Spike(trl,:) <= 2500)));
            
            %             trlSDF = sSDF(Spike(trl,:)+500,500,[-100 500]);
            %             subplot(5,4,[4 8])
            %             hold on
            %             plot(-100:500,trlSDF,'r')
            %
            
            %create audioplayer object. Should be 1000 Hz but trial and
            %error seems to suggest that 750 will keep sound and raster
            %displays in sync best.  Dependent on specific computer you are
            %running it on
            spikeSound = audioplayer(contSpike,1000);
            play(spikeSound)
        end
    end
    
    
    didClear = 0;
    
    pause(1)
    %for time = Target_(1,1)-1000:speed:size(EyeX_,2)-1000
    for time = 1:speed:size(EyeX_,2)
        
        FrameCount = FrameCount + 1;
        
        %if time == 1; pause(1); end
        
        
        subplot(5,4,1:2)
        v1 = vline(time-Target_(1,1));
        set(v1,'linewidth',4,'color','k')
        
        subplot(5,4,3:4)
        v2 = vline(time-Target_(1,1));
        set(v2,'linewidth',4,'color','k')
        
        subplot(5,4,[9:11 13:15 17:19])
        sc = scatter(EyeX_(trls(trl),time),EyeY_(trls(trl),time),'SizeData',50,'MarkerFaceColor','r','MarkerEdgeColor','white');
%         box on
%         set(gca,'xtick',[])
%         set(gca,'ytick',[])
%         set(gca,'linewidth',5)
        pause(.0001)
        set(sc,'SizeData',50,'MarkerFaceColor','white')
        
        %if you do NOT want to keep eye path visible (i.e., you want to see
        %only 1 point / sample) enable the below.  Note that it will make
        %each trial run more quickly and the sound will probably lose
        %synchronization
        
        %delete(sc)
        
        Distractor_Set = Stimuli_(trls(trl),~ismember(Stimuli_(trls(trl),:),Targ_ID));
        Dists.ID(1:7) = NaN;
        Dists.Orient(1:7) = NaN;
        Dists.ID(find(ismember(Distractor_Set,[11 12 13 14]))) = 'T';
        Dists.ID(find(ismember(Distractor_Set,[21 22 23 24]))) = 'L';
        
        Dists.Orient(find(ismember(Distractor_Set,[11 21]))) = 0;
        Dists.Orient(find(ismember(Distractor_Set,[12 22]))) = 90;
        Dists.Orient(find(ismember(Distractor_Set,[13 23]))) = 180;
        Dists.Orient(find(ismember(Distractor_Set,[14 24]))) = 270;
        
        
        
        
        
        if time >= Target_(1,1) & ~didDraw
            didDraw = 1;
            
            tPos = find(Stimuli_(trls(trl),:) == TargStim);
            dPos = find(Stimuli_(trls(trl),:) ~= TargStim);
            
            %draw target (always "T" for this example)
            t1 = text(eval(['p' mat2str(tPos-1) '(1)'])+.4*boxwidth,eval(['p' mat2str(tPos-1) '(2)']) + .5*boxheight,Targ,'fontsize',40,'fontweight','bold','color','white','rotation',Orien);
            
            %turn off filled fixation point
            set(r,'facecolor','none')
            
            %draw in distractor stimuli (always "L" for this example)
            for distractor = 1:7
                
                %show as if some trials are homogeneous and some are non-homogeneous
                
                
                t2(distractor) = text(eval(['p' mat2str(dPos(distractor)-1) '(1)'])+.4*boxwidth,eval(['p' mat2str(dPos(distractor)-1) '(2)'])+.5*boxheight,char(Dists.ID(distractor)),'fontsize',40,'fontweight','bold','color','white','rotation',Dists.Orient(distractor));
            end
            
        end
        
        
        %for FAST trials, clear the display if it was in fact cleared
        if clear_Fast_at_missed_dead
            if SAT_(trls(trl),11) == 1 & time > Target_(1,1)+1 & time > SAT_(trls(trl),3)+Target_(1,1) & didClear == 0
                didClear = 1;
                for distractor = 1:7
                    set(t2(distractor),'color','white')
                end
            end
        end
        
        if record_movie; F(FrameCount) = getframe(gcf); end
         
        %turn off time marker and deadline marker on upper plot
        subplot(5,4,1:2)
        delete(v1)%set(v,'visible','off')
        subplot(5,4,3:4)
        delete(v2)
    end
    
    cla
    
    if nargin == 2
        subplot(5,4,5:7)
        if exist('SPlines') && ~isempty(SPlines) && ~isempty(RF)
            set(SPlines,'visible','off')
        end
    end
    

    
    subplot(5,4,[9:11 13:15 17:19])
    cla
    
    subplot(5,4,4)
    cla
    
%     subplot(5,4,[12 16])
%     cla
end