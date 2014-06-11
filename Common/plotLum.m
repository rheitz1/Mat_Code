% Plots SDFs by luminance in memory guided task
%
% RPH
function [] = plotLum(name)

%figure out if entering a spike or an LFP channel
ch = name(1:2);
switch ch 
    case 'DS'
        % Get variables from workspace
        
        Spike = evalin('caller',name);
        Correct_ = evalin('caller','Correct_');
        Target_ = evalin('caller','Target_');
        SRT = evalin('caller','SRT');
        RFs = evalin('caller','RFs');
        MFs = evalin('caller','MFs');
        
        RF = RFs.(name);
        MF = MFs.(name);
        
        if isempty(RF) %if no RF, check for an MF for move cells
            if ~isempty(MF)
                RF = MFs.(name);
            else
                error('No RF or MF')
            end
        end
        
        antiRF = mod((RF+4),8);
        
        
        SDF = sSDF(Spike,Target_(:,1),[-100 500]);
        SDF_resp = sSDF(Spike,SRT(:,1)+500,[-400 200]);
        
        lumarray = sort(unique(Target_(:,3)));
        
        %remove any accidental 1's
        
        lumarray = lumarray(find(lumarray > 1));
        
        %what is division between spacings?
        jump = lumarray(2) - lumarray(1);
        
        %also group some together
        spacing = ceil(length(lumarray) / 3);
        L1 = lumarray(1):jump:lumarray(spacing);
        L2 = lumarray(spacing+1):jump:lumarray(spacing*2);
        L3 = lumarray(spacing*2+1):jump:lumarray(end);
        
        L1_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L1) & ismember(Target_(:,2),RF));
        L2_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L2) & ismember(Target_(:,2),RF));
        L3_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L3) & ismember(Target_(:,2),RF));
        
        figure
        subplot(2,2,1)
        hold on
        
        col = [1 1 1];
        for lum = 1:length(lumarray)
            trls = find(Correct_(:,2) == 1 & Target_(:,3) == lumarray(lum) & ismember(Target_(:,2),RF));
            plot(-100:500,nanmean(SDF(trls,:)),'Color',col)
            clear trls
            col = col - .1;
        end
        xlim([-100 500])
        
        subplot(2,2,2)
        %drawing them in reverse order because lower values = darker stim.
        plot(-100:500,nanmean(SDF(L1_trls,:)),'r',-100:500,nanmean(SDF(L2_trls,:)),'b',-100:500,nanmean(SDF(L3_trls,:)),'k')
        xlim([-100 500])
   
        
        
% for LFPs
    case 'AD'
        
        AD = evalin('caller',name);
        Correct_ = evalin('caller','Correct_');
        Target_ = evalin('caller','Target_');
        SRT = evalin('caller','SRT');
        Hemi = evalin('caller','Hemi');
        
        
        if Hemi.(name) == 'R'
            RF = [3 4 5];
        elseif Hemi.(name) == 'L'
            RF = [7 0 1];
        end
        
%         RF = LFPtuning(AD);
        antiRF = mod((RF+4),8);
        
        disp(['AD RF = ' mat2str(RF)])
        
        AD = fixClipped(AD);
        AD = baseline_correct(AD,[400 500]);
        
        lumarray = sort(unique(Target_(:,3)));
        
        %remove any accidental 1's
        
        lumarray = lumarray(find(lumarray > 1));
        
        %what is division between spacings?
        jump = lumarray(2) - lumarray(1);
        
        %also group some together
        spacing = ceil(length(lumarray) / 3);
        L1 = lumarray(1):jump:lumarray(spacing);
        L2 = lumarray(spacing+1):jump:lumarray(spacing*2);
        L3 = lumarray(spacing*2+1):jump:lumarray(end);
        
        L1_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L1) & ismember(Target_(:,2),RF));
        L2_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L2) & ismember(Target_(:,2),RF));
        L3_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L3) & ismember(Target_(:,2),RF));
        
        figure
        subplot(2,2,1)
        hold on
        
        col = [1 1 1];
        for lum = 1:length(lumarray)
            trls = find(Correct_(:,2) == 1 & Target_(:,3) == lumarray(lum) & ismember(Target_(:,2),RF));
            plot(-500:2500,nanmean(AD(trls,:)),'Color',col)
            clear trls
            col = col - .1;
        end
        xlim([-100 500])
        
        subplot(2,2,2)
        %drawing them in reverse order because lower values = darker stim.
        plot(-500:2500,nanmean(AD(L1_trls,:)),'r',-500:2500,nanmean(AD(L2_trls,:)),'b',-500:2500,nanmean(AD(L3_trls,:)),'k')
        axis ij
        xlim([-100 500])
end