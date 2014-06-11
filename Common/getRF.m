%getRF_MF looks through a file and determines the
%relevent MFs and RFs in file, based on DSP signal loaded

%figure out if more than one DSP channel is in current workspace
% if length(strmatch('DSP',who)) > 1
%     disp('More than one DSP channel in current workspace...')
% else
%     varlist = who('-file',cell2mat(file_name(file)));
%     D_S_list = varlist(strmatch('DSP',who('-file',cell2mat(file_name(file)))));
%     x = strmatch(cell2mat(cell_name(file)),D_S_list);
%     RF = RFs{x};
%     BestRF = BestRF{x};
%     MF = MFs{x};
%     BestMF = BestMF{x};
% end
% 
% clear varlist D_S_list x RFs MFs


    %have to search in file because we do not know if DSP channels
    %currently loaded are the ONLY DSP channels in the file.  Necessary for
    %linking with RFs variable
    file_varlist = who('-file',newfile);
    varlist = who;
    all_neurons_in_workspace = varlist(strmatch('DSP',varlist));
    all_neurons_in_file = file_varlist(strmatch('DSP',who('-file',newfile)));
    
    for nNeuron = 1:length(all_neurons_in_workspace)
        RF{nNeuron} = RFs{strmatch(all_neurons_in_workspace(nNeuron),all_neurons_in_file)};
    end