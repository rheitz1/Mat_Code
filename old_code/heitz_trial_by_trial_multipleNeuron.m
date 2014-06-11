load('C:\Documents and Settings\Steph\Desktop\NorSef_f.102','-mat')

%call to subfunction to sort trials.  This is done to create the raster
%display.
[RT_unsort,RT_sort,Sort_index,Sort_index_clean] = CalcSortRT(Target_(:,1),Saccade_(:,1));

CellName = input('Enter Cell ID: ');

if isempty(CellName)
    CellName = DSP01a;
end


%create a list of all variables in workspace
varlist = who;

%find indexes of cell names
CellMarker = strmatch('DSP0',varlist);

%create a list of target cells to analyze
for a = 1:length(CellMarker)
    CellNames(a,1) = varlist(CellMarker(a))
end

%want to align at trial start.  actual "trial start" variable is a clock
%read, so instead, take time of target onset and subtract it from itself.
%SDF will be aligned at 0.
Align_Time_= (Target_(Sort_index(Sort_index_clean),1) - Target_(Sort_index(Sort_index_clean,1)));
Eot_=TrialStart_+500;
triallist_=1:length(Sort_index_clean);
Plot_Time=[0 8000];

for i = 1:length(CellNames)
    figure
    CellName = eval(cell2mat(CellNames(i)));
    %draw SDF
    subplot(6,1,5)
    SDF=[];
    [SDF] = spikedensityfunct_lgn_old(CellName, Align_Time_, Plot_Time, triallist_, TrialStart_, Eot_, 1);
    plot(SDF,'r','LineWidth',2)
    xLabel('Spike Density Function')
    axis([0 8000 -inf inf])

    %draw raster
    subplot(6,1,6)
    for i = 1:length(Sort_index_clean)
        for l = 1:length(CellName(i,:))
           line([CellName(Sort_index(Sort_index_clean(i,1)),l) CellName(Sort_index(Sort_index_clean(i,1)),l)], [i-1 i+1])
        end
    end
    axis([0 8000 -inf inf])
    Xlabel('Raster Display')
end


for trial=1:length(Sort_index_clean)
    for i = 1:length(CellNames)
        figure(i)
    subplot(6,1,1)
    time_x = (1:length(EyeX_))*4;
    plot(time_x,EyeX_(Sort_index(Sort_index_clean(trial)),:))
    Xlabel('X-axis Eye position');
    line([250 250],[-400 0]);
    set(gcf,'Color','white')
    axis([0 8000 -inf inf])  
    subplot(6,1,2)
    plot(time_x,EyeY_(Sort_index(Sort_index_clean(trial)),:))
    Xlabel('Y-axis Eye Position');
    axis([0 8000 -inf inf])
  
    
 
    subplot(6,1,3)
    %draw target onset
    axis([0 8000 -10 10])
    %draw target onset
    line([Target_(Sort_index(Sort_index_clean(trial))) Target_(Sort_index(Sort_index_clean(trial)))], [-10 10]);


    %draw saccade onset
    line([Saccade_(Sort_index(Sort_index_clean(trial))) Saccade_(Sort_index(Sort_index_clean(trial)))], [-10 10],'color','r');
    xLabel('Blue: Target Onset    Red: Saccade Onset')

    %draw spike train
    subplot(6,1,4)
    for l = 1:length(CellName(Sort_index(Sort_index_clean(trial)),:))
        line([CellName(Sort_index(Sort_index_clean(trial)),l) CellName(Sort_index(Sort_index_clean(trial)),l)], [-10 10],'color', 'b');
    end
    xLabel('Spike Train')
    axis([0 8000 -inf inf])

    tdisp = int2str(Sort_index(Sort_index_clean(trial)));
    text(2000,-100,tdisp,'HorizontalAlignment','left','verticalalignment','top')
    Title('Trial-By-Trial Analysis')


    end
        pause
    
    %redraw changing portion of figures so that each display is not
    %superimposed.
% for i = 1:length(CellNames)
%     figure(i)
%     cla
%     subplot(6,1,3)
%     cla
%     subplot(6,1,4)
%     cla
% end
end
