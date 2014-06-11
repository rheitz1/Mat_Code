%Richard P. Heitz
%Vanderbilt
%6/20/07
% %Plot SDFs by screen location
% %Use to find cell's RF
%
%maxspike = 0;
%create a list of all variables in workspace
clear all
close all
cd 'D:\Data\RawData\'
file_path = 'D:\Data\RawData\';
q = ''''; c = ','; qcq = [q c q];

batch_list = dir('D:\Data\RawData\*_1*.*');




for i = 1:length(batch_list)
    disp('Press key to begin next file...')
    pause
    close all
    eval(['load(',q,file_path,batch_list(i).name,qcq,'-mat',q,')'])
    batch_list(i).name
    %Contrast flag to optionally run contrast sensitivity analysis
    ContrastFlag = 1;
    %Print Flag
    printflag = 0;
    %Save PDF flag
    saveflag = 0;

    %DRAW RASTER script
    eval('SDF_screenloc_raster')

    eval('getCellnames')


    for k = 1:length(CellNames) 
        orient landscape;
        set(gcf,'Color','white')
       % CellName = eval(cell2mat(CellNames(k)));
        TotalSpikes = eval(cell2mat(CellNames(k)));

        Contrast_sensitivity_new(RFs{k},batch_list(i).name,CellNames(k),TotalSpikes,Target_,Errors_,Correct_,TrialStart_);

    end
    keep batch_list file_path q c qcq

end