clear all;
close all;

%more efficient random walk
drift = .65;
nTrials = 1;
nIter = 10000;
nSims = 1; %number simulations
criterion = 70;
sd = .1; %drift constant

%create accumulator

%     accumulator = cumsum(2.*(rand(nTrials,nIter) + trlNoise <=drift)-1,2);
%
tic
for count = 1:nSims
    for n = 1:nTrials
        Accumulat_final = [];
        temp = [];
        temp = [];
        trlNoise = randn + (randn*sd);
%        trlNoise = randn*noise;
        temp = cumsum(2.*(rand(1,nIter) + trlNoise <= drift)-1,2);
        accumulator(n,1:length(temp)) = temp;
    end
    toc

    %create column of 0's to shift
    accumulator(:,nIter+1) = 0;

    %shift last column to first
    accumulator_shift = circshift(accumulator,[0,1]);

    figure
    for tr = 1:size(accumulator_shift,1)
    hold on
    hold all
        temp = accumulator_shift(tr,find(abs(accumulator_shift(tr,:)) <= criterion));
        %RT(tr,1) = accumulator_shift(tr,find(abs(accumulator_shift(tr,:)) <= criterion,1));
        Accumulat_final(tr,1:length(temp)) = temp;
        plot(nonzeros(Accumulat_final(tr,:)))
        ylim([-1*(criterion+10) criterion+10]);
        hold off
    end
end