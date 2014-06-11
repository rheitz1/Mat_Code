function [SDF_boot] = bootSDF(spike,nboot)
%function [boot_SDF] = bootSDF(SDF,n,t)
% % % %bootstrapping method for SDFs: returns bootstrapped matrix of t 'trials',
% % % %each sample being the mean of n draws
% % % %
% % % %NOTE: requires trial-by-trial SDFs
% % % 
% % % if size(SDF,1) == 1
% % %     disp('Need trial-by-trial SDFs!')
% % %     return
% % % end
% % % 
% % % %create n draws of target trial numbers ranging from 1 to the length of the
% % % %trial-by-trial SDF matrix
% % % f = ceil(size(SDF,1).*rand(n,1));
% % % 
% % % %record mean of each 'trial,' each composed of n samples
% % % disp('Bootstrapping...')
% % % for trl = 1:t
% % %     f = ceil(size(SDF,1).*rand(n,1));
% % %     boot_SDF(trl,1:size(SDF,2)) = nanmean(SDF(f,:));
% % % end

SDF_boot=[];
[ntrials samples]=size(spike);
indexmat=unidrnd(ntrials,nboot,samples);
for ii=1:nboot
    for jj=1:samples
        whichtrial=indexmat(ii,jj);
        SDF_boot(ii,jj)=spike(whichtrial,jj);
    end
end