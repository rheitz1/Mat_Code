%analysis routine for TDT correct vs errors in all signals

% Spikes: Compute TDT @ relaxed criterion of .05,5 for correct trials.
% Do not truncate
% Calucate correct trial TDT after downsampling to # of error trials,
% repeat 100 times, take average.

% LFP: Same as spikes but do not truncate, try both neuron RF and hemifield
% RF (for paper, am using hemifield RF)
%
% OL & OR: truncate 20 ms before saccade
%
% P2Pc: same as for LFP, but use only hemifield.
%RPH
%6/15/09


function [] = Search_Errors_Uber_vampire_final(file)
warning off
path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/ALLDATA/')


q = '''';
c = ',';
qcq = [q c q];
PDFflag = 0;
saveFlag = 0;
numSamps = 100;
%numSamps = 1;

% PDFdir = '~/desktop/temp/PDF/';
% MATdir = '~/desktop/temp/Matrices/';

PDFdir = '//scratch/heitzrp/Output/Search_Errors/PDF/';
MATdir = '//scratch/heitzrp/Output/Search_Errors/Matrices/';


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
eval(['load(' q file qcq 'Hemi' qcq 'RFs' qcq 'newfile' qcq 'Errors_' qcq 'SRT' qcq 'Target_' qcq 'Correct_' qcq 'TrialStart_' qcq '-mat' q ')']);
fixErrors

eval(['load(' q file qcq 'EyeX_' qcq 'EyeY_' q ')'])
[SRT saccLoc] = getSRT(EyeX_,EyeY_);

%keep track of RTs
RTs.correct = SRT(find(Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & Target_(:,2) ~= 255),1);
RTs.errors = SRT(find(Errors_(:,5) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & Target_(:,2) ~= 255),1);

%only need to get RTs for trial history one time.
%NOTE: THESE DO NOT REMOVE CATCH TRIALS!!!!!!!!!!!!!!!!
Cor = Correct_(:,2)';
c_c_temp = [1 1];
e_c_temp = [0 1];
c_e_temp = [1 0];
e_e_temp = [0 0];

c_c_temp = strfind(Cor,c_c_temp);
e_c_temp = strfind(Cor,e_c_temp);
c_e_temp = strfind(Cor,c_e_temp);
e_e_temp = strfind(Cor,e_e_temp);

%strfind only gets first instance, need 2nd, so add 1
c_c_temp = c_c_temp' + 1;
e_c_temp = e_c_temp' + 1;
c_e_temp = c_e_temp' + 1;
e_e_temp = e_e_temp' + 1;

RTs.c_c = nanmean(SRT(c_c_temp,1));
RTs.c_e = nanmean(SRT(c_e_temp,1));
RTs.e_c = nanmean(SRT(e_c_temp,1));
RTs.e_e = nanmean(SRT(e_e_temp,1));


%now get saccade metrics for each screen position and condition
cc.pos0 = intersect(c_c_temp,find(Target_(:,2) == 0));
cc.pos1 = intersect(c_c_temp,find(Target_(:,2) == 1));
cc.pos2 = intersect(c_c_temp,find(Target_(:,2) == 2));
cc.pos3 = intersect(c_c_temp,find(Target_(:,2) == 3));
cc.pos4 = intersect(c_c_temp,find(Target_(:,2) == 4));
cc.pos5 = intersect(c_c_temp,find(Target_(:,2) == 5));
cc.pos6 = intersect(c_c_temp,find(Target_(:,2) == 6));
cc.pos7 = intersect(c_c_temp,find(Target_(:,2) == 7));

ec.pos0 = intersect(e_c_temp,find(Target_(:,2) == 0));
ec.pos1 = intersect(e_c_temp,find(Target_(:,2) == 1));
ec.pos2 = intersect(e_c_temp,find(Target_(:,2) == 2));
ec.pos3 = intersect(e_c_temp,find(Target_(:,2) == 3));
ec.pos4 = intersect(e_c_temp,find(Target_(:,2) == 4));
ec.pos5 = intersect(e_c_temp,find(Target_(:,2) == 5));
ec.pos6 = intersect(e_c_temp,find(Target_(:,2) == 6));
ec.pos7 = intersect(e_c_temp,find(Target_(:,2) == 7));

ce.pos0 = intersect(c_e_temp,find(saccLoc == 0));
ce.pos1 = intersect(c_e_temp,find(saccLoc == 1));
ce.pos2 = intersect(c_e_temp,find(saccLoc == 2));
ce.pos3 = intersect(c_e_temp,find(saccLoc == 3));
ce.pos4 = intersect(c_e_temp,find(saccLoc == 4));
ce.pos5 = intersect(c_e_temp,find(saccLoc == 5));
ce.pos6 = intersect(c_e_temp,find(saccLoc == 6));
ce.pos7 = intersect(c_e_temp,find(saccLoc == 7));

ee.pos0 = intersect(e_e_temp,find(saccLoc == 0));
ee.pos1 = intersect(e_e_temp,find(saccLoc == 1));
ee.pos2 = intersect(e_e_temp,find(saccLoc == 2));
ee.pos3 = intersect(e_e_temp,find(saccLoc == 3));
ee.pos4 = intersect(e_e_temp,find(saccLoc == 4));
ee.pos5 = intersect(e_e_temp,find(saccLoc == 5));
ee.pos6 = intersect(e_e_temp,find(saccLoc == 6));
ee.pos7 = intersect(e_e_temp,find(saccLoc == 7));

[stats.cc.pos0 pos.cc.pos0 alpha.cc.pos0] = getVec(EyeX_,EyeY_,SRT,0,1,cc.pos0);
[stats.cc.pos1 pos.cc.pos1 alpha.cc.pos1] = getVec(EyeX_,EyeY_,SRT,0,1,cc.pos1);
[stats.cc.pos2 pos.cc.pos2 alpha.cc.pos2] = getVec(EyeX_,EyeY_,SRT,0,1,cc.pos2);
[stats.cc.pos3 pos.cc.pos3 alpha.cc.pos3] = getVec(EyeX_,EyeY_,SRT,0,1,cc.pos3);
[stats.cc.pos4 pos.cc.pos4 alpha.cc.pos4] = getVec(EyeX_,EyeY_,SRT,0,1,cc.pos4);
[stats.cc.pos5 pos.cc.pos5 alpha.cc.pos5] = getVec(EyeX_,EyeY_,SRT,0,1,cc.pos5);
[stats.cc.pos6 pos.cc.pos6 alpha.cc.pos6] = getVec(EyeX_,EyeY_,SRT,0,1,cc.pos6);
[stats.cc.pos7 pos.cc.pos7 alpha.cc.pos7] = getVec(EyeX_,EyeY_,SRT,0,1,cc.pos7);

[stats.ec.pos0 pos.ec.pos0 alpha.ec.pos0] = getVec(EyeX_,EyeY_,SRT,0,1,ec.pos0);
[stats.ec.pos1 pos.ec.pos1 alpha.ec.pos1] = getVec(EyeX_,EyeY_,SRT,0,1,ec.pos1);
[stats.ec.pos2 pos.ec.pos2 alpha.ec.pos2] = getVec(EyeX_,EyeY_,SRT,0,1,ec.pos2);
[stats.ec.pos3 pos.ec.pos3 alpha.ec.pos3] = getVec(EyeX_,EyeY_,SRT,0,1,ec.pos3);
[stats.ec.pos4 pos.ec.pos4 alpha.ec.pos4] = getVec(EyeX_,EyeY_,SRT,0,1,ec.pos4);
[stats.ec.pos5 pos.ec.pos5 alpha.ec.pos5] = getVec(EyeX_,EyeY_,SRT,0,1,ec.pos5);
[stats.ec.pos6 pos.ec.pos6 alpha.ec.pos6] = getVec(EyeX_,EyeY_,SRT,0,1,ec.pos6);
[stats.ec.pos7 pos.ec.pos7 alpha.ec.pos7] = getVec(EyeX_,EyeY_,SRT,0,1,ec.pos7);

[stats.ce.pos0 pos.ce.pos0 alpha.ce.pos0] = getVec(EyeX_,EyeY_,SRT,0,1,ce.pos0);
[stats.ce.pos1 pos.ce.pos1 alpha.ce.pos1] = getVec(EyeX_,EyeY_,SRT,0,1,ce.pos1);
[stats.ce.pos2 pos.ce.pos2 alpha.ce.pos2] = getVec(EyeX_,EyeY_,SRT,0,1,ce.pos2);
[stats.ce.pos3 pos.ce.pos3 alpha.ce.pos3] = getVec(EyeX_,EyeY_,SRT,0,1,ce.pos3);
[stats.ce.pos4 pos.ce.pos4 alpha.ce.pos4] = getVec(EyeX_,EyeY_,SRT,0,1,ce.pos4);
[stats.ce.pos5 pos.ce.pos5 alpha.ce.pos5] = getVec(EyeX_,EyeY_,SRT,0,1,ce.pos5);
[stats.ce.pos6 pos.ce.pos6 alpha.ce.pos6] = getVec(EyeX_,EyeY_,SRT,0,1,ce.pos6);
[stats.ce.pos7 pos.ce.pos7 alpha.ce.pos7] = getVec(EyeX_,EyeY_,SRT,0,1,ce.pos7);

[stats.ee.pos0 pos.ee.pos0 alpha.ee.pos0] = getVec(EyeX_,EyeY_,SRT,0,1,ee.pos0);
[stats.ee.pos1 pos.ee.pos1 alpha.ee.pos1] = getVec(EyeX_,EyeY_,SRT,0,1,ee.pos1);
[stats.ee.pos2 pos.ee.pos2 alpha.ee.pos2] = getVec(EyeX_,EyeY_,SRT,0,1,ee.pos2);
[stats.ee.pos3 pos.ee.pos3 alpha.ee.pos3] = getVec(EyeX_,EyeY_,SRT,0,1,ee.pos3);
[stats.ee.pos4 pos.ee.pos4 alpha.ee.pos4] = getVec(EyeX_,EyeY_,SRT,0,1,ee.pos4);
[stats.ee.pos5 pos.ee.pos5 alpha.ee.pos5] = getVec(EyeX_,EyeY_,SRT,0,1,ee.pos5);
[stats.ee.pos6 pos.ee.pos6 alpha.ee.pos6] = getVec(EyeX_,EyeY_,SRT,0,1,ee.pos6);
[stats.ee.pos7 pos.ee.pos7 alpha.ee.pos7] = getVec(EyeX_,EyeY_,SRT,0,1,ee.pos7);

clear cc* ec* ce* ee* EyeX_ EyeY_ c_c_temp c_e_temp e_c_temp e_e_temp

%check to see if there are catch trials
catch_correct = find(Correct_(:,2) == 1 & Target_(:,2) == 255);
catch_errors = find(Correct_(:,2) == 0 & Target_(:,2) == 255);

if (length(catch_correct) > 5) || length(catch_errors > 5)
    goCatch = 1;
else
    goCatch = 0;
end


% keep track of RTs for catch conditions when saccades were made
% (not limiting to screen positions)
if goCatch == 1
    RTs.catch.correct_in = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) == 255 & ~isnan(SRT(:,1))),1));
    RTs.catch.errors = nanmean(SRT(find(Correct_(:,2) == 0 & Target_(:,2) == 255 & ~isnan(SRT(:,1))),1));
else
    RTs.catch.correct_in = NaN; % remember this is the condition where catch trials were 'correct' but a saccade was still made after reward
    RTs.catch.errors = NaN;
end



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
            
            cMed = nanmedian(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
            eMed = nanmedian(SRT(find(Errors_(:,5) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
            
            %find trial #s and randomize them for the subsampling below
            in_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            out_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            in_incorrect = find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            out_incorrect = find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            SDF = sSDF(Spike,Target_(:,1),[-100 500]);
            SDF_resp = sSDF(Spike,SRT(:,1)+500,[-400 200]);
            
            %SDF = truncateSP_targ(SDF,SRT,[-100 500]);
            
            
            
            
            %======================
            % Set up trial-history
            
            e_e.in(1:size(Correct_,1),1) = NaN;
            e_c.in(1:size(Correct_,1),1) = NaN;
            c_e.in(1:size(Correct_,1),1) = NaN;
            c_c.in(1:size(Correct_,1),1) = NaN;
            
            e_e.out(1:size(Correct_,1),1) = NaN;
            e_c.out(1:size(Correct_,1),1) = NaN;
            c_e.out(1:size(Correct_,1),1) = NaN;
            c_c.out(1:size(Correct_,1),1) = NaN;
            
            
            
            for trl = 2:size(Correct_,1)
                if Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),RF) & ismember(saccLoc(trl),antiRF) & Target_(trl-1,2) ~= 255
                    e_e.in(trl-1,1) = trl;
                elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),antiRF) & ismember(saccLoc(trl),RF) & Target_(trl-1,2) ~= 255
                    e_e.out(trl-1,1) = trl;
                    
                elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),RF) & Target_(trl-1,2) ~= 255
                    e_c.in(trl-1,1) = trl;
                elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),antiRF) & Target_(trl-1,2) ~= 255
                    e_c.out(trl-1,1) = trl;
                    
                elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),RF) & ismember(saccLoc(trl),antiRF) & Target_(trl-1,2) ~= 255
                    c_e.in(trl-1,1) = trl;
                elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),antiRF) & ismember(saccLoc(trl),RF) & Target_(trl-1,2) ~= 255
                    c_e.out(trl-1,1) = trl;
                    
                elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),RF) & Target_(trl-1,2) ~= 255
                    c_c.in(trl-1,1) = trl;
                elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),antiRF) & Target_(trl-1,2) ~= 255
                    c_c.out(trl-1,1) = trl;
                end
            end
            
            
            e_e.in = removeNaN(e_e.in);
            e_c.in = removeNaN(e_c.in);
            c_e.in = removeNaN(c_e.in);
            c_c.in = removeNaN(c_c.in);
            
            e_e.out = removeNaN(e_e.out);
            e_c.out = removeNaN(e_c.out);
            c_e.out = removeNaN(c_e.out);
            c_c.out = removeNaN(c_c.out);
            
            
            ROC.(cell2mat(DSPlist(DSPchan))).c_c = getROC(SDF,c_c.in,c_c.out,50);
            ROC.(cell2mat(DSPlist(DSPchan))).e_c = getROC(SDF,e_c.in,e_c.out,50);
            ROC.(cell2mat(DSPlist(DSPchan))).c_e = getROC(SDF,c_e.out,c_e.in,50);
            ROC.(cell2mat(DSPlist(DSPchan))).e_e = getROC(SDF,e_e.out,e_e.in,50);
            ROC.(cell2mat(DSPlist(DSPchan))).correct = getROC(SDF,in_correct,out_correct,50);
            ROC.(cell2mat(DSPlist(DSPchan))).errors = getROC(SDF,out_incorrect,in_incorrect,50);
            %======================
            %subsample trials for comparison
            mintrls = findMin(length(c_c.in),length(c_c.out),length(e_c.in), ...
                length(e_c.out),length(c_e.in),length(c_e.out),length(e_e.in), ...
                length(e_e.out));
            
            %randomize arrays
            xc_c.in = shake(c_c.in);
            xc_c.out = shake(c_c.out);
            xe_c.in = shake(e_c.in);
            xe_c.out = shake(e_c.out);
            xc_e.in = shake(c_e.in);
            xc_e.out = shake(c_e.out);
            xe_e.in = shake(e_e.in);
            xe_e.out = shake(e_e.out);
            
            %subsample
            xc_c.in = xc_c.in(randperm(mintrls));
            xc_c.out = xc_c.out(randperm(mintrls));
            xe_c.in = xe_c.in(randperm(mintrls));
            xe_c.out = xe_c.out(randperm(mintrls));
            xc_e.in = xc_e.in(randperm(mintrls));
            xc_e.out = xc_e.out(randperm(mintrls));
            xe_e.in = xe_e.in(randperm(mintrls));
            xe_e.out = xe_e.out(randperm(mintrls));
            
            ROC_sub.(cell2mat(DSPlist(DSPchan))).c_c = getROC(SDF,xc_c.in,xc_c.out,50);
            ROC_sub.(cell2mat(DSPlist(DSPchan))).e_c = getROC(SDF,xe_c.in,xe_c.out,50);
            ROC_sub.(cell2mat(DSPlist(DSPchan))).c_e = getROC(SDF,xc_e.out,xc_e.in,50);
            ROC_sub.(cell2mat(DSPlist(DSPchan))).e_e = getROC(SDF,xe_e.out,xe_e.in,50);
            
            clear mintrls xc_c.in xc_c.out xe_c.in xe_c.out xc_e.in xc_e.out xe_e.in xe_e.out
            
            mintrls = findMin(length(in_correct),length(out_correct),length(in_incorrect),length(out_incorrect));
            in_correct = shake(in_correct);
            out_correct = shake(out_correct);
            in_incorrect = shake(in_incorrect);
            out_incorrect = shake(out_incorrect);
            
            inc = in_correct(randperm(mintrls));
            outc = out_correct(randperm(mintrls));
            ine = in_incorrect(randperm(mintrls));
            oute = out_incorrect(randperm(mintrls));
            
            ROC_sub.(cell2mat(DSPlist(DSPchan))).correct = getROC(SDF,inc,outc,50);
            ROC_sub.(cell2mat(DSPlist(DSPchan))).errors = getROC(SDF,oute,ine,50);
            
            clear mintrls inc outc ine oute
            
            %=====================
            
            
            
            %condition where catch trial scored as error because fast
            %saccade (< 1000 ms)
            catch_errors_in = find(Correct_(:,2) == 0 & Target_(:,2) == 255 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
            %condition where catch trial scored as correct & no saccade
            catch_correct_nosacc = find(Correct_(:,2) == 1 & Target_(:,2) == 255 & isnan(SRT(:,1)));
            
            %condition where catch trial scored as correct but saccade
            %still made, late
            catch_correct_in = find(Correct_(:,2) == 1 & Target_(:,2) == 255 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
            
            
            %abort if any condition has no trials
            %             if findMin(length(in_correct),length(out_correct),length(in_incorrect),length(out_incorrect)) < 10
            %                 disp('At least one condition has too few trials')
            %
            %             else
            
            
            
            
            
            %===========================================
            % Find TDT for error trials
            %             SDF_in_correct = nanmean(SDF(in_correct,:));
            %             SDF_out_correct = nanmean(SDF(out_correct,:));
            SDF_in_incorrect = nanmean(SDF(in_incorrect,:));
            SDF_out_incorrect = nanmean(SDF(out_incorrect,:));
            
            
            
            
            
            
            %for trial history, always going to have many more c_c trials
            %than any other.  subsample down to comparison signal e_c
            %and take the average TDT & waveform
            
            for samp = 1:numSamps
                %re-randomize full trial list
                c_c.in_temp = shake(c_c.in);
                c_c.out_temp = shake(c_c.out);
                
                %take random samples
                if length(c_c.in) > length(c_e.in)
                    c_c.in_temp = c_c.in_temp(randperm(length(c_e.in)));
                else
                    c_c.in_temp = c_c.in_temp;
                end
                
                if length(c_c.out) > length(c_e.out)
                    c_c.out_temp = c_c.out_temp(randperm(length(c_e.out)));
                else
                    c_c.out_temp = c_c.out_temp;
                end
                
                SDF_in_correct_c_c(samp,1:601) = nanmean(SDF(c_c.in_temp,:));
                SDF_out_correct_c_c(samp,1:601) = nanmean(SDF(c_c.out_temp,:));
                
                tempTDT.c_c(samp,1) = getTDT_SP(Spike,c_c.in_temp,c_c.out_temp,0,.05,5);
            end
            
            %for c_c waveforms only, take average over random samples
            SDF_in_correct_c_c = nanmean(SDF_in_correct_c_c);
            SDF_out_correct_c_c = nanmean(SDF_out_correct_c_c);
            
            
            SDF_in_correct_e_e = nanmean(SDF(e_e.in,:));
            SDF_in_correct_e_c = nanmean(SDF(e_c.in,:));
            SDF_in_correct_c_e = nanmean(SDF(c_e.in,:));
            SDF_out_correct_e_e = nanmean(SDF(e_e.out,:));
            SDF_out_correct_e_c = nanmean(SDF(e_c.out,:));
            SDF_out_correct_c_e = nanmean(SDF(c_e.out,:));
            
            
            
            
            
            if goCatch == 1
                SDF_catch_correct_nosacc = nanmean(SDF(catch_correct_nosacc,:));
                SDF_catch_correct_in = nanmean(SDF(catch_correct_in,:));
                SDF_catch_errors_in = nanmean(SDF(catch_errors_in,:));
                
                SDF_catch_correct_nosacc_resp = nanmean(SDF_resp(catch_correct_nosacc,:));
                SDF_catch_correct_in_resp = nanmean(SDF_resp(catch_correct_in,:));
                SDF_catch_errors_in_resp = nanmean(SDF_resp(catch_errors_in,:));
            else
                SDF_catch_correct_nosacc(1:601) = NaN;
                SDF_catch_correct_in(1:601) = NaN;
                SDF_catch_errors_in(1:601) = NaN;
                
                SDF_catch_correct_nosacc_resp = NaN;
                SDF_catch_correct_in_resp = NaN;
                SDF_catch_errors_in_resp = NaN;
            end
            
            %             n.(cell2mat(DSPlist(DSPchan))).correct.in = length(in_correct);
            %             n.(cell2mat(DSPlist(DSPchan))).correct.out = length(out_correct);
            
            n.allCatch.catchtotal = length(find(Target_(:,2) == 255));
            n.allCatch.correct_nosacc = length(find(Correct_(:,2) == 1 & Target_(:,2) == 255 & isnan(SRT(:,1))));
            n.allCatch.fasterr = length(find(Correct_(:,2) == 0 & Target_(:,2) == 255 & ~isnan(SRT(:,1))));
            n.allCatch.lateresp = length(find(Correct_(:,2) == 1 & Target_(:,2) == 255 & ~isnan(SRT(:,1))));
            
            n.(cell2mat(DSPlist(DSPchan))).errors.in = length(in_incorrect);
            n.(cell2mat(DSPlist(DSPchan))).errors.out = length(out_incorrect);
            n.(cell2mat(DSPlist(DSPchan))).catch.correct_nosacc = length(catch_correct_nosacc);
            n.(cell2mat(DSPlist(DSPchan))).catch.correct_in = length(catch_correct_in);
            n.(cell2mat(DSPlist(DSPchan))).catch.errors_in = length(catch_errors_in);
            n.(cell2mat(DSPlist(DSPchan))).c_c.in = length(c_c.in);
            n.(cell2mat(DSPlist(DSPchan))).c_c.out = length(c_c.out);
            n.(cell2mat(DSPlist(DSPchan))).e_c.in = length(e_c.in);
            n.(cell2mat(DSPlist(DSPchan))).e_c.out = length(e_c.out);
            n.(cell2mat(DSPlist(DSPchan))).c_e.in = length(c_e.in);
            n.(cell2mat(DSPlist(DSPchan))).c_e.out = length(c_e.out);
            n.(cell2mat(DSPlist(DSPchan))).e_e.in = length(e_e.in);
            n.(cell2mat(DSPlist(DSPchan))).e_e.out = length(e_e.out);
            
            %keep track of waveforms
            %             wf.(cell2mat(DSPlist(DSPchan))).correct.in = SDF_in_correct;
            %             wf.(cell2mat(DSPlist(DSPchan))).correct.out = SDF_out_correct;
            
            %response aligned correct waveforms, not subsampled: use for
            %catch trial comparison
            wf.(cell2mat(DSPlist(DSPchan))).correct.in_resp = nanmean(SDF_resp(in_correct,:));
            wf.(cell2mat(DSPlist(DSPchan))).correct.out_resp = nanmean(SDF_resp(out_correct,:));
            
            wf.(cell2mat(DSPlist(DSPchan))).errors.in = SDF_in_incorrect;
            wf.(cell2mat(DSPlist(DSPchan))).errors.out = SDF_out_incorrect;
            wf.(cell2mat(DSPlist(DSPchan))).correct.in_e_e = SDF_in_correct_e_e;
            wf.(cell2mat(DSPlist(DSPchan))).correct.in_e_c = SDF_in_correct_e_c;
            wf.(cell2mat(DSPlist(DSPchan))).correct.in_c_e = SDF_in_correct_c_e;
            wf.(cell2mat(DSPlist(DSPchan))).correct.in_c_c = SDF_in_correct_c_c;
            wf.(cell2mat(DSPlist(DSPchan))).correct.out_e_e = SDF_out_correct_e_e;
            wf.(cell2mat(DSPlist(DSPchan))).correct.out_e_c = SDF_out_correct_e_c;
            wf.(cell2mat(DSPlist(DSPchan))).correct.out_c_e = SDF_out_correct_c_e;
            wf.(cell2mat(DSPlist(DSPchan))).correct.out_c_c = SDF_out_correct_c_c;
            
            %TDT for trial-history
            TDT.(cell2mat(DSPlist(DSPchan))).correct_e_e = getTDT_SP(Spike,e_e.in,e_e.out,0,.05,5);
            TDT.(cell2mat(DSPlist(DSPchan))).correct_e_c = getTDT_SP(Spike,e_c.in,e_c.out,0,.05,5);
            TDT.(cell2mat(DSPlist(DSPchan))).correct_c_e = getTDT_SP(Spike,c_e.in,c_e.out,0,.05,5);
            TDT.(cell2mat(DSPlist(DSPchan))).correct_c_c_nosub = getTDT_SP(Spike,c_c.in,c_c.out,0,.05,5);
            %take average TDT from random samples
            TDT.(cell2mat(DSPlist(DSPchan))).correct_c_c = nanmean(tempTDT.c_c);
            clear tempTDT.c_c
            
            if goCatch == 1
                wf.(cell2mat(DSPlist(DSPchan))).catch.correct_nosacc = SDF_catch_correct_nosacc;
                wf.(cell2mat(DSPlist(DSPchan))).catch.correct_in = SDF_catch_correct_in;
                wf.(cell2mat(DSPlist(DSPchan))).catch.errors_in = SDF_catch_errors_in;
                
                wf.(cell2mat(DSPlist(DSPchan))).catch.correct_nosacc_resp = SDF_catch_correct_nosacc_resp;
                wf.(cell2mat(DSPlist(DSPchan))).catch.correct_in_resp = SDF_catch_correct_in_resp;
                wf.(cell2mat(DSPlist(DSPchan))).catch.errors_in_resp = SDF_catch_errors_in_resp;
            else
                wf.(cell2mat(DSPlist(DSPchan))).catch.correct_nosacc(1:601) = NaN;
                wf.(cell2mat(DSPlist(DSPchan))).catch.correct_in(1:601) = NaN;
                wf.(cell2mat(DSPlist(DSPchan))).catch.errors_in(1:601) = NaN;
                
                wf.(cell2mat(DSPlist(DSPchan))).catch.correct_nosacc_resp(1:601) = NaN;
                wf.(cell2mat(DSPlist(DSPchan))).catch.correct_in_resp(1:601) = NaN;
                wf.(cell2mat(DSPlist(DSPchan))).catch.errors_in_resp(1:601) = NaN;
            end
            
            
            %non-sub-sampled correct trial TDT
            for time = 200:size(SDF,2) %200 == 100 ms post stimulus onset
                %remove any nan values for current time
                clean_in = SDF(in_correct,time);
                clean_in(find(isnan(clean_in))) = [];
                
                clean_out = SDF(out_correct,time);
                clean_out(find(isnan(clean_out))) = [];
                
                if ~isempty(clean_in) & ~isempty(clean_out)
                    [p(time) h(time)] = ranksum(clean_in,clean_out,'alpha',.05);
                else
                    p(time) = NaN;
                    h(time) = 0;
                end
                
            end
            
            
            TDT.(cell2mat(DSPlist(DSPchan))).correct_nosub = min(findRuns(h,5)) - 100;
            
            
            if TDT.(cell2mat(DSPlist(DSPchan))).correct_nosub > nanmean(RTs.correct)
                disp('TDT greater than RT...writing NaN')
                TDT.(cell2mat(DSPlist(DSPchan))).correct_nosub = NaN;
            end
            
            
            if isempty(TDT)
                TDT.(cell2mat(DSPlist(DSPchan))).correct_nosub = NaN;
            end
            
            
            
            for time = 200:size(SDF,2) %200 == 100 ms post stimulus onset
                %remove any nan values for current time
                clean_in = SDF(in_incorrect,time);
                clean_in(find(isnan(clean_in))) = [];
                
                clean_out = SDF(out_incorrect,time);
                clean_out(find(isnan(clean_out))) = [];
                
                if ~isempty(clean_in) & ~isempty(clean_out)
                    [p(time) h(time)] = ranksum(clean_in,clean_out,'alpha',.05);
                else
                    p(time) = NaN;
                    h(time) = 0;
                end
                
            end
            
            
            TDT.(cell2mat(DSPlist(DSPchan))).errors = min(findRuns(h,5)) - 100;
            
            
            if TDT.(cell2mat(DSPlist(DSPchan))).errors > nanmean(RTs.errors)
                disp('TDT greater than RT...writing NaN')
                TDT.(cell2mat(DSPlist(DSPchan))).errors = NaN;
            end
            
            
            
            
            %=====================================================
            % Find TDT for correct trials after sub-sampling
            
            
            %keep track of original vector of trial numbers
            in_correct_all = in_correct;
            out_correct_all = out_correct;
            for samp = 1:numSamps
                %re-randomize
                in_correct = shake(in_correct_all);
                out_correct = shake(out_correct_all);
                
                %sub-sample to length of equivalent error signals
                %check to make sure there are fewer correct trials than
                %incorrect; if not true, then just keep resampling same
                %correct trials
                
                if length(in_correct) > length(in_incorrect)
                    in_correct = in_correct(randperm(length(in_incorrect)));
                end
                
                if length(out_correct) > length(out_incorrect)
                    out_correct = out_correct(randperm(length(out_incorrect)));
                end
                
                
                %calculate TDT here rather than with function because truncated signals
                for time = 200:size(SDF,2) %200 == 100 ms post stimulus onset
                    %remove any nan values for current time
                    clean_in = SDF(in_correct,time);
                    clean_in(find(isnan(clean_in))) = [];
                    
                    clean_out = SDF(out_correct,time);
                    clean_out(find(isnan(clean_out))) = [];
                    
                    if ~isempty(clean_in) & ~isempty(clean_out)
                        [p(time) h(time)] = ranksum(clean_in,clean_out,'alpha',.05);
                    else
                        p(time) = NaN;
                        h(time) = 0;
                    end
                    
                end
                
                if ~isempty(findRuns(h,5))
                    TDT.(cell2mat(DSPlist(DSPchan))).correct(samp,1) = min(findRuns(h,5)) - 100;
                else
                    TDT.(cell2mat(DSPlist(DSPchan))).correct(samp,1) = NaN;
                end
                
                if TDT.(cell2mat(DSPlist(DSPchan))).correct(samp,1) > nanmean(RTs.correct)
                    TDT.(cell2mat(DSPlist(DSPchan))).correct(samp,1) = NaN;
                end
                
                
                
                wf.(cell2mat(DSPlist(DSPchan))).correct.in(samp,1:601) = nanmean(SDF(in_correct,:));
                wf.(cell2mat(DSPlist(DSPchan))).correct.out(samp,1:601) = nanmean(SDF(out_correct,:));
            end
            %
            
            
            if PDFflag == 1
                f  = figure;
                subplot(1,2,1)
                plot(-100:500,nanmean(wf.(cell2mat(DSPlist(DSPchan))).correct.in),'b',-100:500,nanmean(wf.(cell2mat(DSPlist(DSPchan))).correct.out),'--b')
                fon
                xlim([-50 300])
                %             ylim([mn mx])
                
                vline(nanmean(TDT.(cell2mat(DSPlist(DSPchan))).correct),'b')
                
                
                title([cell2mat(DSPlist(DSPchan)) ' Correct'])
                
                
                subplot(1,2,2)
                plot(-100:500,SDF_in_incorrect,'r',-100:500,SDF_out_incorrect,'--r')
                fon
                xlim([-50 300])
                %             ylim([mn mx])
                
                
                vline(TDT.(cell2mat(DSPlist(DSPchan))).errors,'r')
                
                title([cell2mat(DSPlist(DSPchan)) ' Errors'])
                
                
                eval(['print -dpdf ' PDFdir file '_' DSPlist{DSPchan} '.pdf'])
                %eval(['print -dpdf /volumes/Dump/Analyses/Errors/Uber/PDF/' batch_list(i).name '_' DSPlist{DSPchan} '.pdf'])
                
                
                close(f)
                
                
                if goCatch == 1
                    f = figure;
                    plot(-100:500,nanmean(wf.(cell2mat(DSPlist(DSPchan))).correct.in),'k',-100:500,nanmean(wf.(cell2mat(DSPlist(DSPchan))).correct.out),'--k',-100:500,SDF_catch_correct_nosacc,'r',-100:500,SDF_catch_errors_in,'b',-100:500,SDF_catch_correct_in,'--b')
                    fon
                    xlim([-50 300])
                    eval(['print -dpdf ' PDFdir file '_' DSPlist{DSPchan} '_catch.pdf'])
                    close(f)
                    
                    
                    f = figure;
                    plot(-400:200,wf.(cell2mat(DSPlist(DSPchan))).correct.in_resp,'k',-400:200,wf.(cell2mat(DSPlist(DSPchan))).correct.out_resp,'--k',-400:200,SDF_catch_correct_nosacc_resp,'r',-400:200,SDF_catch_errors_in_resp,'b',-400:200,SDF_catch_correct_in_resp,'--b')
                    fon
                    xlim([-400 200])
                    eval(['print -dpdf ' PDFdir file '_' DSPlist{DSPchan} '_catch_resp.pdf'])
                    close(f)
                    
                end
                
                
                %plot trial-history
                f = figure;
                set(gcf,'color','white')
                subplot(2,1,1)
                plot(-100:500,SDF_in_correct_c_c,'b',-100:500,SDF_out_correct_c_c,'--b',-100:500,SDF_in_correct_e_c,'r',-100:500,SDF_out_correct_e_c,'--r')
                vline(TDT.(cell2mat(DSPlist(DSPchan))).correct_c_c,'b')
                vline(TDT.(cell2mat(DSPlist(DSPchan))).correct_e_c,'r')
                xlim([-100 500])
                legend('cor-cor in','cor-cor out','err-corr in','err-corr out')
                
                subplot(2,1,2)
                plot(-100:500,SDF_in_correct_c_e,'b',-100:500,SDF_out_correct_c_e,'--b',-100:500,SDF_in_correct_e_e,'r',-100:500,SDF_out_correct_e_e,'--r')
                vline(TDT.(cell2mat(DSPlist(DSPchan))).correct_c_e,'b')
                vline(TDT.(cell2mat(DSPlist(DSPchan))).correct_e_e,'r')
                xlim([-100 500])
                legend('cor-err in','cor-err out','err-err in','err-err out')
                
                eval(['print -dpdf ' PDFdir file '_' DSPlist{DSPchan} '_trial_history.pdf'])
                close(f)
                
                
            end
            % end
        end
        
    end
    clear Spike SDF* RF antiRF
end
%==========================================================









% %
% %
% % %=============================================================
% % % TDT for LFP Channels w/ neuron RF
% % if isempty(LFPlist)
% %     disp('No LFP Channel detected...')
% % else
% %
% %
% %
% %     for LFPchan = 1:size(LFPlist,1)
% %         LFP = eval(cell2mat(LFPlist(LFPchan)));
% %         LFPname = cell2mat(LFPlist(LFPchan));
% %
% %         %find RF of corresponding first single unit
% %         newname = ['DSP' LFPname(end-1:end) 'a'];
% %         RF = RFs.(str2mat(DSPlist(strmatch(newname,DSPlist,'exact'))));
% %
% %
% %         if isempty(RF)
% %             disp('Empty LFP RF...moving on...')
% %         else
% %
% %             antiRF = mod((RF+4),8);
% %
% %
% %             in_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
% %             out_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
% %             in_incorrect = find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
% %             out_incorrect = find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
% %
% %
% %             %remove clipped trials
% %             LFP = fixClipped(LFP,[500 900]);
% %
% %
% %             LFP_resp = response_align(LFP,SRT,[-400 200]);
% %
% %
% %             %baseline correct
% %             LFP = baseline_correct(LFP,[400 500]);
% %             LFP_resp = baseline_correct(LFP_resp,[1 100]);
% %
% %
% %             %truncate 20 ms before saccade
% %             %LFP_trunc = truncateAD_targ(LFP,SRT);
% %
% %
% %
% %
% %             %======================
% %             % Set up trial-history
% %
% %             e_e.in(1:size(Correct_,1),1) = NaN;
% %             e_c.in(1:size(Correct_,1),1) = NaN;
% %             c_e.in(1:size(Correct_,1),1) = NaN;
% %             c_c.in(1:size(Correct_,1),1) = NaN;
% %
% %             e_e.out(1:size(Correct_,1),1) = NaN;
% %             e_c.out(1:size(Correct_,1),1) = NaN;
% %             c_e.out(1:size(Correct_,1),1) = NaN;
% %             c_c.out(1:size(Correct_,1),1) = NaN;
% %
% %
% %             for trl = 2:size(Correct_,1)
% %                 if Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),RF) & ismember(saccLoc(trl),antiRF) & Target_(trl-1,2) ~= 255
% %                     e_e.in(trl-1,1) = trl;
% %                 elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),antiRF) & ismember(saccLoc(trl),RF) & Target_(trl-1,2) ~= 255
% %                     e_e.out(trl-1,1) = trl;
% %
% %                 elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),RF) & Target_(trl-1,2) ~= 255
% %                     e_c.in(trl-1,1) = trl;
% %                 elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),antiRF) & Target_(trl-1,2) ~= 255
% %                     e_c.out(trl-1,1) = trl;
% %
% %                 elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),RF) & ismember(saccLoc(trl),antiRF) & Target_(trl-1,2) ~= 255
% %                     c_e.in(trl-1,1) = trl;
% %                 elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),antiRF) & ismember(saccLoc(trl),RF) & Target_(trl-1,2) ~= 255
% %                     c_e.out(trl-1,1) = trl;
% %
% %                 elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),RF) & Target_(trl-1,2) ~= 255
% %                     c_c.in(trl-1,1) = trl;
% %                 elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),antiRF) & Target_(trl-1,2) ~= 255
% %                     c_c.out(trl-1,1) = trl;
% %                 end
% %             end
% %
% %
% %             e_e.in = removeNaN(e_e.in);
% %             e_c.in = removeNaN(e_c.in);
% %             c_e.in = removeNaN(c_e.in);
% %             c_c.in = removeNaN(c_c.in);
% %
% %             e_e.out = removeNaN(e_e.out);
% %             e_c.out = removeNaN(e_c.out);
% %             c_e.out = removeNaN(c_e.out);
% %             c_c.out = removeNaN(c_c.out);
% %             %===========================
% %
% %             ROC.(cell2mat(LFPlist(LFPchan))).RF.c_c = getROC(LFP(:,400:1000),c_c.out,c_c.in,50);
% %             ROC.(cell2mat(LFPlist(LFPchan))).RF.e_c = getROC(LFP(:,400:1000),e_c.out,e_c.in,50);
% %             ROC.(cell2mat(LFPlist(LFPchan))).RF.c_e = getROC(LFP(:,400:1000),c_e.in,c_e.out,50);
% %             ROC.(cell2mat(LFPlist(LFPchan))).RF.e_e = getROC(LFP(:,400:1000),e_e.in,e_e.out,50);
% %
% %             %======================
% %             %subsample trials for comparison
% %             mintrls = findMin(length(c_c.in),length(c_c.out),length(e_c.in), ...
% %                 length(e_c.out),length(c_e.in),length(c_e.out),length(e_e.in), ...
% %                 length(e_e.out));
% %
% %             %randomize arrays
% %             xc_c.in = shake(c_c.in);
% %             xc_c.out = shake(c_c.out);
% %             xe_c.in = shake(e_c.in);
% %             xe_c.out = shake(e_c.out);
% %             xc_e.in = shake(c_e.in);
% %             xc_e.out = shake(c_e.out);
% %             xe_e.in = shake(e_e.in);
% %             xe_e.out = shake(e_e.out);
% %
% %             %subsample
% %             xc_c.in = xc_c.in(randperm(mintrls));
% %             xc_c.out = xc_c.out(randperm(mintrls));
% %             xe_c.in = xe_c.in(randperm(mintrls));
% %             xe_c.out = xe_c.out(randperm(mintrls));
% %             xc_e.in = xc_e.in(randperm(mintrls));
% %             xc_e.out = xc_e.out(randperm(mintrls));
% %             xe_e.in = xe_e.in(randperm(mintrls));
% %             xe_e.out = xe_e.out(randperm(mintrls));
% %
% %             ROC_sub.(cell2mat(LFPlist(LFPchan))).RF.c_c = getROC(LFP(:,400:1000),xc_c.out,xc_c.in,50);
% %             ROC_sub.(cell2mat(LFPlist(LFPchan))).RF.e_c = getROC(LFP(:,400:1000),xe_c.out,xe_c.in,50);
% %             ROC_sub.(cell2mat(LFPlist(LFPchan))).RF.c_e = getROC(LFP(:,400:1000),xc_e.in,xc_e.out,50);
% %             ROC_sub.(cell2mat(LFPlist(LFPchan))).RF.e_e = getROC(LFP(:,400:1000),xe_e.in,xe_e.out,50);
% %
% %             clear mintrls xc_c.in xc_c.out xe_c.in xe_c.out xc_e.in xc_e.out xe_e.in xe_e.out
% %
% %             %=====================
% %
% %
% %
% %             %condition where catch trial scored as error because fast
% %             %saccade (< 1000 ms)
% %             catch_errors_in = find(Errors_(:,5) == 1 & Target_(:,2) == 255 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
% %             %condition where catch trial scored as correct & no saccade
% %             catch_correct_nosacc = find(Correct_(:,2) == 1 & Target_(:,2) == 255 & isnan(SRT(:,1)));
% %
% %             %condition where catch trial scored as correct but saccade
% %             %still made, late
% %             catch_correct_in = find(Correct_(:,2) == 1 & Target_(:,2) == 255 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
% %
% %
% %
% %
% %             LFP_in_incorrect = nanmean(LFP(in_incorrect,:));
% %             LFP_out_incorrect = nanmean(LFP(out_incorrect,:));
% %
% %             %for trial history, always going to have many more c_c trials
% %             %than any other.  subsample down to comparison signal e_c
% %             %and take the average TDT & waveform
% %
% %             for samp = 1:numSamps
% %                 %re-randomize full trial list
% %                 c_c.in_temp = shake(c_c.in);
% %                 c_c.out_temp = shake(c_c.out);
% %
% %                 %take random samples
% %                 if length(c_c.in) > length(c_e.in)
% %                     c_c.in_temp = c_c.in_temp(randperm(length(c_e.in)));
% %                 else
% %                     c_c.in_temp = c_c.in_temp;
% %                 end
% %
% %                 if length(c_c.out) > length(c_e.out)
% %                     c_c.out_temp = c_c.out_temp(randperm(length(c_e.out)));
% %                 else
% %                     c_c.out_temp = c_c.out_temp;
% %                 end
% %
% %                 LFP_in_correct_c_c(samp,1:3001) = nanmean(LFP(c_c.in_temp,:));
% %                 LFP_out_correct_c_c(samp,1:3001) = nanmean(LFP(c_c.out_temp,:));
% %
% %                 tempTDT.c_c(samp,1) = getTDT_AD(LFP,c_c.in_temp,c_c.out_temp,0,.05,5);
% %             end
% %
% %             %for c_c waveforms only, take average over random samples
% %             LFP_in_correct_c_c = nanmean(LFP_in_correct_c_c);
% %             LFP_out_correct_c_c = nanmean(LFP_out_correct_c_c);
% %
% %
% %             LFP_in_correct_e_e = nanmean(LFP(e_e.in,:));
% %             LFP_in_correct_e_c = nanmean(LFP(e_c.in,:));
% %             LFP_in_correct_c_e = nanmean(LFP(c_e.in,:));
% %             LFP_out_correct_e_e = nanmean(LFP(e_e.out,:));
% %             LFP_out_correct_e_c = nanmean(LFP(e_c.out,:));
% %             LFP_out_correct_c_e = nanmean(LFP(c_e.out,:));
% %
% %
% %             if goCatch == 1
% %                 LFP_catch_correct_nosacc = nanmean(LFP(catch_correct_nosacc,:));
% %                 LFP_catch_correct_in = nanmean(LFP(catch_correct_in,:));
% %                 LFP_catch_errors_in = nanmean(LFP(catch_errors_in,:));
% %
% %                 LFP_catch_correct_nosacc_resp = nanmean(LFP_resp(catch_correct_nosacc,:));
% %                 LFP_catch_correct_in_resp = nanmean(LFP_resp(catch_correct_in,:));
% %                 LFP_catch_errors_in_resp = nanmean(LFP_resp(catch_errors_in,:));
% %             else
% %                 LFP_catch_correct_nosacc(1:601) = NaN;
% %                 LFP_catch_correct_in(1:601) = NaN;
% %                 LFP_catch_errors_in(1:601) = NaN;
% %
% %                 LFP_catch_correct_nosacc_resp(1:601) = NaN;
% %                 LFP_catch_correct_in_resp(1:601) = NaN;
% %                 LFP_catch_errors_in_resp(1:601) = NaN;
% %             end
% %
% %             n.(cell2mat(LFPlist(LFPchan))).RF.errors.in = length(in_incorrect);
% %             n.(cell2mat(LFPlist(LFPchan))).RF.errors.out = length(out_incorrect);
% %
% %             %keep track of waveforms
% %
% %             %response aligned for catch trial comparison (non-subsampled
% %             %correct trials)
% %
% %             wf.(cell2mat(LFPlist(LFPchan))).RF.correct.in_resp = nanmean(LFP_resp(in_correct,:));
% %             wf.(cell2mat(LFPlist(LFPchan))).RF.correct.out_resp = nanmean(LFP_resp(out_correct,:));
% %
% %             wf.(cell2mat(LFPlist(LFPchan))).RF.errors.in = LFP_in_incorrect;
% %             wf.(cell2mat(LFPlist(LFPchan))).RF.errors.out = LFP_out_incorrect;
% %             wf.(cell2mat(LFPlist(LFPchan))).RF.correct.in_e_e = LFP_in_correct_e_e;
% %             wf.(cell2mat(LFPlist(LFPchan))).RF.correct.in_e_c = LFP_in_correct_e_c;
% %             wf.(cell2mat(LFPlist(LFPchan))).RF.correct.in_c_e = LFP_in_correct_c_e;
% %             wf.(cell2mat(LFPlist(LFPchan))).RF.correct.in_c_c = LFP_in_correct_c_c;
% %             wf.(cell2mat(LFPlist(LFPchan))).RF.correct.out_e_e = LFP_out_correct_e_e;
% %             wf.(cell2mat(LFPlist(LFPchan))).RF.correct.out_e_c = LFP_out_correct_e_c;
% %             wf.(cell2mat(LFPlist(LFPchan))).RF.correct.out_c_e = LFP_out_correct_c_e;
% %             wf.(cell2mat(LFPlist(LFPchan))).RF.correct.out_c_c = LFP_out_correct_c_c;
% %
% %
% %
% %
% %             %TDT for trial history
% %             TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_e_e = getTDT_AD(LFP,e_e.in,e_e.out,0,.05,5);
% %             TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_e_c = getTDT_AD(LFP,e_c.in,e_c.out,0,.05,5);
% %             TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_c_e = getTDT_AD(LFP,c_e.in,c_e.out,0,.05,5);
% %             TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_c_c_nosub = getTDT_AD(LFP,c_c.in,c_c.out,0,.05,5);
% %             %take average TDT from random samples
% %             TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_c_c = nanmean(tempTDT.c_c);
% %             clear tempTDT.c_c
% %
% %
% %             if goCatch == 1
% %                 wf.(cell2mat(LFPlist(LFPchan))).RF.catch.correct_nosacc = LFP_catch_correct_nosacc;
% %                 wf.(cell2mat(LFPlist(LFPchan))).RF.catch.correct_in = LFP_catch_correct_in;
% %                 wf.(cell2mat(LFPlist(LFPchan))).RF.catch.errors_in = LFP_catch_errors_in;
% %
% %                 wf.(cell2mat(LFPlist(LFPchan))).RF.catch.correct_nosacc_resp = LFP_catch_correct_nosacc_resp;
% %                 wf.(cell2mat(LFPlist(LFPchan))).RF.catch.correct_in_resp = LFP_catch_correct_in_resp;
% %                 wf.(cell2mat(LFPlist(LFPchan))).RF.catch.errors_in_resp = LFP_catch_errors_in_resp;
% %             else
% %                 wf.(cell2mat(LFPlist(LFPchan))).RF.catch.correct_nosacc(1:3001) = NaN;
% %                 wf.(cell2mat(LFPlist(LFPchan))).RF.catch.correct_in(1:3001) = NaN;
% %                 wf.(cell2mat(LFPlist(LFPchan))).RF.catch.errors_in(1:3001) = NaN;
% %
% %                 wf.(cell2mat(LFPlist(LFPchan))).RF.catch.correct_nosacc_resp(1:601) = NaN;
% %                 wf.(cell2mat(LFPlist(LFPchan))).RF.catch.correct_in_resp(1:601) = NaN;
% %                 wf.(cell2mat(LFPlist(LFPchan))).RF.catch.errors_in_resp(1:601) = NaN;
% %             end
% %
% %             %             TDT.(cell2mat(LFPlist(LFPchan))).correct = getTDT_AD(LFP,in_correct,out_correct);
% %             %=======================================
% %             % Check to make sure that truncated correct trial TDT
% %             % equivalent to non-truncated TDT
% %             %             tempTDT_trunc = getTDT_AD(LFP_trunc,in_correct,out_correct,0,.05,5);
% %             %             tempTDT_notrunc = getTDT_AD(LFP,in_correct,out_correct,0,.05,5);
% %
% %             %             if isnan(tempTDT_trunc) | isnan(tempTDT_notrunc)
% %             %                 disp('At least one correct trial signal has NaN TDT')
% %             %
% %             %             elseif abs(tempTDT_trunc - tempTDT_notrunc) > 10
% %             %                 disp('Correct trial LFP TDT not equivalent for trunc and no trunc')
% %             %
% %             %             else
% %
% %
% %
% %             TDT.(cell2mat(LFPlist(LFPchan))).RF.errors = getTDT_AD(LFP,in_incorrect,out_incorrect,0,.05,5);
% %
% %             if TDT.(cell2mat(LFPlist(LFPchan))).RF.errors > nanmean(RTs.errors);
% %                 disp('TDT greater than RT')
% %                 TDT.(cell2mat(LFPlist(LFPchan))).RF.errors = NaN;
% %             end
% %
% %             if isempty(TDT.(cell2mat(LFPlist(LFPchan))).RF.errors)
% %                 TDT.(cell2mat(LFPlist(LFPchan))).RF.errors = NaN;
% %             end
% %
% %
% %
% %             %for non-subsampled correct trial TDT
% %             TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_nosub = getTDT_AD(LFP,in_correct,out_correct,0,.05,5);
% %
% %             if TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_nosub > nanmean(RTs.correct)
% %                 TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_nosub = NaN;
% %             end
% %
% %             %=======================================
% %             % Repeated-sampling correct trial TDT
% %
% %
% %             %keep track of original vector of trial numbers
% %             in_correct_all = in_correct;
% %             out_correct_all = out_correct;
% %             for samp = 1:numSamps
% %                 %re-randomize
% %                 in_correct = shake(in_correct_all);
% %                 out_correct = shake(out_correct_all);
% %
% %                 %sub-sample to length of equivalent error signals
% %
% %                 if length(in_correct) > length(in_incorrect)
% %                     in_correct = in_correct(randperm(length(in_incorrect)));
% %                 end
% %
% %                 if length(out_correct) > length(out_incorrect)
% %                     out_correct = out_correct(randperm(length(out_incorrect)));
% %                 end
% %
% %                 TDT.(cell2mat(LFPlist(LFPchan))).RF.correct(samp,1) = getTDT_AD(LFP,in_correct,out_correct,0,.05,5);
% %
% %                 if TDT.(cell2mat(LFPlist(LFPchan))).RF.correct(samp,1) > nanmean(RTs.correct)
% %                     TDT.(cell2mat(LFPlist(LFPchan))).RF.correct(samp,1) = NaN;
% %                 end
% %
% %                 wf.(cell2mat(LFPlist(LFPchan))).RF.correct.in(samp,1:3001) = nanmean(LFP(in_correct,:));
% %                 wf.(cell2mat(LFPlist(LFPchan))).RF.correct.out(samp,1:3001) = nanmean(LFP(out_correct,:));
% %             end
% %
% %             %
% %             if PDFflag == 1
% %                 f = figure;
% %                 subplot(1,2,1)
% %                 plot(-500:2500,nanmean(wf.(cell2mat(LFPlist(LFPchan))).RF.correct.in),'b',-500:2500,nanmean(wf.(cell2mat(LFPlist(LFPchan))).RF.correct.out),'--b')
% %                 fon
% %                 xlim([-50 300])
% %                 axis ij
% %
% %
% %
% %                 vline(nanmean(TDT.(cell2mat(LFPlist(LFPchan))).RF.correct),'b')
% %
% %
% %                 title([cell2mat(LFPlist(LFPchan)) ' Correct'])
% %
% %
% %                 subplot(1,2,2)
% %                 plot(-500:2500,LFP_in_incorrect,'r',-500:2500,LFP_out_incorrect,'--r')
% %                 fon
% %                 xlim([-50 300])
% %                 axis ij
% %
% %
% %                 vline(TDT.(cell2mat(LFPlist(LFPchan))).RF.errors,'r')
% %
% %                 title([cell2mat(LFPlist(LFPchan)) ' Errors'])
% %
% %                 eval(['print -dpdf ' PDFdir file '_RF_' LFPlist{LFPchan} '.pdf'])
% %                 %eval(['print -dpdf /volumes/Dump/Analyses/Errors/Uber/PDF/' batch_list(i).name '_RF_' LFPlist{LFPchan} '.pdf'])
% %                 close(f)
% %
% %                 if goCatch == 1
% %                     f = figure;
% %                     plot(-500:2500,nanmean(wf.(cell2mat(LFPlist(LFPchan))).RF.correct.in),'k',-500:2500,nanmean(wf.(cell2mat(LFPlist(LFPchan))).RF.correct.out),'--k',-500:2500,LFP_catch_correct_nosacc,'r',-500:2500,LFP_catch_errors_in,'b',-500:2500,LFP_catch_correct_in,'--b')
% %                     fon
% %                     xlim([-50 300])
% %                     axis ij
% %                     eval(['print -dpdf ' PDFdir file '_RF_' LFPlist{LFPchan} '_catch.pdf'])
% %                     close(f)
% %
% %                     f = figure;
% %                     plot(-400:200,wf.(cell2mat(LFPlist(LFPchan))).RF.correct.in_resp,'k',-400:200,wf.(cell2mat(LFPlist(LFPchan))).RF.correct.out_resp,'--k',-400:200,LFP_catch_correct_nosacc_resp,'r',-400:200,LFP_catch_errors_in_resp,'b',-400:200,LFP_catch_correct_in_resp,'--b')
% %                     fon
% %                     xlim([-400 200])
% %                     axis ij
% %                     eval(['print -dpdf ' PDFdir file '_RF_' LFPlist{LFPchan} '_catch_resp.pdf'])
% %                     close(f)
% %                 end
% %
% %                 %plot trial-history
% %                 f = figure;
% %                 set(gcf,'color','white')
% %                 subplot(2,1,1)
% %                 plot(-500:2500,LFP_in_correct_c_c,'b',-500:2500,LFP_out_correct_c_c,'--b',-500:2500,LFP_in_correct_e_c,'r',-500:2500,LFP_out_correct_e_c,'--r')
% %                 vline(TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_c_c,'b')
% %                 vline(TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_e_c,'r')
% %                 xlim([-100 500])
% %                 axis ij
% %
% %
% %                 legend('cor-cor in','cor-cor out','err-cor in','err-cor out')
% %
% %                 subplot(2,1,2)
% %                 plot(-500:2500,LFP_in_correct_c_e,'b',-500:2500,LFP_out_correct_c_e,'--b',-500:2500,LFP_in_correct_e_e,'r',-500:2500,LFP_out_correct_e_e,'--r')
% %                 vline(TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_c_e,'b')
% %                 vline(TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_e_e,'r')
% %                 xlim([-400 200])
% %                 axis ij
% %
% %
% %                 legend('cor-err in','cor-err out','err-err in','err-err out')
% %
% %
% %                 eval(['print -dpdf ' PDFdir file '_' LFPlist{LFPchan} '_RF_trial_history.pdf'])
% %                 close(f)
% %             end
% %             %end
% %         end
% %
% %     end
% %     clear RF antiRF
% % end
% % %==========================================================
% %
% %
% %







%=============================================================
% TDT for LFP Channels w/ Hemifield RF
if isempty(LFPlist)
    disp('No LFP Channel detected...')
else
    
    
    
    for LFPchan = 1:size(LFPlist,1)
        LFP = eval(cell2mat(LFPlist(LFPchan)));
        LFPname = cell2mat(LFPlist(LFPchan));
        
        
        if Hemi.(cell2mat(LFPlist(LFPchan))) == 'L'
            RF = [7 0 1];
        elseif Hemi.(cell2mat(LFPlist(LFPchan))) == 'R'
            RF = [3 4 5];
        end
        
        antiRF = mod((RF+4),8);
        
        
        in_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        out_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        in_incorrect = find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF));
        out_incorrect = find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF));
        
        
        
        %remove clipped trials
        LFP = fixClipped(LFP,[500 900]);
        
        LFP_resp = response_align(LFP,SRT,[-400 200]);
        
        
        %baseline correct
        LFP = baseline_correct(LFP,[400 500]);
        LFP_resp = baseline_correct(LFP_resp,[1 100]);
        
        %truncate 20 ms before saccade
        %LFP_trunc = truncateAD_targ(LFP,SRT);
        
        
        
        %======================
        % Set up trial-history
        
        e_e.in(1:size(Correct_,1),1) = NaN;
        e_c.in(1:size(Correct_,1),1) = NaN;
        c_e.in(1:size(Correct_,1),1) = NaN;
        c_c.in(1:size(Correct_,1),1) = NaN;
        
        e_e.out(1:size(Correct_,1),1) = NaN;
        e_c.out(1:size(Correct_,1),1) = NaN;
        c_e.out(1:size(Correct_,1),1) = NaN;
        c_c.out(1:size(Correct_,1),1) = NaN;
        
        
        for trl = 2:size(Correct_,1)
            if Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),RF) & ismember(saccLoc(trl),antiRF) & Target_(trl-1,2) ~= 255
                e_e.in(trl-1,1) = trl;
            elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),antiRF) & ismember(saccLoc(trl),RF) & Target_(trl-1,2) ~= 255
                e_e.out(trl-1,1) = trl;
                
            elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),RF) & Target_(trl-1,2) ~= 255
                e_c.in(trl-1,1) = trl;
            elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),antiRF) & Target_(trl-1,2) ~= 255
                e_c.out(trl-1,1) = trl;
                
            elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),RF) & ismember(saccLoc(trl),antiRF) & Target_(trl-1,2) ~= 255
                c_e.in(trl-1,1) = trl;
            elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),antiRF) & ismember(saccLoc(trl),RF) & Target_(trl-1,2) ~= 255
                c_e.out(trl-1,1) = trl;
                
            elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),RF) & Target_(trl-1,2) ~= 255
                c_c.in(trl-1,1) = trl;
            elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),antiRF) & Target_(trl-1,2) ~= 255
                c_c.out(trl-1,1) = trl;
            end
        end
        
        
        e_e.in = removeNaN(e_e.in);
        e_c.in = removeNaN(e_c.in);
        c_e.in = removeNaN(c_e.in);
        c_c.in = removeNaN(c_c.in);
        
        e_e.out = removeNaN(e_e.out);
        e_c.out = removeNaN(e_c.out);
        c_e.out = removeNaN(c_e.out);
        c_c.out = removeNaN(c_c.out);
        %===========================
        
        ROC.(cell2mat(LFPlist(LFPchan))).Hemi.c_c = getROC(LFP(:,400:1000),c_c.out,c_c.in,50);
        ROC.(cell2mat(LFPlist(LFPchan))).Hemi.e_c = getROC(LFP(:,400:1000),e_c.out,e_c.in,50);
        ROC.(cell2mat(LFPlist(LFPchan))).Hemi.c_e = getROC(LFP(:,400:1000),c_e.in,c_e.out,50);
        ROC.(cell2mat(LFPlist(LFPchan))).Hemi.e_e = getROC(LFP(:,400:1000),e_e.in,e_e.out,50);
        ROC.(cell2mat(LFPlist(LFPchan))).correct = getROC(LFP(:,400:1000),in_correct,out_correct,50);
        ROC.(cell2mat(LFPlist(LFPchan))).errors = getROC(LFP(:,400:1000),out_incorrect,in_incorrect,50);
        
        
        %======================
        %subsample trials for comparison
        mintrls = findMin(length(c_c.in),length(c_c.out),length(e_c.in), ...
            length(e_c.out),length(c_e.in),length(c_e.out),length(e_e.in), ...
            length(e_e.out));
        
        %randomize arrays
        xc_c.in = shake(c_c.in);
        xc_c.out = shake(c_c.out);
        xe_c.in = shake(e_c.in);
        xe_c.out = shake(e_c.out);
        xc_e.in = shake(c_e.in);
        xc_e.out = shake(c_e.out);
        xe_e.in = shake(e_e.in);
        xe_e.out = shake(e_e.out);
        
        %subsample
        xc_c.in = xc_c.in(randperm(mintrls));
        xc_c.out = xc_c.out(randperm(mintrls));
        xe_c.in = xe_c.in(randperm(mintrls));
        xe_c.out = xe_c.out(randperm(mintrls));
        xc_e.in = xc_e.in(randperm(mintrls));
        xc_e.out = xc_e.out(randperm(mintrls));
        xe_e.in = xe_e.in(randperm(mintrls));
        xe_e.out = xe_e.out(randperm(mintrls));
        
        ROC_sub.(cell2mat(LFPlist(LFPchan))).Hemi.c_c = getROC(LFP(:,400:1000),xc_c.out,xc_c.in,50);
        ROC_sub.(cell2mat(LFPlist(LFPchan))).Hemi.e_c = getROC(LFP(:,400:1000),xe_c.out,xe_c.in,50);
        ROC_sub.(cell2mat(LFPlist(LFPchan))).Hemi.c_e = getROC(LFP(:,400:1000),xc_e.in,xc_e.out,50);
        ROC_sub.(cell2mat(LFPlist(LFPchan))).Hemi.e_e = getROC(LFP(:,400:1000),xe_e.in,xe_e.out,50);
        
        clear mintrls xc_c.in xc_c.out xe_c.in xe_c.out xc_e.in xc_e.out xe_e.in xe_e.out
        
        mintrls = findMin(length(in_correct),length(out_correct),length(in_incorrect),length(out_incorrect));
        in_correct = shake(in_correct);
        out_correct = shake(out_correct);
        in_incorrect = shake(in_incorrect);
        out_incorrect = shake(out_incorrect);
        
        inc = in_correct(randperm(mintrls));
        outc = out_correct(randperm(mintrls));
        ine = in_incorrect(randperm(mintrls));
        oute = out_incorrect(randperm(mintrls));
        
        ROC_sub.(cell2mat(LFPlist(LFPchan))).correct = getROC(LFP(:,400:1000),inc,outc,50);
        ROC_sub.(cell2mat(LFPlist(LFPchan))).errors = getROC(LFP(:,400:1000),oute,ine,50);
        
        clear mintrls inc outc ine oute
        
        %=====================
        
        
        
        %condition where catch trial scored as error because fast
        %saccade (< 1000 ms)
        catch_errors_in = find(Correct_(:,2) == 0 & Target_(:,2) == 255 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
        %condition where catch trial scored as correct & no saccade
        catch_correct_nosacc = find(Correct_(:,2) == 1 & Target_(:,2) == 255 & isnan(SRT(:,1)));
        
        %condition where catch trial scored as correct but saccade
        %still made, late
        catch_correct_in = find(Correct_(:,2) == 1 & Target_(:,2) == 255 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
        
        
        
        
        
        
        LFP_in_incorrect = nanmean(LFP(in_incorrect,:));
        LFP_out_incorrect = nanmean(LFP(out_incorrect,:));
        
        %for trial history, always going to have many more c_c trials
        %than any other.  subsample down to comparison signal e_c
        %and take the average TDT & waveform
        
        for samp = 1:numSamps
            %re-randomize full trial list
            c_c.in_temp = shake(c_c.in);
            c_c.out_temp = shake(c_c.out);
            
            %take random samples
            if length(c_c.in) > length(c_e.in)
                c_c.in_temp = c_c.in_temp(randperm(length(c_e.in)));
            else
                c_c.in_temp = c_c.in_temp;
            end
            
            if length(c_c.out) > length(c_e.out)
                c_c.out_temp = c_c.out_temp(randperm(length(c_e.out)));
            else
                c_c.out_temp = c_c.out_temp;
            end
            
            LFP_in_correct_c_c(samp,1:3001) = nanmean(LFP(c_c.in_temp,:));
            LFP_out_correct_c_c(samp,1:3001) = nanmean(LFP(c_c.out_temp,:));
            
            tempTDT.c_c(samp,1) = getTDT_AD(LFP,c_c.in_temp,c_c.out_temp,0,.05,5);
        end
        
        %for c_c waveforms only, take average over random samples
        LFP_in_correct_c_c = nanmean(LFP_in_correct_c_c);
        LFP_out_correct_c_c = nanmean(LFP_out_correct_c_c);
        
        
        LFP_in_correct_e_e = nanmean(LFP(e_e.in,:));
        LFP_in_correct_e_c = nanmean(LFP(e_c.in,:));
        LFP_in_correct_c_e = nanmean(LFP(c_e.in,:));
        LFP_out_correct_e_e = nanmean(LFP(e_e.out,:));
        LFP_out_correct_e_c = nanmean(LFP(e_c.out,:));
        LFP_out_correct_c_e = nanmean(LFP(c_e.out,:));
        
        
        if goCatch == 1
            LFP_catch_correct_nosacc = nanmean(LFP(catch_correct_nosacc,:));
            LFP_catch_correct_in = nanmean(LFP(catch_correct_in,:));
            LFP_catch_errors_in = nanmean(LFP(catch_errors_in,:));
            
            LFP_catch_correct_nosacc_resp = nanmean(LFP_resp(catch_correct_nosacc,:));
            LFP_catch_correct_in_resp = nanmean(LFP_resp(catch_correct_in,:));
            LFP_catch_errors_in_resp = nanmean(LFP_resp(catch_errors_in,:));
        else
            LFP_catch_correct_nosacc(1:3001) = NaN;
            LFP_catch_correct_in(1:3001) = NaN;
            LFP_catch_errors_in(1:3001) = NaN;
            
            LFP_catch_correct_nosacc_resp(1:601) = NaN;
            LFP_catch_correct_in_resp(1:601) = NaN;
            LFP_catch_errors_in_resp(1:601) = NaN;
        end
        
        n.(cell2mat(LFPlist(LFPchan))).Hemi.errors.in = length(in_incorrect);
        n.(cell2mat(LFPlist(LFPchan))).Hemi.errors.out = length(out_incorrect);
        
        %keep track of waveforms
        
        %non-subsampled response aligned correct trials for catch trial
        %comparison
        wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.in_resp = nanmean(LFP_resp(in_correct,:));
        wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.out_resp = nanmean(LFP_resp(out_correct,:));
        
        
        wf.(cell2mat(LFPlist(LFPchan))).Hemi.errors.in = LFP_in_incorrect;
        wf.(cell2mat(LFPlist(LFPchan))).Hemi.errors.out = LFP_out_incorrect;
        wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.in_e_e = LFP_in_correct_e_e;
        wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.in_e_c = LFP_in_correct_e_c;
        wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.in_c_e = LFP_in_correct_c_e;
        wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.in_c_c = LFP_in_correct_c_c;
        wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.out_e_e = LFP_out_correct_e_e;
        wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.out_e_c = LFP_out_correct_e_c;
        wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.out_c_e = LFP_out_correct_c_e;
        wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.out_c_c = LFP_out_correct_c_c;
        
        
        %TDT for trial history
        TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_e_e = getTDT_AD(LFP,e_e.in,e_e.out,0,.05,5);
        TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_e_c = getTDT_AD(LFP,e_c.in,e_c.out,0,.05,5);
        TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_c_e = getTDT_AD(LFP,c_e.in,c_e.out,0,.05,5);
        TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_c_c_nosub = getTDT_AD(LFP,c_c.in,c_c.out,0,.05,5);
        %take average of random samples
        TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_c_c = nanmean(tempTDT.c_c);
        clear tempTDT.c_c
        
        
        
        
        if goCatch == 1
            wf.(cell2mat(LFPlist(LFPchan))).Hemi.catch.correct_nosacc = LFP_catch_correct_nosacc;
            wf.(cell2mat(LFPlist(LFPchan))).Hemi.catch.correct_in = LFP_catch_correct_in;
            wf.(cell2mat(LFPlist(LFPchan))).Hemi.catch.errors_in = LFP_catch_errors_in;
            
            wf.(cell2mat(LFPlist(LFPchan))).Hemi.catch.correct_nosacc_resp = LFP_catch_correct_nosacc_resp;
            wf.(cell2mat(LFPlist(LFPchan))).Hemi.catch.correct_in_resp = LFP_catch_correct_in_resp;
            wf.(cell2mat(LFPlist(LFPchan))).Hemi.catch.errors_in_resp = LFP_catch_errors_in_resp;
        else
            wf.(cell2mat(LFPlist(LFPchan))).Hemi.catch.correct_nosacc(1:3001) = NaN;
            wf.(cell2mat(LFPlist(LFPchan))).Hemi.catch.correct_in(1:3001) = NaN;
            wf.(cell2mat(LFPlist(LFPchan))).Hemi.catch.errors_in(1:3001) = NaN;
            
            wf.(cell2mat(LFPlist(LFPchan))).Hemi.catch.correct_nosacc_resp(1:601) = NaN;
            wf.(cell2mat(LFPlist(LFPchan))).Hemi.catch.correct_in_resp(1:601) = NaN;
            wf.(cell2mat(LFPlist(LFPchan))).Hemi.catch.errors_in_resp(1:601) = NaN;
        end
        
        %=======================================
        % Check to make sure that truncated correct trial TDT
        % equivalent to non-truncated TDT
        %         tempTDT_trunc = getTDT_AD(LFP_trunc,in_correct,out_correct,0,.05,5);
        %         tempTDT_notrunc = getTDT_AD(LFP,in_correct,out_correct,0,.05,5);
        
        %         if isnan(tempTDT_trunc) | isnan(tempTDT_notrunc)
        %             disp('At least one correct trial signal has NaN TDT')
        %         elseif abs(tempTDT_trunc - tempTDT_notrunc) > 10
        %             disp('Correct trial LFP TDT not equivalent for trunc and no trunc')
        %         else
        
        
        TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_nosub = getTDT_AD(LFP,in_correct,out_correct,0,.05,5);
        
        if TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_nosub > nanmean(RTs.correct)
            TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_nosub = NaN;
        end
        
        
        TDT.(cell2mat(LFPlist(LFPchan))).Hemi.errors = getTDT_AD(LFP,in_incorrect,out_incorrect,0,.05,5);
        
        if TDT.(cell2mat(LFPlist(LFPchan))).Hemi.errors > nanmean(RTs.errors)
            disp('TDT later than RT')
            TDT.(cell2mat(LFPlist(LFPchan))).Hemi.errors = NaN;
        end
        
        %=======================================
        % Repeated-sampling correct trial TDT
        
        %keep track of original vector of trial numbers
        in_correct_all = in_correct;
        out_correct_all = out_correct;
        for samp = 1:numSamps
            %re-randomize
            in_correct = shake(in_correct_all);
            out_correct = shake(out_correct_all);
            
            %sub-sample to length of equivalent error signals
            if length(in_correct) > length(in_incorrect)
                in_correct = in_correct(randperm(length(in_incorrect)));
            end
            
            if length(out_correct) > length(out_incorrect)
                out_correct = out_correct(randperm(length(out_incorrect)));
            end
            
            TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct(samp,1) = getTDT_AD(LFP,in_correct,out_correct,0,.05,5);
            
            if TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct(samp,1) > nanmean(RTs.correct)
                TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct(samp,1) = NaN;
            end
            
            wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.in(samp,1:3001) = nanmean(LFP(in_correct,:));
            wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.out(samp,1:3001) = nanmean(LFP(out_correct,:));
        end
        
        %
        if PDFflag == 1
            f = figure;
            subplot(1,2,1)
            plot(-500:2500,nanmean(wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.in),'b',-500:2500,nanmean(wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.out),'--b')
            fon
            xlim([-50 300])
            axis ij
            
            
            vline(nanmean(TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct),'b')
            
            
            title([cell2mat(LFPlist(LFPchan)) ' Correct'])
            
            subplot(1,2,2)
            plot(-500:2500,LFP_in_incorrect,'r',-500:2500,LFP_out_incorrect,'--r')
            fon
            xlim([-50 300])
            axis ij
            
            
            
            vline(TDT.(cell2mat(LFPlist(LFPchan))).Hemi.errors,'r')
            
            title([cell2mat(LFPlist(LFPchan)) ' Errors'])
            
            eval(['print -dpdf ' PDFdir file '_Hemi_' LFPlist{LFPchan} '.pdf'])
            %eval(['print -dpdf /volumes/Dump/Analyses/Errors/Uber/PDF/' batch_list(i).name '_Hemi_' LFPlist{LFPchan} '.pdf'])
            
            close(f)
            
            
            if goCatch == 1
                f = figure;
                plot(-500:2500,nanmean(wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.in),'k',-500:2500,nanmean(wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.out),'--k',-500:2500,LFP_catch_correct_nosacc,'r',-500:2500,LFP_catch_errors_in,'b',-500:2500,LFP_catch_correct_in,'--b')
                fon
                xlim([-50 300])
                axis ij
                eval(['print -dpdf ' PDFdir file '_Hemi_' LFPlist{LFPchan} '_catch.pdf'])
                close(f)
                
                f = figure;
                plot(-400:200,wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.in_resp,'k',-400:200,wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.out_resp,'--k',-400:200,LFP_catch_correct_nosacc_resp,'r',-400:200,LFP_catch_errors_in_resp,'b',-400:200,LFP_catch_correct_in_resp,'--b')
                fon
                xlim([-400 200])
                axis ij
                eval(['print -dpdf ' PDFdir file '_Hemi_' LFPlist{LFPchan} '_catch_resp.pdf'])
                close(f)
            end
            
            %plot trial-history
            f = figure;
            set(gcf,'color','white')
            subplot(2,1,1)
            plot(-500:2500,LFP_in_correct_c_c,'b',-500:2500,LFP_out_correct_c_c,'--b',-500:2500,LFP_in_correct_e_c,'r',-500:2500,LFP_out_correct_e_c,'--r')
            vline(TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_c_c,'b')
            vline(TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_e_c,'r')
            xlim([-100 500])
            axis ij
            
            
            legend('cor-cor in','cor-cor out','err-cor in','err-cor out')
            
            subplot(2,1,2)
            plot(-500:2500,LFP_in_correct_c_e,'b',-500:2500,LFP_out_correct_c_e,'--b',-500:2500,LFP_in_correct_e_e,'r',-500:2500,LFP_out_correct_e_e,'--r')
            vline(TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_c_e,'b')
            vline(TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_e_e,'r')
            xlim([-100 500])
            axis ij
            
            
            legend('cor-err in','cor-err out','err-err in','err-err out')
            
            
            eval(['print -dpdf ' PDFdir file '_' LFPlist{LFPchan} '_Hemi_trial_history.pdf'])
            close(f)
        end
        %end
        
    end
    clear LFP* RF antiRF
end
%==========================================================













%=============================================================
% n2pc for EEG Channels
if isempty(EEGlist)
    disp('No EEG Channel detected...')
else
    
    OL = AD03;
    OR = AD02;
    
    
    %remove saturated trials, considering only 0:400 ms post-target
    OL = fixClipped(OL,[500 900]);
    OR = fixClipped(OR,[500 900]);
    
    OL_resp = response_align(OL,SRT,[-400 200]);
    OR_resp = response_align(OR,SRT,[-400 200]);
    
    %baseline correct
    OL = baseline_correct(OL,[400 500]);
    OR = baseline_correct(OR,[400 500]);
    OL_resp = baseline_correct(OL_resp,[1 100]);
    OR_resp = baseline_correct(OR_resp,[1 100]);
    
    
    OL = truncateAD_targ(OL,SRT);
    OR = truncateAD_targ(OR,SRT);
    %note; no truncation for saccade-aligned traces
    
    
    
    
    %============================================
    % OL
    RF = [7 0 1];
    antiRF = mod((RF+4),8);
    
    contraCorrectOL = find(Target_(:,2) ~= 255 & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOL = find(Target_(:,2) ~= 255 & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    contraErrorsOL = find(~isnan(OL(:,1)) & ismember(saccLoc,[3 4 5]) & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiErrorsOL = find(~isnan(OL(:,1)) & ismember(saccLoc,[7 0 1]) & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    
    %======================
    % Set up trial-history
    
    e_e.in(1:size(Correct_,1),1) = NaN;
    e_c.in(1:size(Correct_,1),1) = NaN;
    c_e.in(1:size(Correct_,1),1) = NaN;
    c_c.in(1:size(Correct_,1),1) = NaN;
    
    e_e.out(1:size(Correct_,1),1) = NaN;
    e_c.out(1:size(Correct_,1),1) = NaN;
    c_e.out(1:size(Correct_,1),1) = NaN;
    c_c.out(1:size(Correct_,1),1) = NaN;
    
    
    for trl = 2:size(Correct_,1)
        if Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),RF) & ismember(saccLoc(trl),antiRF) & Target_(trl-1,2) ~= 255
            e_e.in(trl-1,1) = trl;
        elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),antiRF) & ismember(saccLoc(trl),RF) & Target_(trl-1,2) ~= 255
            e_e.out(trl-1,1) = trl;
            
        elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),RF) & Target_(trl-1,2) ~= 255
            e_c.in(trl-1,1) = trl;
        elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),antiRF) & Target_(trl-1,2) ~= 255
            e_c.out(trl-1,1) = trl;
            
        elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),RF) & ismember(saccLoc(trl),antiRF) & Target_(trl-1,2) ~= 255
            c_e.in(trl-1,1) = trl;
        elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),antiRF) & ismember(saccLoc(trl),RF) & Target_(trl-1,2) ~= 255
            c_e.out(trl-1,1) = trl;
            
        elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),RF) & Target_(trl-1,2) ~= 255
            c_c.in(trl-1,1) = trl;
        elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),antiRF) & Target_(trl-1,2) ~= 255
            c_c.out(trl-1,1) = trl;
        end
    end
    
    
    e_e.in = removeNaN(e_e.in);
    e_c.in = removeNaN(e_c.in);
    c_e.in = removeNaN(c_e.in);
    c_c.in = removeNaN(c_c.in);
    
    e_e.out = removeNaN(e_e.out);
    e_c.out = removeNaN(e_c.out);
    c_e.out = removeNaN(c_e.out);
    c_c.out = removeNaN(c_c.out);
    %===========================
    
    
    ROC.OL.c_c = getROC(OL(:,400:1000),c_c.in,c_c.out,50);
    ROC.OL.e_c = getROC(OL(:,400:1000),e_c.in,e_c.out,50);
    ROC.OL.c_e = getROC(OL(:,400:1000),c_e.out,c_e.in,50);
    ROC.OL.e_e = getROC(OL(:,400:1000),e_e.out,e_e.in,50);
    ROC.OL.correct = getROC(OL(:,400:1000),contraCorrectOL,ipsiCorrectOL,50);
    ROC.OL.errors = getROC(OL(:,400:1000),ipsiErrorsOL,contraErrorsOL,50);
    
    %======================
    %subsample trials for comparison
    mintrls = findMin(length(c_c.in),length(c_c.out),length(e_c.in), ...
        length(e_c.out),length(c_e.in),length(c_e.out),length(e_e.in), ...
        length(e_e.out));
    
    %randomize arrays
    xc_c.in = shake(c_c.in);
    xc_c.out = shake(c_c.out);
    xe_c.in = shake(e_c.in);
    xe_c.out = shake(e_c.out);
    xc_e.in = shake(c_e.in);
    xc_e.out = shake(c_e.out);
    xe_e.in = shake(e_e.in);
    xe_e.out = shake(e_e.out);
    
    %subsample
    xc_c.in = xc_c.in(randperm(mintrls));
    xc_c.out = xc_c.out(randperm(mintrls));
    xe_c.in = xe_c.in(randperm(mintrls));
    xe_c.out = xe_c.out(randperm(mintrls));
    xc_e.in = xc_e.in(randperm(mintrls));
    xc_e.out = xc_e.out(randperm(mintrls));
    xe_e.in = xe_e.in(randperm(mintrls));
    xe_e.out = xe_e.out(randperm(mintrls));
    
    ROC_sub.OL.c_c = getROC(OL(:,400:1000),xc_c.in,xc_c.out,50);
    ROC_sub.OL.e_c = getROC(OL(:,400:1000),xe_c.in,xe_c.out,50);
    ROC_sub.OL.c_e = getROC(OL(:,400:1000),xc_e.out,xc_e.in,50);
    ROC_sub.OL.e_e = getROC(OL(:,400:1000),xe_e.out,xe_e.in,50);
    
    clear mintrls xc_c.in xc_c.out xe_c.in xe_c.out xc_e.in xc_e.out xe_e.in xe_e.out
    
    mintrls = findMin(length(contraCorrectOL),length(ipsiCorrectOL),length(contraErrorsOL),length(ipsiErrorsOL));
    contraCorrectOL = shake(contraCorrectOL);
    ipsiCorrectOL = shake(ipsiCorrectOL);
    contraErrorsOL = shake(contraErrorsOL);
    ipsiErrorsOL = shake(ipsiErrorsOL);
    
    inc = contraCorrectOL(randperm(mintrls));
    outc = ipsiCorrectOL(randperm(mintrls));
    ine = contraErrorsOL(randperm(mintrls));
    oute = ipsiErrorsOL(randperm(mintrls));
    
    ROC_sub.OL.correct = getROC(OL(:,400:1000),inc,outc);
    ROC_sub.OL.errors = getROC(OL(:,400:1000),oute,ine);
    
    clear mintrls inc outc ine oute
    
    %=====================
    
    %condition where catch trial scored as error because fast
    %saccade (< 1000 ms)
    catch_errors_in = find(Correct_(:,2) == 0 & Target_(:,2) == 255 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
    %condition where catch trial scored as correct & no saccade
    catch_correct_nosacc = find(Correct_(:,2) == 1 & Target_(:,2) == 255 & isnan(SRT(:,1)));
    
    %condition where catch trial scored as correct but saccade
    %still made, late
    catch_correct_in = find(Correct_(:,2) == 1 & Target_(:,2) == 255 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
    
    
    
    
    n.OL_errors.contra = length(contraErrorsOL);
    n.OL_errors.ipsi = length(ipsiErrorsOL);
    
    
    
    %     OL_trunc = truncateAD_targ(OL,SRT);
    %
    %     tempTDT_notrunc = getTDT_AD(OL,contraCorrectOL,ipsiCorrectOL,0,.05,5);
    %     tempTDT_trunc = getTDT_AD(OL_trunc,contraCorrectOL,ipsiCorrectOL,0,.05,5);
    %
    
    %     if isnan(tempTDT_trunc) | isnan(tempTDT_notrunc)
    %         disp('At least one correct trial signal has NaN TDT')
    %
    %     elseif abs(tempTDT_trunc - tempTDT_notrunc) > 10
    %         disp('Correct trial LFP TDT not equivalent for trunc and no trunc')
    %
    %     else
    
    %non sub-sampled correct trial TDT
    TDT.OL.correct_nosub = getTDT_AD(OL,contraCorrectOL,ipsiCorrectOL,0,.05,5);
    
    if TDT.OL.correct_nosub > nanmean(RTs.correct)
        TDT.OL.correct_nosub = NaN;
    end
    
    
    %pass tests, so calculate error TDT
    TDT.OL.errors = getTDT_AD(OL,contraErrorsOL,ipsiErrorsOL,0,.05,5);
    
    if TDT.OL.errors > nanmean(RTs.errors)
        disp('Error TDT later than RT')
        TDT.OL.errors = NaN;
    end
    
    wf.OL.errors.contra = nanmean(OL(contraErrorsOL,:));
    wf.OL.errors.ipsi = nanmean(OL(ipsiErrorsOL,:));
    
    %for trial history, always going to have many more c_c trials
    %than any other.  subsample down to comparison signal e_c
    %and take the average TDT & waveform
    
    for samp = 1:numSamps
        %re-randomize full trial list
        c_c.in_temp = shake(c_c.in);
        c_c.out_temp = shake(c_c.out);
        
        %take random samples
        if length(c_c.in) > length(c_e.in)
            c_c.in_temp = c_c.in_temp(randperm(length(c_e.in)));
        else
            c_c.in_temp = c_c.in_temp;
        end
        
        if length(c_c.out) > length(c_e.out)
            c_c.out_temp = c_c.out_temp(randperm(length(c_e.out)));
        else
            c_c.out_temp = c_c.out_temp;
        end
        
        OL_in_correct_c_c(samp,1:3001) = nanmean(OL(c_c.in_temp,:));
        OL_out_correct_c_c(samp,1:3001) = nanmean(OL(c_c.out_temp,:));
        
        tempTDT.c_c(samp,1) = getTDT_AD(OL,c_c.in_temp,c_c.out_temp,0,.05,5);
    end
    
    %for c_c waveforms only, take average over random samples
    wf.OL.correct.in_c_c = nanmean(OL_in_correct_c_c);
    wf.OL.correct.out_c_c = nanmean(OL_out_correct_c_c);
    
    
    
    wf.OL.correct.in_e_e = nanmean(OL(e_e.in,:));
    wf.OL.correct.in_e_c = nanmean(OL(e_c.in,:));
    wf.OL.correct.in_c_e = nanmean(OL(c_e.in,:));
    wf.OL.correct.out_e_e = nanmean(OL(e_e.out,:));
    wf.OL.correct.out_e_c = nanmean(OL(e_c.out,:));
    wf.OL.correct.out_c_e = nanmean(OL(c_e.out,:));
    
    
    %non-subsampled correct trial response aligned traces for catch trial
    %comparison
    wf.OL.correct.in_resp = nanmean(OL_resp(contraCorrectOL,:));
    wf.OL.correct.out_resp = nanmean(OL_resp(ipsiCorrectOL,:));
    
    
    %TDT for trial history
    TDT.OL.correct_e_e = getTDT_AD(OL,e_e.in,e_e.out,0,.05,5);
    TDT.OL.correct_e_c = getTDT_AD(OL,e_c.in,e_c.out,0,.05,5);
    TDT.OL.correct_c_e = getTDT_AD(OL,c_e.in,c_e.out,0,.05,5);
    TDT.OL.correct_c_c_nosub = getTDT_AD(OL,c_c.in,c_c.out,0,.05,5);
    %take average of random samples
    TDT.OL.correct_c_c = nanmean(tempTDT.c_c);
    clear tempTDT.c_c
    
    
    
    if goCatch == 1
        wf.OL.catch.correct_nosacc = nanmean(OL(catch_correct_nosacc,:));
        wf.OL.catch.correct_in = nanmean(OL(catch_correct_in,:));
        wf.OL.catch.errors_in = nanmean(OL(catch_errors_in,:));
        
        wf.OL.catch.correct_nosacc_resp = nanmean(OL_resp(catch_correct_nosacc,:));
        wf.OL.catch.correct_in_resp = nanmean(OL_resp(catch_correct_in,:));
        wf.OL.catch.errors_in_resp = nanmean(OL_resp(catch_errors_in,:));
    else
        wf.OL.catch.correct_nosacc(1:3001) = NaN;
        wf.OL.catch.correct_in(1:3001) = NaN;
        wf.OL.catch.errors_in(1:3001) = NaN;
        
        wf.OL.catch.correct_nosacc_resp(1:601) = NaN;
        wf.OL.catch.correct_in_resp(1:601) = NaN;
        wf.OL.catch.errors_in_resp(1:601) = NaN;
    end
    %=======================================
    % Repeated-sampling correct trial TDT
    
    %keep track of original vector of trial numbers
    contra_correct_all = contraCorrectOL;
    ipsi_correct_all = ipsiCorrectOL;
    contra_errors_all = contraErrorsOL;
    ipsi_errors_all = ipsiErrorsOL;
    
    
    for samp = 1:numSamps
        %re-randomize
        in_correct = shake(contra_correct_all);
        out_correct = shake(ipsi_correct_all);
        in_incorrect = shake(contra_errors_all);
        out_incorrect = shake(ipsi_errors_all);
        
        
        %sub-sample to length of equivalent error signals
        if length(in_correct) > length(in_incorrect)
            in_correct = in_correct(randperm(length(contraErrorsOL)));
        end
        
        if length(out_correct) > length(out_incorrect)
            out_correct = out_correct(randperm(length(ipsiErrorsOL)));
        end
        
        TDT.OL.correct(samp,1) = getTDT_AD(OL,in_correct,out_correct,0,.05,5);
        
        if TDT.OL.correct(samp,1) > nanmean(RTs.correct)
            TDT.OL.correct(samp,1) = NaN;
        end
        
        wf.OL.correct.contra(samp,1:3001) = nanmean(OL(in_correct,:));
        wf.OL.correct.ipsi(samp,1:3001) = nanmean(OL(out_correct,:));
    end
    
    
    
    
    %
    if PDFflag == 1
        f = figure;
        subplot(1,2,1)
        plot(-500:2500,nanmean(wf.OL.correct.contra),'b',-500:2500,nanmean(wf.OL.correct.ipsi),'--b')
        fon
        xlim([-50 300])
        axis ij
        
        
        
        vline(nanmean(TDT.OL.correct),'b')
        
        
        title('OL Correct')
        
        subplot(1,2,2)
        
        plot(-500:2500,wf.OL.errors.contra,'r',-500:2500,wf.OL.errors.ipsi,'--r')
        fon
        xlim([-50 300])
        axis ij
        
        
        
        vline(TDT.OL.errors,'r')
        
        title('OL Errors')
        
        eval(['print -dpdf ' PDFdir file '_OL.pdf'])
        %eval(['print -dpdf /volumes/Dump/Analyses/Errors/Uber/PDF/' batch_list(i).name '_OL.pdf'])
        
        
        close(f)
        
        if goCatch == 1
            f = figure;
            plot(-500:2500,nanmean(wf.OL.correct.contra),'k',-500:2500,nanmean(wf.OL.correct.ipsi),'--k',-500:2500,wf.OL.catch.correct_nosacc,'r',-500:2500,wf.OL.catch.errors_in,'b',-500:2500,wf.OL.catch.correct_in,'--b')
            fon
            xlim([-50 300])
            axis ij
            eval(['print -dpdf ' PDFdir file '_OL_catch.pdf'])
            close(f)
            
            f = figure;
            plot(-400:200,wf.OL.correct.in_resp,'k',-400:200,wf.OL.correct.out_resp,'--k',-400:200,wf.OL.catch.correct_nosacc_resp,'r',-400:200,wf.OL.catch.errors_in_resp,'b',-400:200,wf.OL.catch.correct_in_resp,'--b')
            fon
            xlim([-400 200])
            axis ij
            eval(['print -dpdf ' PDFdir file '_OL_catch_resp.pdf'])
            close(f)
        end
        
        %plot trial-history
        f = figure;
        set(gcf,'color','white')
        subplot(2,1,1)
        plot(-500:2500,wf.OL.correct.in_c_c,'b',-500:2500,wf.OL.correct.out_c_c,'--b',-500:2500,wf.OL.correct.in_e_c,'r',-500:2500,wf.OL.correct.out_e_c,'--r')
        vline(TDT.OL.correct_c_c,'b')
        vline(TDT.OL.correct_e_c,'r')
        xlim([-100 500])
        axis ij
        
        
        legend('cor-cor in','cor-cor out','err-cor in','err-cor out')
        
        subplot(2,1,2)
        plot(-500:2500,wf.OL.correct.in_c_e,'b',-500:2500,wf.OL.correct.out_c_e,'--b',-500:2500,wf.OL.correct.in_e_e,'r',-500:2500,wf.OL.correct.out_e_e,'--r')
        vline(TDT.OL.correct_c_e,'b')
        vline(TDT.OL.correct_e_e,'r')
        xlim([-100 500])
        axis ij
        
        
        legend('cor-err in','cor-err out','err-err in','err-err out')
        
        eval(['print -dpdf ' PDFdir file '_OL_trial_history.pdf'])
        close(f)
        
    end
    %end
    
    
    
    %==============================================
    % OR
    RF = [3 4 5];
    antiRF = mod((RF+4),8);
    
    contraCorrectOR = find(Target_(:,2) ~= 255 & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOR = find(Target_(:,2) ~= 255 & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    contraErrorsOR = find(~isnan(OR(:,1)) & ismember(saccLoc,[7 0 1]) & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiErrorsOR = find(~isnan(OR(:,1)) & ismember(saccLoc,[3 4 5]) & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    
    
    %======================
    % Set up trial-history
    
    e_e.in(1:size(Correct_,1),1) = NaN;
    e_c.in(1:size(Correct_,1),1) = NaN;
    c_e.in(1:size(Correct_,1),1) = NaN;
    c_c.in(1:size(Correct_,1),1) = NaN;
    
    e_e.out(1:size(Correct_,1),1) = NaN;
    e_c.out(1:size(Correct_,1),1) = NaN;
    c_e.out(1:size(Correct_,1),1) = NaN;
    c_c.out(1:size(Correct_,1),1) = NaN;
    
    
    for trl = 2:size(Correct_,1)
        if Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),RF) & ismember(saccLoc(trl),antiRF) & Target_(trl-1,2) ~= 255
            e_e.in(trl-1,1) = trl;
        elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),antiRF) & ismember(saccLoc(trl),RF) & Target_(trl-1,2) ~= 255
            e_e.out(trl-1,1) = trl;
            
        elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),RF) & Target_(trl-1,2) ~= 255
            e_c.in(trl-1,1) = trl;
        elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),antiRF) & Target_(trl-1,2) ~= 255
            e_c.out(trl-1,1) = trl;
            
        elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),RF) & ismember(saccLoc(trl),antiRF) & Target_(trl-1,2) ~= 255
            c_e.in(trl-1,1) = trl;
        elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),antiRF) & ismember(saccLoc(trl),RF) & Target_(trl-1,2) ~= 255
            c_e.out(trl-1,1) = trl;
            
        elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),RF) & Target_(trl-1,2) ~= 255
            c_c.in(trl-1,1) = trl;
        elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),antiRF) & Target_(trl-1,2) ~= 255
            c_c.out(trl-1,1) = trl;
        end
    end
    
    
    e_e.in = removeNaN(e_e.in);
    e_c.in = removeNaN(e_c.in);
    c_e.in = removeNaN(c_e.in);
    c_c.in = removeNaN(c_c.in);
    
    e_e.out = removeNaN(e_e.out);
    e_c.out = removeNaN(e_c.out);
    c_e.out = removeNaN(c_e.out);
    c_c.out = removeNaN(c_c.out);
    %===========================
    
    ROC.OR.c_c = getROC(OR(:,400:1000),c_c.in,c_c.out,50);
    ROC.OR.e_c = getROC(OR(:,400:1000),e_c.in,e_c.out,50);
    ROC.OR.c_e = getROC(OR(:,400:1000),c_e.out,c_e.in,50);
    ROC.OR.e_e = getROC(OR(:,400:1000),e_e.out,e_e.in,50);
    ROC.OR.correct = getROC(OR(:,400:1000),contraCorrectOR,ipsiCorrectOR,50);
    ROC.OR.errors = getROC(OR(:,400:1000),ipsiErrorsOR,contraErrorsOR,50);
    
    %======================
    %subsample trials for comparison
    mintrls = findMin(length(c_c.in),length(c_c.out),length(e_c.in), ...
        length(e_c.out),length(c_e.in),length(c_e.out),length(e_e.in), ...
        length(e_e.out));
    
    %randomize arrays
    xc_c.in = shake(c_c.in);
    xc_c.out = shake(c_c.out);
    xe_c.in = shake(e_c.in);
    xe_c.out = shake(e_c.out);
    xc_e.in = shake(c_e.in);
    xc_e.out = shake(c_e.out);
    xe_e.in = shake(e_e.in);
    xe_e.out = shake(e_e.out);
    
    %subsample
    xc_c.in = xc_c.in(randperm(mintrls));
    xc_c.out = xc_c.out(randperm(mintrls));
    xe_c.in = xe_c.in(randperm(mintrls));
    xe_c.out = xe_c.out(randperm(mintrls));
    xc_e.in = xc_e.in(randperm(mintrls));
    xc_e.out = xc_e.out(randperm(mintrls));
    xe_e.in = xe_e.in(randperm(mintrls));
    xe_e.out = xe_e.out(randperm(mintrls));
    
    ROC_sub.OR.c_c = getROC(OR(:,400:1000),xc_c.in,xc_c.out,50);
    ROC_sub.OR.e_c = getROC(OR(:,400:1000),xe_c.in,xe_c.out,50);
    ROC_sub.OR.c_e = getROC(OR(:,400:1000),xc_e.out,xc_e.in,50);
    ROC_sub.OR.e_e = getROC(OR(:,400:1000),xe_e.out,xe_e.in,50);
    
    clear mintrls xc_c.in xc_c.out xe_c.in xe_c.out xc_e.in xc_e.out xe_e.in xe_e.out
    
    mintrls = findMin(length(contraCorrectOR),length(ipsiCorrectOR),length(contraErrorsOR),length(ipsiErrorsOR));
    contraCorrectOR = shake(contraCorrectOR);
    ipsiCorrectOR = shake(ipsiCorrectOR);
    contraErrorsOR = shake(contraErrorsOR);
    ipsiErrorsOR = shake(ipsiErrorsOR);
    
    inc = contraCorrectOR(randperm(mintrls));
    outc = ipsiCorrectOR(randperm(mintrls));
    ine = contraErrorsOR(randperm(mintrls));
    oute = ipsiErrorsOR(randperm(mintrls));
    
    ROC_sub.OR.correct = getROC(OR(:,400:1000),inc,outc);
    ROC_sub.OR.errors = getROC(OR(:,400:1000),oute,ine);
    
    clear mintrls inc outc ine oute
    
    %=====================
    
    
    %condition where catch trial scored as error because fast
    %saccade (< 1000 ms)
    catch_errors_in = find(Errors_(:,5) == 1 & Target_(:,2) == 255 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
    %condition where catch trial scored as correct & no saccade
    catch_correct_nosacc = find(Correct_(:,2) == 1 & Target_(:,2) == 255 & isnan(SRT(:,1)));
    
    %condition where catch trial scored as correct but saccade
    %still made, late
    catch_correct_in = find(Correct_(:,2) == 1 & Target_(:,2) == 255 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
    
    n.OR_errors.contra = length(contraErrorsOR);
    n.OR_errors.ipsi = length(ipsiErrorsOR);
    
    
    %     OR_trunc = truncateAD_targ(OR,SRT);
    %
    %     tempTDT_notrunc = getTDT_AD(OR,contraCorrectOR,ipsiCorrectOR,0,.05,5);
    %     tempTDT_trunc = getTDT_AD(OR_trunc,contraCorrectOR,ipsiCorrectOR,0,.05,5);
    
    
    %     if isnan(tempTDT_trunc) | isnan(tempTDT_notrunc)
    %         disp('At least one correct trial signal has NaN TDT')
    %     elseif abs(tempTDT_trunc - tempTDT_notrunc) > 10
    %         disp('Correct trial LFP TDT not equivalent for trunc and no trunc')
    %     else
    
    TDT.OR.correct_nosub = getTDT_AD(OR,contraCorrectOR,ipsiCorrectOR,0,.05,5);
    
    if TDT.OR.correct_nosub > nanmean(RTs.correct)
        TDT.OR.correct_nosub = NaN;
    end
    
    %pass tests, so calculate error TDT
    TDT.OR.errors = getTDT_AD(OR,contraErrorsOR,ipsiErrorsOR,0,.05,5);
    
    if TDT.OR.errors > nanmean(RTs.errors)
        disp('Error TDT later than RT')
        TDT.OR.errors = NaN;
    end
    
    wf.OR.errors.contra = nanmean(OR(contraErrorsOR,:));
    wf.OR.errors.ipsi = nanmean(OR(ipsiErrorsOR,:));
    
    %for trial history, always going to have many more c_c trials
    %than any other.  subsample down to comparison signal e_c
    %and take the average TDT & waveform
    
    for samp = 1:numSamps
        %re-randomize full trial list
        c_c.in_temp = shake(c_c.in);
        c_c.out_temp = shake(c_c.out);
        
        %take random samples
        if length(c_c.in) > length(c_e.in)
            c_c.in_temp = c_c.in_temp(randperm(length(c_e.in)));
        else
            c_c.in_temp = c_c.in_temp;
        end
        
        if length(c_c.out) > length(c_e.out)
            c_c.out_temp = c_c.out_temp(randperm(length(c_e.out)));
        else
            c_c.out_temp = c_c.out_temp;
        end
        
        OR_in_correct_c_c(samp,1:3001) = nanmean(OR(c_c.in_temp,:));
        OR_out_correct_c_c(samp,1:3001) = nanmean(OR(c_c.out_temp,:));
        
        tempTDT.c_c(samp,1) = getTDT_AD(OR,c_c.in_temp,c_c.out_temp,0,.05,5);
    end
    
    %for c_c waveforms only, take average over random samples
    
    wf.OR.correct.in_resp = nanmean(OR_resp(contraCorrectOR,:));
    wf.OR.correct.out_resp = nanmean(OR_resp(ipsiCorrectOR,:));
    
    wf.OR.correct.in_c_c = nanmean(OR_in_correct_c_c);
    wf.OR.correct.out_c_c = nanmean(OR_out_correct_c_c);
    
    wf.OR.correct.in_e_e = nanmean(OR(e_e.in,:));
    wf.OR.correct.in_e_c = nanmean(OR(e_c.in,:));
    wf.OR.correct.in_c_e = nanmean(OR(c_e.in,:));
    wf.OR.correct.out_e_e = nanmean(OR(e_e.out,:));
    wf.OR.correct.out_e_c = nanmean(OR(e_c.out,:));
    wf.OR.correct.out_c_e = nanmean(OR(c_e.out,:));
    
    
    %TDT for trial history
    TDT.OR.correct_e_e = getTDT_AD(OR,e_e.in,e_e.out,0,.05,5);
    TDT.OR.correct_e_c = getTDT_AD(OR,e_c.in,e_c.out,0,.05,5);
    TDT.OR.correct_c_e = getTDT_AD(OR,c_e.in,c_e.out,0,.05,5);
    TDT.OR.correct_c_c_nosub = getTDT_AD(OR,c_c.in,c_c.out,0,.05,5);
    %take average of random samples
    TDT.OR.correct_c_c = nanmean(tempTDT.c_c);
    clear tempTDT.c_c
    
    if goCatch == 1
        wf.OR.catch.correct_nosacc = nanmean(OR(catch_correct_nosacc,:));
        wf.OR.catch.correct_in = nanmean(OR(catch_correct_in,:));
        wf.OR.catch.errors_in = nanmean(OR(catch_errors_in,:));
        
        wf.OR.catch.correct_nosacc_resp = nanmean(OR_resp(catch_correct_nosacc,:));
        wf.OR.catch.correct_in_resp = nanmean(OR_resp(catch_correct_in,:));
        wf.OR.catch.errors_in_resp = nanmean(OR_resp(catch_errors_in,:));
    else
        wf.OR.catch.correct_nosacc(1:3001) = NaN;
        wf.OR.catch.correct_in(1:3001) = NaN;
        wf.OR.catch.errors_in(1:3001) = NaN;
        
        wf.OR.catch.correct_nosacc_resp(1:601) = NaN;
        wf.OR.catch.correct_in_resp(1:601) = NaN;
        wf.OR.catch.errors_in_resp(1:601) = NaN;
    end
    %=======================================
    % Repeated-sampling correct trial TDT
    
    %keep track of original vector of trial numbers
    contra_correct_all = contraCorrectOR;
    ipsi_correct_all = ipsiCorrectOR;
    contra_errors_all = contraErrorsOR;
    ipsi_errors_all = ipsiErrorsOR;
    
    for samp = 1:numSamps
        %re-randomize
        in_correct = shake(contra_correct_all);
        out_correct = shake(ipsi_correct_all);
        in_incorrect = shake(contra_errors_all);
        out_incorrect = shake(ipsi_errors_all);
        
        
        %sub-sample to length of equivalent error signals
        if length(in_correct) > length(in_incorrect)
            in_correct = in_correct(randperm(length(contraErrorsOR)));
        end
        
        if length(out_correct) > length(out_incorrect)
            out_correct = out_correct(randperm(length(ipsiErrorsOR)));
        end
        
        TDT.OR.correct(samp,1) = getTDT_AD(OR,in_correct,out_correct,0,.05,5);
        
        if TDT.OR.correct(samp,1) > nanmean(RTs.correct)
            TDT.OR.correct(samp,1) = NaN;
        end
        
        wf.OR.correct.contra(samp,1:3001) = nanmean(OR(in_correct,:));
        wf.OR.correct.ipsi(samp,1:3001) = nanmean(OR(out_correct,:));
    end
    
    
    
    
    %
    if PDFflag == 1
        f = figure;
        subplot(1,2,1)
        plot(-500:2500,nanmean(wf.OR.correct.contra),'b',-500:2500,nanmean(wf.OR.correct.ipsi),'--b')
        fon
        xlim([-50 300])
        axis ij
        
        
        
        vline(nanmean(TDT.OR.correct),'b')
        
        
        title('OR Correct')
        
        subplot(1,2,2)
        plot(-500:2500,wf.OR.errors.contra,'r',-500:2500,wf.OR.errors.ipsi,'--r')
        fon
        xlim([-50 300])
        axis ij
        
        
        
        
        vline(TDT.OR.errors,'r')
        
        title('OR Errors')
        
        
        eval(['print -dpdf ' PDFdir file '_OR.pdf'])
        %eval(['print -dpdf /volumes/Dump/Analyses/Errors/Uber/PDF/' batch_list(i).name '_OR.pdf'])
        
        
        close(f)
        
        if goCatch == 1
            f = figure;
            plot(-500:2500,nanmean(wf.OR.correct.contra),'k',-500:2500,nanmean(wf.OR.correct.ipsi),'--k',-500:2500,wf.OR.catch.correct_nosacc,'r',-500:2500,wf.OR.catch.errors_in,'b',-500:2500,wf.OR.catch.correct_in,'--b')
            fon
            xlim([-50 300])
            axis ij
            eval(['print -dpdf ' PDFdir file '_OR_catch.pdf'])
            
            close(f)
            
            f = figure;
            plot(-400:200,wf.OR.correct.in_resp,'k',-400:200,wf.OR.correct.out_resp,'--k',-400:200,wf.OR.catch.correct_nosacc_resp,'r',-400:200,wf.OR.catch.errors_in_resp,'b',-400:200,wf.OR.catch.correct_in_resp,'--b')
            fon
            xlim([-400 200])
            axis ij
            eval(['print -dpdf ' PDFdir file '_OR_catch_resp.pdf'])
            
            close(f)
        end
        
        %plot trial-history
        f = figure;
        set(gcf,'color','white')
        subplot(2,1,1)
        plot(-500:2500,wf.OR.correct.in_c_c,'b',-500:2500,wf.OR.correct.out_c_c,'--b',-500:2500,wf.OR.correct.in_e_c,'r',-500:2500,wf.OR.correct.out_e_c,'--r')
        vline(TDT.OR.correct_c_c,'b')
        vline(TDT.OR.correct_e_c,'r')
        xlim([-100 500])
        axis ij
        
        
        legend('cor-cor in','cor-cor out','err-cor in','err-cor out')
        
        subplot(2,1,2)
        plot(-500:2500,wf.OR.correct.in_c_e,'b',-500:2500,wf.OR.correct.out_c_e,'--b',-500:2500,wf.OR.correct.in_e_e,'r',-500:2500,wf.OR.correct.out_e_e,'--r')
        vline(TDT.OR.correct_c_e,'b')
        vline(TDT.OR.correct_e_e,'r')
        xlim([-100 500])
        axis ij
        
        
        legend('cor-err in','cor-err out','err-err in','err-err out')
        
        eval(['print -dpdf ' PDFdir file '_OR_trial_history.pdf'])
        close(f)
        
        
        
    end
    % end
    
    
end
clear OL* OR* n2pc* RF antiRF

%==========================================================

if saveFlag == 1
    if exist('TDT')
        eval(['save(' q MATdir,file,'_TDT.mat' qcq 'stats' qcq 'pos' qcq 'alpha' qcq 'ROC' qcq 'ROC_sub' qcq 'n' qcq 'wf' qcq 'TDT' qcq 'RTs' qcq '-mat' q ')'])
    else
        disp('Calculation of TDT Failed...not saving...')
        return
    end
end

keep  i q c qcq saveFlag

end