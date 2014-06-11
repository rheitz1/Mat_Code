%Plots the average of peak SDF for target-in and distractor-in CORRECT trials over subsequent blocks of
%trials
function [peaks_in peaks_out] = SDF_over_time(Spikename,batch_size)

if nargin < 2; batch_size = 10; end

Target_ = evalin('caller','Target_');
Correct_ = evalin('caller','Correct_');
Spike = evalin('caller',Spikename);
RFs = evalin('caller','RFs');

RF = RFs.(Spikename);

SDF = sSDF(Spike,Target_(:,1),[-400 1000]);

in_correct = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF));
%in_error = find(Correct_(:,2)==0 & ismember(Target_(:,2),RF));
out_correct = find(Correct_(:,2) == 1 & ismember(Target_(:,2),mod((RF+4),8)));

%Get mean SDFs over batches of specified size

for cur_batch = 0:floor(length(in_correct)/batch_size)-1
    batch_trls_in = in_correct(cur_batch*batch_size+1:(cur_batch+1)*batch_size);
    
    %find error trials falling within that same interval of correct trials for maximal matching
    batch_trls_out = out_correct(find(out_correct >= min(batch_trls_in) & out_correct <= max(batch_trls_in)));
    
    %cur_SDF(cur_batch+1,1:1401) = nanmean(SDF(in_correct(cur_batch*batch_size+1:(cur_batch+1)*batch_size),:));
    cur_SDF_in(cur_batch+1,1:1401) = nanmean(SDF(batch_trls_in,:));
    cur_SDF_out(cur_batch+1,1:1401) = nanmean(SDF(batch_trls_out,:));
end

%Find the relevant peak
[~,peakLoc] = max(nanmean(SDF));

%find mean amplitude in window for each batch

winsize = 25;

peaks_in = nanmean(cur_SDF_in(:,peakLoc-winsize/2:peakLoc+winsize/2),2);
peaks_out = nanmean(cur_SDF_out(:,peakLoc-winsize/2:peakLoc+winsize/2),2);

figure
set(gcf,'position',[1163         565        1049         686])

subplot(221)
plot(-400:1000,nanmean(SDF(in_correct,:)),'k',-400:1000,nanmean(SDF(out_correct,:)),'--k')
xlim([-100 800])
box off

subplot(223)
%plot(1:batch_size:length(peaks_correct)*batch_size,peaks_correct,'-ok',1:batch_size:length(peaks_error)*batch_size,peaks_error,'--ok')
plot(batch_size/2:batch_size:length(peaks_in)*batch_size-batch_size/2,peaks_in,'-ok',batch_size/2:batch_size:length(peaks_in)*batch_size-batch_size/2,peaks_out,'--ok')
xlabel('Trial # (bin center)','fontsize',18,'fontweight','bold')
ylabel('Spikes/sec','fontsize',18,'fontweight','bold')
box off

subplot(224)
plot(batch_size/2:batch_size:length(peaks_in)*batch_size-batch_size/2,peaks_in-peaks_out,'-or')
xlabel('Trial # (bin center)','fontsize',18,'fontweight','bold')
ylabel('Spikes/sec difference (correct-error)','fontsize',18,'fontweight','bold')
box off
ylim([-max(peaks_in - peaks_out)-5 max(peaks_in - peaks_out)+5])
hline(0,'k')