%CVLV analysis
q = ''''; c = ','; qcq = [q c q];

%f_path = 'C:\Data\Analyses\Contrast_2008\';
[file_name cell_name] = textread('Contrast_2008_all.txt', '%s %s');

CVLV_counter = 1;
for i = 1:length(file_name)

    close all
    eval(['load(',q,cell2mat(file_name(i)),qcq,cell2mat(cell_name(i)),qcq,'TrialStart_',qcq,'-mat',q,')'])

    %display current file
    file_name(i)


    TotalSpikes = eval(cell2mat(cell_name(i)));

    [CV,LV] = getCVLV(TotalSpikes,TrialStart_);
    CV_all(CVLV_counter,1) = median(CV);
    LV_all(CVLV_counter,1) = median(LV);
    file_index{CVLV_counter} = cell2mat(file_name(i));
    cell_index(CVLV_counter) = cell_name(i);
    CVLV_counter = CVLV_counter + 1

end
keep file_name cell_name q c qcq CV_all LV_all CVLV_counter file_index cell_index

