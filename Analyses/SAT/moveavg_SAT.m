% plots moving averages of accuracy rate for SAT data
%
% RPH

function [] = moveavg_SAT()

lag = 20;

Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
SAT_ = evalin('caller','SAT_');
SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');

getTrials_SAT

%alter Correct_ variable to take into account missed deadline trials,
%which Tempo scores as incorrect (because no reinforcement delivered)
crt = Correct_;
crt(slow_correct_missed_dead,2) = 1;
crt(fast_correct_missed_dead_withCleared,2) = 1;

move_avg.slow = tsmovavg(crt(slow_all,2)','s',lag);
move_avg.fast = tsmovavg(crt(fast_all_withCleared,2)','s',lag);


figure
plot(move_avg.slow,'r');
hold
plot(move_avg.fast,'g');
xlabel('Bin #')
ylabel('Accuracy rate')

ylim([0 1.1])
hline(1/8,'--r')
hline(1,'k')
box off