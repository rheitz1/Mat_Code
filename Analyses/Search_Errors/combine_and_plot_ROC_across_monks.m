%combines ROC averages across monkeys
clear all
 
%cd /Volumes/Dump/Analyses/Errors/Uber_5runs_.05_FINAL/
%load Qagg_final

cd /Volumes/Dump/Analyses/Errors/Uber_5runs_.05_withSaccMets/
load Qagg_withMets
 
keeper.history.neuron_e_e = keeper.reg.neuron;
keeper.history.LFP_e_e = keeper.reg.LFP;
keeper.history.OR_e_e = keeper.reg.OR;

win = 50;
intervalwin = 250:400;
 
QROC.neuron.c_c = allROC.neuron.c_c(find(keeper.history.neuron_e_e),:);
QROC.neuron.e_c = allROC.neuron.e_c(find(keeper.history.neuron_e_e),:);
QROC.neuron.c_e = allROC.neuron.c_e(find(keeper.history.neuron_e_e),:);
QROC.neuron.e_e = allROC.neuron.e_e(find(keeper.history.neuron_e_e),:);
 
QROC_sub.neuron.c_c = allROC_sub.neuron.c_c(find(keeper.history.neuron_e_e),:);
QROC_sub.neuron.e_c = allROC_sub.neuron.e_c(find(keeper.history.neuron_e_e),:);
QROC_sub.neuron.c_e = allROC_sub.neuron.c_e(find(keeper.history.neuron_e_e),:);
QROC_sub.neuron.e_e = allROC_sub.neuron.e_e(find(keeper.history.neuron_e_e),:);
 
[max i] = nanmax(nanmean(allROC.neuron.c_c(find(keeper.history.neuron_e_e),:)));
Qccav_maxpos.neuron = nanmean(allROC.neuron.c_c(find(keeper.history.neuron_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.neuron.c_e(find(keeper.history.neuron_e_e),:)));
Qceav_maxpos.neuron = nanmean(allROC.neuron.c_e(find(keeper.history.neuron_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.neuron.e_c(find(keeper.history.neuron_e_e),:)));
Qecav_maxpos.neuron = nanmean(allROC.neuron.e_c(find(keeper.history.neuron_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.neuron.e_e(find(keeper.history.neuron_e_e),:)));
Qeeav_maxpos.neuron = nanmean(allROC.neuron.e_e(find(keeper.history.neuron_e_e),i-win:i+win),2);
 
 
Qccav.neuron = nanmean(allROC.neuron.c_c(find(keeper.history.neuron_e_e),intervalwin),2);
Qceav.neuron = nanmean(allROC.neuron.c_e(find(keeper.history.neuron_e_e),intervalwin),2);
Qecav.neuron = nanmean(allROC.neuron.e_c(find(keeper.history.neuron_e_e),intervalwin),2);
Qeeav.neuron = nanmean(allROC.neuron.e_e(find(keeper.history.neuron_e_e),intervalwin),2);
 
 
 
 
 
QROC.LFP.c_c = allROC.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:);
QROC.LFP.e_c = allROC.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:);
QROC.LFP.c_e = allROC.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:);
QROC.LFP.e_e = allROC.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:);
 
QROC_sub.LFP.c_c = allROC_sub.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:);
QROC_sub.LFP.e_c = allROC_sub.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:);
QROC_sub.LFP.c_e = allROC_sub.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:);
QROC_sub.LFP.e_e = allROC_sub.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:);
 
 
 
[max i] = nanmax(nanmean(allROC.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:)));
Qccav_maxpos.LFP = nanmean(allROC.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:)));
Qceav_maxpos.LFP = nanmean(allROC.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:)));
Qecav_maxpos.LFP = nanmean(allROC.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:)));
Qeeav_maxpos.LFP = nanmean(allROC.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),i-win:i+win),2);
 
 
Qccav.LFP = nanmean(allROC.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),intervalwin),2);
Qceav.LFP = nanmean(allROC.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),intervalwin),2);
Qecav.LFP = nanmean(allROC.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),intervalwin),2);
Qeeav.LFP = nanmean(allROC.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),intervalwin),2);
 
 
 
 
 
 
QROC.OR.c_c = allROC.OR.c_c(find(keeper.history.OR_e_e),:);
QROC.OR.e_c = allROC.OR.e_c(find(keeper.history.OR_e_e),:);
QROC.OR.c_e = allROC.OR.c_e(find(keeper.history.OR_e_e),:);
QROC.OR.e_e = allROC.OR.e_e(find(keeper.history.OR_e_e),:);
 
QROC_sub.OR.c_c = allROC_sub.OR.c_c(find(keeper.history.OR_e_e),:);
QROC_sub.OR.e_c = allROC_sub.OR.e_c(find(keeper.history.OR_e_e),:);
QROC_sub.OR.c_e = allROC_sub.OR.c_e(find(keeper.history.OR_e_e),:);
QROC_sub.OR.e_e = allROC_sub.OR.e_e(find(keeper.history.OR_e_e),:);
 
 
 
[max i] = nanmax(nanmean(allROC.OR.c_c(find(keeper.history.OR_e_e),250:400)));
Qccav_maxpos.OR = nanmean(allROC.OR.c_c(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
 
[max i] = nanmax(nanmean(allROC.OR.c_e(find(keeper.history.OR_e_e),250:400)));
Qceav_maxpos.OR = nanmean(allROC.OR.c_e(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
 
[max i] = nanmax(nanmean(allROC.OR.e_c(find(keeper.history.OR_e_e),250:400)));
Qecav_maxpos.OR = nanmean(allROC.OR.e_c(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
 
[max i] = nanmax(nanmean(allROC.OR.e_e(find(keeper.history.OR_e_e),250:400)));
Qeeav_maxpos.OR = nanmean(allROC.OR.e_e(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
 
 
Qccav.OR = nanmean(allROC.OR.c_c(find(keeper.history.OR_e_e),intervalwin),2);
Qceav.OR = nanmean(allROC.OR.c_e(find(keeper.history.OR_e_e),intervalwin),2);
Qecav.OR = nanmean(allROC.OR.e_c(find(keeper.history.OR_e_e),intervalwin),2);
Qeeav.OR = nanmean(allROC.OR.e_e(find(keeper.history.OR_e_e),intervalwin),2);
 
 
 
keep QROC_sub QROC intervalwin win Qccav Qecav Qceav Qeeav Qccav_maxpos Qecav_maxpos Qceav_maxpos Qeeav_maxpos
 
%load Sagg_final
load Sagg_withMets 

keeper.history.neuron_e_e = keeper.reg.neuron;
keeper.history.LFP_e_e = keeper.reg.LFP;
keeper.history.OR_e_e = keeper.reg.OR;

SROC.neuron.c_c = allROC.neuron.c_c(find(keeper.history.neuron_e_e),:);
SROC.neuron.e_c = allROC.neuron.e_c(find(keeper.history.neuron_e_e),:);
SROC.neuron.c_e = allROC.neuron.c_e(find(keeper.history.neuron_e_e),:);
SROC.neuron.e_e = allROC.neuron.e_e(find(keeper.history.neuron_e_e),:);
 
SROC_sub.neuron.c_c = allROC_sub.neuron.c_c(find(keeper.history.neuron_e_e),:);
SROC_sub.neuron.e_c = allROC_sub.neuron.e_c(find(keeper.history.neuron_e_e),:);
SROC_sub.neuron.c_e = allROC_sub.neuron.c_e(find(keeper.history.neuron_e_e),:);
SROC_sub.neuron.e_e = allROC_sub.neuron.e_e(find(keeper.history.neuron_e_e),:);
 
 
 
[max i] = nanmax(nanmean(allROC.neuron.c_c(find(keeper.history.neuron_e_e),:)));
Sccav_maxpos.neuron = nanmean(allROC.neuron.c_c(find(keeper.history.neuron_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.neuron.c_e(find(keeper.history.neuron_e_e),:)));
Sceav_maxpos.neuron = nanmean(allROC.neuron.c_e(find(keeper.history.neuron_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.neuron.e_c(find(keeper.history.neuron_e_e),:)));
Secav_maxpos.neuron = nanmean(allROC.neuron.e_c(find(keeper.history.neuron_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.neuron.e_e(find(keeper.history.neuron_e_e),100:end)));
Seeav_maxpos.neuron = nanmean(allROC.neuron.e_e(find(keeper.history.neuron_e_e),i-win:i+win),2);
 
 
Sccav.neuron = nanmean(allROC.neuron.c_c(find(keeper.history.neuron_e_e),intervalwin),2);
Sceav.neuron = nanmean(allROC.neuron.c_e(find(keeper.history.neuron_e_e),intervalwin),2);
Secav.neuron = nanmean(allROC.neuron.e_c(find(keeper.history.neuron_e_e),intervalwin),2);
Seeav.neuron = nanmean(allROC.neuron.e_e(find(keeper.history.neuron_e_e),intervalwin),2);
 
 
 
 
 
 
 
SROC.LFP.c_c = allROC.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:);
SROC.LFP.e_c = allROC.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:);
SROC.LFP.c_e = allROC.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:);
SROC.LFP.e_e = allROC.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:);
 
SROC_sub.LFP.c_c = allROC_sub.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:);
SROC_sub.LFP.e_c = allROC_sub.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:);
SROC_sub.LFP.c_e = allROC_sub.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:);
SROC_sub.LFP.e_e = allROC_sub.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:);
 
 
[max i] = nanmax(nanmean(allROC.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:)));
Sccav_maxpos.LFP = nanmean(allROC.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:)));
Sceav_maxpos.LFP = nanmean(allROC.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:)));
Secav_maxpos.LFP = nanmean(allROC.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),i-win:i+win),2);
 
[max i] = nanmax(nanmean(allROC.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:)));
Seeav_maxpos.LFP = nanmean(allROC.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),i-win:i+win),2);
 
 
 
Sccav.LFP = nanmean(allROC.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),intervalwin),2);
Sceav.LFP = nanmean(allROC.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),intervalwin),2);
Secav.LFP = nanmean(allROC.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),intervalwin),2);
Seeav.LFP = nanmean(allROC.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),intervalwin),2);
 
 
 
 
SROC.OR.c_c = allROC.OR.c_c(find(keeper.history.OR_e_e),:);
SROC.OR.e_c = allROC.OR.e_c(find(keeper.history.OR_e_e),:);
SROC.OR.c_e = allROC.OR.c_e(find(keeper.history.OR_e_e),:);
SROC.OR.e_e = allROC.OR.e_e(find(keeper.history.OR_e_e),:);
 
SROC_sub.OR.c_c = allROC_sub.OR.c_c(find(keeper.history.OR_e_e),:);
SROC_sub.OR.e_c = allROC_sub.OR.e_c(find(keeper.history.OR_e_e),:);
SROC_sub.OR.c_e = allROC_sub.OR.c_e(find(keeper.history.OR_e_e),:);
SROC_sub.OR.e_e = allROC_sub.OR.e_e(find(keeper.history.OR_e_e),:);
 
 
 
[max i] = nanmax(nanmean(allROC.OR.c_c(find(keeper.history.OR_e_e),250:400)));
Sccav_maxpos.OR = nanmean(allROC.OR.c_c(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
 
[max i] = nanmax(nanmean(allROC.OR.c_e(find(keeper.history.OR_e_e),250:400)));
Sceav_maxpos.OR = nanmean(allROC.OR.c_e(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
 
[max i] = nanmax(nanmean(allROC.OR.e_c(find(keeper.history.OR_e_e),250:400)));
Secav_maxpos.OR = nanmean(allROC.OR.e_c(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
 
[max i] = nanmax(nanmean(allROC.OR.e_e(find(keeper.history.OR_e_e),250:400)));
Seeav_maxpos.OR = nanmean(allROC.OR.e_e(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
 
 
Sccav.OR = nanmean(allROC.OR.c_c(find(keeper.history.OR_e_e),intervalwin),2);
Sceav.OR = nanmean(allROC.OR.c_e(find(keeper.history.OR_e_e),intervalwin),2);
Secav.OR = nanmean(allROC.OR.e_c(find(keeper.history.OR_e_e),intervalwin),2);
Seeav.OR = nanmean(allROC.OR.e_e(find(keeper.history.OR_e_e),intervalwin),2);
 
 
 
 
%C O M B I N E   M O N K S
ROC_cc.neuron = [QROC.neuron.c_c;SROC.neuron.c_c];
ROC_ec.neuron = [QROC.neuron.e_c;SROC.neuron.e_c];
ROC_ce.neuron = [QROC.neuron.c_e;SROC.neuron.c_e];
ROC_ee.neuron = [QROC.neuron.e_e;SROC.neuron.e_e];
 
ROC_cc.LFP = [QROC.LFP.c_c;SROC.LFP.c_c];
ROC_ec.LFP = [QROC.LFP.e_c;SROC.LFP.e_c];
ROC_ce.LFP = [QROC.LFP.c_e;SROC.LFP.c_e];
ROC_ee.LFP = [QROC.LFP.e_e;SROC.LFP.e_e];
 
ROC_cc.OR = [QROC.OR.c_c;SROC.OR.c_c];
ROC_ec.OR = [QROC.OR.e_c;SROC.OR.e_c];
ROC_ce.OR = [QROC.OR.c_e;SROC.OR.c_e];
ROC_ee.OR = [QROC.OR.e_e;SROC.OR.e_e];
 
ROC_cc.neuron = [QROC.neuron.c_c;SROC.neuron.c_c];
ROC_ec.neuron = [QROC.neuron.e_c;SROC.neuron.e_c];
ROC_ce.neuron = [QROC.neuron.c_e;SROC.neuron.c_e];
ROC_ee.neuron = [QROC.neuron.e_e;SROC.neuron.e_e];
 
ROC_cc.LFP = [QROC.LFP.c_c;SROC.LFP.c_c];
ROC_ec.LFP = [QROC.LFP.e_c;SROC.LFP.e_c];
ROC_ce.LFP = [QROC.LFP.c_e;SROC.LFP.c_e];
ROC_ee.LFP = [QROC.LFP.e_e;SROC.LFP.e_e];
 
ROC_cc.OR = [QROC.OR.c_c;SROC.OR.c_c];
ROC_ec.OR = [QROC.OR.e_c;SROC.OR.e_c];
ROC_ce.OR = [QROC.OR.c_e;SROC.OR.c_e];
ROC_ee.OR = [QROC.OR.e_e;SROC.OR.e_e];
 
 
 
ROC_sub_cc.neuron = [QROC_sub.neuron.c_c;SROC_sub.neuron.c_c];
ROC_sub_ec.neuron = [QROC_sub.neuron.e_c;SROC_sub.neuron.e_c];
ROC_sub_ce.neuron = [QROC_sub.neuron.c_e;SROC_sub.neuron.c_e];
ROC_sub_ee.neuron = [QROC_sub.neuron.e_e;SROC_sub.neuron.e_e];
 
ROC_sub_cc.LFP = [QROC_sub.LFP.c_c;SROC_sub.LFP.c_c];
ROC_sub_ec.LFP = [QROC_sub.LFP.e_c;SROC_sub.LFP.e_c];
ROC_sub_ce.LFP = [QROC_sub.LFP.c_e;SROC_sub.LFP.c_e];
ROC_sub_ee.LFP = [QROC_sub.LFP.e_e;SROC_sub.LFP.e_e];
 
ROC_sub_cc.OR = [QROC_sub.OR.c_c;SROC_sub.OR.c_c];
ROC_sub_ec.OR = [QROC_sub.OR.e_c;SROC_sub.OR.e_c];
ROC_sub_ce.OR = [QROC_sub.OR.c_e;SROC_sub.OR.c_e];
ROC_sub_ee.OR = [QROC_sub.OR.e_e;SROC_sub.OR.e_e];
 
 
 
ccav_maxpos.neuron = [Qccav_maxpos.neuron;Sccav_maxpos.neuron];
ecav_maxpos.neuron = [Qecav_maxpos.neuron;Secav_maxpos.neuron];
ceav_maxpos.neuron = [Qceav_maxpos.neuron;Sceav_maxpos.neuron];
eeav_maxpos.neuron = [Qeeav_maxpos.neuron;Seeav_maxpos.neuron];
 
ccav_maxpos.LFP = [Qccav_maxpos.LFP;Sccav_maxpos.LFP];
ecav_maxpos.LFP = [Qecav_maxpos.LFP;Secav_maxpos.LFP];
ceav_maxpos.LFP = [Qceav_maxpos.LFP;Sceav_maxpos.LFP];
eeav_maxpos.LFP = [Qeeav_maxpos.LFP;Seeav_maxpos.LFP];
 
ccav_maxpos.OR = [Qccav_maxpos.OR;Sccav_maxpos.OR];
ecav_maxpos.OR = [Qecav_maxpos.OR;Secav_maxpos.OR];
ceav_maxpos.OR = [Qceav_maxpos.OR;Sceav_maxpos.OR];
eeav_maxpos.OR = [Qeeav_maxpos.OR;Seeav_maxpos.OR];
 
ccav.neuron = [Qccav.neuron;Sccav.neuron];
ecav.neuron = [Qecav.neuron;Secav.neuron];
ceav.neuron = [Qceav.neuron;Sceav.neuron];
eeav.neuron = [Qeeav.neuron;Seeav.neuron];
 
ccav.LFP = [Qccav.LFP;Sccav.LFP];
ecav.LFP = [Qecav.LFP;Secav.LFP];
ceav.LFP = [Qceav.LFP;Sceav.LFP];
eeav.LFP = [Qeeav.LFP;Seeav.LFP];
 
ccav.OR = [Qccav.OR;Sccav.OR];
ecav.OR = [Qecav.OR;Secav.OR];
ceav.OR = [Qceav.OR;Sceav.OR];
eeav.OR = [Qeeav.OR;Seeav.OR];
 
 
beforearray_ccav.neuron = [Qccav.neuron;Sccav.neuron];
beforearray_ecav.neuron = [Qecav.neuron;Secav.neuron];
beforearray_ceav.neuron = [Qceav.neuron;Sceav.neuron];
beforearray_eeav.neuron = [Qeeav.neuron;Seeav.neuron];
 
beforearray_ccav.LFP = [Qccav.LFP;Sccav.LFP];
beforearray_ecav.LFP = [Qecav.LFP;Secav.LFP];
beforearray_ceav.LFP = [Qceav.LFP;Sceav.LFP];
beforearray_eeav.LFP = [Qeeav.LFP;Seeav.LFP];
 
beforearray_ccav.OR = [Qccav.OR;Sccav.OR];
beforearray_ecav.OR = [Qecav.OR;Secav.OR];
beforearray_ceav.OR = [Qceav.OR;Sceav.OR];
beforearray_eeav.OR = [Qeeav.OR;Seeav.OR];
 
 
err_beforearray_ccav.neuron = std(beforearray_ccav.neuron) / sqrt(length(beforearray_ccav.neuron));
err_beforearray_ecav.neuron = std(beforearray_ecav.neuron) / sqrt(length(beforearray_ecav.neuron));
err_beforearray_ceav.neuron = std(beforearray_ceav.neuron) / sqrt(length(beforearray_ceav.neuron));
err_beforearray_eeav.neuron = std(beforearray_eeav.neuron) / sqrt(length(beforearray_eeav.neuron));
 
err_beforearray_ccav.LFP = std(beforearray_ccav.LFP) / sqrt(length(beforearray_ccav.LFP));
err_beforearray_ecav.LFP = std(beforearray_ecav.LFP) / sqrt(length(beforearray_ecav.LFP));
err_beforearray_ceav.LFP = std(beforearray_ceav.LFP) / sqrt(length(beforearray_ceav.LFP));
err_beforearray_eeav.LFP = std(beforearray_eeav.LFP) / sqrt(length(beforearray_eeav.LFP));
 
err_beforearray_ccav.OR = std(beforearray_ccav.OR) / sqrt(length(beforearray_ccav.OR));
err_beforearray_ecav.OR = std(beforearray_ecav.OR) / sqrt(length(beforearray_ecav.OR));
err_beforearray_ceav.OR = std(beforearray_ceav.OR) / sqrt(length(beforearray_ceav.OR));
err_beforearray_eeav.OR = std(beforearray_eeav.OR) / sqrt(length(beforearray_eeav.OR));
% 
%runs on QS_ROC.mat
 
%calculate standard errors
 
%neuron
err.cc.neuron_maxpos = std(ccav_maxpos.neuron) / sqrt(length(ccav_maxpos.neuron));
err.ce.neuron_maxpos = std(ceav_maxpos.neuron) / sqrt(length(ceav_maxpos.neuron));
err.ec.neuron_maxpos = std(ecav_maxpos.neuron) / sqrt(length(ecav_maxpos.neuron));
err.ee.neuron_maxpos = std(eeav_maxpos.neuron) / sqrt(length(eeav_maxpos.neuron));
 
Serr.cc.neuron_maxpos = std(Sccav_maxpos.neuron) / sqrt(length(Sccav_maxpos.neuron));
Serr.ce.neuron_maxpos = std(Sceav_maxpos.neuron) / sqrt(length(Sceav_maxpos.neuron));
Serr.ec.neuron_maxpos = std(Secav_maxpos.neuron) / sqrt(length(Secav_maxpos.neuron));
Serr.ee.neuron_maxpos = std(Seeav_maxpos.neuron) / sqrt(length(Seeav_maxpos.neuron));
 
Qerr.cc.neuron_maxpos = std(Qccav_maxpos.neuron) / sqrt(length(Qccav_maxpos.neuron));
Qerr.ce.neuron_maxpos = std(Qceav_maxpos.neuron) / sqrt(length(Qceav_maxpos.neuron));
Qerr.ec.neuron_maxpos = std(Qecav_maxpos.neuron) / sqrt(length(Qecav_maxpos.neuron));
Qerr.ee.neuron_maxpos = std(Qeeav_maxpos.neuron) / sqrt(length(Qeeav_maxpos.neuron));
 
err.cc.neuron = std(ccav.neuron) / sqrt(length(ccav.neuron));
err.ce.neuron = std(ceav.neuron) / sqrt(length(ceav.neuron));
err.ec.neuron = std(ecav.neuron) / sqrt(length(ecav.neuron));
err.ee.neuron = std(eeav.neuron) / sqrt(length(eeav.neuron));
 
Serr.cc.neuron = std(Sccav.neuron) / sqrt(length(Sccav.neuron));
Serr.ce.neuron = std(Sceav.neuron) / sqrt(length(Sceav.neuron));
Serr.ec.neuron = std(Secav.neuron) / sqrt(length(Secav.neuron));
Serr.ee.neuron = std(Seeav.neuron) / sqrt(length(Seeav.neuron));
 
Qerr.cc.neuron = std(Qccav.neuron) / sqrt(length(Qccav.neuron));
Qerr.ce.neuron = std(Qceav.neuron) / sqrt(length(Qceav.neuron));
Qerr.ec.neuron = std(Qecav.neuron) / sqrt(length(Qecav.neuron));
Qerr.ee.neuron = std(Qeeav.neuron) / sqrt(length(Qeeav.neuron));
 
 
%LFP
 
 
err.cc.LFP_maxpos = std(ccav_maxpos.LFP) / sqrt(length(ccav_maxpos.LFP));
err.ce.LFP_maxpos = std(ceav_maxpos.LFP) / sqrt(length(ceav_maxpos.LFP));
err.ec.LFP_maxpos = std(ecav_maxpos.LFP) / sqrt(length(ecav_maxpos.LFP));
err.ee.LFP_maxpos = std(eeav_maxpos.LFP) / sqrt(length(eeav_maxpos.LFP));
 
Serr.cc.LFP_maxpos = std(Sccav_maxpos.LFP) / sqrt(length(Sccav_maxpos.LFP));
Serr.ce.LFP_maxpos = std(Sceav_maxpos.LFP) / sqrt(length(Sceav_maxpos.LFP));
Serr.ec.LFP_maxpos = std(Secav_maxpos.LFP) / sqrt(length(Secav_maxpos.LFP));
Serr.ee.LFP_maxpos = std(Seeav_maxpos.LFP) / sqrt(length(Seeav_maxpos.LFP));
 
Qerr.cc.LFP_maxpos = std(Qccav_maxpos.LFP) / sqrt(length(Qccav_maxpos.LFP));
Qerr.ce.LFP_maxpos = std(Qceav_maxpos.LFP) / sqrt(length(Qceav_maxpos.LFP));
Qerr.ec.LFP_maxpos = std(Qecav_maxpos.LFP) / sqrt(length(Qecav_maxpos.LFP));
Qerr.ee.LFP_maxpos = std(Qeeav_maxpos.LFP) / sqrt(length(Qeeav_maxpos.LFP));
 
err.cc.LFP = std(ccav.LFP) / sqrt(length(ccav.LFP));
err.ce.LFP = std(ceav.LFP) / sqrt(length(ceav.LFP));
err.ec.LFP = std(ecav.LFP) / sqrt(length(ecav.LFP));
err.ee.LFP = std(eeav.LFP) / sqrt(length(eeav.LFP));
 
Serr.cc.LFP = std(Sccav.LFP) / sqrt(length(Sccav.LFP));
Serr.ce.LFP = std(Sceav.LFP) / sqrt(length(Sceav.LFP));
Serr.ec.LFP = std(Secav.LFP) / sqrt(length(Secav.LFP));
Serr.ee.LFP = std(Seeav.LFP) / sqrt(length(Seeav.LFP));
 
Qerr.cc.LFP = std(Qccav.LFP) / sqrt(length(Qccav.LFP));
Qerr.ce.LFP = std(Qceav.LFP) / sqrt(length(Qceav.LFP));
Qerr.ec.LFP = std(Qecav.LFP) / sqrt(length(Qecav.LFP));
Qerr.ee.LFP = std(Qeeav.LFP) / sqrt(length(Qeeav.LFP));
 
 
%OR
err.cc.OR = std(ccav_maxpos.OR) / sqrt(length(ccav_maxpos.OR));
err.ce.OR = std(ceav_maxpos.OR) / sqrt(length(ceav_maxpos.OR));
err.ec.OR = std(ecav_maxpos.OR) / sqrt(length(ecav_maxpos.OR));
err.ee.OR = std(removeNaN(eeav_maxpos.OR)) / sqrt(length(removeNaN(eeav_maxpos.OR)));
 
Serr.cc.OR = std(Sccav_maxpos.OR) / sqrt(length(Sccav_maxpos.OR));
Serr.ce.OR = std(Sceav_maxpos.OR) / sqrt(length(Sceav_maxpos.OR));
Serr.ec.OR = std(Secav_maxpos.OR) / sqrt(length(Secav_maxpos.OR));
Serr.ee.OR = std(Seeav_maxpos.OR) / sqrt(length(Seeav_maxpos.OR));
 
Qerr.cc.OR = std(Qccav_maxpos.OR) / sqrt(length(Qccav_maxpos.OR));
Qerr.ce.OR = std(Qceav_maxpos.OR) / sqrt(length(Qceav_maxpos.OR));
Qerr.ec.OR = std(Qecav_maxpos.OR) / sqrt(length(Qecav_maxpos.OR));
Qerr.ee.OR = std(removeNaN(Qeeav_maxpos.OR)) / sqrt(length(removeNaN(Qeeav_maxpos.OR)));
 
 
 
%Seymour
% 
% figure
% fw
% hold on
% bar(1:4,[nanmean(Sccav_maxpos.neuron) nanmean(Secav_maxpos.neuron) nanmean(Sceav_maxpos.neuron) nanmean(Seeav_maxpos.neuron)],'r')
% bar(1:4,[nanmean(Sccav_maxpos.LFP) nanmean(Secav_maxpos.LFP) nanmean(Sceav_maxpos.LFP) nanmean(Seeav_maxpos.LFP)],'b')
% bar(1:4,[nanmean(Sccav_maxpos.OR) nanmean(Secav_maxpos.OR) nanmean(Sceav_maxpos.OR) nanmean(Seeav_maxpos.OR)],'g')
% 
% errorbar(1:4,[nanmean(Sccav_maxpos.neuron) nanmean(Secav_maxpos.neuron) nanmean(Sceav_maxpos.neuron) nanmean(Seeav_maxpos.neuron)],[Serr.cc.neuron Serr.ec.neuron Serr.ce.neuron Serr.ee.neuron],'xr')
% errorbar(1:4,[nanmean(Sccav_maxpos.LFP) nanmean(Secav_maxpos.LFP) nanmean(Sceav_maxpos.LFP) nanmean(Seeav_maxpos.LFP)],[Serr.cc.LFP Serr.ec.LFP Serr.ce.LFP Serr.ee.LFP],'xb')
% errorbar(1:4,[nanmean(Sccav_maxpos.OR) nanmean(Secav_maxpos.OR) nanmean(Sceav_maxpos.OR) nanmean(Seeav_maxpos.OR)],[Serr.cc.OR Serr.ec.OR Serr.ce.OR Serr.ee.OR],'xg')
% 
% ylim([.49 .75])
% title('Seymour')
% 
% 
% %Quincy
% figure
% fw
% hold on
% bar(1:4,[nanmean(Qccav_maxpos.neuron) nanmean(Qecav_maxpos.neuron) nanmean(Qceav_maxpos.neuron) nanmean(Qeeav_maxpos.neuron)],'r')
% bar(1:4,[nanmean(Qccav_maxpos.LFP) nanmean(Qecav_maxpos.LFP) nanmean(Qceav_maxpos.LFP) nanmean(Qeeav_maxpos.LFP)],'b')
% bar(1:4,[nanmean(Qccav_maxpos.OR) nanmean(Qecav_maxpos.OR) nanmean(Qceav_maxpos.OR) nanmean(Qeeav_maxpos.OR)],'g')
%  
% errorbar(1:4,[nanmean(Qccav_maxpos.neuron) nanmean(Qecav_maxpos.neuron) nanmean(Qceav_maxpos.neuron) nanmean(Qeeav_maxpos.neuron)],[Qerr.cc.neuron Qerr.ec.neuron Qerr.ce.neuron Qerr.ee.neuron],'xr')
% errorbar(1:4,[nanmean(Qccav_maxpos.LFP) nanmean(Qecav_maxpos.LFP) nanmean(Qceav_maxpos.LFP) nanmean(Qeeav_maxpos.LFP)],[Qerr.cc.LFP Qerr.ec.LFP Qerr.ce.LFP Qerr.ee.LFP],'xb')
% errorbar(1:4,[nanmean(Qccav_maxpos.OR) nanmean(Qecav_maxpos.OR) nanmean(Qceav_maxpos.OR) nanmean(Qeeav_maxpos.OR)],[Qerr.cc.OR Qerr.ec.OR Qerr.ce.OR Qerr.ee.OR],'xg')
%  
% ylim([.48 .75])
% title('Quincy')
 
 
%combined - maxPos average
figure
fw
hold on
bar(1:4,[nanmean(ccav_maxpos.neuron) nanmean(ecav_maxpos.neuron) nanmean(ceav_maxpos.neuron) nanmean(eeav_maxpos.neuron)],'r')
bar(1:4,[nanmean(ccav_maxpos.LFP) nanmean(ecav_maxpos.LFP) nanmean(ceav_maxpos.LFP) nanmean(eeav_maxpos.LFP)],'b')
bar(1:4,[nanmean(ccav_maxpos.OR) nanmean(ecav_maxpos.OR) nanmean(ceav_maxpos.OR) nanmean(eeav_maxpos.OR)],'g')
 
errorbar(1:4,[nanmean(ccav_maxpos.neuron) nanmean(ecav_maxpos.neuron) nanmean(ceav_maxpos.neuron) nanmean(eeav_maxpos.neuron)],[err.cc.neuron err.ec.neuron err.ce.neuron err.ee.neuron],'xr')
errorbar(1:4,[nanmean(ccav_maxpos.LFP) nanmean(ecav_maxpos.LFP) nanmean(ceav_maxpos.LFP) nanmean(eeav_maxpos.LFP)],[err.cc.LFP err.ec.LFP err.ce.LFP err.ee.LFP],'xb')
errorbar(1:4,[nanmean(ccav_maxpos.OR) nanmean(ecav_maxpos.OR) nanmean(ceav_maxpos.OR) nanmean(eeav_maxpos.OR)],[err.cc.OR err.ec.OR err.ce.OR err.ee.OR],'xg')
 
ylim([.49 .75])
title('Combined MaxPos Average')
 
 
% %combined - interval average
figure
fw
hold on
 
bar(1:4,[nanmean(ccav.neuron) nanmean(ecav.neuron) nanmean(ceav.neuron) nanmean(eeav.neuron)],'r')
bar(1:4,[nanmean(ccav.LFP) nanmean(ecav.LFP) nanmean(ceav.LFP) nanmean(eeav.LFP)],'b')
bar(1:4,[nanmean(ccav.OR) nanmean(ecav.OR) nanmean(ceav.OR) nanmean(eeav.OR)],'g')
 
errorbar(1:4,[nanmean(ccav.neuron) nanmean(ecav.neuron) nanmean(ceav.neuron) nanmean(eeav.neuron)],[err.cc.neuron err.ec.neuron err.ce.neuron err.ee.neuron],'xr')
errorbar(1:4,[nanmean(ccav.LFP) nanmean(ecav.LFP) nanmean(ceav.LFP) nanmean(eeav.LFP)],[err.cc.LFP err.ec.LFP err.ce.LFP err.ee.LFP],'xb')
errorbar(1:4,[nanmean(ccav.OR) nanmean(ecav.OR) nanmean(ceav.OR) nanmean(eeav.OR)],[err.cc.OR err.ec.OR err.ce.OR err.ee.OR],'xg')
 
ylim([.49 .75])
title('Combined Interval Average')
 
 
 
%neuron t-tests
% [a b] = ttest(ccav_maxpos.neuron,ceav_maxpos.neuron)
[a b] = ttest(ceav_maxpos.neuron,eeav_maxpos.neuron)
 
%LFP t-tests
% [a b] = ttest(ccav_maxpos.LFP,ceav_maxpos.LFP)
[a b] = ttest(ceav_maxpos.LFP,eeav_maxpos.LFP)
 
%OR t-tests
% [a b] = ttest(ccav_maxpos.OR,ceav_maxpos.OR)
[a b] = ttest(ceav_maxpos.OR,eeav_maxpos.OR)
 
 
% %neuron t-tests
% % [a b] = ttest(ccav_maxpos.neuron,ceav_maxpos.neuron)
% [a b] = ttest(ceav.neuron,eeav.neuron)
% 
% %LFP t-tests
% % [a b] = ttest(ccav_maxpos.LFP,ceav_maxpos.LFP)
% [a b] = ttest(ceav.LFP,eeav.LFP)
% 
% %OR t-tests
% % [a b] = ttest(ccav_maxpos.OR,ceav_maxpos.OR)
% [a b] = ttest(ceav.OR,eeav.OR)
 
 
figure
fw
subplot(2,3,1)
plot(-100:500,nanmean(ROC_cc.neuron),'k',-100:500,nanmean(ROC_ec.neuron),'b',-100:500,nanmean(ROC_ce.neuron),'r',-100:500,nanmean(ROC_ee.neuron),'g')
xlim([-100 500])
title('Neuron')
 
subplot(2,3,2)
plot(-100:500,nanmean(ROC_cc.LFP),'k',-100:500,nanmean(ROC_ec.LFP),'b',-100:500,nanmean(ROC_ce.LFP),'r',-100:500,nanmean(ROC_ee.LFP),'g')
xlim([-100 500])
title('LFP')
 
subplot(2,3,3)
plot(-100:500,nanmean(ROC_cc.OR),'k',-100:500,nanmean(ROC_ec.OR),'b',-100:500,nanmean(ROC_ce.OR),'r',-100:500,nanmean(ROC_ee.OR),'g')
xlim([-100 500])
title('OR')
 
subplot(2,3,4)
plot(-100:500,nanmean(ROC_sub_cc.neuron),'k',-100:500,nanmean(ROC_sub_ec.neuron),'b',-100:500,nanmean(ROC_sub_ce.neuron),'r',-100:500,nanmean(ROC_sub_ee.neuron),'g')
xlim([-100 500])
title('Neuron')
 
subplot(2,3,5)
plot(-500:2500,nanmean(ROC_sub_cc.LFP),'k',-500:2500,nanmean(ROC_sub_ec.LFP),'b',-500:2500,nanmean(ROC_sub_ce.LFP),'r',-500:2500,nanmean(ROC_sub_ee.LFP),'g')
xlim([-100 500])
title('LFP')
 
subplot(2,3,6)
plot(-500:2500,nanmean(ROC_sub_cc.OR),'k',-500:2500,nanmean(ROC_sub_ec.OR),'b',-500:2500,nanmean(ROC_sub_ce.OR),'r',-500:2500,nanmean(ROC_sub_ee.OR),'g')
xlim([-100 500])
title('OR')
 





% %combines ROC averages across monkeys
% clear all
% 
% cd /Volumes/Dump/Analyses/Errors/Uber_5runs_.05_FINAL/
% load Qagg_final
% 
% win = 50;
% intervalwin = 250:400;
% 
% QROC.neuron.c_c = allROC_avg.neuron.c_c(find(keeper.history.neuron_e_e),:);
% QROC.neuron.e_c = allROC_avg.neuron.e_c(find(keeper.history.neuron_e_e),:);
% QROC.neuron.c_e = allROC_avg.neuron.c_e(find(keeper.history.neuron_e_e),:);
% QROC.neuron.e_e = allROC_avg.neuron.e_e(find(keeper.history.neuron_e_e),:);
% 
% QROC_sub.neuron.c_c = allROC_sub_avg.neuron.c_c(find(keeper.history.neuron_e_e),:);
% QROC_sub.neuron.e_c = allROC_sub_avg.neuron.e_c(find(keeper.history.neuron_e_e),:);
% QROC_sub.neuron.c_e = allROC_sub_avg.neuron.c_e(find(keeper.history.neuron_e_e),:);
% QROC_sub.neuron.e_e = allROC_sub_avg.neuron.e_e(find(keeper.history.neuron_e_e),:);
% 
% [max i] = nanmax(nanmean(allROC_avg.neuron.c_c(find(keeper.history.neuron_e_e),:)));
% Qccav_maxpos.neuron = nanmean(allROC_avg.neuron.c_c(find(keeper.history.neuron_e_e),i-win:i+win),2);
% 
% [max i] = nanmax(nanmean(allROC_avg.neuron.c_e(find(keeper.history.neuron_e_e),:)));
% Qceav_maxpos.neuron = nanmean(allROC_avg.neuron.c_e(find(keeper.history.neuron_e_e),i-win:i+win),2);
% 
% [max i] = nanmax(nanmean(allROC_avg.neuron.e_c(find(keeper.history.neuron_e_e),:)));
% Qecav_maxpos.neuron = nanmean(allROC_avg.neuron.e_c(find(keeper.history.neuron_e_e),i-win:i+win),2);
% 
% [max i] = nanmax(nanmean(allROC_avg.neuron.e_e(find(keeper.history.neuron_e_e),:)));
% Qeeav_maxpos.neuron = nanmean(allROC_avg.neuron.e_e(find(keeper.history.neuron_e_e),i-win:i+win),2);
% 
% 
% Qccav.neuron = nanmean(allROC_avg.neuron.c_c(find(keeper.history.neuron_e_e),intervalwin),2);
% Qceav.neuron = nanmean(allROC_avg.neuron.c_e(find(keeper.history.neuron_e_e),intervalwin),2);
% Qecav.neuron = nanmean(allROC_avg.neuron.e_c(find(keeper.history.neuron_e_e),intervalwin),2);
% Qeeav.neuron = nanmean(allROC_avg.neuron.e_e(find(keeper.history.neuron_e_e),intervalwin),2);
% 
% 
% 
% 
% 
% QROC.LFP.c_c = allROC_avg.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:);
% QROC.LFP.e_c = allROC_avg.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:);
% QROC.LFP.c_e = allROC_avg.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:);
% QROC.LFP.e_e = allROC_avg.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:);
% 
% QROC_sub.LFP.c_c = allROC_sub_avg.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:);
% QROC_sub.LFP.e_c = allROC_sub_avg.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:);
% QROC_sub.LFP.c_e = allROC_sub_avg.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:);
% QROC_sub.LFP.e_e = allROC_sub_avg.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:);
% 
% 
% 
% [max i] = nanmax(nanmean(allROC.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:)));
% Qccav_maxpos.LFP = nanmean(allROC.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),i-win:i+win),2);
% 
% [max i] = nanmax(nanmean(allROC.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:)));
% Qceav_maxpos.LFP = nanmean(allROC.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),i-win:i+win),2);
% 
% [max i] = nanmax(nanmean(allROC.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:)));
% Qecav_maxpos.LFP = nanmean(allROC.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),i-win:i+win),2);
% 
% [max i] = nanmax(nanmean(allROC.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:)));
% Qeeav_maxpos.LFP = nanmean(allROC.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),i-win:i+win),2);
% 
% 
% Qccav.LFP = nanmean(allROC_avg.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),intervalwin),2);
% Qceav.LFP = nanmean(allROC_avg.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),intervalwin),2);
% Qecav.LFP = nanmean(allROC_avg.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),intervalwin),2);
% Qeeav.LFP = nanmean(allROC_avg.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),intervalwin),2);
% 
% 
% 
% 
% 
% 
% QROC.OR.c_c = allROC_avg.OR.c_c(find(keeper.history.OR_e_e),:);
% QROC.OR.e_c = allROC_avg.OR.e_c(find(keeper.history.OR_e_e),:);
% QROC.OR.c_e = allROC_avg.OR.c_e(find(keeper.history.OR_e_e),:);
% QROC.OR.e_e = allROC_avg.OR.e_e(find(keeper.history.OR_e_e),:);
% 
% QROC_sub.OR.c_c = allROC_sub_avg.OR.c_c(find(keeper.history.OR_e_e),:);
% QROC_sub.OR.e_c = allROC_sub_avg.OR.e_c(find(keeper.history.OR_e_e),:);
% QROC_sub.OR.c_e = allROC_sub_avg.OR.c_e(find(keeper.history.OR_e_e),:);
% QROC_sub.OR.e_e = allROC_sub_avg.OR.e_e(find(keeper.history.OR_e_e),:);
% 
% 
% 
% [max i] = nanmax(nanmean(allROC_avg.OR.c_c(find(keeper.history.OR_e_e),250:400)));
% Qccav_maxpos.OR = nanmean(allROC_avg.OR.c_c(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
% 
% [max i] = nanmax(nanmean(allROC_avg.OR.c_e(find(keeper.history.OR_e_e),250:400)));
% Qceav_maxpos.OR = nanmean(allROC_avg.OR.c_e(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
% 
% [max i] = nanmax(nanmean(allROC_avg.OR.e_c(find(keeper.history.OR_e_e),250:400)));
% Qecav_maxpos.OR = nanmean(allROC_avg.OR.e_c(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
% 
% [max i] = nanmax(nanmean(allROC_avg.OR.e_e(find(keeper.history.OR_e_e),250:400)));
% Qeeav_maxpos.OR = nanmean(allROC_avg.OR.e_e(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
% 
% 
% Qccav.OR = nanmean(allROC_avg.OR.c_c(find(keeper.history.OR_e_e),intervalwin),2);
% Qceav.OR = nanmean(allROC_avg.OR.c_e(find(keeper.history.OR_e_e),intervalwin),2);
% Qecav.OR = nanmean(allROC_avg.OR.e_c(find(keeper.history.OR_e_e),intervalwin),2);
% Qeeav.OR = nanmean(allROC_avg.OR.e_e(find(keeper.history.OR_e_e),intervalwin),2);
% 
% 
% 
% keep QROC_sub QROC intervalwin win Qccav Qecav Qceav Qeeav Qccav_maxpos Qecav_maxpos Qceav_maxpos Qeeav_maxpos
% 
% load Sagg_final
% 
% SROC.neuron.c_c = allROC_avg.neuron.c_c(find(keeper.history.neuron_e_e),:);
% SROC.neuron.e_c = allROC_avg.neuron.e_c(find(keeper.history.neuron_e_e),:);
% SROC.neuron.c_e = allROC_avg.neuron.c_e(find(keeper.history.neuron_e_e),:);
% SROC.neuron.e_e = allROC_avg.neuron.e_e(find(keeper.history.neuron_e_e),:);
% 
% SROC_sub.neuron.c_c = allROC_sub_avg.neuron.c_c(find(keeper.history.neuron_e_e),:);
% SROC_sub.neuron.e_c = allROC_sub_avg.neuron.e_c(find(keeper.history.neuron_e_e),:);
% SROC_sub.neuron.c_e = allROC_sub_avg.neuron.c_e(find(keeper.history.neuron_e_e),:);
% SROC_sub.neuron.e_e = allROC_sub_avg.neuron.e_e(find(keeper.history.neuron_e_e),:);
% 
% 
% 
% [max i] = nanmax(nanmean(allROC_avg.neuron.c_c(find(keeper.history.neuron_e_e),:)));
% Sccav_maxpos.neuron = nanmean(allROC_avg.neuron.c_c(find(keeper.history.neuron_e_e),i-win:i+win),2);
%  
% [max i] = nanmax(nanmean(allROC_avg.neuron.c_e(find(keeper.history.neuron_e_e),:)));
% Sceav_maxpos.neuron = nanmean(allROC_avg.neuron.c_e(find(keeper.history.neuron_e_e),i-win:i+win),2);
%  
% [max i] = nanmax(nanmean(allROC_avg.neuron.e_c(find(keeper.history.neuron_e_e),:)));
% Secav_maxpos.neuron = nanmean(allROC_avg.neuron.e_c(find(keeper.history.neuron_e_e),i-win:i+win),2);
%  
% [max i] = nanmax(nanmean(allROC_avg.neuron.e_e(find(keeper.history.neuron_e_e),:)));
% Seeav_maxpos.neuron = nanmean(allROC_avg.neuron.e_e(find(keeper.history.neuron_e_e),i-win:i+win),2);
%  
%  
% Sccav.neuron = nanmean(allROC_avg.neuron.c_c(find(keeper.history.neuron_e_e),intervalwin),2);
% Sceav.neuron = nanmean(allROC_avg.neuron.c_e(find(keeper.history.neuron_e_e),intervalwin),2);
% Secav.neuron = nanmean(allROC_avg.neuron.e_c(find(keeper.history.neuron_e_e),intervalwin),2);
% Seeav.neuron = nanmean(allROC_avg.neuron.e_e(find(keeper.history.neuron_e_e),intervalwin),2);
%  
%  
% 
% 
% 
% 
% 
% SROC.LFP.c_c = allROC_avg.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:);
% SROC.LFP.e_c = allROC_avg.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:);
% SROC.LFP.c_e = allROC_avg.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:);
% SROC.LFP.e_e = allROC_avg.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:);
% 
% SROC_sub.LFP.c_c = allROC_sub_avg.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:);
% SROC_sub.LFP.e_c = allROC_sub_avg.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:);
% SROC_sub.LFP.c_e = allROC_sub_avg.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:);
% SROC_sub.LFP.e_e = allROC_sub_avg.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:);
% 
% 
% [max i] = nanmax(nanmean(allROC_avg.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),:)));
% Sccav_maxpos.LFP = nanmean(allROC_avg.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),i-win:i+win),2);
%  
% [max i] = nanmax(nanmean(allROC_avg.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),:)));
% Sceav_maxpos.LFP = nanmean(allROC_avg.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),i-win:i+win),2);
%  
% [max i] = nanmax(nanmean(allROC_avg.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),:)));
% Secav_maxpos.LFP = nanmean(allROC_avg.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),i-win:i+win),2);
%  
% [max i] = nanmax(nanmean(allROC_avg.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),:)));
% Seeav_maxpos.LFP = nanmean(allROC_avg.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),i-win:i+win),2);
% 
% 
% 
% Sccav.LFP = nanmean(allROC_avg.LFP.Hemi.c_c(find(keeper.history.LFP_e_e),intervalwin),2);
% Sceav.LFP = nanmean(allROC_avg.LFP.Hemi.c_e(find(keeper.history.LFP_e_e),intervalwin),2);
% Secav.LFP = nanmean(allROC_avg.LFP.Hemi.e_c(find(keeper.history.LFP_e_e),intervalwin),2);
% Seeav.LFP = nanmean(allROC_avg.LFP.Hemi.e_e(find(keeper.history.LFP_e_e),intervalwin),2);
%  
%  
% 
% 
% SROC.OR.c_c = allROC_avg.OR.c_c(find(keeper.history.OR_e_e),:);
% SROC.OR.e_c = allROC_avg.OR.e_c(find(keeper.history.OR_e_e),:);
% SROC.OR.c_e = allROC_avg.OR.c_e(find(keeper.history.OR_e_e),:);
% SROC.OR.e_e = allROC_avg.OR.e_e(find(keeper.history.OR_e_e),:);
% 
% SROC_sub.OR.c_c = allROC_sub_avg.OR.c_c(find(keeper.history.OR_e_e),:);
% SROC_sub.OR.e_c = allROC_sub_avg.OR.e_c(find(keeper.history.OR_e_e),:);
% SROC_sub.OR.c_e = allROC_sub_avg.OR.c_e(find(keeper.history.OR_e_e),:);
% SROC_sub.OR.e_e = allROC_sub_avg.OR.e_e(find(keeper.history.OR_e_e),:);
% 
% 
% 
% [max i] = nanmax(nanmean(allROC_avg.OR.c_c(find(keeper.history.OR_e_e),250:400)));
% Sccav_maxpos.OR = nanmean(allROC_avg.OR.c_c(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
%  
% [max i] = nanmax(nanmean(allROC_avg.OR.c_e(find(keeper.history.OR_e_e),250:400)));
% Sceav_maxpos.OR = nanmean(allROC_avg.OR.c_e(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
%  
% [max i] = nanmax(nanmean(allROC_avg.OR.e_c(find(keeper.history.OR_e_e),250:400)));
% Secav_maxpos.OR = nanmean(allROC_avg.OR.e_c(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
%  
% [max i] = nanmax(nanmean(allROC_avg.OR.e_e(find(keeper.history.OR_e_e),250:400)));
% Seeav_maxpos.OR = nanmean(allROC_avg.OR.e_e(find(keeper.history.OR_e_e),i+250-win:i+250+win),2);
% 
% 
% Sccav.OR = nanmean(allROC_avg.OR.c_c(find(keeper.history.OR_e_e),intervalwin),2);
% Sceav.OR = nanmean(allROC_avg.OR.c_e(find(keeper.history.OR_e_e),intervalwin),2);
% Secav.OR = nanmean(allROC_avg.OR.e_c(find(keeper.history.OR_e_e),intervalwin),2);
% Seeav.OR = nanmean(allROC_avg.OR.e_e(find(keeper.history.OR_e_e),intervalwin),2);
% 
% 
% 
% 
% %C O M B I N E   M O N K S
% ROC_cc.neuron = [QROC.neuron.c_c;SROC.neuron.c_c];
% ROC_ec.neuron = [QROC.neuron.e_c;SROC.neuron.e_c];
% ROC_ce.neuron = [QROC.neuron.c_e;SROC.neuron.c_e];
% ROC_ee.neuron = [QROC.neuron.e_e;SROC.neuron.e_e];
% 
% ROC_cc.LFP = [QROC.LFP.c_c;SROC.LFP.c_c];
% ROC_ec.LFP = [QROC.LFP.e_c;SROC.LFP.e_c];
% ROC_ce.LFP = [QROC.LFP.c_e;SROC.LFP.c_e];
% ROC_ee.LFP = [QROC.LFP.e_e;SROC.LFP.e_e];
% 
% ROC_cc.OR = [QROC.OR.c_c;SROC.OR.c_c];
% ROC_ec.OR = [QROC.OR.e_c;SROC.OR.e_c];
% ROC_ce.OR = [QROC.OR.c_e;SROC.OR.c_e];
% ROC_ee.OR = [QROC.OR.e_e;SROC.OR.e_e];
% 
% ROC_cc.neuron = [QROC.neuron.c_c;SROC.neuron.c_c];
% ROC_ec.neuron = [QROC.neuron.e_c;SROC.neuron.e_c];
% ROC_ce.neuron = [QROC.neuron.c_e;SROC.neuron.c_e];
% ROC_ee.neuron = [QROC.neuron.e_e;SROC.neuron.e_e];
% 
% ROC_cc.LFP = [QROC.LFP.c_c;SROC.LFP.c_c];
% ROC_ec.LFP = [QROC.LFP.e_c;SROC.LFP.e_c];
% ROC_ce.LFP = [QROC.LFP.c_e;SROC.LFP.c_e];
% ROC_ee.LFP = [QROC.LFP.e_e;SROC.LFP.e_e];
% 
% ROC_cc.OR = [QROC.OR.c_c;SROC.OR.c_c];
% ROC_ec.OR = [QROC.OR.e_c;SROC.OR.e_c];
% ROC_ce.OR = [QROC.OR.c_e;SROC.OR.c_e];
% ROC_ee.OR = [QROC.OR.e_e;SROC.OR.e_e];
% 
% 
%  
% ROC_sub_cc.neuron = [QROC_sub.neuron.c_c;SROC_sub.neuron.c_c];
% ROC_sub_ec.neuron = [QROC_sub.neuron.e_c;SROC_sub.neuron.e_c];
% ROC_sub_ce.neuron = [QROC_sub.neuron.c_e;SROC_sub.neuron.c_e];
% ROC_sub_ee.neuron = [QROC_sub.neuron.e_e;SROC_sub.neuron.e_e];
%  
% ROC_sub_cc.LFP = [QROC_sub.LFP.c_c;SROC_sub.LFP.c_c];
% ROC_sub_ec.LFP = [QROC_sub.LFP.e_c;SROC_sub.LFP.e_c];
% ROC_sub_ce.LFP = [QROC_sub.LFP.c_e;SROC_sub.LFP.c_e];
% ROC_sub_ee.LFP = [QROC_sub.LFP.e_e;SROC_sub.LFP.e_e];
%  
% ROC_sub_cc.OR = [QROC_sub.OR.c_c;SROC_sub.OR.c_c];
% ROC_sub_ec.OR = [QROC_sub.OR.e_c;SROC_sub.OR.e_c];
% ROC_sub_ce.OR = [QROC_sub.OR.c_e;SROC_sub.OR.c_e];
% ROC_sub_ee.OR = [QROC_sub.OR.e_e;SROC_sub.OR.e_e];
% 
% 
% 
% ccav_maxpos.neuron = [Qccav_maxpos.neuron;Sccav_maxpos.neuron];
% ecav_maxpos.neuron = [Qecav_maxpos.neuron;Secav_maxpos.neuron];
% ceav_maxpos.neuron = [Qceav_maxpos.neuron;Sceav_maxpos.neuron];
% eeav_maxpos.neuron = [Qeeav_maxpos.neuron;Seeav_maxpos.neuron];
% 
% ccav_maxpos.LFP = [Qccav_maxpos.LFP;Sccav_maxpos.LFP];
% ecav_maxpos.LFP = [Qecav_maxpos.LFP;Secav_maxpos.LFP];
% ceav_maxpos.LFP = [Qceav_maxpos.LFP;Sceav_maxpos.LFP];
% eeav_maxpos.LFP = [Qeeav_maxpos.LFP;Seeav_maxpos.LFP];
% 
% ccav_maxpos.OR = [Qccav_maxpos.OR;Sccav_maxpos.OR];
% ecav_maxpos.OR = [Qecav_maxpos.OR;Secav_maxpos.OR];
% ceav_maxpos.OR = [Qceav_maxpos.OR;Sceav_maxpos.OR];
% eeav_maxpos.OR = [Qeeav_maxpos.OR;Seeav_maxpos.OR];
% 
% ccav.neuron = [Qccav.neuron;Sccav.neuron];
% ecav.neuron = [Qecav.neuron;Secav.neuron];
% ceav.neuron = [Qceav.neuron;Sceav.neuron];
% eeav.neuron = [Qeeav.neuron;Seeav.neuron];
%  
% ccav.LFP = [Qccav.LFP;Sccav.LFP];
% ecav.LFP = [Qecav.LFP;Secav.LFP];
% ceav.LFP = [Qceav.LFP;Sceav.LFP];
% eeav.LFP = [Qeeav.LFP;Seeav.LFP];
%  
% ccav.OR = [Qccav.OR;Sccav.OR];
% ecav.OR = [Qecav.OR;Secav.OR];
% ceav.OR = [Qceav.OR;Sceav.OR];
% eeav.OR = [Qeeav.OR;Seeav.OR];
% 
% 
% beforearray_ccav.neuron = [Qccav.neuron;Sccav.neuron];
% beforearray_ecav.neuron = [Qecav.neuron;Secav.neuron];
% beforearray_ceav.neuron = [Qceav.neuron;Sceav.neuron];
% beforearray_eeav.neuron = [Qeeav.neuron;Seeav.neuron];
% 
% beforearray_ccav.LFP = [Qccav.LFP;Sccav.LFP];
% beforearray_ecav.LFP = [Qecav.LFP;Secav.LFP];
% beforearray_ceav.LFP = [Qceav.LFP;Sceav.LFP];
% beforearray_eeav.LFP = [Qeeav.LFP;Seeav.LFP];
% 
% beforearray_ccav.OR = [Qccav.OR;Sccav.OR];
% beforearray_ecav.OR = [Qecav.OR;Secav.OR];
% beforearray_ceav.OR = [Qceav.OR;Sceav.OR];
% beforearray_eeav.OR = [Qeeav.OR;Seeav.OR];
% 
% 
% err_beforearray_ccav.neuron = std(beforearray_ccav.neuron) / sqrt(length(beforearray_ccav.neuron));
% err_beforearray_ecav.neuron = std(beforearray_ecav.neuron) / sqrt(length(beforearray_ecav.neuron));
% err_beforearray_ceav.neuron = std(beforearray_ceav.neuron) / sqrt(length(beforearray_ceav.neuron));
% err_beforearray_eeav.neuron = std(beforearray_eeav.neuron) / sqrt(length(beforearray_eeav.neuron));
% 
% err_beforearray_ccav.LFP = std(beforearray_ccav.LFP) / sqrt(length(beforearray_ccav.LFP));
% err_beforearray_ecav.LFP = std(beforearray_ecav.LFP) / sqrt(length(beforearray_ecav.LFP));
% err_beforearray_ceav.LFP = std(beforearray_ceav.LFP) / sqrt(length(beforearray_ceav.LFP));
% err_beforearray_eeav.LFP = std(beforearray_eeav.LFP) / sqrt(length(beforearray_eeav.LFP));
% 
% err_beforearray_ccav.OR = std(beforearray_ccav.OR) / sqrt(length(beforearray_ccav.OR));
% err_beforearray_ecav.OR = std(beforearray_ecav.OR) / sqrt(length(beforearray_ecav.OR));
% err_beforearray_ceav.OR = std(beforearray_ceav.OR) / sqrt(length(beforearray_ceav.OR));
% err_beforearray_eeav.OR = std(beforearray_eeav.OR) / sqrt(length(beforearray_eeav.OR));
% % 
% %runs on QS_ROC.mat
% 
% %calculate standard errors
% 
% %neuron
% err.cc.neuron_maxpos = std(ccav_maxpos.neuron) / sqrt(length(ccav_maxpos.neuron));
% err.ce.neuron_maxpos = std(ceav_maxpos.neuron) / sqrt(length(ceav_maxpos.neuron));
% err.ec.neuron_maxpos = std(ecav_maxpos.neuron) / sqrt(length(ecav_maxpos.neuron));
% err.ee.neuron_maxpos = std(eeav_maxpos.neuron) / sqrt(length(eeav_maxpos.neuron));
% 
% Serr.cc.neuron_maxpos = std(Sccav_maxpos.neuron) / sqrt(length(Sccav_maxpos.neuron));
% Serr.ce.neuron_maxpos = std(Sceav_maxpos.neuron) / sqrt(length(Sceav_maxpos.neuron));
% Serr.ec.neuron_maxpos = std(Secav_maxpos.neuron) / sqrt(length(Secav_maxpos.neuron));
% Serr.ee.neuron_maxpos = std(Seeav_maxpos.neuron) / sqrt(length(Seeav_maxpos.neuron));
% 
% Qerr.cc.neuron_maxpos = std(Qccav_maxpos.neuron) / sqrt(length(Qccav_maxpos.neuron));
% Qerr.ce.neuron_maxpos = std(Qceav_maxpos.neuron) / sqrt(length(Qceav_maxpos.neuron));
% Qerr.ec.neuron_maxpos = std(Qecav_maxpos.neuron) / sqrt(length(Qecav_maxpos.neuron));
% Qerr.ee.neuron_maxpos = std(Qeeav_maxpos.neuron) / sqrt(length(Qeeav_maxpos.neuron));
% 
% err.cc.neuron = std(ccav.neuron) / sqrt(length(ccav.neuron));
% err.ce.neuron = std(ceav.neuron) / sqrt(length(ceav.neuron));
% err.ec.neuron = std(ecav.neuron) / sqrt(length(ecav.neuron));
% err.ee.neuron = std(eeav.neuron) / sqrt(length(eeav.neuron));
% 
% Serr.cc.neuron = std(Sccav.neuron) / sqrt(length(Sccav.neuron));
% Serr.ce.neuron = std(Sceav.neuron) / sqrt(length(Sceav.neuron));
% Serr.ec.neuron = std(Secav.neuron) / sqrt(length(Secav.neuron));
% Serr.ee.neuron = std(Seeav.neuron) / sqrt(length(Seeav.neuron));
% 
% Qerr.cc.neuron = std(Qccav.neuron) / sqrt(length(Qccav.neuron));
% Qerr.ce.neuron = std(Qceav.neuron) / sqrt(length(Qceav.neuron));
% Qerr.ec.neuron = std(Qecav.neuron) / sqrt(length(Qecav.neuron));
% Qerr.ee.neuron = std(Qeeav.neuron) / sqrt(length(Qeeav.neuron));
% 
% 
% %LFP
% 
% 
% err.cc.LFP_maxpos = std(ccav_maxpos.LFP) / sqrt(length(ccav_maxpos.LFP));
% err.ce.LFP_maxpos = std(ceav_maxpos.LFP) / sqrt(length(ceav_maxpos.LFP));
% err.ec.LFP_maxpos = std(ecav_maxpos.LFP) / sqrt(length(ecav_maxpos.LFP));
% err.ee.LFP_maxpos = std(eeav_maxpos.LFP) / sqrt(length(eeav_maxpos.LFP));
%  
% Serr.cc.LFP_maxpos = std(Sccav_maxpos.LFP) / sqrt(length(Sccav_maxpos.LFP));
% Serr.ce.LFP_maxpos = std(Sceav_maxpos.LFP) / sqrt(length(Sceav_maxpos.LFP));
% Serr.ec.LFP_maxpos = std(Secav_maxpos.LFP) / sqrt(length(Secav_maxpos.LFP));
% Serr.ee.LFP_maxpos = std(Seeav_maxpos.LFP) / sqrt(length(Seeav_maxpos.LFP));
%  
% Qerr.cc.LFP_maxpos = std(Qccav_maxpos.LFP) / sqrt(length(Qccav_maxpos.LFP));
% Qerr.ce.LFP_maxpos = std(Qceav_maxpos.LFP) / sqrt(length(Qceav_maxpos.LFP));
% Qerr.ec.LFP_maxpos = std(Qecav_maxpos.LFP) / sqrt(length(Qecav_maxpos.LFP));
% Qerr.ee.LFP_maxpos = std(Qeeav_maxpos.LFP) / sqrt(length(Qeeav_maxpos.LFP));
% 
% err.cc.LFP = std(ccav.LFP) / sqrt(length(ccav.LFP));
% err.ce.LFP = std(ceav.LFP) / sqrt(length(ceav.LFP));
% err.ec.LFP = std(ecav.LFP) / sqrt(length(ecav.LFP));
% err.ee.LFP = std(eeav.LFP) / sqrt(length(eeav.LFP));
%  
% Serr.cc.LFP = std(Sccav.LFP) / sqrt(length(Sccav.LFP));
% Serr.ce.LFP = std(Sceav.LFP) / sqrt(length(Sceav.LFP));
% Serr.ec.LFP = std(Secav.LFP) / sqrt(length(Secav.LFP));
% Serr.ee.LFP = std(Seeav.LFP) / sqrt(length(Seeav.LFP));
%  
% Qerr.cc.LFP = std(Qccav.LFP) / sqrt(length(Qccav.LFP));
% Qerr.ce.LFP = std(Qceav.LFP) / sqrt(length(Qceav.LFP));
% Qerr.ec.LFP = std(Qecav.LFP) / sqrt(length(Qecav.LFP));
% Qerr.ee.LFP = std(Qeeav.LFP) / sqrt(length(Qeeav.LFP));
% 
% 
% %OR
% err.cc.OR = std(ccav_maxpos.OR) / sqrt(length(ccav_maxpos.OR));
% err.ce.OR = std(ceav_maxpos.OR) / sqrt(length(ceav_maxpos.OR));
% err.ec.OR = std(ecav_maxpos.OR) / sqrt(length(ecav_maxpos.OR));
% err.ee.OR = std(removeNaN(eeav_maxpos.OR)) / sqrt(length(removeNaN(eeav_maxpos.OR)));
% 
% Serr.cc.OR = std(Sccav_maxpos.OR) / sqrt(length(Sccav_maxpos.OR));
% Serr.ce.OR = std(Sceav_maxpos.OR) / sqrt(length(Sceav_maxpos.OR));
% Serr.ec.OR = std(Secav_maxpos.OR) / sqrt(length(Secav_maxpos.OR));
% Serr.ee.OR = std(Seeav_maxpos.OR) / sqrt(length(Seeav_maxpos.OR));
%  
% Qerr.cc.OR = std(Qccav_maxpos.OR) / sqrt(length(Qccav_maxpos.OR));
% Qerr.ce.OR = std(Qceav_maxpos.OR) / sqrt(length(Qceav_maxpos.OR));
% Qerr.ec.OR = std(Qecav_maxpos.OR) / sqrt(length(Qecav_maxpos.OR));
% Qerr.ee.OR = std(removeNaN(Qeeav_maxpos.OR)) / sqrt(length(removeNaN(Qeeav_maxpos.OR)));
% 
% 
% 
% %Seymour
% % 
% % figure
% % fw
% % hold on
% % bar(1:4,[nanmean(Sccav_maxpos.neuron) nanmean(Secav_maxpos.neuron) nanmean(Sceav_maxpos.neuron) nanmean(Seeav_maxpos.neuron)],'r')
% % bar(1:4,[nanmean(Sccav_maxpos.LFP) nanmean(Secav_maxpos.LFP) nanmean(Sceav_maxpos.LFP) nanmean(Seeav_maxpos.LFP)],'b')
% % bar(1:4,[nanmean(Sccav_maxpos.OR) nanmean(Secav_maxpos.OR) nanmean(Sceav_maxpos.OR) nanmean(Seeav_maxpos.OR)],'g')
% % 
% % errorbar(1:4,[nanmean(Sccav_maxpos.neuron) nanmean(Secav_maxpos.neuron) nanmean(Sceav_maxpos.neuron) nanmean(Seeav_maxpos.neuron)],[Serr.cc.neuron Serr.ec.neuron Serr.ce.neuron Serr.ee.neuron],'xr')
% % errorbar(1:4,[nanmean(Sccav_maxpos.LFP) nanmean(Secav_maxpos.LFP) nanmean(Sceav_maxpos.LFP) nanmean(Seeav_maxpos.LFP)],[Serr.cc.LFP Serr.ec.LFP Serr.ce.LFP Serr.ee.LFP],'xb')
% % errorbar(1:4,[nanmean(Sccav_maxpos.OR) nanmean(Secav_maxpos.OR) nanmean(Sceav_maxpos.OR) nanmean(Seeav_maxpos.OR)],[Serr.cc.OR Serr.ec.OR Serr.ce.OR Serr.ee.OR],'xg')
% % 
% % ylim([.49 .75])
% % title('Seymour')
% % 
% % 
% % %Quincy
% % figure
% % fw
% % hold on
% % bar(1:4,[nanmean(Qccav_maxpos.neuron) nanmean(Qecav_maxpos.neuron) nanmean(Qceav_maxpos.neuron) nanmean(Qeeav_maxpos.neuron)],'r')
% % bar(1:4,[nanmean(Qccav_maxpos.LFP) nanmean(Qecav_maxpos.LFP) nanmean(Qceav_maxpos.LFP) nanmean(Qeeav_maxpos.LFP)],'b')
% % bar(1:4,[nanmean(Qccav_maxpos.OR) nanmean(Qecav_maxpos.OR) nanmean(Qceav_maxpos.OR) nanmean(Qeeav_maxpos.OR)],'g')
% %  
% % errorbar(1:4,[nanmean(Qccav_maxpos.neuron) nanmean(Qecav_maxpos.neuron) nanmean(Qceav_maxpos.neuron) nanmean(Qeeav_maxpos.neuron)],[Qerr.cc.neuron Qerr.ec.neuron Qerr.ce.neuron Qerr.ee.neuron],'xr')
% % errorbar(1:4,[nanmean(Qccav_maxpos.LFP) nanmean(Qecav_maxpos.LFP) nanmean(Qceav_maxpos.LFP) nanmean(Qeeav_maxpos.LFP)],[Qerr.cc.LFP Qerr.ec.LFP Qerr.ce.LFP Qerr.ee.LFP],'xb')
% % errorbar(1:4,[nanmean(Qccav_maxpos.OR) nanmean(Qecav_maxpos.OR) nanmean(Qceav_maxpos.OR) nanmean(Qeeav_maxpos.OR)],[Qerr.cc.OR Qerr.ec.OR Qerr.ce.OR Qerr.ee.OR],'xg')
% %  
% % ylim([.48 .75])
% % title('Quincy')
% 
% 
% %combined - maxPos average
% figure
% fw
% hold on
% bar(1:4,[nanmean(ccav_maxpos.neuron) nanmean(ecav_maxpos.neuron) nanmean(ceav_maxpos.neuron) nanmean(eeav_maxpos.neuron)],'r')
% bar(1:4,[nanmean(ccav_maxpos.LFP) nanmean(ecav_maxpos.LFP) nanmean(ceav_maxpos.LFP) nanmean(eeav_maxpos.LFP)],'b')
% bar(1:4,[nanmean(ccav_maxpos.OR) nanmean(ecav_maxpos.OR) nanmean(ceav_maxpos.OR) nanmean(eeav_maxpos.OR)],'g')
%  
% errorbar(1:4,[nanmean(ccav_maxpos.neuron) nanmean(ecav_maxpos.neuron) nanmean(ceav_maxpos.neuron) nanmean(eeav_maxpos.neuron)],[err.cc.neuron err.ec.neuron err.ce.neuron err.ee.neuron],'xr')
% errorbar(1:4,[nanmean(ccav_maxpos.LFP) nanmean(ecav_maxpos.LFP) nanmean(ceav_maxpos.LFP) nanmean(eeav_maxpos.LFP)],[err.cc.LFP err.ec.LFP err.ce.LFP err.ee.LFP],'xb')
% errorbar(1:4,[nanmean(ccav_maxpos.OR) nanmean(ecav_maxpos.OR) nanmean(ceav_maxpos.OR) nanmean(eeav_maxpos.OR)],[err.cc.OR err.ec.OR err.ce.OR err.ee.OR],'xg')
%  
% ylim([.49 .75])
% title('Combined MaxPos Average')
% 
% 
% % %combined - interval average
% figure
% fw
% hold on
% 
% bar(1:4,[nanmean(ccav.neuron) nanmean(ecav.neuron) nanmean(ceav.neuron) nanmean(eeav.neuron)],'r')
% bar(1:4,[nanmean(ccav.LFP) nanmean(ecav.LFP) nanmean(ceav.LFP) nanmean(eeav.LFP)],'b')
% bar(1:4,[nanmean(ccav.OR) nanmean(ecav.OR) nanmean(ceav.OR) nanmean(eeav.OR)],'g')
%  
% errorbar(1:4,[nanmean(ccav.neuron) nanmean(ecav.neuron) nanmean(ceav.neuron) nanmean(eeav.neuron)],[err.cc.neuron err.ec.neuron err.ce.neuron err.ee.neuron],'xr')
% errorbar(1:4,[nanmean(ccav.LFP) nanmean(ecav.LFP) nanmean(ceav.LFP) nanmean(eeav.LFP)],[err.cc.LFP err.ec.LFP err.ce.LFP err.ee.LFP],'xb')
% errorbar(1:4,[nanmean(ccav.OR) nanmean(ecav.OR) nanmean(ceav.OR) nanmean(eeav.OR)],[err.cc.OR err.ec.OR err.ce.OR err.ee.OR],'xg')
% 
% ylim([.49 .75])
% title('Combined Interval Average')
% 
% 
% 
% %neuron t-tests
% % [a b] = ttest(ccav_maxpos.neuron,ceav_maxpos.neuron)
% [a b] = ttest(ceav_maxpos.neuron,eeav_maxpos.neuron)
% 
% %LFP t-tests
% % [a b] = ttest(ccav_maxpos.LFP,ceav_maxpos.LFP)
% [a b] = ttest(ceav_maxpos.LFP,eeav_maxpos.LFP)
% 
% %OR t-tests
% % [a b] = ttest(ccav_maxpos.OR,ceav_maxpos.OR)
% [a b] = ttest(ceav_maxpos.OR,eeav_maxpos.OR)
% 
% 
% % %neuron t-tests
% % % [a b] = ttest(ccav_maxpos.neuron,ceav_maxpos.neuron)
% % [a b] = ttest(ceav.neuron,eeav.neuron)
% % 
% % %LFP t-tests
% % % [a b] = ttest(ccav_maxpos.LFP,ceav_maxpos.LFP)
% % [a b] = ttest(ceav.LFP,eeav.LFP)
% % 
% % %OR t-tests
% % % [a b] = ttest(ccav_maxpos.OR,ceav_maxpos.OR)
% % [a b] = ttest(ceav.OR,eeav.OR)
% 
% 
% figure
% fw
% subplot(2,3,1)
% plot(-100:500,nanmean(ROC_cc.neuron),'k',-100:500,nanmean(ROC_ec.neuron),'b',-100:500,nanmean(ROC_ce.neuron),'r',-100:500,nanmean(ROC_ee.neuron),'g')
% xlim([-100 500])
% title('Neuron')
% 
% subplot(2,3,2)
% plot(-100:500,nanmean(ROC_cc.LFP),'k',-100:500,nanmean(ROC_ec.LFP),'b',-100:500,nanmean(ROC_ce.LFP),'r',-100:500,nanmean(ROC_ee.LFP),'g')
% xlim([-100 500])
% title('LFP')
% 
% subplot(2,3,3)
% plot(-100:500,nanmean(ROC_cc.OR),'k',-100:500,nanmean(ROC_ec.OR),'b',-100:500,nanmean(ROC_ce.OR),'r',-100:500,nanmean(ROC_ee.OR),'g')
% xlim([-100 500])
% title('OR')
% 
% subplot(2,3,4)
% plot(-100:500,nanmean(ROC_sub_cc.neuron),'k',-100:500,nanmean(ROC_sub_ec.neuron),'b',-100:500,nanmean(ROC_sub_ce.neuron),'r',-100:500,nanmean(ROC_sub_ee.neuron),'g')
% xlim([-100 500])
% title('Neuron')
%  
% subplot(2,3,5)
% plot(-100:500,nanmean(ROC_sub_cc.LFP),'k',-100:500,nanmean(ROC_sub_ec.LFP),'b',-100:500,nanmean(ROC_sub_ce.LFP),'r',-100:500,nanmean(ROC_sub_ee.LFP),'g')
% xlim([-100 500])
% title('LFP')
%  
% subplot(2,3,6)
% plot(-100:500,nanmean(ROC_sub_cc.OR),'k',-100:500,nanmean(ROC_sub_ec.OR),'b',-100:500,nanmean(ROC_sub_ce.OR),'r',-100:500,nanmean(ROC_sub_ee.OR),'g')
% xlim([-100 500])
% title('OR')
% 
