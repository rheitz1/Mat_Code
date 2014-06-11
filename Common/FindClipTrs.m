function ClipTrs=FindClipTrs(curADMat,nConsecSampCutoff)
%function ClipTrs=FindClipTrs(curADMat,nConsecSampCutoff)
%
%Given an input AD matrix divided into trials, this finds trials where 
%clipping occurs. Clipping is determined to happen when more than 
%nConsecSampCutoff (an input to this fxn) samples have the same precise 
%value. For real data, this should only happen when clipping has occured 
%at either the maximal or minimal value for teh analog channel.
%
%Inputs:
%       curADMat:   A nTrials x nSampsPerTrial array containing the samples
%                   of an analog value for each trial.
%       nConsecSampCutoff:      A scalar value indicating the number of
%                   consecutive repeating samples for a clipping event to
%                   be considered to have been found.
%
% Outputs:
%       ClipTrs:    A nTrials x 1 vector of logical values that is true for
%                   trials where sufficient clipping was deemed to have
%                   ocurred.
%
% written by Matthew Nelson on 090226

if nargin<2 || isempty(nConsecSampCutoff);      nConsecSampCutoff=20;       end     %the number of consecutive samples with the same exact value to needed to officially call something a clipped trial

maxval=max(max(curADMat));
minval=min(min(curADMat));

ClipTrs=logical( repmat(0,size(curADMat,1),1) );

%find max OR min clips in the same swoop... 
[I,J]=find( curADMat'==maxval | curADMat'==minval ); %so I will be timepoint and J will be Trial number
[Cks CkInds]=getchunks(diff(I));    %gets the "chunk" length in Cks, and chunk Inds in CkInds of any repeats of at least 2 samples
ClipTrs( unique( J( CkInds( Cks>nConsecSampCutoff ) ) ) )=1;     %sets to true the indices of trials in which the chunks greater than the cutoff length occured