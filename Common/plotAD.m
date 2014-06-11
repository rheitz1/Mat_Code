% Plots T/in D/in SDF along with TDT for a given AD
% input should be given as a string of the name of the unit you want to
% plot

% RPH
%

function [] = plotAD(name,RFswitch)

%assume you want to use entire hemisphere.  If you want to use an
%associated neuron's RF, set to 1.  If you want to use a tuning curve, set
%to 2
if nargin < 2; RFswitch = 0; end

% Get variables from workspace

AD = evalin('caller',name);
Correct_ = evalin('caller','Correct_');
Target_ = evalin('caller','Target_');
SRT = evalin('caller','SRT');
RFs = evalin('caller','RFs');
MFs = evalin('caller','MFs');
Hemi = evalin('caller','Hemi');
%conversion to spike name given AD channel.  Have to assume unit a....
if RFswitch == 1
    disp('Using Hemifield RF')
    SPKname = ['DSP' name(3:4) 'a'];
    
    RF = RFs.(SPKname);
    MF = MFs.(SPKname);
    
    if isempty(RF) %if no RF, check for an MF for move cells
        if ~isempty(MF)
            RF = MFs.(name);
        else
            error('No RF or MF')
        end
    end
    
    antiRF = mod((RF+4),8);
    
elseif RFswitch == 0
    disp('Using Neuron RF')
    if Hemi.(name) == 'L'
        RF = [7 0 1];
        antiRF = [3 4 5];
    elseif Hemi.(name) == 'R'
        RF = [3 4 5];
        antiRF = [7 0 1];
    end
   
    
elseif RFswitch == 2
    disp('Using tuning curve RF')
    RF = LFPtuning(AD);
    antiRF = mod((RF+4),8);
end
    




if exist('MStim_')
    in = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
else
    
    in = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
end


AD_resp = response_align(AD,SRT(:,1),[-400 200],0);

%remove saturating trials
AD = fixClipped(AD);

%baseline correction
AD = baseline_correct(AD,[Target_(1,1)-100 Target_(1,1)]);
AD_resp = baseline_correct(AD_resp,[1 100]);

TDT = getTDT_AD(AD,in,out);


figure
fw
subplot(1,2,1)
plot(-Target_(1,1):2500,nanmean(AD(in,:)),'k',-Target_(1,1):2500,nanmean(AD(out,:)),'--k','linewidth',2);
vline(TDT,'k')
xlim([-100 800])
xlabel('Time from Target Onset')
ylabel('uV')
axis ij
title([name '  TDT = ' mat2str(TDT)])
box off

subplot(1,2,2)
plot(-400:200,nanmean(AD_resp(in,:)),'k',-400:200,nanmean(AD_resp(out,:)),'--k','linewidth',2)
xlim([-400 200])
vline(0,'k')
axis ij
xlabel('Time from Saccade Onset')
box off