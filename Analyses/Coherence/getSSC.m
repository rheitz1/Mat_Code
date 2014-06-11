%quick function to return just partial spike-field coherence
%corrects Spike channel for you
%
%RPH

function [tout,f,Pcoh,coh] = getSSC(Spike1,Spike2,trls,tapers)

Target_ = evalin('caller','Target_');

if nargout < 3; error('Too few output arguments'); end

if nargin < 4
    tapers = PreGenTapers([.2 5]);
else
    tapers = PreGenTapers([tapers(1) tapers(2)]);
end


%if spike channel not corrected yet, correct
if isempty(find(isnan(Spike1))) && isempty(find(isnan(Spike2)))
    Spike1(find(Spike1 == 0)) = NaN;
    Spike1 = Spike1 - Target_(1,1); %put on correct time scale
    
    Spike2(find(Spike2 == 0)) = NaN;
    Spike2 = Spike2 - Target_(1,1);
end

pad = 4;

[coh,f,tout,~,~,Pcoh] = Spk_SpkCoh(Spike1(trls,:),Spike2(trls,:),tapers,[-Target_(1,1) 2500],1000,.01,[0 100],0,pad,.05,0,2,2);

end