%find usable files and plot slope of burst detector lines

[file_name cell_name] = textread('Contrast_Quincy.txt', '%s %s');

%load file of burst detector times
load('bursts_lums','-mat')

plotFlag = 0;

if plotFlag == 1
    figure
    orient landscape
    hold
end

c = 1;
x = [1 2 3];
for file = 1:length(file_name)

    %select only usable files, which are contained in the Contrast_Seymour
    %and Contrast_Quincy text files

    %find index where information is kept re: current file
    %     cur = strmatch(eval(mat2str(cell2mat(file_name(file)))),cell2mat(Burst_Record(:,1)));
    cur_f = strmatch(eval(mat2str(cell2mat(file_name(file)))),cell2mat(Burst_Record(:,1)));
    cur_c = strmatch(eval(mat2str(cell2mat(cell_name(file)))),cell2mat(Burst_Record(:,2)));
    loc = cur_c(find(ismember(cur_c,cur_f)));

    Q_meanBurst(file,1:3) = Burst_Record(loc,3:5);
    Q_corrs(file,1) = corr([cell2mat(Q_meanBurst(file,1)) cell2mat(Q_meanBurst(file,2)) cell2mat(Q_meanBurst(file,3))]',x');
    Q_corrs_files(file,1) = Burst_Record(loc,1);
    Q_corrs_files(file,2) = Burst_Record(loc,2);
    Q_meanBurst_maxDiff(file,1) = cell2mat(Q_meanBurst(file,1)) - cell2mat(Q_meanBurst(file,3));

    if plotFlag == 1
        plot(cell2mat(Burst_Record(loc,3:5)))
    end

    %
    %     else
    %         Q_meanBurst(c,1:3) = Burst_Record(cur_f,3:5);
    %         Q_corrs(c,1) = corr([cell2mat(Q_meanBurst(c,1)) cell2mat(Q_meanBurst(c,2)) cell2mat(Q_meanBurst(c,3))]',x');
    %         Q_corrs_files(c,1) = Burst_Record(cur_f,1);
    %         Q_corrs_files(c,2) = Burst_Record(cur_f,2);
    %
    %         if plotFlag == 1
    %             plot(cell2mat(Burst_Record(cur_f,3:5)))
    %         end
    %
    %
    %         c = c+1;
    %     end
end

%keep Q_meanBurst Q_corrs Q_corrs_files plotFlag


%for Seymour
[file_name cell_name] = textread('Contrast_Seymour.txt', '%s %s');

%load file of burst detector times
load('bursts_lums','-mat')


if plotFlag == 1
    figure
    orient landscape
    hold
end

c = 1;
x = [1 2 3];
for file = 1:length(file_name)

    %select only usable files, which are contained in the Contrast_Seymour
    %and Contrast_Quincy text files

    %find index where information is kept re: current file
    %     cur = strmatch(eval(mat2str(cell2mat(file_name(file)))),cell2mat(Burst_Record(:,1)));
    cur_f = strmatch(eval(mat2str(cell2mat(file_name(file)))),cell2mat(Burst_Record(:,1)));
    cur_c = strmatch(eval(mat2str(cell2mat(cell_name(file)))),cell2mat(Burst_Record(:,2)));
    loc = cur_c(find(ismember(cur_c,cur_f)));

    S_meanBurst(file,1:3) = Burst_Record(loc,3:5);
    S_corrs(file,1) = corr([cell2mat(S_meanBurst(file,1)) cell2mat(S_meanBurst(file,2)) cell2mat(S_meanBurst(file,3))]',x');
    S_corrs_files(file,1) = Burst_Record(loc,1);
    S_corrs_files(file,2) = Burst_Record(loc,2);
    S_meanBurst_maxDiff(file,1) = cell2mat(S_meanBurst(file,1)) - cell2mat(S_meanBurst(file,3));

    if plotFlag == 1
        plot(cell2mat(Burst_Record(loc,3:5)))
    end

    %
    %     else
    %         Q_meanBurst(c,1:3) = Burst_Record(cur_f,3:5);
    %         Q_corrs(c,1) = corr([cell2mat(Q_meanBurst(c,1)) cell2mat(Q_meanBurst(c,2)) cell2mat(Q_meanBurst(c,3))]',x');
    %         Q_corrs_files(c,1) = Burst_Record(cur_f,1);
    %         Q_corrs_files(c,2) = Burst_Record(cur_f,2);
    %
    %         if plotFlag == 1
    %             plot(cell2mat(Burst_Record(cur_f,3:5)))
    %         end
    %
    %
    %         c = c+1;
    %     end
end



%Create stacked histogram of correlation (slope) values
if plotFlag == 1
    figure
    orient landscape
    set(gcf,'Color','white')

    %create separate histograms
    [S_hist, bins] = hist(S_corrs,30);
    Q_hist = hist(Q_corrs,30);
    cat_hist = cat(1,S_hist,Q_hist);

    bar(bins,cat_hist','stacked')
    ylim([0 40])
end