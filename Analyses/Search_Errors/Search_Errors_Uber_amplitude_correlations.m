%analysis routine to compute trial-by-trial amplitude correlations within a
%session between spikes-LFP, spikes-EEG, and LFP-EEG.  For this to work,
%all trials must be matched.  Therefore, we will use only the NEURON RF,
%unlike the full analysis which uses the neuron RF for neurons only, and
%hemifield otherwise.  Furthermore, we will compute the correlation only
%for signals that had significant TDT by running wilcoxon.
%
%RPH

function [] = Search_Errors_Uber_amplitude_correlations(file)
warning off
path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/ALLDATA/')


q = '''';
c = ',';
qcq = [q c q];
saveFlag = 1;


%t PDFdir = '~/desktop/temp/PDF/';
MATdir = '/volumes/Dump/Analyses/Errors/amplitude_correlations/';

%PDFdir = '//scratch/heitzrp/Output/Search_Errors/PDF/';
%MATdir = '//scratch/heitzrp/Output/Search_Errors/Matrices/';


try
    loadChan(file,'DSP');
    varlist = who;
    DSPlist = varlist(strmatch('DSP',varlist));
    clear varlist
catch
    DSPlist = [];
    %  disp('ERROR IN DSP CHANNELS....SKIPPING')
end


try
    loadChan(file,'LFP');
    varlist = who;
    LFPlist = varlist(strmatch('AD',varlist));
    clear varlist
catch
    LFPlist = [];
    %  disp('ERROR IN LFP CHANNELS ....SKIPPING')
end

%manually add AD02 and AD03
try
    eval(['load(' q file qcq 'AD02' qcq '-mat' q ')']);
    % disp('loading AD02')
    chanlist3{1,1} = 'AD02';
catch
    %  disp('Missing AD02')
end

try
    eval(['load(' q file qcq 'AD03' qcq '-mat' q ')']);
    chanlist3{2,1} = 'AD03';
    %  disp('loading AD03')
catch
    %  disp('Missing AD03')
end

EEGlist = chanlist3;

%full chanlist
allchanlist = [DSPlist;LFPlist;EEGlist];




%load Target_ & Correct_ variable
eval(['load(' q file qcq 'Hemi' qcq 'RFs' qcq 'MFs' qcq 'newfile' qcq 'Errors_' qcq 'SRT' qcq 'Target_' qcq 'Correct_' qcq 'TrialStart_' qcq '-mat' q ')']);
fixErrors

eval(['load(' q file qcq 'EyeX_' qcq 'EyeY_' q ')'])
[SRT saccLoc] = getSRT(EyeX_,EyeY_);

%keep track of RTs
RTs.correct = SRT(find(Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & Target_(:,2) ~= 255),1);
RTs.errors = SRT(find(Errors_(:,5) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & Target_(:,2) ~= 255),1);


%keep track of how many signal comparisons we've done for indexing purposes
SPK_LFP_index = 1;
SPK_EEG_index = 1;
LFP_EEG_index = 1;
%=============================================================
% SPIKE - LFP correlations using the neuron RF
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
            
            %find trial #s and randomize them for the subsampling below
            in_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            out_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            in_incorrect = find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            out_incorrect = find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            if length(in_correct) < 10 || length(out_correct) < 10 || ...
                    length(in_incorrect) < 10 || length(out_incorrect) < 10
                disp('Too few Trials')
                continue
            end
            
            
            SDF = sSDF(Spike,Target_(:,1),[-500 2000]);
            
            
            %only get integral if the signal selected the target on correct
            %trials
            TDT = getTDT_SP(Spike,in_correct,out_correct);
            
            if ~isempty(TDT)
                %we will only consider variations from 150ms post target
                %onset up to the moment of saccade, from Cohen et al., 2009
                %p. 2378
                
                %use truncate function to set moment of saccade onward on
                %each trial to NaN
                SDF = truncateSP_targ(SDF,SRT,[-500 2000],0);
                
                %now get rid of first 650 ms (500 ms baseline + 150 ms)
                SDF(:,1:650) = [];
                %SDF(find(SDF == 0)) = NaN;
                
                %take integral and divide by # of usable observations
                integral.(DSPlist{DSPchan}).in_correct = nansum(SDF(in_correct,:),2) ./ sum(~isnan(SDF(in_correct,:)),2);
                integral.(DSPlist{DSPchan}).out_correct = nansum(SDF(out_correct,:),2) ./ sum(~isnan(SDF(out_correct,:)),2);
                integral.(DSPlist{DSPchan}).in_incorrect = nansum(SDF(in_incorrect,:),2) ./ sum(~isnan(SDF(in_incorrect,:)),2);
                integral.(DSPlist{DSPchan}).out_incorrect = nansum(SDF(out_incorrect,:),2) ./ sum(~isnan(SDF(out_incorrect,:)),2);
            end
            
            %do for each LFP if there is an overlap of RF & LFP tuning from
            %tuning curve
            for LFPchan = 1:size(LFPlist,1)
                LFP = eval(cell2mat(LFPlist(LFPchan)));
                LFP = baseline_correct(LFP,[400 500]);
                LFP = truncateAD_targ(LFP,SRT,0);
                
                TDT = getTDT_AD(LFP,in_correct,out_correct);
                
                
                
                if ~isempty(TDT)
                    LFPRF = LFPtuning(LFP);
                    
                    LFP(:,1:650) = [];
                    
                    
                    if ~isempty(intersect(RF,LFPRF))
                        integral.(LFPlist{LFPchan}).in_correct = nansum(LFP(in_correct,:),2) ./ sum(~isnan(LFP(in_correct,:)),2);
                        integral.(LFPlist{LFPchan}).out_correct = nansum(LFP(out_correct,:),2) ./ sum(~isnan(LFP(out_correct,:)),2);
                        integral.(LFPlist{LFPchan}).in_incorrect = nansum(LFP(in_incorrect,:),2) ./ sum(~isnan(LFP(in_incorrect,:)),2);
                        integral.(LFPlist{LFPchan}).out_incorrect = nansum(LFP(out_incorrect,:),2) ./ sum(~isnan(LFP(out_incorrect,:)),2);
                        
                        %get rid of NaNs for correlation
                        r_in_cor = removeNaN([integral.(DSPlist{DSPchan}).in_correct integral.(LFPlist{LFPchan}).in_correct]);
                        r_out_cor = removeNaN([integral.(DSPlist{DSPchan}).out_correct integral.(LFPlist{LFPchan}).out_correct]);
                        r_in_incor = removeNaN([integral.(DSPlist{DSPchan}).in_incorrect integral.(LFPlist{LFPchan}).in_incorrect]);
                        r_out_incor = removeNaN([integral.(DSPlist{DSPchan}).out_incorrect integral.(LFPlist{LFPchan}).out_incorrect]);
                        
                        
                        %compute correlation
                        [cor.SPK_LFP.in_correct(SPK_LFP_index,1) p.SPK_LFP.in_correct(SPK_LFP_index,1)] = corr(r_in_cor(:,1),r_in_cor(:,2));
                        [cor.SPK_LFP.out_correct(SPK_LFP_index,1) p.SPK_LFP.out_correct(SPK_LFP_index,1)] = corr(r_out_cor(:,1),r_out_cor(:,2));
                        [cor.SPK_LFP.in_incorrect(SPK_LFP_index,1) p.SPK_LFP.in_incorrect(SPK_LFP_index,1)] = corr(r_in_incor(:,1),r_in_incor(:,2));
                        [cor.SPK_LFP.out_incorrect(SPK_LFP_index,1) p.SPK_LFP.out_incorrect(SPK_LFP_index,1)] = corr(r_out_incor(:,1),r_out_incor(:,2));
                        info.SPK_LFP{SPK_LFP_index,1} = file;
                        info.SPK_LFP{SPK_LFP_index,2} = DSPlist{DSPchan};
                        info.SPK_LFP{SPK_LFP_index,3} = LFPlist{LFPchan};
                        SPK_LFP_index = SPK_LFP_index + 1;
                    end
                end
            end
            
            %do for OR if there is an overlap of RF & hemifield
            OR = AD02;
            OR = baseline_correct(OR,[400 500]);
            OR = truncateAD_targ(OR,SRT,0);
            
            TDT = getTDT_AD(OR,in_correct,out_correct);
            
            OR(:,1:650) = [];
            
            if ~isempty(TDT)
                OR_RF = [3 4 5];
                
                if ~isempty(intersect(RF,OR_RF))
                    
                    integral.OR.in_correct = nansum(OR(in_correct,:),2) ./ sum(~isnan(OR(in_correct,:)),2);
                    integral.OR.out_correct = nansum(OR(out_correct,:),2) ./ sum(~isnan(OR(out_correct,:)),2);
                    integral.OR.in_incorrect = nansum(OR(in_incorrect,:),2) ./ sum(~isnan(OR(in_incorrect,:)),2);
                    integral.OR.out_incorrect = nansum(OR(out_incorrect,:),2) ./ sum(~isnan(OR(out_incorrect,:)),2);
                    
                    %get rid of NaNs for correlation
                    r_in_cor = removeNaN([integral.(DSPlist{DSPchan}).in_correct integral.OR.in_correct]);
                    r_out_cor = removeNaN([integral.(DSPlist{DSPchan}).out_correct integral.OR.out_correct]);
                    r_in_incor = removeNaN([integral.(DSPlist{DSPchan}).in_incorrect integral.OR.in_incorrect]);
                    r_out_incor = removeNaN([integral.(DSPlist{DSPchan}).out_incorrect integral.OR.out_incorrect]);
                    
                    %compute correlation
                    [cor.SPK_EEG.in_correct(SPK_EEG_index,1) p.SPK_EEG.in_correct(SPK_EEG_index,1)] = corr(r_in_cor(:,1),r_in_cor(:,2));
                    [cor.SPK_EEG.out_correct(SPK_EEG_index,1) p.SPK_EEG.out_correct(SPK_EEG_index,1)] = corr(r_out_cor(:,1),r_out_cor(:,2));
                    [cor.SPK_EEG.in_incorrect(SPK_EEG_index,1) p.SPK_EEG.in_incorrect(SPK_EEG_index,1)] = corr(r_in_incor(:,1),r_in_incor(:,2));
                    [cor.SPK_EEG.out_incorrect(SPK_EEG_index,1) p.SPK_EEG.out_incorrect(SPK_EEG_index,1)] = corr(r_out_incor(:,1),r_out_incor(:,2));
                    info.SPK_EEG{SPK_EEG_index,1} = file;
                    info.SPK_EEG{SPK_EEG_index,2} = DSPlist{DSPchan};
                    info.SPK_EEG{SPK_EEG_index,3} = 'OR';
                    SPK_EEG_index = SPK_EEG_index + 1;
                end
            end
            
        end
        clear Spike SDF* RF antiRF TDT
    end
    %==========================================================
    
    
    %now for LFP & EEG, using hemifield as RF.  We will only need to do
    %this for right hemisphere LFPs since we are only considering skull
    %electrode OR
    
    for LFPchan = 1:size(LFPlist,1)
        LFP = eval(cell2mat(LFPlist(LFPchan)));
        LFP = baseline_correct(LFP,[400 500]);
        LFP = truncateAD_targ(LFP,SRT,0);
        
        
        
        OR = AD02;
        OR = baseline_correct(OR,[400 500]);
        OR = truncateAD_targ(OR,SRT,0);
        
        OR_RF = [3 4 5];
        OR_antiRF = [7 0 1];
        
        if Hemi.(LFPlist{LFPchan}) == 'R'
            LFP_RF = [3 4 5];
            LFP_antiRF = [7 0 1];
            
            in_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),LFP_RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            out_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),LFP_antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            in_incorrect = find(ismember(Target_(:,2),LFP_RF) & ismember(saccLoc,LFP_antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            out_incorrect = find(ismember(Target_(:,2),LFP_antiRF) & ismember(saccLoc,LFP_RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            if length(in_correct) < 10 || length(out_correct) < 10 || ...
                    length(in_incorrect) < 10 || length(out_incorrect) < 10
                disp('Too few Trials')
                continue
            end
            
            TDT.LFP = getTDT_AD(LFP,in_correct,out_correct);
            TDT.OR = getTDT_AD(OR,in_correct,out_correct);
            
            LFP(:,1:650) = [];
            OR(:,1:650) = [];
            
            
            if ~isempty(TDT.LFP) && ~isempty(TDT.OR)
                
                
                if ~isempty(intersect(LFP_RF,OR_RF))
                    integral.(LFPlist{LFPchan}).in_correct = nansum(LFP(in_correct,:),2) ./ sum(~isnan(LFP(in_correct,:)),2);
                    integral.(LFPlist{LFPchan}).out_correct = nansum(LFP(out_correct,:),2) ./ sum(~isnan(LFP(out_correct,:)),2);
                    integral.(LFPlist{LFPchan}).in_incorrect = nansum(LFP(in_incorrect,:),2) ./ sum(~isnan(LFP(in_incorrect,:)),2);
                    integral.(LFPlist{LFPchan}).out_incorrect = nansum(LFP(out_incorrect,:),2) ./ sum(~isnan(LFP(out_incorrect,:)),2);
                    
                    integral.OR.in_correct = nansum(OR(in_correct,:),2) ./ sum(~isnan(OR(in_correct,:)),2);
                    integral.OR.out_correct = nansum(OR(out_correct,:),2) ./ sum(~isnan(OR(out_correct,:)),2);
                    integral.OR.in_incorrect = nansum(OR(in_incorrect,:),2) ./ sum(~isnan(OR(in_incorrect,:)),2);
                    integral.OR.out_incorrect = nansum(OR(out_incorrect,:),2) ./ sum(~isnan(OR(out_incorrect,:)),2);
                    
                    %get rid of NaNs for correlation
                    r_in_cor = removeNaN([integral.(LFPlist{LFPchan}).in_correct integral.OR.in_correct]);
                    r_out_cor = removeNaN([integral.(LFPlist{LFPchan}).out_correct integral.OR.out_correct]);
                    r_in_incor = removeNaN([integral.(LFPlist{LFPchan}).in_incorrect integral.OR.in_incorrect]);
                    r_out_incor = removeNaN([integral.(LFPlist{LFPchan}).out_incorrect integral.OR.out_incorrect]);
                    
                    %compute correlation
                    [cor.LFP_EEG.in_correct(LFP_EEG_index,1) p.LFP_EEG.in_correct(LFP_EEG_index,1)] = corr(r_in_cor(:,1),r_in_cor(:,2));
                    [cor.LFP_EEG.out_correct(LFP_EEG_index,1) p.LFP_EEG.out_correct(LFP_EEG_index,1)] = corr(r_out_cor(:,1),r_out_cor(:,2));
                    [cor.LFP_EEG.in_incorrect(LFP_EEG_index,1) p.LFP_EEG.in_incorrect(LFP_EEG_index,1)] = corr(r_in_incor(:,1),r_in_incor(:,2));
                    [cor.LFP_EEG.out_incorrect(LFP_EEG_index,1) p.LFP_EEG.out_incorrect(LFP_EEG_index,1)] = corr(r_out_incor(:,1),r_out_incor(:,2));
                    info.LFP_EEG{LFP_EEG_index,1} = file;
                    info.LFP_EEG{LFP_EEG_index,2} = LFPlist{LFPchan};
                    info.LFP_EEG{LFP_EEG_index,3} = 'OR';
                    LFP_EEG_index = LFP_EEG_index + 1;
                end
            end
        end
    end
    
    
    %==========================================================
    
    if saveFlag == 1
        if exist('cor')
            eval(['save(' q MATdir,file,'_corr.mat' qcq 'info' qcq 'cor' qcq 'p' qcq '-mat' q ')'])
        else
            disp('No Correlations...')
            return
        end
    end
    
end