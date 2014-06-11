%quick function to return just partial spike-field coherence
%corrects Spike channel for you
%
%RPH

function [tout,f,Pcoh,coh] = getSFC_fix(Spike,LFP,trls,interpFlag,tapers)

Target_ = evalin('caller','Target_');
FixTimes = evalin('caller','FixTime_Jit_');

Plot_Time = [-1000 3000];

if nargout < 3; error('Too few output arguments'); end

if nargin < 5;    tapers = PreGenTapers([.2 5]); end
%if nargin < 5; tapers = hann(200); end

if nargin < 4
    interpFlag = 0;
    disp('Not Interpolating LFP...')
end

if interpFlag
    LFP = RemSpkAndInterpLFP(LFP,Spike,0,[-2 2],0);
    disp('Interpolating LFP around each spike...')
end


%Tapers won't work unless its a row vector (not a column vector). Transpose if necessary
if size(tapers,1) > size(tapers,2)
    disp('Transposing Tapers...')
    tapers = tapers';
end


%if spike channel not corrected yet, correct
if isempty(find(isnan(Spike)))
    Spike(find(Spike == 0)) = NaN;
    Spike_fix = Spike - repmat(FixTimes,1,size(Spike,2)); %to put in register w/ LFP
end

LFP_fix = fix_align(LFP,FixTimes,[Plot_Time(1) Plot_Time(2)]);

remove = find(any(isnan(LFP_fix),2));

%LFP_resp(remove,:) = [];

%remove bad trials from trial list, not from raw signals to preserve
%indexing
trls(intersect(trls,remove)) = [];

pad = 4;

% NOTE: for Spike - LFP coherence, T0 and BN(1) must be identical due to the way the code is written... I
% think?
[coh,f,tout,~,~,Pcoh] = Spk_LFPCoh(Spike_fix(trls,:),LFP_fix(trls,:),tapers,Plot_Time(1),[Plot_Time(1) Plot_Time(2)],1000,.01,[0 100],0,pad,.05,0,2,2);
