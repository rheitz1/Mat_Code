function [onset, base] = mov_onset_p(sdf, t_len, t_win);
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
    t_len = 29;%19
    t_win = 30;%20
end

base = mean(sdf(501 + [-200:0]));

onset = NaN;
flag = 0;
pflag = 0;
t = 0;



while( isnan(onset) )
    itvl = [t-t_win:t+t_win]+501;
    if min(itvl)>10
        flag = spearman(itvl, sdf(itvl), 0.05);

        if flag == 0 & pflag == 1 & sdf(501+t) < base,
            nflag = [];
            for i = 1:t_len,
                nflag(i) = spearman(itvl-i, sdf(itvl-i), 0.05);
            end

            if sum(nflag) == 0,
                onset = t + 1;
            else
                t = t-1;
            end
        else
            t = t - 1;
        end

        if t == -500 + t_win,
            onset = t;
        end

        pflag = flag;
    else
    onset=8888;   
    end

end

return;