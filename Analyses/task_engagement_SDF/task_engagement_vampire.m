function [] = task_engagement_vampire(file)
path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/ALLDATA/')


q = '''';
c = ',';
qcq = [q c q];
PDFflag = 1;
saveFlag = 1;


% PDFdir = '~/desktop/temp/PDF/';
% MATdir = '~/desktop/temp/Matrices/';

PDFdir = '//scratch/heitzrp/Output/Task_Engagement/PDF/';
MATdir = '//scratch/heitzrp/Output/Task_Engagement/Matrices/';


try
    ChanStruct = loadChan(file,'DSP');
    %DSPlist = fieldnames(ChanStruct);
        x = fieldnames(ChanStruct); %need to temporarily do this because 'shorten_file' will 
    %erroneously include 'DSPlist' in its list of real DSP channels.
    %Setting back after calling 'shorten_file' 
    decodeChanStruct
catch
    DSPlist = [];
    disp('ERROR IN DSP CHANNELS....SKIPPING')
end


%load Target_ & Correct_ variable
eval(['load(' q file qcq 'Hemi' qcq 'RFs' qcq 'newfile' qcq 'Errors_' qcq 'SRT' qcq 'Target_' qcq 'Correct_' qcq 'TrialStart_' qcq '-mat' q ')']);
fixErrors

%only use file if it has at least 2000 trials; then, truncate each file to
%use ONLY 2000 trials.  We will be missing very long sessions,  but we
%should be matching on absolute length
if size(Target_,1) < 2000
    disp('File too short...aborting...')
    return
else
    shorten_file %truncate file to 2000 trials exactly
end

DSPlist = x;
%=============================================================
% TDT for Spike Channels
if isempty(DSPlist)
    disp('No Spike Channel detected...')
else
    
    
    
    for DSPchan = 1:size(DSPlist,1)
        Spike = eval(cell2mat(DSPlist(DSPchan)));
        RF = eval(['RFs.' cell2mat(DSPlist(DSPchan))]);
        
        if isempty(RF)
            disp('Empty RF...moving on...')
        else
            
            antiRF = mod((RF+4),8);
            
            SDF = sSDF(Spike,Target_(:,1),[-100 500]);
            
            %find trial #s and randomize them for the subsampling below
            in_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            out_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            
            
            %number of 400-trial blocks
            window = 400;
            numBlocks = floor(size(Target_,1) / window);
            
            
            
            for block = 1:numBlocks
                in = in_correct(find(in_correct > window*(block-1) & in_correct <= window*block));
                out = out_correct(find(out_correct > window*(block-1) & out_correct <= window*block));
                
                TDT.(cell2mat(DSPlist(DSPchan))).x(block,1) = getTDT_SP(Spike,in,out);
                wf.(cell2mat(DSPlist(DSPchan))).in(block,1:601) = nanmean(SDF(in,:));
                wf.(cell2mat(DSPlist(DSPchan))).out(block,1:601) = nanmean(SDF(out,:));
                ROC.(cell2mat(DSPlist(DSPchan))).x(block,1:601) = getROC(SDF,in,out);
                RT.(cell2mat(DSPlist(DSPchan))).x(block,1) = nanmean(SRT([in;out],1));
            end
            
            %only needs to be run once because it itself quantifies block
            binprob.(cell2mat(DSPlist(DSPchan))) = getBinomialErrors(Correct_,Errors_,window);
            
            
            if PDFflag == 1
                f = figure;
                fw
                subplot(2,3,1)
                hold
                graymap = linspace(0,.9,numBlocks); %set dimmest color to be .9 so its always visible
                for plt = 1:numBlocks
                    plot(-100:500,wf.(cell2mat(DSPlist(DSPchan))).in(plt,:),'-',-100:500,wf.(cell2mat(DSPlist(DSPchan))).out(plt,:),'--','Color',[graymap(plt) graymap(plt) graymap(plt)])
                    xlim([-100 500])
                end
                title('SDFs')
                xlabel('Time')
                ylabel('Spikes/s')
                
                subplot(2,3,2)
                plot(1:window:window*numBlocks,TDT.(cell2mat(DSPlist(DSPchan))).x)
                title('TDT')
                xlabel('Trial')
                
                
                subplot(2,3,3)
                hold
                for plt = 1:numBlocks
                    plot(-100:500,ROC.(cell2mat(DSPlist(DSPchan))).x(plt,:),'color',[graymap(plt) graymap(plt) graymap(plt)])
                    xlim([-100 500])
                end
                title('ROC')
                xlabel('Time')
                
                subplot(2,3,4)
                plot(1:window:window*numBlocks,RT.(cell2mat(DSPlist(DSPchan))).x)
                title('RT')
                xlabel('Trial')
                ylabel('RT')
                
                subplot(2,3,5)
                plot(1:window:window*numBlocks,binprob.(cell2mat(DSPlist(DSPchan))))
                title('Bin Prob of Errors')
                xlabel('Trial')
                ylabel('p')
                
                subplot(2,3,6)
                %calculate average area of ROC curve between 150-300 ms
                %post target-onset
                ROCarea = nanmean(ROC.(cell2mat(DSPlist(DSPchan))).x(:,250:400),2);
                plot(1:window:window*numBlocks,ROCarea)
                xlabel('Trial')
                ylabel('ROC area')
                title('ROC area 150 - 300 ms')
                
                eval(['print -dpdf ' PDFdir file '_' DSPlist{DSPchan} '.pdf'])
            end
            
            
            
            
            
        end
        
    end
    clear Spike SDF* RF antiRF
end
%==========================================================



if saveFlag == 1
    eval(['save(' q MATdir,file,'.mat' qcq 'ROC' qcq 'wf' qcq 'TDT' qcq 'RT' qcq 'binprob' qcq '-mat' q ')'])
end

end