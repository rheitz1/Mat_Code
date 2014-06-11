%get averages
Spike_correct_in = nanmean(wf_all.Spike_correct.in);
Spike_correct_out = nanmean(wf_all.Spike_correct.out);
Spike_errors_in = nanmean(wf_all.Spike_errors.in);
Spike_errors_out = nanmean(wf_all.Spike_errors.out);

LFP_correct_in = nanmean(wf_all.LFP_correct.in);
LFP_correct_out = nanmean(wf_all.LFP_correct.out);
LFP_errors_in = nanmean(wf_all.LFP_errors.in);
LFP_errors_out = nanmean(wf_all.LFP_errors.out);


OL_correct_contra = nanmean(wf_all.OL_correct.contra);
OL_correct_ipsi = nanmean(wf_all.OL_correct.ipsi);
OL_errors_contra = nanmean(wf_all.OL_errors.contra);
OL_errors_ipsi = nanmean(wf_all.OL_errors.ipsi);


OR_correct_contra = nanmean(wf_all.OR_correct.contra);
OR_correct_ipsi = nanmean(wf_all.OR_correct.ipsi);
OR_errors_contra = nanmean(wf_all.OR_errors.contra);
OR_errors_ipsi = nanmean(wf_all.OR_errors.ipsi);

%take out NaN's because filter can't handle them.
Spike_correct_in(isnan(Spike_correct_in)) = [];
Spike_correct_out(isnan(Spike_correct_out)) = [];
Spike_errors_in(isnan(Spike_errors_in)) = [];
Spike_errors_out(isnan(Spike_errors_out)) = [];

LFP_correct_in(isnan(LFP_correct_in)) = [];
LFP_correct_out(isnan(LFP_correct_out)) = [];
LFP_errors_in(isnan(LFP_errors_in)) = [];
LFP_errors_out(isnan(LFP_errors_out)) = [];


OL_correct_contra(isnan(OL_correct_contra)) = [];
OL_correct_ipsi(isnan(OL_correct_ipsi)) = [];
OL_errors_contra(isnan(OL_errors_contra)) = [];
OL_errors_ipsi(isnan(OL_errors_ipsi)) = [];

OR_correct_contra(isnan(OR_correct_contra)) = [];
OR_correct_ipsi(isnan(OR_correct_ipsi)) = [];
OR_errors_contra(isnan(OR_errors_contra)) = [];
OR_errors_ipsi(isnan(OR_errors_ipsi)) = [];


%30 Hz filter for display purposes only [AD only - leave SDFs alone]
band = 50;

% Spike_correct_in = filtSig(Spike_correct_in,band,'lowpass');
% Spike_correct_out = filtSig(Spike_correct_out,band,'lowpass');
% Spike_errors_in = filtSig(Spike_errors_in,band,'lowpass');
% Spike_errors_out = filtSig(Spike_errors_out,band,'lowpass');

LFP_correct_in = filtSig(LFP_correct_in,band,'lowpass');
LFP_correct_out = filtSig(LFP_correct_out,band,'lowpass');
LFP_errors_in = filtSig(LFP_errors_in,band,'lowpass');
LFP_errors_out = filtSig(LFP_errors_out,band,'lowpass');

OL_correct_contra = filtSig(OL_correct_contra,band,'lowpass');
OL_correct_ipsi = filtSig(OL_correct_ipsi,band,'lowpass');
OL_errors_contra = filtSig(OL_errors_contra,band,'lowpass');
OL_errors_ipsi = filtSig(OL_errors_ipsi,band,'lowpass');

OR_correct_contra = filtSig(OR_correct_contra,band,'lowpass');
OR_correct_ipsi = filtSig(OR_correct_ipsi,band,'lowpass');
OR_errors_contra = filtSig(OR_errors_contra,band,'lowpass');
OR_errors_ipsi = filtSig(OR_errors_ipsi,band,'lowpass');


%shorten signals so vector lengths are equal (-50:300)

% Spike_correct_in = Spike_correct_in(50:400);
% Spike_correct_out = Spike_correct_out(50:400);
% Spike_errors_in = Spike_errors_in(50:400);
% Spike_errors_out = Spike_errors_out(50:400);

LFP_correct_in = LFP_correct_in(450:800);
LFP_correct_out = LFP_correct_out(450:800);
LFP_errors_in = LFP_errors_in(450:800);
LFP_errors_out = LFP_errors_out(450:800);

OL_correct_contra = OL_correct_contra(450:800);
OL_correct_ipsi = OL_correct_ipsi(450:800);
OL_errors_contra = OL_errors_contra(450:800);
OL_errors_ipsi = OL_errors_ipsi(450:800);

OR_correct_contra = OR_correct_contra(450:800);
OR_correct_ipsi = OR_correct_ipsi(450:800);
OR_errors_contra = OR_errors_contra(450:800);
OR_errors_ipsi = OR_errors_ipsi(450:800);


%plot filtered signals
% figure
% plot(-50:300,Spike_correct_in,'b',-50:300,Spike_correct_out,'--b',-50:300,Spike_errors_in,'r',-50:300,Spike_errors_out,'--r')
% xlim([-50 300])
% fon
% title('Spike')

figure
plot(-50:300,LFP_correct_in,'b',-50:300,LFP_correct_out,'--b',-50:300,LFP_errors_in,'r',-50:300,LFP_errors_out,'--r')
axis ij
xlim([-50 300])
fon
title('LFP')

figure
plot(-50:300,OL_correct_contra,'b',-50:300,OL_correct_ipsi,'--b',-50:300,OL_errors_contra,'r',-50:300,OL_errors_ipsi,'--r')
axis ij
xlim([-50 300])
fon
title('OL')

figure
plot(-50:300,OR_correct_contra,'b',-50:300,OR_correct_ipsi,'--b',-50:300,OR_errors_contra,'r',-50:300,OR_errors_ipsi,'--r')
axis ij
fon
xlim([-50 300])
title('OR')


