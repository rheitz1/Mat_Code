function [flag] = reverse_correlation(sdf, t_len, t_win);
%
% MOV_ONSET
%   mov_onset returns onset time calculated from spearman correlation
%   sdf     : spike density function aligned with saccade onset at 1001
%   t_len   : successive examine interval
%   t_win   : spearman sample interval [-t_win:t_win]
%   onset   : onset time
%   base    : baseline activity of the motor part measured [-200:0] ms
%
% Schall Lab Method RM 030 Tempo/Mac
% Modified by pierre pouget for coverted matlab files

if nargin == 1,
    t_len = 19;
    t_win = 20;
end

base = mean(sdf(1:200));

onset = NaN;
flag = 0;
pflag = 0;
%t = 0;
t = 200;

for n = 250:length(sdf)-t_win
    
    itvl = [n-t_win:n+t_win];
    flag(n-200,1) = spearman(itvl, sdf(itvl), 0.05);
    
    end



return;