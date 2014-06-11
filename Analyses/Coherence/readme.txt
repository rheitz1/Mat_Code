SPKLFP.txt:  LFP RF (by LFPtuning.m) had overlap with defined spike RF from spreadsheet.  LFP had to have significant TDT


SPKLFP_nooverlap.txt:  Went through the database and found instances where the neuron selected regions of space other than the LFP (by LFPtuning.m).  Note that the LFP had to have significant TDT using LFPtuning.m



SPKLFP_neuronRF:  For every Spike-LFP comparison in the database, I plotted Target-In and Distractor-In for both spikes and LFP using the NEURON's associated RF.  If the LFP had significant selection in the same direction as the neuron, I kept that comparison and used just the neuron's RF.  If the LFP had significant selection in the opposing direction, I added it to the 'nooverlap' condition.

SPKLFP_neuronRF_nooverlap.txt:  the 'nooverlap' condition from the above.