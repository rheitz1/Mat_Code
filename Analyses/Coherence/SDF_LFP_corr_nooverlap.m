%gets trial-by-trial integral correlation for T-in RF and D-in RF between
%single units and LFP

function [integ_corr_in,integ_corr_out,integ_corr_in_fast,integ_corr_out_fast,integ_corr_in_slow,integ_corr_out_slow] = SDF_LFP_corr_nooverlap(file_name,sig1_name,sig2_name)
%also try to load MStim_ so we can tell if it is that kind of data set
load(file_name,sig1_name,sig2_name,'SRT','Target_','Correct_','RFs','MStim_')

sig1 = eval(sig1_name);
sig2 = eval(sig2_name);

[RF1 ~] = LFPtuning(sig1);
 
%INVERT RFS BECAUSE NON-OVERLAPPING
RF1 = mod((RF1+4),8);
 
RF2 = RFs.(sig2_name);
 
RF = intersect(RF1,RF2);
antiRF = mod((RF+4),8);
 
if isempty(RF)
    disp('Empty RF...')
    integ_corr_in = NaN;
    integ_corr_out = NaN;
    integ_corr_in_fast = NaN;
    integ_corr_out_fast = NaN;
    integ_corr_in_slow = NaN;
    integ_corr_out_slow = NaN;
    return
end


%median split on RTs
SRTmed = nanmedian(SRT(:,1));

%if it was a uStim session, use only non-stim trials.
if exist('MStim_') == 1
    in = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & isnan(MStim_(:,1)) == 1);
    out = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & isnan(MStim_(:,1)) == 1);
    
    in_fast = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & isnan(MStim_(:,1)) == 1 & SRT(:,1) <= SRTmed);
    out_fast = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & isnan(MStim_(:,1)) == 1 & SRT(:,1) <= SRTmed);
    
    in_slow = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & isnan(MStim_(:,1)) == 1 & SRT(:,1) > SRTmed);
    out_slow = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & isnan(MStim_(:,1)) == 1 & SRT(:,1) > SRTmed);
else
    in = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF));
    out = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF));
        
    in_fast = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) <= SRTmed);
    out_fast = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) <= SRTmed);
    
    in_slow = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) > SRTmed);
    out_slow = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) > SRTmed);
end


SDF = sSDF(sig2,Target_(:,1),[-100 600]);
LFP = baseline_correct(sig1,[400 500]);

% LFP_filt = filtSig(LFP,10,'lowpass');
% SDF_filt = filtSig(SDF,10,'lowpass');

LFP_filt = filtSig(LFP,35,'highpass');
SDF_filt = filtSig(SDF,35,'highpass');

%get integral 200:300 ms post target onset, where most of the low frequency
%coherence is observed.

integ.LFP.in = sum(LFP_filt(in,700:800),2);
integ.LFP.out = sum(LFP_filt(out,700:800),2);

integ.SDF.in = sum(SDF_filt(in,300:400),2);
integ.SDF.out = sum(SDF_filt(out,300:400),2);

integ.LFP.in_fast = sum(LFP_filt(in_fast,700:800),2);
integ.LFP.out_fast = sum(LFP_filt(out_fast,700:800),2);

integ.SDF.in_fast = sum(SDF_filt(in_fast,300:400),2);
integ.SDF.out_fast = sum(SDF_filt(out_fast,300:400),2);

integ.LFP.in_slow = sum(LFP_filt(in_slow,700:800),2);
integ.LFP.out_slow = sum(LFP_filt(out_slow,700:800),2);

integ.SDF.in_slow = sum(SDF_filt(in_slow,300:400),2);
integ.SDF.out_slow = sum(SDF_filt(out_slow,300:400),2);


c1 = [integ.LFP.in integ.SDF.in];
c1 = removeNaN(c1);

c1_fast = [integ.LFP.in_fast integ.SDF.in_fast];
c1_fast = removeNaN(c1_fast);

c1_slow = [integ.LFP.in_slow integ.SDF.in_slow];
c1_slow = removeNaN(c1_slow);


integ_corr_in = corr(c1(:,1),c1(:,2));
integ_corr_in_fast = corr(c1_fast(:,1),c1_fast(:,2));
integ_corr_in_slow = corr(c1_slow(:,1),c1_slow(:,2));


c2 = [integ.LFP.out integ.SDF.out];
c2 = removeNaN(c2);

c2_fast = [integ.LFP.out_fast integ.SDF.out_fast];
c2_fast = removeNaN(c2_fast);

c2_slow = [integ.LFP.out_slow integ.SDF.out_slow];
c2_slow = removeNaN(c2_slow);

integ_corr_out = corr(c2(:,1),c2(:,2));
integ_corr_out_fast = corr(c2_fast(:,1),c2_fast(:,2));
integ_corr_out_slow = corr(c2_slow(:,1),c2_slow(:,2));