function [] = breakFiles(file_path, fileID, outfile)

%Break into separate files for DET, MG, and SEARCH trials.

load([file_path outfile],'-mat')
vars2save = who;

DET_trials = find(Target_(:,9) == 1 & Target_(:,10) == 0);
MG_trials = find((Target_(:,9) == 1 | Target_(:,9) == 2) & Target_(:,10) > 0);
SEARCH_trials = find(Target_(:,9) == 2 & Target_(:,10) == 0 & Target_(:,3) < 5); %last condition ensures we were not accidentally running MG w/ a hold time of 0.  < 5 because a few days had target colors of 2 instead of 1

disp(['Found ' mat2str(size(DET_trials,1))  ' DETECTION trials'])
disp(['Found ' mat2str(size(MG_trials,1)) ' MEMORY GUIDED trials'])
disp(['Found ' mat2str(size(SEARCH_trials,1)) ' SEARCH trials'])

%Because vars2save is dependent on number of units, size won't always be
%the same.  Calculate how many variables we care about (which will always
%be the first variables, so 1:n.  Also, TrialStart_ is always the last of
%the relevant variables.

endvar = strmatch('TrialStart_',vars2save);

keep fileID file_path outfile vars2save DET_trials MG_trials SEARCH_trials endvar
%save supporting files for future use
save('tempvars.mat', 'DET_trials', 'MG_trials','SEARCH_trials','file_path','vars2save','outfile','fileID','endvar')

if ~isempty(DET_trials)
    load([file_path outfile],'-mat')
    out_ = '_DET.mat';
    newfile = strcat(fileID,out_);
    clear out_
    %subtract 6 so that we do not attempt to index fileID,file_path, etc
    %which are inevitably the last variables
    for var_index = 1:endvar%length(vars2save)-6
        eval([cell2mat(vars2save(var_index)) ' = ' cell2mat(vars2save(var_index)) '(DET_trials,:);'])
    end
    clear var_index DET_trials MG_trials SEARCH_trials vars2save outfile endvar
    save([file_path newfile],'-mat')
end

clear all
load('tempvars.mat')

if ~isempty(MG_trials)
    load([file_path outfile],'-mat')
    out_ = '_MG.mat';
    newfile = strcat(fileID,out_);
    clear out_
    for var_index = 1:endvar%length(vars2save)-6
        eval([cell2mat(vars2save(var_index)) ' = ' cell2mat(vars2save(var_index)) '(MG_trials,:);'])
    end
    clear var_index DET_trials MG_trials SEARCH_trials vars2save outfile endvar
    save([file_path newfile],'-mat')
end

clear all
load('tempvars.mat')

if ~isempty(SEARCH_trials)
    load([file_path outfile],'-mat')
    out_ = '_SEARCH.mat';
    newfile = strcat(fileID,out_);
    clear out_
    for var_index = 1:endvar%length(vars2save)-6
        eval([cell2mat(vars2save(var_index)) ' = ' cell2mat(vars2save(var_index)) '(SEARCH_trials,:);'])
    end

    %no need to save supporting files here; just clear them
    clear var_index DET_trials MG_trials SEARCH_trials vars2save outfile endvar
    save([file_path newfile],'-mat')
end

delete('tempvars.mat')