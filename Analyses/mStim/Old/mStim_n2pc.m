%n2pc stim vs. nonstim

%backup variables because n2pc script is hard-coded.  Need to temporarily
%alter stuff
getMonk

Correct_backup = Correct_;
Target_backup = Target_;
SRT_backup = SRT;
AD02_backup = AD02;
AD03_backup = AD03;




stim = find(Correct_(:,2) == 1 & ~isnan(MStim_(:,3)));
nonstim = find(Correct_(:,2) == 1 & isnan(MStim_(:,3)));

clear AD02 AD03 Target_ SRT Correct_



%for non-stim
AD02 = AD02_backup(nonstim,:);
AD03 = AD03_backup(nonstim,:);

AD02 = fixClipped(AD02);
AD03 = fixClipped(AD03);


% AD02 = filtSig(AD02,[.10 5],'bandstop');
% AD03 = filtSig(AD03,[.10 5],'bandstop');


Correct_ = Correct_backup(nonstim,:);
Target_ = Target_backup(nonstim,:);
SRT = SRT_backup(nonstim,:);

%run n2pc
n2pc
suplabel('NON STIM','t');

clear AD03 AD03 Correct_ Target_ SRT

%for stim trials
AD02 = AD02_backup(stim,:);
AD03 = AD03_backup(stim,:);

AD02 = fixClipped(AD02);
AD03 = fixClipped(AD03);


% AD02 = filtSig(AD02,[.10 5],'bandstop');
% AD03 = filtSig(AD03,[.10 5],'bandstop');


Correct_ = Correct_backup(stim,:);
Target_ = Target_backup(stim,:);
SRT = SRT_backup(stim,:);

%run n2pc
n2pc

suplabel('STIM','t');

clear AD03 AD03 Target_ SRT Correct_

AD02 = AD02_backup;
AD03 = AD03_backup;
Target_ = Target_backup;
SRT = SRT_backup;
Correct_ = Correct_backup;

clear *backup