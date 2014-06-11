function [PD R NormR p] =TuningTest(Act,Dir)
%function [PD R NormR p] =TuningTest(Act,Dir)
%
% Gives the prefered direction and magnitude of tuning via the method of
% trigonometric moments, and optionally tests the strength of this tuning 
% using a permutation test.
%
% Inputs:
%       Act -   [nTr x 1] vector with the measurement of activity for each
%               trial to be used to test the tuning of.
%       Dir -   The stimulus direction on each trial. Note- this code
%               assumes targets every 45 deg from 0 to 315 are presented.
%               Inputs for dir can be 0 to 7, or 1 to 8, or 2 to 9, etc.
%               Note that Dirs itself should be 0 to 7 or 1 to 8 instead of
%               0 - 315, for example...
%               If needed, the code can easily be changed later to allow
%               for any combination of angles by allowing the user to input
%               the currently hard-coded variable Angs.
%
% Outputs:
%       PD -    The preferred direction for this cell- in units of degrees.
%       R -     The magnitude of the resultant vector. Indicates the
%               strength of the tuning.
%       NormR - The magnitude of the normalized resultant vector.
%               Normalization is done by the dividing the mean activity in
%               each direction by the (unweighted) mean activity across all
%               directions. NormR should be used when comparing tuning
%               strength across different signals with different mean
%               values, or different types of signals (i.e. LFPs and
%               Spikes)
%       p -     The probability (determined using a permutation test) that
%               a resultant vector as large as R will be found when the
%               direction for each trial is randomly assigned.
%
% by MJN 090430
%   Ref: Pesaran, Nelson, Andersen et. al, Nature 2008, supplementary
%       materials
%   And as I am aware of it this technique was first employed by the
%   Kalaska lab at least 15 years ago, though I'm not sure what spefically 
%   is the canonical article to cite. In their methods section, Cisek and 
%   Kalaska (2005) in Neuron cites a bunch of earlier articles that are a
%   good place to look.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Angs=[0:45:315]'*pi/180;
DirVals=min(Dir):min(Dir)+7;

nDirs=max(Dir)-min(Dir)+1;
DirAct=repmat(0,nDirs,1);
for iDr = 1:8   %min(Dir):max(Dir)
    DirAct(iDr) = mean(Act( Dir==DirVals(iDr) ));
end
xPref= sum(DirAct.*cos(Angs));
yPref= sum(DirAct.*sin(Angs));

R=sqrt(xPref^2 + yPref^2);
PD = 180./pi*atan2(yPref,xPref);

%Calc NormR...
%Note- dividing by the unweighted mean per target (as done below) is what we want to do, not dividing by the weighted overall mean of Act     
%To see why- consider a case where two neurons have the mean activty per direction, with very high activity in one direction, but no activity in the others.
%For one neurons, we might have a lot of trials in the directions where there is little activity, and for the other we may have a lot trials in the direction with a lot of activity     
%The weighted (overall) mean in this case would report very different normalized R values b/t these two cells, but the unweighted mean would not. 
%The latter (unweighted) indeed gives us what we want, as it accurately reflects that the activity for these cells is the same, juts the directions were sampled differently     
DirActNorm=DirAct/mean(DirAct);
xPrefNorm= sum(DirActNorm.*cos(Angs));
yPrefNorm= sum(DirActNorm.*sin(Angs));

NormR=sqrt(xPrefNorm^2 + yPrefNorm^2);

if nargout>3
    %Now test sig of tuning
    nits=1000; 
    
    nTr=length(Dir);             
    RandRs=repmat(NaN,nits,1);    
    for iit=1:nits
        tmpDir=Dir( randperm(nTr) );
        for iDr = 1:8   %min(Dir):max(Dir)
            DirAct(iDr) = mean(Act( tmpDir==DirVals(iDr) ));
        end
        RandRs(iit)= sqrt( sum(DirAct.*cos(Angs))^2 + sum(DirAct.*sin(Angs))^2 );                        
    end
    
    p= (sum( RandRs>=R ))/nits;
end
