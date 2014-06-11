%RPH
function [] = plotTrialHistory_SAT(UnitName)


Spike = evalin('caller',UnitName);
Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
SAT_ = evalin('caller','SAT_');
RFs = evalin('caller','RFs');
MFs = evalin('caller','MFs');
SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');
saccLoc = evalin('caller','saccLoc');
%finds patterns of correct/errors (trial history)

% capital letter = current trial
% lower case letter = previous trial
% i/I = incorrect
% c/C = correct

crt = Correct_(:,2)';


%Correction for SAT task; missed deadlines sometimes coded as incorrect in 'Correct_' variable but are
%technically correct if not for the deadline.
crt(find(Errors_(:,6) == 1 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3)));
crt(find(Errors_(:,7) == 1 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3)));

%need to tack on 1 because strfind gives 1st indices;
iI = strfind(crt,[0 0])' + 1;
iC = strfind(crt,[0 1])' + 1;
cI = strfind(crt,[1 0])' + 1;
cC = strfind(crt,[1 1])' + 1;



SDF = sSDF(Spike,Target_(:,1),[-400 1000]);
in = find(ismember(saccLoc,RFs.(UnitName))); %use saccLoc to simultaneously find correct and errant saccades into RF

in_iI = intersect(in,iI);
in_cI = intersect(in,cI);
in_iC = intersect(in,iC);
in_cC = intersect(in,cC);

figure
plot(-400:1000,nanmean(SDF(in_cC,:)),'k',-400:1000,nanmean(SDF(in_iC,:)),'--k', ...
    -400:1000,nanmean(SDF(in_cI,:)),'--r',-400:1000,nanmean(SDF(in_iI,:)),'r')
legend('cC','iC','cI','iI')
xlim([-400 1000])
box off
set(gca,'xminortick','on')