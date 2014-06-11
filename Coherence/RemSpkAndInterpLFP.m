function AD=RemSpkAndInterpLFP(AD,Spk,t0,InterpBn,ViewExampTr)
% function AD=RemSpkAndInterpLFP(AD,Spk,t0,InterpBn,ViewExampTr)
%
% Given the inputs AD and Spk, this will remove the LFP data around the 
% time of each spike and interpolate the LFP data. The general purpose of
% this is to analyze Spk_LFPCoh for spk-LFP pairs on the same electrode
% without the fear of spikes on that electrode contributing to the LFP.
%
% Sampling rate presently assumd to be 1 kHz. Written by MJN
%
% INPUTS:
%   AD:         A [nTr x nSamps] matrix of LFP values.
%   Spk:        Spk timestamps array in [Tr x MaxnSpks] form. Trials with
%               fewer than the maximum number of spikes are assumed to be
%               padded with NaNs.
%   t0:         The timestamp of the first sample in Y. The time must be 
%               relative to the same temporal reference point (usually the 
%               target onset) as spikes. This is a necessary input to match
%               the times of Y and Spk. Defaults to 0.
%   InterpBn:           The relative times (in ms) around the spike to 
%                       remove from the LFP and interpolate (endpoints 
%                       inclusive, at this point assumed to be an integer 
%                       input in the code.) Defaults to [-2 2]
%   ViewExampTr:    Set to 1 to add a plot of the performance of the 
%                   program for one sample trial, chosen to be the trial
%                   with the most spikes. Defaults to 0.
%
% OUTPUTS:
%   AD:     Output AD data, in same format as the input: nTr x nSamps.


disp('Note: if Spike channel has been unaltered, the align time (T0) should be 0.')
if nargin<5 || isempty(ViewExampTr);        ViewExampTr=0;      end
if nargin<4 || isempty(InterpBn);        InterpBn=[-2 2];      end
if nargin<3 || isempty(t0);        t0=0;      end

if ViewExampTr
    [tmpi,tmpj] = find( ~isnan(Spk) );
    [~,mInd]=max(tmpj);
    exTr=tmpi(mInd);
    %exTr=find( ~isnan(Spk(:,end)),1,'first' );  %This works fine if the matrix is already 'trimmed' on the right of excess nans... but if not, you need to use the above code    
    figure
    plot(AD(exTr,:),'r')
    hold on
end

t=t0:t0+size(AD,2)-1;
nt=length(t);
MaxnSpks=size(Spk,2);

%have to loop across trials
for iTr=1:size(AD,1)         
    %if mod(iTr,100)==0;       disp(['On trial: ' num2str(iTr)]);        end
    %YI = INTERP1(X,Y,XI,METHOD)
    
    %there's probably a way to do this without looping across spikes, but just loop across spikes...    
    Keept=repmat(true,nt,1);     %for the interp below, the idea is to keep all of the timepoints that aren't within InterpBn of a spike   
    iSpk=1;
    while iSpk<=MaxnSpks && ~isnan( Spk(iTr,iSpk) )
        Keept( max(Spk(iTr,iSpk)-t0+1+InterpBn(1),1) : min(Spk(iTr,iSpk)-t0+1+InterpBn(2),nt) )=false;     %Spk(iTr,iSpk)-t0+1 gives the AD sample index of the current Spk
        iSpk=iSpk+1;
    end
    
    AD(iTr,:)=interp1( t(Keept),AD(iTr,Keept),t,'pchip');
end

if ViewExampTr
    figure
    plot(AD(exTr,:),'b')
    title(['Tr: ' num2str(exTr) ' r: raw, b: SpkRem']) 
end

