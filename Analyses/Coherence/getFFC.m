%quick function to return just partial field-field coherence
%assumes fields have been inverted if desired
%if inputting EEG instead of LFP, assumes all pre-processing of EEG has
%been done (e.g., truncating 20 ms before the saccade...)
%
%RPH

function [tout,f,Pcoh,coh] = getFFC(LFP1,LFP2,trls,tapers)

Target_ = evalin('caller','Target_');

if nargin < 4;    tapers = PreGenTapers([.2 5]); end

pad = 4;

[coh,f,tout,~,~,Pcoh] = LFP_LFPCoh(LFP1(trls,:),LFP2(trls,:),tapers,1000,.01,[0 100],0,-Target_(1,1),0,pad,.05,0,2,2);