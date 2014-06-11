%Critical cell analyses

%reads from "cell_list.txt"
tic
close all
clear all

saveFlag = 1;

[file_list cell_list] = textread('TDT.txt','%s %s');




for i = 1:size(file_list,1)

    load(file_list{i},'-mat')
    file_list{i}
    %set luminance values

    Spike = eval(cell_list{i});
    %find relevant RFs
    varlist = who;

    %remove hash cells if they exist
    varlist = who;
    cells = varlist(strmatch('DSP',varlist));
    m = 1;
    for j = 1:length(cells)
        if isempty(strfind(cell2mat(cells(j)),'i') > 0)
            varlist_clean(m) = cells(j);
            m = m + 1;
        end
    end



    y = strmatch(cell_list{i},varlist_clean);

    if exist('RFs') == 0
        file_list(i)
        disp('above has no RFs')
        RF = [];
    else
        RF = RFs{y};
    end
    %Get ROC area and TDT

    [ROCarea, TDT(i,1:3)] = ROC(Spike,RF,Target_,Correct_,TrialStart_);


    [ax,h3] = suplabel(strcat('Filename:  ',cell2mat(file_list(i)),'    Cell:  ',cell2mat(cell_list(i)),'    Generated: ',date),'t');
    set(h3,'FontSize',10)

    outdir = 'C:\Data\Analyses\TDT\';

    if saveFlag == 1
        eval(['print -dpdf ',outdir,cell2mat(file_list(i)),'_',cell2mat(cell_list(i)),'_ROC.pdf']);
    end

    close all

    keep saveFlag file_list cell_list i TDT
end
