function [] = SDF_raster(SDF,currSpikes,Cell_name,CorrectTrials,Target_,SDFPlot_Time,cell_num)

%Plots SDFs and rasters by screen location
figure
set(gcf,'Color','white')

for j = 0:7
    %Will be plotting with subplot, but need to specify where each
    %screen location will fall in subplot coordinates
    switch j
        case 0
            screenloc = 6;
        case 1
            screenloc = 3;
        case 2
            screenloc = 2;
        case 3
            screenloc = 1;
        case 4
            screenloc = 4;
        case 5
            screenloc = 7;
        case 6
            screenloc = 8;
        case 7
            screenloc = 9;
    end
    
    %Collapse across set size for this plot, but only in the 
    %multidimensional array.  We retain single-trial information
    %as we are passing the entire array of spikes ("currSpikes")
    SDF_sz_collapse = nanmean(SDF,3);
    
    subplot(3,3,screenloc)
    plot(SDFPlot_Time(1):SDFPlot_Time(2),SDF_sz_collapse(:,j+1,1,cell_num)/(max(max(SDF_sz_collapse(:,:,1,cell_num))))*100,'Color','r')
    xlim([0 2000])
    ylim([0 100])
    set(gca,'XTickLabel',-500:100:1500)
    
    %draw raster
    
    %use find command so that we can plot trials sequentially even
    %when they are actually separated by other trials (i.e., screen
    %locations chosen randomly, but still want to plot sequentially
    
    rastertrials = find(Target_(CorrectTrials,2) == j);
    
    %where do you want raster plots to start?
    y_start = 1;
    
    for trl = 1:size(rastertrials,1)
        toplot = nonzeros(currSpikes(rastertrials(trl),:));
        for time_index = 1:length(toplot)
            line([toplot(time_index) toplot(time_index)],[y_start+trl-.5 y_start+trl+.5],'Color','k')
        end
    end
end

%plot final position
subplot(3,3,5)
SDF_sz_loc_collapse = nanmean(nanmean(SDF,3),2);

plot(SDFPlot_Time(1):SDFPlot_Time(2),SDF_sz_loc_collapse(:,1,1,cell_num)/(max(max(SDF_sz_loc_collapse(:,1,1,cell_num))))*100,'Color','r')
    for trl = 1:size(currSpikes,1)
        toplot = nonzeros(currSpikes(trl,:));
        for time_index = 1:length(toplot)
            line([toplot(time_index) toplot(time_index)],[y_start+trl-.5 y_start+trl+.5],'Color','k')
        end
    end
suplabel(mat2str(cell2mat(Cell_name)),'t')


    