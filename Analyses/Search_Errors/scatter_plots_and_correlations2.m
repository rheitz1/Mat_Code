markersize = 120;

load Qagg_final

fire_corr_in = nanmean(allwf.neuron.in_correct(find(keeper.reg.neuron),250:350),2);
fire_corr_out = nanmean(allwf.neuron.out_correct(find(keeper.reg.neuron),250:350),2);
fire_err_in = nanmean(allwf.neuron.in_errors(find(keeper.reg.neuron),250:350),2);
fire_err_out = nanmean(allwf.neuron.out_errors(find(keeper.reg.neuron),250:350),2);
firediff_corr = fire_corr_in - fire_corr_out;
firediff_err = fire_err_in - fire_err_out;


figure
scatter(firediff_corr,firediff_err,'k','markerfacecolor','white','sizedata',markersize)
xlim([-80 80])
ylim([-80 80])
vline(0,'k')
hline(0,'k')
hold on


% LFP
fire_corr_in = nanmean(allwf.LFP.Hemi.in_correct(find(keeper.reg.LFP),650:750),2);
fire_corr_out = nanmean(allwf.LFP.Hemi.out_correct(find(keeper.reg.LFP),650:750),2);
fire_err_in = nanmean(allwf.LFP.Hemi.in_errors(find(keeper.reg.LFP),650:750),2);
fire_err_out = nanmean(allwf.LFP.Hemi.out_errors(find(keeper.reg.LFP),650:750),2);
firediff_corr = fire_corr_in - fire_corr_out;
firediff_err = fire_err_in - fire_err_out;

firediff_corr = firediff_corr * 1000;
firediff_err = firediff_err * 1000;

scatter(firediff_corr,firediff_err,'^b','markerfacecolor','white','sizedata',markersize)


%OR
fire_corr_in = nanmean(allwf.OR.in_correct(find(keeper.reg.OR),650:750),2);
fire_corr_out = nanmean(allwf.OR.out_correct(find(keeper.reg.OR),650:750),2);
fire_err_in = nanmean(allwf.OR.in_errors(find(keeper.reg.OR),650:750),2);
fire_err_out = nanmean(allwf.OR.out_errors(find(keeper.reg.OR),650:750),2);
firediff_corr = fire_corr_in - fire_corr_out;
firediff_err = fire_err_in - fire_err_out;

firediff_corr = firediff_corr * 10000;
firediff_err = firediff_err * 10000;

scatter(firediff_corr,firediff_err,'sr','markerfacecolor','white','sizedata',markersize)

keep markersize

load Sagg_final

fire_corr_in = nanmean(allwf.neuron.in_correct(find(keeper.reg.neuron),250:350),2);
fire_corr_out = nanmean(allwf.neuron.out_correct(find(keeper.reg.neuron),250:350),2);
fire_err_in = nanmean(allwf.neuron.in_errors(find(keeper.reg.neuron),250:350),2);
fire_err_out = nanmean(allwf.neuron.out_errors(find(keeper.reg.neuron),250:350),2);
firediff_corr = fire_corr_in - fire_corr_out;
firediff_err = fire_err_in - fire_err_out;


scatter(firediff_corr,firediff_err,'k','markerfacecolor','k','sizedata',markersize)


% LFP
fire_corr_in = nanmean(allwf.LFP.Hemi.in_correct(find(keeper.reg.LFP),650:750),2);
fire_corr_out = nanmean(allwf.LFP.Hemi.out_correct(find(keeper.reg.LFP),650:750),2);
fire_err_in = nanmean(allwf.LFP.Hemi.in_errors(find(keeper.reg.LFP),650:750),2);
fire_err_out = nanmean(allwf.LFP.Hemi.out_errors(find(keeper.reg.LFP),650:750),2);
firediff_corr = fire_corr_in - fire_corr_out;
firediff_err = fire_err_in - fire_err_out;

firediff_corr = firediff_corr * 1000;
firediff_err = firediff_err * 1000;

scatter(firediff_corr,firediff_err,'^b','markerfacecolor','b','sizedata',markersize)


%OR
fire_corr_in = nanmean(allwf.OR.in_correct(find(keeper.reg.OR),650:750),2);
fire_corr_out = nanmean(allwf.OR.out_correct(find(keeper.reg.OR),650:750),2);
fire_err_in = nanmean(allwf.OR.in_errors(find(keeper.reg.OR),650:750),2);
fire_err_out = nanmean(allwf.OR.out_errors(find(keeper.reg.OR),650:750),2);
firediff_corr = fire_corr_in - fire_corr_out;
firediff_err = fire_err_in - fire_err_out;

firediff_corr = firediff_corr * 10000;
firediff_err = firediff_err * 10000;

scatter(firediff_corr,firediff_err,'sr','markerfacecolor','r','sizedata',markersize)

v_