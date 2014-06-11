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

function [F] = animate_eye_SAT_longBase(trls,SpikeName)
clear_Fast_at_missed_dead = 0;
record_movie = 1;

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
set(gcf,'color','white')

%maximize

%if spike channel included and it has an RF, draw
if nargin == 2 && ~isempty(RF)
    in = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF));
    out = find(Correct_(:,2) == 1 & ismember(Target_(:,2),mod((RF+4),8)));
    
    SDF.in = spikedensityfunct(Spike,Target_(:,1),[-100 500],in,TrialStart_);
    SDF.out = spikedensityfunct(Spike,Target_(:,1),[-100 500],out,TrialStart_);
    TDT = getTDT_SP(Spike,in,out);
    
    subplot(5,4,[4 8])
    plot(-100:500,SDF.in,'k',-100:500,SDF.out,'--k','linewidth',2)
    xlim([-100 500])
    vline(TDT,'k')
    title(['RF = ' mat2str(RF)])
    set(gca,'yaxislocation','right')
    
    
    Spike(find(Spike == 0)) = NaN;
    %Alter spike times so they are in register for raster displays and
    %sound
    Spike = Spike - Target_(1,1);
    
end


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
    
    if isnan(SAT_(trls(trl),1)); continue; end
%     
%     %draw detected saccade trajectory from getVec
%     subplot(5,4,[12 16])
%     circ_plot(alpha(trls(trl)),'pretty','bo','true','linewidth',2);
%     axis off
    
    %Draw X and Y voltage values, baseline corrected so starts at 0
    subplot(5,4,1:3)
    set(gca,'fontsize',20)
    plot(-Target_(1,1):2500,EyeX_(trls(trl),:),'b',-Target_(1,1):2500,EyeY_(trls(trl),:),'r','linewidth',2)
    xlim([-1000 1500])
    
    %mark response deadline and color based on condition
    if SAT_(trls(trl),1) == 1
        v = vline(SAT_(trls(trl),3),'r');
    elseif SAT_(trls(trl),1) == 2
        v = vline(SAT_(trls(trl),3),'k');
    elseif SAT_(trls(trl),1) == 3
        v = vline(SAT_(trls(trl),3),'g');
    end
    
    set(v,'linewidth',2)
    
    set(gca,'yticklabel',[])
    %title(['Trial = ' mat2str(trls(trl))])
    
    %NOTE TRIAL TYPE
    subplot(5,4,4)
    if SAT_(trls(trl),1) == 1
        text(.1,.5,'ACCURATE','fontsize',20,'fontweight','bold','color','r')
    elseif SAT_(trls(trl),1) == 2
        text(.1,.5,'NEUTRAL','fontsize',20,'fontweight','bold','color','k')
    elseif SAT_(trls(trl),1) == 3
        text(.1,.5,'FAST','fontsize',20,'fontweight','bold','color','g')
    end
    axis off
    
    
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
    box on
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    set(gca,'linewidth',5)
    
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
    switch targpos
        case 0
            rectangle('position',p0,'linewidth',2)
            %arrow([p0(1)+boxwidth*.5 p0(2)-boxwidth*.5],[p0(1)+boxwidth*.5 p0(2)],'linewidth',3,'edgecolor','r','facecolor','r')
        case 1
            rectangle('position',p1,'linewidth',2)
            %arrow([p1(1)+boxwidth*.5 p1(2)-boxwidth*.5],[p1(1)+boxwidth*.5 p1(2)],'linewidth',3,'edgecolor','r','facecolor','r')
        case 2
            rectangle('position',p2,'linewidth',2)
            %arrow([p2(1)+boxwidth*.5 p2(2)-boxwidth*.5],[p2(1)+boxwidth*.5 p2(2)],'linewidth',3,'edgecolor','r','facecolor','r')
        case 3
            rectangle('position',p3,'linewidth',2)
            %arrow([p3(1)+boxwidth*.5 p3(2)-boxwidth*.5],[p3(1)+boxwidth*.5 p3(2)],'linewidth',3,'edgecolor','r','facecolor','r')
        case 4
            rectangle('position',p4,'linewidth',2)
            %arrow([p4(1)+boxwidth*.5 p4(2)-boxwidth*.5],[p4(1)+boxwidth*.5 p4(2)],'linewidth',3,'edgecolor','r','facecolor','r')
        case 5
            rectangle('position',p5,'linewidth',2)
            %arrow([p5(1)+boxwidth*.5 p5(2)-boxwidth*.5],[p5(1)+boxwidth*.5 p5(2)],'linewidth',3,'edgecolor','r','facecolor','r')
        case 6
            rectangle('position',p6,'linewidth',2)
            %arrow([p6(1)+boxwidth*.5 p6(2)-boxwidth*.5],[p6(1)+boxwidth*.5 p6(2)],'linewidth',3,'edgecolor','r','facecolor','r')
        case 7
            rectangle('position',p7,'linewidth',2)
            %arrow([p7(1)+boxwidth*.5 p7(2)-boxwidth*.5],[p7(1)+boxwidth*.5 p7(2)],'linewidth',3,'edgecolor','r','facecolor','r')
    end
    
    % now draw a fixation point square at mean location of fixation
    if SAT_(trls(trl),1) == 1; r = rectangle('position',[-.25,-.25,.4,.4],'edgecolor','r','facecolor','r','linewidth',2); end
    if SAT_(trls(trl),1) == 2; r = rectangle('position',[-.25,-.25,.4,.4],'edgecolor','k','facecolor','k','linewidth',2); end
    if SAT_(trls(trl),1) == 3; r = rectangle('position',[-.25,-.25,.4,.4],'edgecolor','g','facecolor','g','linewidth',2); end
    
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
    for time = Target_(1,1)-1000:50:size(EyeX_,2)-1000
        
        FrameCount = FrameCount + 1;
        
        %if time == 1; pause(1); end
        
        
        subplot(5,4,1:3)
        v = vline(time-Target_(1,1),'k');
        set(v,'linewidth',2)
        
        subplot(5,4,[9:11 13:15 17:19])
        sc = scatter(EyeX_(trls(trl),time),EyeY_(trls(trl),time),'k','SizeData',25,'MarkerFaceColor','r');
%         box on
%         set(gca,'xtick',[])
%         set(gca,'ytick',[])
%         set(gca,'linewidth',5)
        pause(.0001)
        set(sc,'SizeData',15,'MarkerFaceColor','k')
        
        %if you do NOT want to keep eye path visible (i.e., you want to see
        %only 1 point / sample) enable the below.  Note that it will make
        %each trial run more quickly and the sound will probably lose
        %synchronization
        
        %delete(sc)
        
        if time == Target_(1,1)
            tPos = find(Stimuli_(trls(trl),:) == TargStim);
            dPos = find(Stimuli_(trls(trl),:) ~= TargStim);
            
            %draw target (always "T" for this example)
            t1 = text(eval(['p' mat2str(tPos-1) '(1)'])+.4*boxwidth,eval(['p' mat2str(tPos-1) '(2)']) + .5*boxheight,'T','fontsize',20,'fontweight','bold');
            
            %turn off filled fixation point
            set(r,'facecolor','none')
            
            %draw in distractor stimuli (always "L" for this example)
            for distractor = 1:7
                t2(distractor) = text(eval(['p' mat2str(dPos(distractor)-1) '(1)'])+.4*boxwidth,eval(['p' mat2str(dPos(distractor)-1) '(2)'])+.5*boxheight,'L','fontsize',20,'fontweight','bold');
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
         
        %turn off time marker on upper plot
        subplot(5,4,1:3)
        delete(v)%set(v,'visible','off')
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