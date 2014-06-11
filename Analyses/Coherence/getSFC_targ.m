%quick function to return just partial spike-field coherence
%corrects Spike channel for you
%
%RPH

function [tout,f,Pcoh,coh] = getSFC_targ(Spike,LFP,trls,interpFlag,tapers)



Target_ = evalin('caller','Target_');

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
    Spike = Spike - Target_(1,1); %to put in register w/ LFP
end

pad = 4;

% NOTE: for Spike - LFP coherence, T0 and BN(1) must be identical due to the way the code is written... I
% think?
%                                                                         t0,              bn,       sampling, dn, fk, plotflag, pad, pval, JustPartFlag,errType,ZTransFlag,ClusShuffOpts)
[coh,f,tout,~,~,Pcoh] = Spk_LFPCoh(Spike(trls,:),LFP(trls,:),tapers,-Target_(1,1),[-Target_(1,1) 800],1000,.01,[0 100],0,pad,.05,0,2,2);
% 
% 
% fast_all_withCleared = evalin('caller','fast_all_withCleared');
% slow_all = evalin('caller','slow_all');
% fast_vs_slow = [fast_all_withCleared ; slow_all];
% 
% ClusShuffOpts.nShuffs = 5000;
% ClusShuffOpts.TestType = 2;
% ClusShuffOpts.TrType(1:length(fast_all_withCleared)) = 1;
% ClusShuffOpts.TrType(length(fast_all_withCleared)+1:length(fast_all_withCleared)+length(slow_all)) = 2;
% [tout,f_shuff,~,~,~,~,~,~,~,~,~,between_cond_shuff,~,~] = Spk_LFPCoh(Spike(fast_vs_slow,:),LFP(fast_vs_slow,:),tapers,-Target_(1,1),[-Target_(1,1) 1000],1000,.01,[0 100],0,pad,.05,0,2,2,ClusShuffOpts);
