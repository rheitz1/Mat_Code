function ContSpk=mySpk2Cont(Spk, bn, Fs)
%function ContSpk=mySpk2Cont(Spk, bn, Fs)
%
% Converts spike timestamps into a continuous value (sampled at each ms)
% for use with Spike Spectrum routines
%
%INPUTS:
%   Spk-        Array of Spk data in (nTr x MaxnSpks) form. Trials with
%               fewer than the maximum number of spikes are assumed to be
%               padded with NaNs.
%   bn-         A 2x1 row or column vector listing the start and end of the 
%               window to create a Continuous value spike train for.
%               Defaults to [min(min( Spk )) max(max( Spk ))]
%   Fs-         The sampling rate (in Hz) to determine the resolution of 
%               the output ContSpk. if Fs<1000, ContSpk can have a value of
%               greater than 1 in a given bin. Defaults to 1000.
%
%OUTPUTS:
%   ContSpk-    The Continuous spike train values, a 2D array of size(nTr x
%               bn(2)-bn(1)+1). This will contain one sample spanning each ms
%               from bn(1) to bn(2) for each trial, with a value of either
%               1 or 0 denoting whether or not a spk occurred at that ms
%               for that trial.
%
% Matt Nelson 081018

if nargin < 3 || isempty(Fs);     Fs=1000;       end
if nargin < 2 || isempty(bn);     bn=[min(min( Spk )) max(max( Spk ))];       end
SampPer=1/Fs*1000;  %in units of ms

nTr=size(Spk,1);
edges = bn(1):SampPer:bn(2)+SampPer;     %this will define the bin edges for histc
ContSpk=repmat(0,nTr,length(edges)-1);

for iTr=1:nTr
    tmpH=histc(Spk(iTr,:),edges);
    ContSpk(iTr,:)=tmpH(1:end-1);   % we don'twant the last val from the output of histc
end
