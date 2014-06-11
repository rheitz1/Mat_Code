%for DMAT toolbox fitting
trunc_RT = 2000;

%%
% Get trials
med_correct = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 2);
med_errors = find(Errors_(:,5) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 2);
med_all = [med_correct ; med_errors];


%All correct trials w/ made deadlines
slow_correct_made_dead = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
fast_correct_made_dead_withCleared = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
fast_correct_made_dead_noCleared = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3) & SAT_(:,11) == 0);

%=========================


slow_errors_made_dead = find(Errors_(:,5) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
fast_errors_made_dead_withCleared = find(Errors_(:,5) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
fast_errors_made_dead_noCleared = find(Errors_(:,5) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3) & SAT_(:,11) == 0);

%All trials w/ made deadlines
slow_all_made_dead = [slow_correct_made_dead ; slow_errors_made_dead];
fast_all_made_dead_withCleared = [fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared];
fast_all_made_dead_noCleared = [fast_correct_made_dead_noCleared ; fast_errors_made_dead_noCleared];


%All correct trials w/ missed deadlines (too late in FAST/too early in SLOW
slow_correct_missed_dead = find(Errors_(:,6) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3));
fast_correct_missed_dead_withCleared = find(Errors_(:,7) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3));
fast_correct_missed_dead_noCleared = find(Errors_(:,7) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3) & SAT_(:,11) == 0);

slow_errors_missed_dead = find(Errors_(:,5) == 1 & isnan(Errors_(:,6)) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3));
fast_errors_missed_dead_withCleared = find(Errors_(:,5) == 1 & isnan(Errors_(:,7)) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3));
fast_errors_missed_dead_noCleared = find(Errors_(:,5) == 1 & isnan(Errors_(:,7)) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3) & SAT_(:,11) == 0);

%All trials w/ missed deadlines
slow_all_missed_dead = [slow_correct_missed_dead ; slow_errors_missed_dead];
fast_all_missed_dead_withCleared = [fast_correct_missed_dead_withCleared ; fast_errors_missed_dead_withCleared];
fast_all_missed_dead_noCleared = [fast_correct_missed_dead_noCleared ; fast_errors_missed_dead_noCleared];


%All correct trials made + missed
slow_correct_made_missed = [slow_correct_made_dead ; slow_correct_missed_dead];
fast_correct_made_missed_withCleared = [fast_correct_made_dead_withCleared ; fast_correct_missed_dead_withCleared];
fast_correct_made_missed_noCleared = [fast_correct_made_dead_noCleared ; fast_correct_missed_dead_noCleared];

slow_errors_made_missed = [slow_errors_made_dead ; slow_errors_missed_dead];
fast_errors_made_missed_withCleared = [fast_errors_made_dead_withCleared ; fast_errors_missed_dead_withCleared];
fast_errors_made_missed_noCleared = [fast_errors_made_dead_noCleared ; fast_errors_missed_dead_noCleared];

%All trials made + missed
slow_all = [slow_all_made_dead ; slow_all_missed_dead];
fast_all_withCleared = [fast_all_made_dead_withCleared ; fast_all_missed_dead_withCleared];
fast_all_noCleared = [fast_all_made_dead_noCleared ; fast_all_missed_dead_noCleared];


%ACC rate for made deadlines
ACC.slow_made_dead = length(slow_correct_made_dead) / length(slow_all_made_dead);
ACC.fast_made_dead_withCleared = length(fast_correct_made_dead_withCleared) / length(fast_all_made_dead_withCleared);
ACC.fast_made_dead_noCleared = length(fast_correct_made_dead_noCleared) / length(fast_all_made_dead_noCleared);


%ACC rate for missed deadlines
ACC.slow_missed_dead = length(slow_correct_missed_dead) / length(slow_all_missed_dead);
ACC.fast_missed_dead_withCleared = length(fast_correct_missed_dead_withCleared) / length(fast_all_missed_dead_withCleared);
ACC.fast_missed_dead_noCleared = length(fast_correct_missed_dead_noCleared) / length(fast_all_missed_dead_noCleared);


%overall ACC rate for made + missed deadlines
ACC.slow_made_missed = length(slow_correct_made_missed) / length(slow_all);
ACC.fast_made_missed_withCleared = length(fast_correct_made_missed_withCleared) / length(fast_all_withCleared);
ACC.fast_made_missed_noCleared = length(fast_correct_made_missed_noCleared) / length(fast_all_noCleared);

ACC.med = length(med_correct) / length(med_all);



%%
%Fitting procedure

%create toFit variable.  column 1 = condition, column 2 = ACC, column 3 =
%RT in seconds
%NOTE: this is structured for sessions w/ only a fast and a slow condition

%=============================================
%condition
a(1:length(slow_correct_made_missed),1) = 1;
a(1:length(slow_correct_made_missed),2) = 1;
a(1:length(slow_correct_made_missed),3) = SRT(slow_correct_made_missed,1) / 1000;

b(1:length(slow_errors_made_missed),1) = 1;
b(1:length(slow_errors_made_missed),2) = 0;
b(1:length(slow_errors_made_missed),3) = SRT(slow_errors_made_missed,1) / 1000;

c(1:length(med_correct),1) = 2;
c(1:length(med_correct),2) = 1;
c(1:length(med_correct),3) = SRT(med_correct,1) / 1000;

d(1:length(med_errors),1) = 2;
d(1:length(med_errors),2) = 0;
d(1:length(med_errors),3) = SRT(med_errors,1) / 1000;

e(1:length(fast_correct_made_missed_withCleared),1) = 3;
e(1:length(fast_correct_made_missed_withCleared),2) = 1;
e(1:length(fast_correct_made_missed_withCleared),3) = SRT(fast_correct_made_missed_withCleared,1) / 1000;

f(1:length(fast_errors_made_missed_withCleared),1) = 3;
f(1:length(fast_errors_made_missed_withCleared),2) = 0;
f(1:length(fast_errors_made_missed_withCleared),3) = SRT(fast_errors_made_missed_withCleared,1) / 1000;

data_made_missed = [a ; b ; c ; d ; e ; f];

data_made_missed = removeNaN(data_made_missed);


%=============================================
g(1:length(slow_correct_made_dead),1) = 1;
g(1:length(slow_correct_made_dead),2) = 1;
g(1:length(slow_correct_made_dead),3) = SRT(slow_correct_made_dead,1) / 1000;

h(1:length(slow_errors_made_dead),1) = 1;
h(1:length(slow_errors_made_dead),2) = 0;
h(1:length(slow_errors_made_dead),3) = SRT(slow_errors_made_dead,1) / 1000;

k(1:length(med_correct),1) = 2;
k(1:length(med_correct),2) = 1;
k(1:length(med_correct),3) = SRT(med_correct,1) / 1000;

l(1:length(med_errors),1) = 2;
l(1:length(med_errors),2) = 0;
l(1:length(med_errors),3) = SRT(med_errors,1) / 1000;

m(1:length(fast_correct_made_dead_withCleared),1) = 3;
m(1:length(fast_correct_made_dead_withCleared),2) = 1;
m(1:length(fast_correct_made_dead_withCleared),3) = SRT(fast_correct_made_dead_withCleared,1) / 1000;

n(1:length(fast_errors_made_dead_withCleared),1) = 3;
n(1:length(fast_errors_made_dead_withCleared),2) = 0;
n(1:length(fast_errors_made_dead_withCleared),3) = SRT(fast_errors_made_dead_withCleared,1) / 1000;

data_made_dead = [g ; h ; k ; l ; m ; n];

% 
% %accuracy rate
% %need to make a new 'correct' variable that fixes missed deadlines that
% %were actually correct
% fixedCorrect = Correct_(:,2);
% fixedCorrect(slow_correct_missed_dead) = 1;
% fixedCorrect(fast_correct_missed_dead_withCleared) = 1;
% 
% data_made_missed(1:size(SRT,1),2) = fixedCorrect;
% 
% %RT in seconds
% data_made_missed(1:size(SRT,1),3) = SRT(:,1) / 1000;
% 
% %remove stray NaN's, keeping trial structure intact
% data_made_missed = removeNaN(data_made_missed);
% %==============================================





% 
% 
% toFit(1:length(slow_all_alldead),1) = 1;
% toFit(length(slow_all_alldead)+1:(length(slow_all_alldead)+length(fast_all_alldead)),1) = 2;
% 
% toFit(1:length(slow_all_alldead),2) = Correct_(slow_all_alldead,2);
% toFit(length(slow_all_alldead)+1:(length(slow_all_alldead)+length(fast_all_alldead)),2) = Correct_(fast_all_alldead,2);
% 
% toFit(1:length(slow_all_alldead),3) = SRT(slow_all_alldead,1) / 1000;
% toFit(length(slow_all_alldead)+1:(length(slow_all_alldead)+length(fast_all_alldead)),3) = SRT(fast_all_alldead,1) / 1000;
% 
% %call default options struct
% opts = multiestv4();
% 
% %alter some settings
% opts.Name = 'test';
% 
% 
% output = multiestv4(toFit,opts);