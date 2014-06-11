% Compiles population of SAT behavioral data for sharing
%
% RPH


cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
% [filename1] = textread('SAT_Beh_Med_Q.txt','%s');
% [filename2] = textread('SAT_Beh_NoMed_Q.txt','%s');
% [filename3] = textread('SAT_Beh_Med_S.txt','%s');
% [filename4] = textread('SAT_Beh_NoMed_S.txt','%s');
% filename = [filename1 ; filename2 ; filename3 ; filename4];
% 

[filename1] = textread('SAT2_Beh_NoMed_D.txt','%s');
[filename2] = textread('SAT2_Beh_NoMed_E.txt','%s');

filename = [filename1 ; filename2];




% For population, compile all data into one huge dataset
allTarget_ = [];
allCorrect_ = [];
allSRT = [];
allSAT_ = [];
allErrors_ = [];

filenum = [];
allFile_ = [];
allMonk_ = [];

allSaccLoc = [];
allSaccDir_ = [];

allFileNames_ = [];

for file = 1:length(filename)
    load(filename{file},'Correct_','Target_','SRT','SAT_','Errors_','saccLoc','SaccDir_')
    
    filename{file}
    
    date = filename{file};
    date = date(2:7);
        
    filenum(1:size(Target_,1),1) = file;
    
    fi = cell2mat(filename(file));
    monkey = fi(1);
    if monkey == 'D'
        monk(1:size(Target_,1),1) = 1;
    elseif monkey == 'E'
        monk(1:size(Target_,1),1) = 2;
    end
    

    
    allTarget_ = [allTarget_ ; Target_];
    allCorrect_ = [allCorrect_ ; Correct_];
    allSRT = [allSRT ; SRT(:,1)];
    allSAT_ = [allSAT_ ; SAT_];
    allErrors_ = [allErrors_ ; Errors_];
    allFile_ = [allFile_ ; filenum];
    allMonk_ = [allMonk_ ; monk];
    allSaccLoc = [allSaccLoc ; saccLoc];
    allSaccDir_ = [allSaccDir_ ; SaccDir_];
    allFileNames_ = [allFileNames_ ; repmat(date,size(Target_,1),1)];
    
    clear Correct_ Target_ SRT SAT_ Errors_ saccLoc SaccDir_ filenum monk
end

%Rename variables back to what scripts want them to be
Target_ = allTarget_;
Correct_ = allCorrect_;
SRT = allSRT;
SAT_ = allSAT_;
Errors_ = allErrors_;
saccLoc = allSaccLoc;
SaccDir_ = allSaccDir_;

getTrials_SAT


%FIX CORRECT_ VARIABLE FOR MISSED DEADLINES THAT WERE ACTUALLY CORRECT
Correct_(slow_correct_missed_dead,2) = 1;
Correct_(fast_correct_missed_dead_withCleared,2) = 1;


Trial_Mat(:,1) = allMonk_;
Trial_Mat(:,2) = allFile_;
Trial_Mat(:,3) = SAT_(:,1);
Trial_Mat(:,4) = SRT(:,1);
Trial_Mat(:,5) = Correct_(:,2);

%code made/missed deadline
Trial_Mat(:,6) = NaN;
Trial_Mat(slow_correct_made_dead,6) = 1;
Trial_Mat(slow_errors_made_dead,6) = 1;
Trial_Mat(med_correct,6) = 1;
Trial_Mat(med_errors,6) = 1;
Trial_Mat(fast_correct_made_dead_withCleared,6) = 1;
Trial_Mat(fast_errors_made_dead_withCleared,6) = 1;

Trial_Mat(slow_correct_missed_dead,6) = 0;
Trial_Mat(slow_errors_missed_dead,6) = 0;
Trial_Mat(fast_correct_missed_dead_withCleared,6) = 0;
Trial_Mat(fast_errors_missed_dead_withCleared,6) = 0;

Trial_Mat(:,7) = SAT_(:,3);

%Real Target Location
Trial_Mat(:,8) = Target_(:,2);

%Sometimes saccLoc algorithm fails; we can get some of those trials back using SaccDir_, which is Tempo's
%estimate of eye position (but this is only there for error trials)
% err = find(Correct_(:,2) == 0);
% x = saccLoc(err);
% x(:,2) = SaccDir_(err);
% recover = find(isnan(x(:,1)) & ~isnan(x(:,2)));

x = saccLoc;
x(:,2) = SaccDir_;
recover = find(isnan(x(:,1)) & ~isnan(x(:,2)));
saccLoc(recover) = x(recover,2);

clear x err recover


%Actual Saccade Location
Trial_Mat(:,9) = saccLoc;

%Remove irrelevant trials

%remove1 = find(nansum(Errors_(:,1:4),2)); %Latency and target hold errors
remove = find(isnan(Trial_Mat(:,6)));

allFileNames_(remove,:) = [];
%allFileNames_ = str2num(allFileNames_);

Trial_Mat(remove,:) = [];

keep Trial_Mat allFileNames_


%================================
% Plotting

m1_slow = find(Trial_Mat(:,1) == 1 & Trial_Mat(:,3) == 1);
m1_fast = find(Trial_Mat(:,1) == 1 & Trial_Mat(:,3) == 3);

m2_slow = find(Trial_Mat(:,1) == 2 & Trial_Mat(:,3) == 1);
m2_fast = find(Trial_Mat(:,1) == 2 & Trial_Mat(:,3) == 3);

nbins = 200;

figure
subplot(221)
hist(Trial_Mat(m1_slow,4),nbins)
xlim([0 1000])
title('Monkey Q Accurate')

h = findobj(gca,'Type','patch');
set(h(1),'facecolor','r')
set(h(1),'edgecolor','k')


subplot(222)
hist(Trial_Mat(m2_slow,4),nbins)
xlim([0 1000])
title('Monkey S Accurate')

h = findobj(gca,'Type','patch');
set(h(1),'facecolor','r')
set(h(1),'edgecolor','k')

subplot(223)
hist(Trial_Mat(m1_fast,4),nbins)
xlim([0 1000])
title('Monkey Q Fast')

h = findobj(gca,'Type','patch');
set(h(1),'facecolor','g')
set(h(1),'edgecolor','k')

subplot(224)
hist(Trial_Mat(m2_fast,4),nbins)
xlim([0 1000])
title('Monkey S Fast')

h = findobj(gca,'Type','patch');
set(h(1),'facecolor','g')
set(h(1),'edgecolor','k')

keep Trial_Mat allFileNames_