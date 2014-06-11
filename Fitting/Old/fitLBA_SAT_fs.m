clear Trial_Mat remove* A b v s T0 lb ub

%This version assumes equal drift rates, biases, and boundaries for all screen positions.  This boils the
%model down into a 2AFC condition
minimize = 1;
plotFlag = 1;
made_dead_only = 1; %if set to 0, includes all trials irregardless of made/missed deadlines


%SET PARAMETERS TO FIXED OR FREE, 1 FOR Fixed, n FOR NUMBER OF CONDITIONS
%FREE TO VARY ACROSS FOR THAT PARAMETER
% FORMAT:  A b v T0  %%% s assumed to always be fixed
FreeFix = [1 2 2 1]; %set all parameters free

tic
A(1:FreeFix(1)) = .01;
b(1:FreeFix(2)) = 100;
v(1:FreeFix(3)) = .6;
T0(1:FreeFix(4)) = 100;
s = .1; % ALWAYS FIXED;

lb.A(1:FreeFix(1)) = 0;
lb.b(1:FreeFix(2)) = 0;
lb.v(1:FreeFix(3)) = 0;
lb.T0(1:FreeFix(4)) = 0;

ub.A(1:FreeFix(1)) = 500;
ub.b(1:FreeFix(2)) = 500;
ub.v(1:FreeFix(3)) = 1;
ub.T0(1:FreeFix(4)) = 800;



if made_dead_only
    %All correct trials w/ made deadlines
    slow_correct = find(Correct_(:,2) == 1  & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
    fast_correct_withCleared = find(Correct_(:,2) == 1  & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
    
    slow_errors = find(Errors_(:,5) == 1  & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
    fast_errors_withCleared = find(Errors_(:,5) == 1  & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
    
else
    slow_correct_made_dead = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
    fast_correct_made_dead_withCleared = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
    slow_errors_made_dead = find(Errors_(:,5) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
    fast_errors_made_dead_withCleared = find(Errors_(:,5) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
    
    slow_correct_missed_dead = find(Errors_(:,6) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3));
    fast_correct_missed_dead_withCleared = find(Errors_(:,7) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3));
    slow_errors_missed_dead = find(Errors_(:,5) == 1 & isnan(Errors_(:,6)) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3));
    fast_errors_missed_dead_withCleared = find(Errors_(:,5) == 1 & isnan(Errors_(:,7)) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3));
    
    slow_correct = [slow_correct_made_dead ; slow_correct_missed_dead];
    fast_correct_withCleared = [fast_correct_made_dead_withCleared ; fast_correct_missed_dead_withCleared];
    
    slow_errors = [slow_errors_made_dead ; slow_errors_missed_dead];
    fast_errors_withCleared = [fast_errors_made_dead_withCleared ; fast_errors_missed_dead_withCleared];
    
    %FIX CORRECT_ VARIABLE FOR MISSED DEADLINES THAT WERE ACTUALLY CORRECT
    Correct_(slow_correct_missed_dead,2) = 1;
    Correct_(fast_correct_missed_dead_withCleared,2) = 1;
end


%FORMAT:
% TARGET LOC  |  ACTUAL LOC (WINNING UNIT)  |  CORRECT/ERR   |  RT | SetSize
valid_trials = [slow_correct ; fast_correct_withCleared ; slow_errors ; fast_errors_withCleared];
Trial_Mat(:,1) = Target_(valid_trials,2);
Trial_Mat(:,2) = NaN; %LEGACY
Trial_Mat(:,3) = Correct_(valid_trials,2);
Trial_Mat(:,4) = SRT(valid_trials,1);
Trial_Mat(:,5) = SAT_(valid_trials,1);


%eliminate error trials that were not saccade direction errors and get rid of catch trials
remove1 = find(nansum(Errors_(valid_trials,1:4),2));
remove2 = find(Target_(valid_trials,2) == 255);
remove3 = find(~ismember(valid_trials,1:size(Target_,1)));
remove = unique([remove1 ; remove2 ; remove3]);

Trial_Mat(remove,:) = [];


if minimize == 1
    param = [A,b,v,T0];
    lower = [lb.A,lb.b,lb.v,lb.T0];
    upper = [ub.A,ub.b,ub.v,ub.T0];
    options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
    [solution minval exitflag output] = fminsearchbnd(@(param) fitLBA_SAT_fs_calcLL(param,Trial_Mat),param,lower,upper,options)
    
    % options = gaoptimset('Generations',1000,'StallGenLimit',1000,...
    %    'MigrationDirection','forward','TolFun',1e-10);
    % %options.PopInitRange = [0 0 0; 100 100 100];
    % %options = gaoptimset(options,'HybridFcn', {  @fminsearch [] });
    %
    % solution = ga(@(param) fitLBA_TL_2AFC_setsize_calcLL(param,Trial_Mat),numel(param),[],[],[],[],lower,upper,[],options);
    
    A = solution(1:length(A));
    b = solution(length(A)+1:length(A)+length(b));
    v = solution(length(A)+length(b)+1:length(A)+length(b)+length(v));
    T0 = solution(length(A)+length(b)+length(v)+1:length(solution));
    s = [s s];
    %     A = solution(1:2);
    %     b = solution(3:4);
    %     v = solution(5:6);
    %     %s = solution(5:6);
    %     T0 = solution(7:8);
    %     s = [s s];
else
    s = [s s];
    minval = fitLBA_SAT_fs_calcLL_FREEFIXED(param,Trial_Mat);
    
end
%Bayesian Information Criterion
n_free = numel(param);
n_obs = size(Trial_Mat,1);
LL = -minval; %reset back to positive number, since we minimized the negative to maximize the positive
BIC = (-2 * LL) + (n_free * n_obs);

slow.err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 1);
slow.correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 1);
fast.err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 3);
fast.correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 3);

if plotFlag
    
    % %this is kludgy, but will work for plotting.  Tile parameters as if they were free, but just replicate
    % %those that are fixed
    if FreeFix(1) == 1; A = [A A]; end
    if FreeFix(2) == 1; b = [b b]; end
    if FreeFix(3) == 1; v = [v v]; end
    if FreeFix(4) == 1; T0 = [T0 T0]; end
    
    CDF.slow = getDefectiveCDF(slow.correct,slow.err,Trial_Mat(:,4));
    CDF.fast = getDefectiveCDF(fast.correct,fast.err,Trial_Mat(:,4));
    
    winner.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1))));
    loser.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),1-v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),v(1),s(1))));
    t.slow = (1:1000) + T0(1);
    
    winner.fast = cumsum(linearballisticPDF(1:1000,A(2),b(2),v(2),s(2)) .* (1-linearballisticCDF(1:1000,A(2),b(2),1-v(2),s(2))));
    loser.fast = cumsum(linearballisticPDF(1:1000,A(2),b(2),1-v(2),s(2)) .* (1-linearballisticCDF(1:1000,A(2),b(2),v(2),s(2))));
    t.fast = (1:1000) + T0(2);
    
    figure
    fon
    
    subplot(1,2,1)
    plot(t.slow,winner.slow,'k',t.slow,loser.slow,'r')
    hold on
    plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'ok',CDF.slow.err(:,1),CDF.slow.err(:,2),'or')
    ylim([0 1])
    xlim([0 1000])
    text(100,.95,['A = ' mat2str(round(A(1)*100)/100)])
    text(100,.90,['b = ' mat2str(round(b(1)*100)/100)])
    text(100,.85,['v = ' mat2str(round(v(1)*100)/100)])
    text(100,.80,['s = ' mat2str(round(s(1)*100)/100)])
    text(100,.75,['T0 = ' mat2str(round(T0(1)*100)/100)])
    title('SLOW/ACCURATE')
    box off
    
    subplot(1,2,2)
    plot(t.fast,winner.fast,'k',t.fast,loser.fast,'r')
    hold on
    plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok',CDF.fast.err(:,1),CDF.fast.err(:,2),'or')
    ylim([0 1])
    xlim([0 1000])
    text(100,.95,['A = ' mat2str(round(A(2)*100)/100)])
    text(100,.90,['b = ' mat2str(round(b(2)*100)/100)])
    text(100,.85,['v = ' mat2str(round(v(2)*100)/100)])
    text(100,.80,['s = ' mat2str(round(s(2)*100)/100)])
    text(100,.75,['T0 = ' mat2str(round(T0(2)*100)/100)])
    title('FAST')
    box off
    
    [ax h] = suplabel(['LL = ' mat2str(round(minval*100)/100) ' BIC = ' mat2str(round(BIC*1000)/1000)],'t');
    set(h,'fontsize',12)
end

disp(['Optimization ran for ' mat2str(round((toc/60)*1000)/1000) ' minutes'])