function [spike_width spike_amplitude,all_waves] = getSpikeWidth(SPK,waves,trls,window,plotFlag)
% Returns matrix of spike waveforms and peak-to-trough width across some
% set of trials and within some time window (inclusive) relative to target onset.
% RPH

if nargin < 5; plotFlag = 0; end
if nargin < 4; window = [-3500 2500]; end
if nargin < 3; trls = 1:size(SPK,1); end %note: dimension 3 of waves is number of trials

Target_ = evalin('caller','Target_');

%change 0's to NaN
SPK(find(SPK == 0)) = NaN;

%size of waveforms is dependent on window size used during recording.  We
%can reverse engineer this because we know we are sampling at exactly 40 kHz
%In the end, the distance between two samples is 40 us:
%
% e.g., if we have 32 points/spike:
% 40,000 samples / 1000 ms == 32/x     x = .8 ms  (800 us)

% e.g., if we have 56 points/spike:
% 40,000 samples / 1000 ms == 56/x     x = 1.4 ms (1400 us)

%generate time axis
spike_window_size = (1000 * size(waves,2)) / 40000;
tout = linspace(0,spike_window_size,size(waves,2));

wave_count = 1;
for trl = 1:length(trls)
    trlspks = SPK(trls(trl),find(~isnan(SPK(trls(trl),:))));
    
    validspks = find( (trlspks - Target_(1,1) >= window(1)) & (trlspks - Target_(1,1) <= window(2)));
    
    if ~isempty(validspks)
        %Store all waves from given window size and given trial into new variable
        %NOTE: I AM APPENDING THE ACTUAL TRIAL NUMBER IN THE FIRST COLUMN OF THE NEW 'ALL_WAVES' VARIABLE
        all_waves(wave_count:wave_count + length(validspks)-1,1:size(waves,2)+1) = [repmat(trls(trl),length(validspks),1) waves(validspks,:)];
        wave_count = wave_count + length(validspks);
    end
end


%get peak-to-trough distance
% note, when indexing, disregard the first column, which stores the actual trial number
[max_val max_ix] = max(nanmean(all_waves(:,2:end)));
[min_val min_ix] = min(nanmean(all_waves(:,2:end)));

[max_vals max_ixs] = max(all_waves(:,2:end),[],2);
[min_vals min_ixs] = min(all_waves(:,2:end),[],2);


spike_width.mean_of_mean = tout(max_ix) - tout(min_ix);
spike_amplitude.mean_of_mean = max_val - min_val; % in mV

spike_width.all = (tout(max_ixs) - tout(min_ixs))';
spike_amplitude.all = (max_vals - min_vals)';

spike_width.mean = mean(spike_width.all);
spike_amplitude.mean = mean(spike_amplitude.all);

spike_width.std = std(spike_width.all,0,1);
spike_amplitude.std = std(spike_amplitude.all,0,1);

sem = std(all_waves(:,2:end),0,1);
upper = nanmean(all_waves(:,2:end)) + sem;
lower = nanmean(all_waves(:,2:end)) - sem;


if plotFlag == 1
    figure
    subplot(2,2,1)
    plot(tout,nanmean(all_waves(:,2:end)),'linewidth',2)
    xlim([0 tout(end)])
    xlabel('Time (us)')
    ylabel('mV')
    title(['N = ' mat2str(size(all_waves(:,2:end),1)) ' spikes'])
    %fill in area
    fill_area(tout,upper,lower,'b','b');
    box off
    
    subplot(2,2,2)
    hist(spike_width.all,10)
    xlabel('Spike Width (us)')
    v = vline(mean(spike_width.all),'r');
    set(v,'linewidth',2)
    box off
    
    subplot(2,2,3)
    hist(spike_amplitude.all,10)
    xlabel('Amplitude (mV)')
    v = vline(mean(spike_amplitude.all),'r');
    set(v,'linewidth',2)
    box off
    
end