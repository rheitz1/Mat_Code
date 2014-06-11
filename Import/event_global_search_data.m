% event table construction
% type :real   -> time stamp information with the event code
%       update -> only trial related codes are useful
%                             code  : cmd           : type





% code 2728 & 1668 are dummy code for meet the size.
global ec_juce;             % 2727  : juice         : real as a reward timing
global ec_succ;             % 2728  : succ          : success but no juice delievered
global ec_abrt;             % 2620  : fail          : failed
global ec_BOT;              % 1666  : BOT           : real as a target on signal
global ec_EOT;              % 1667  : EOT           : real as a parsing signal
global ec_SOT;              % 1668  : SOT           : stop of trial, when trial was enforced to stop

%
global ec_iagl;global  ic_iagl;             % 3000  : iangel        : update 1  keep & not use
global ec_eccy;global  ic_eccy;             % 3001  : eccy          : update 2  keep & use
global ec_plce;global  ic_plce;             % 3002  : placeholder   : update 3  keep & not implemented
global ec_task;global  ic_task;             % 3003  : ltask         : update 4  keep & use
global ec_ssfg;global  ic_ssfg;             % 3004  : set size flg  : update 5  keep & use
global ec_ssiz;global  ic_ssiz;             % 3005  : set size      : update 6  keep & use
global ec_dmd1;global  ic_dmd1;             % 3006  : microdrive 1  : update 7  keep
global ec_ipos;global  ic_ipos;             % 3007  : target from 1 : update 8 9 10 11 12 13 14 15  keep & use
global ec_icol;global  ic_icol;            % 3008  : color         : update 16 keep & use
global ec_maxc;global  ic_maxc;            % 3009  : max color     : update 17 keep & not use
global ec_minc;global  ic_minc;            % 3010  : min color     : update 18 keep & not use
global ec_cgrd;global  ic_cgrd;            % 3011  : color gradient: update 19 keep & not use
global ec_pair;global  ic_pair;            % 3012  : lpair         : update 20 keep & use
global ec_tgtp;global  ic_tgtp;            % 3013  : target pos    : update 21 keep & use
global ec_grpf;global  ic_grpf;            % 3014  : grouping flg  : update 22 keep & use
global ec_grpr;global  ic_grpr;            % 3015  : group rep     : update 23 keep & use
global ec_grpp;global  ic_grpp;            % 3016  : cur group     : update 24 keep & use
global ec_grpc;global  ic_grpc;            % 3017  : group count   : update 25 keep & use
global ec_titi;global  ic_titi;            % 3018  : inter trial   : update 26 keep & not use
global ec_fxat;global  ic_fxat;            % 3019  : fix acq time  : update 27 keep & not use
global ec_fxmt;global  ic_fxmt;            % 3020  : fix main time : update 28 keep & not use
global ec_uhdt;global  ic_uhdt;            % 3021  : max hold time : update 29 keep & not use
global ec_uscl;global  ic_uscl;            % 3022  : max sac lat   : update 30 keep & not use
global ec_lwtg;global  ic_lwtg;            % 3023  : min wait tgt  : update 31 keep & not use
global ec_lwct;global  ic_lwct;            % 3024  : min wait cat  : update 32 keep & not use
global ec_dmd2;global  ic_dmd2;            % 3025  : microdrive 2  : update 33 keep 
global ec_tfix;global  ic_tfix;            % 3026  : fix time      : update 34 keep & not use
global ec_thld;global  ic_thld;            % 3027  : hold time     : update 35 keep & not use
global ec_isct;global  ic_isct;            % 3028  : catch flag    : update 36 keep & use
global ec_belf;global  ic_belf;            % 3029  : bell on       : update 37 keep & use
global ec_amtj;global  ic_amtj;            % 3030  : amt of juice  : update 38 keep & not use
global ec_wsfx;global  ic_wsfx;            % 3031  : fix win s     : update 39 keep & not use
global ec_dstf;global  ic_dstf;            % 3032  : dist option   : update 40 keep & use
global ec_wsst;global  ic_wsst;            % 3033  : stm win s     : update 41 keep & not use
global ec_corr;global  ic_corr;            % 3034  : succ/fail     : update 42 keep & use
global ec_tsac;global  ic_tsac;            % 3035  : sac latency   : update 43 keep & use
global ec_xgan;global  ic_xgan;            % 3036  : xgain         : update 44 keep & use
global ec_ygan;global  ic_ygan;            % 3037  : ygain         : update 45 keep & use
global ec_gyxf;global  ic_gyxf;            % 3038  : yxf           : update 46 keep & use
global ec_gxyf;global  ic_gxyf;            % 3039  : xyf           : update 47 keep & use
global ec_ecir;global  ic_ecir;            % 3040  : size conv     : update 48 keep & use
global ec_sfxx;global  ic_sfxx;            % 3041  : sFixx(sign)   : update 49 keep & use
global ec_efxx;global  ic_efxx;            % 3041  : eFixx(value)  : update 50 keep & use
global ec_sfxy;global  ic_sfxy;            % 3042  : sFixy(sign)   : update 51 keep & use
global ec_efxy;global  ic_efxy;            % 3042  : eFixy(value)  : update 52 keep & use
global ec_rwdn;global  ic_rwdn;            % 3043  : every rwd     : update 53 keep & use
global ec_rwdc;global  ic_rwdc;            % 3044  : rwd counter   : update 54 keep & use
global ec_rwdf;global  ic_rwdf;            % 3045  : juice on flag : update 55 keep & use
global ec_tsch;global  ic_tsch;            % 3046  : srch ary time : update 56 keep & use
global ec_rcat;global  ic_rcat;            % 3047  : catch ratio   : update 57 keep & use of the trial
global ec_rpar;global  ic_rpar;            % 3048  : pair type rai : update 58 59 60 61 62 63 % use 
global ec_svlx;global  ic_svlx;            % 3049  : voltage sig fx: update 64 keep & use
global ec_volx;global  ic_volx;            % 3049  : voltage val fx: update 65 keep & use
global ec_svly;global  ic_svly;            % 3050  : voltage sig fy: update 66 keep & use
global ec_voly;global  ic_voly;            % 3050  : voltage val fy: update 67 keep & use












% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% code 2728 & 1668 are dummy code for meet the size.
ec_juce = 2727;             % 2727  : juice         : real as a reward timing
ec_succ = 2723;             % 2728  : succ          : success but no juice delievered
ec_abrt = 2620;             % 2620  : fail          : failed
ec_BOT = 1666;              % 1666  : BOT           : real as a target on signal
ec_EOT = 1667;              % 1667  : EOT           : real as a parsing signal
ec_SOT = 1668;              % 1668  : SOT           : stop of trial, when trial was enforced to stop

%
ec_iagl = 3000; ic_iagl = 1;             % 3000  : iangel        : update 1  keep & not use
ec_eccy = 3001; ic_eccy = 2;             % 3001  : eccy          : update 2  keep & use
ec_plce = 3002; ic_plce = 3;             % 3002  : placeholder   : update 3  keep & not implemented
ec_task = 3003; ic_task = 4;             % 3003  : ltask         : update 4  keep & use
ec_ssfg = 3004; ic_ssfg = 5;             % 3004  : set size flg  : update 5  keep & use
ec_ssiz = 3005; ic_ssiz = 6;             % 3005  : set size      : update 6  keep & use
ec_dmd1 = 3006; ic_dmd1 = 7;             % 3006  : microdrive 1  : update 7  keep
ec_ipos = 3007; ic_ipos = 8;             % 3007  : target from 1 : update 8 9 10 11 12 13 14 15  keep & use
ec_icol = 3008; ic_icol = 16;            % 3008  : color         : update 16 keep & use
ec_maxc = 3009; ic_maxc = 17;            % 3009  : max color     : update 17 keep & not use
ec_minc = 3010; ic_minc = 18;            % 3010  : min color     : update 18 keep & not use
ec_cgrd = 3011; ic_cgrd = 19;            % 3011  : color gradient: update 19 keep & not use
ec_pair = 3012; ic_pair = 20;            % 3012  : lpair         : update 20 keep & use
ec_tgtp = 3013; ic_tgtp = 21;            % 3013  : target pos    : update 21 keep & use
ec_grpf = 3014; ic_grpf = 22;            % 3014  : grouping flg  : update 22 keep & use
ec_grpr = 3015; ic_grpr = 23;            % 3015  : group rep     : update 23 keep & use
ec_grpp = 3016; ic_grpp = 24;            % 3016  : cur group     : update 24 keep & use
ec_grpc = 3017; ic_grpc = 25;            % 3017  : group count   : update 25 keep & use
ec_titi = 3018; ic_titi = 26;            % 3018  : inter trial   : update 26 keep & not use
ec_fxat = 3019; ic_fxat = 27;            % 3019  : fix acq time  : update 27 keep & not use
ec_fxmt = 3020; ic_fxmt = 28;            % 3020  : fix main time : update 28 keep & not use
ec_uhdt = 3021; ic_uhdt = 29;            % 3021  : max hold time : update 29 keep & not use
ec_uscl = 3022; ic_uscl = 30;            % 3022  : max sac lat   : update 30 keep & not use
ec_lwtg = 3023; ic_lwtg = 31;            % 3023  : min wait tgt  : update 31 keep & not use
ec_lwct = 3024; ic_lwct = 32;            % 3024  : min wait cat  : update 32 keep & not use
ec_dmd2 = 3025; ic_dmd2 = 33;            % 3025  : microdrive 2  : update 33 keep 
ec_tfix = 2026; ic_tfix = 34;            % 3026  : fix time      : update 34 keep & not use
ec_thld = 3027; ic_thld = 35;            % 3027  : hold time     : update 35 keep & not use
ec_isct = 3028; ic_isct = 36;            % 3028  : catch flag    : update 36 keep & use
ec_belf = 3029; ic_belf = 37;            % 3029  : bell on       : update 37 keep & use
ec_amtj = 3030; ic_amtj = 38;            % 3030  : amt of juice  : update 38 keep & not use
ec_wsfx = 3031; ic_wsfx = 39;            % 3031  : fix win s     : update 39 keep & not use
ec_dstf = 3032; ic_dstf = 40;            % 3032  : dist option   : update 40 keep & use
ec_wsst = 3033; ic_wsst = 41;            % 3033  : stm win s     : update 41 keep & not use
ec_corr = 3034; ic_corr = 42;            % 3034  : succ/fail     : update 42 keep & use
ec_tsac = 3035; ic_tsac = 43;            % 3035  : sac latency   : update 43 keep & use
ec_xgan = 3036; ic_xgan = 44;            % 3036  : xgain         : update 44 keep & use
ec_ygan = 3037; ic_ygan = 45;            % 3037  : ygain         : update 45 keep & use
ec_gyxf = 3038; ic_gyxf = 46;            % 3038  : yxf           : update 46 keep & use
ec_gxyf = 3039; ic_gxyf = 47;            % 3039  : xyf           : update 47 keep & use
ec_ecir = 3040; ic_ecir = 48;            % 3040  : size conv     : update 48 keep & use
ec_sfxx = 3041; ic_sfxx = 49;            % 3041  : sFixx(sign)   : update 49 keep & use
ec_efxx = 3041; ic_efxx = 50;            % 3041  : eFixx(value)  : update 50 keep & use
ec_sfxy = 3042; ic_sfxy = 51;            % 3042  : sFixy(sign)   : update 51 keep & use
ec_efxy = 3042; ic_efxy = 52;            % 3042  : eFixy(value)  : update 52 keep & use
ec_rwdn = 3043; ic_rwdn = 53;            % 3043  : every rwd     : update 53 keep & use
ec_rwdc = 3044; ic_rwdc = 54;            % 3044  : rwd counter   : update 54 keep & use
ec_rwdf = 3045; ic_rwdf = 55;            % 3045  : juice on flag : update 55 keep & use
ec_tsch = 3046; ic_tsch = 56;            % 3046  : srch ary time : update 56 keep & use
ec_rcat = 3047; ic_rcat = 57;            % 3047  : catch ratio   : update 57 keep & use of the trial
ec_rpar = 3048; ic_rpar = 58;            % 3048  : pair type rai : update 58 59 60 61 62 63 % use 
ec_svlx = 3049; ic_svlx = 64;            % 3049  : voltage sig fx: update 64 keep & use
ec_volx = 3049; ic_volx = 65;            % 3049  : voltage val fx: update 65 keep & use
ec_svly = 3050; ic_svly = 66;            % 3050  : voltage sig fy: update 66 keep & use
ec_voly = 3050; ic_voly = 67;            % 3050  : voltage val fy: update 67 keep & use



