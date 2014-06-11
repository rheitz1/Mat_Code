JPSTH ANALYSIS, 2008

written by: John Haitas, Jeremiah Cohen, and Jeff Schall
________________________________________________________________________

INPUT DATA FORMAT:

Spike data should be in the form of a matrix of spike times (spike_data), wherein each row denotes a separate trial.
_________________________________________________________________________

HOW TO RUN:

-In the MATLAB command prompt, type setup_jpsth_toolbox.

-Use the command:
 
	aligned_spike_data = align_timestamps(spike_data, align_event_vector) 

for each signal you wish to compare. This function aligns spike data to the stimulus of interest. The variable align_event_vector should be in the form of a column vector listing the event time for each trial.

-Use the command:

	time_stamps = trim_timestamps(aligned_spike_data, time_window, binwidth) 

for each signal you wish to compare. This function removes spike times outside the window of interest (time_window). The variable time_window should be in the form of [start finish], where both times are relative to the align event.

-Use the command:

	spikes = spike_counts(time_stamps, time_window, binwidth) 

for each signal you wish to compare. This function counts the number of spikes in each bin for each trial.

- Run jpsth(spike_counts_signal1, spike_counts_signal2, coincidence_histogram_width, signal1_electrode_number, signal2_electrode_number). The output is a struct, which is described in the next section. 

________________________________________________________________________
OUTPUT STRUCTURE
________________________________________________________________________

jpsth_data 		
		-> superstructure for jpsth output data

jpsth_data.psth_1 
		-> peristimulus time histogram for signal 1

jpsth_data.psth_2 
		-> peristimulus time histogram for signal 2

jpsth_data.normalized_jpsth
		-> jpsth matrix normalized to the standard deviation

jpsth_data.xcorr_hist
		-> crosscorrelogram based on Aertsen et al's equations

jpsth_data.pstch
		-> coincidence histogram based on Aertsen et al's equations

jpsth_data.covariogram
		-> covariogram based on Brody's equation (qualitatively same as crosscorrelogram)

jpsth_data.sig_low
		-> negative covariogram significance limit based on Brody's equation

jpsth_data.sig_high
		-> positive covariogram significance limit based on Brody's equation

jpsth_data.sign_peak_endpoints 
		-> start and end indices for continuous span of covariogram values exceeding sig_high

jpsth_data.sign_trough_endpoints 
		-> start and end indices for continuous span of covariogram values less than sig_low






