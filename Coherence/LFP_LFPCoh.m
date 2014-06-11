function [coh, f, tout, Sx, Sy, Pcoh, PSx, PSy, N, dn, nwin, err, tmpdf1,tmpdf2] = LFP_LFPCoh(X,Y,tapers,sampling, dn, fk, plotflag, t0, normfreqs, pad, pval, JustPartFlag,errType,ZTransFlag,ClusShuffOpts)
%   [coh, f, tout, Sx, Sy, Pcoh, PSx, PSy, N, dn, nwin, err,  tmpdf1,tmpdf2] = LFP_LFPCoh(X,Y,tapers,sampling, dn, fk, plotflag, t0, normfreqs, pad, pval, JustPartFlag,errType,ZTransFlag,ClusShuffOpts)
%                   or
%   This also accepts the third input (instead of tapers) being an options 
%   structure to by pass all the later arguments. If the code notices that
%   the third argument is a structure, it will take any fieldname in that
%   structure and enter it's value into the workspace as a variable of that
%   name, writing over any previous defaults. For example, set
%   options.sampling=1000; then input options as the this argument, and
%   this will enter 1000 (Hz) as the sampling rate.
%
%   This change was added to the code on 090507, though it is backwards 
%   compatible, and will still accept the long list of arguments as was 
%   previously done.
%
%   NOTE- Feature added on 091111- the option to do across condition 
%   shuffling. Set ClusShuffOpts.TestType to either 1 or 'vsBase' to run 
%   the cluster shuffling as a test of activation in all trials against the
%   baseLine (this is the Default), OR- set it to 2 or 'vsCond' to run a 
%   binary test during the ActPer between two different
%   types of trials. When doing this, the user must also input
%   ClusShuffOpts.TrType, which is a vector of trials type numbers
%   corresponding to the input data. THIS CODE WILL ONLY COMPARE TRTYPE 1 
%   TO TRTYPE 2 FOR THE ACROSS CONDITIONS SHUFFLING. Any trials where the
%   corresponding value of TrType is anything other than 1 or 2 are ignored
%   by the shuffling. Right now the code only compares across two
%   conditions, but running tests across multiple conditions is certainly
%   possible.
%
%   Note that if you do the shuffling across conditions, a significant
%   positive cluster will be a cluster in which condition 1 was larger than
%   condition 2, while a significant negative cluster was a condition in
%   which condition 2 was larger than condition 1.
%
%   Added on 091120- can adjust phase and magnitude when shuffling to test
%   coherence to avoid problems from phase and magnitude differenecs
%   between conditions (or between baseline and activity periods) from
%   altering the shuffled coherenec andthus potentially altering the
%   applicability of the shuffled test stats as a null distribution for the
%   unshuffled test stat. Set ClusShuffOpts.CohAdjPh to 1 (the default) to 
%   adjust the phases for the shuffling, and set ClusShuffOpts.CohAdjMag to
%   1 (the default) to adjust the magnitudes for shuffling. This correctly
%   accounts for these effects for both the coherence and the partial
%   coherence.
%       BE WARNED- that the way the code works, adjusting the magnitude for
%       the purpose of accounting for the coherence effect will throw off
%       teh results of shuffling for spectral power. The Ph adjustment
%       however won't affect that.
%
%   INPUTS: 
%       X		=  Time series array 1 in [Trials,Time] form
%       Y		=  Time series array 2 in [Trials,Time] form
%       TAPERS  =   Typically in [N,W] form, where N is the window length in seconds,
%                   and W is the frequency resolution (half-bandwidth), in Hz
%                   Defaults are .2 for N, and 5 for W (this default is the 
%                   the one slep. spec. with a bandwidth of 5 Hz)
%
%                   The number of slep sequences typically used is 2*NW-1.
%                   SO: SET NW EQUAL TO 1 TO JUST GET THE FIRST TAPER.
%                   
%                   Can also accept [N,W,K] form, where K is the number
%                   of tapers you want to keep, starting with the first
%
%                   Can also accept [K,TIME] form where the tapers are already
%                   calculated, with each taper you want to use down each
%                   column. Useful if you want to use this sliding window code for
%                   non-Slepian tapers, like Gaussian or rectangular, etc.
%               
%	    SAMPLING 	=  Sampling rate of time series X in Hz. 
%				Defaults to 1000/6 Hz (for the Lo Sampling data)
%	    DN		=  Amount to slide window each time sample. (In s)
%			       	Defaults to 10 ms;
%	    FK 	 	=  Frequency range to return in Hz in
%                               either [F1,F2] or [F2] form.  
%                               In [F2] form, F1 is set to 0.
%			   	Defaults to [0,200] unless 200 > sampling/2, in which case
%			   	it defaults to [0,SAMPLING/2]
%       PLOTFLAG=   0 = just output the numbers, no plots
%                   1 = use imagesc to plot spec on a new figure
%                   2 = use the current axes to make a plot
%                   Default is 1
%       t0      = Only used for creating the x-axis when plotting. This is 
%                   in ms the time for first data sample; which is not 
%                   actually included in x-axis of the plot
%                   Defaults to 0
%	    PAD		=  Padding factor for the FFT.  
%			      	i.e. For N = 500, if PAD = 2, we pad the FFT 
%			      	to 1024 points; if PAD = 4, we pad the FFT
%			      	to 2048 points.
%				Defaults to 1.
%	   PVAL		=  P-value to calculate error bars for.
%				Defaults to 0.05 i.e. 95% confidence.
%	   FLAG =   set to 0 to calculate SPEC seperately for each channel/trial.
%               set to 1 to calculate SPEC by pooling across channels/trials.
%               defaults to 1
%      JustPartFlag =   set to 1 if you only want to calculate the partial
%                       coherence of the two signals (after removing 
%                       coherence between them accounted for by the
%                       alignment event). If set to 1, coh will really
%                       return the partial coherence then, and Sx and Sy 
%                       will return partial powers. Defaults to 0
%      ErrType =    If Calculating error bars (which is determined by the
%                   appropriate number of output arguments) this will
%                   determine how to calculate significance. Set to 1 to
%                   do the quick and easy numerical approximations given in
%                   Jarvis and Mitra (2001), and 2 to use the cluster based
%                   Monte Carlo procedure described by Maris et al (2007).
%                   Defaults to 2. Be prepared that this latter procedure 
%                   requires a lot of copmuting time, but it is accurate 
%                   and it will find all the regions of significance in
%                   time and frequency automatically. A note on the quick 
%                   and easy calculations- this is an estimate that's only 
%                   assymptotically accurate and aldo has no protection
%                   against multiple comparisons. It's recommended to only 
%                   use this as a rough estimate for significance.
%
%                   Note that t0 must be included in inpute if doing the 
%                   Shuffling tests in order to tell what is baseline and
%                   activation periods.
%       ZTransFlag = set to 0 to output the raw coherence, set to 1 to 
%                   output the Fisher tarnsformed and bias corrected
%                   coherence, as described in Bokil et al 2007. This 
%                   estimate is primarily distributed as a standard normal 
%                   with unit variance- though Maris et al 2007 argues this
%                   only strictly true for moderate to high coherence 
%                   values (above 0.45...). Note this is not the Z-score 
%                   transform described in section 5.1 (p. 732) in Jarvis
%                   and Mitra 2001. After reading Bokil et al 2007 and
%                   other works, my take is that that transform is inferior
%                   to the Fisher Transform, so I'm not even bothering to
%                   write code for it.
%                   
%                   new on 091118: Set ZTransFLag to 2 to get the Raw Bias
%                   corrected result back. (see MTZTrans_S for details.)
%                   
%                   Note- setting this to one will perform the appropriate 
%                   Z-Transform for all metrics, i.e. coh, Pcoh, Spec and
%                   PSpec...
%
%                   Also note that the transform for power spectra for
%                   actual data seems to give shaky results
%                   
%
%  Outputs:
%       COH	=  Coherency of X and Y in [Time, Freq] form if flag is 1 (the 
%                   default) or [nCh, Time, Freq] form if flag is 0 and
%                   you're not pooling across trials.
%                   The output values are unitless and complex. The 
%                   magnitude of coh ( given by abs(coh) ) ranges from 0 to
%                   1, and the phase angle of coh ( given in radians by
%                   angle(coh) ) ranges from 0 to 2Pi and indicates the
%                   relative phases between the two signals. 
%
%                   Specifically the phase of coh is the phase of X minus 
%                   the phase of Y. So an angle b/t 0 and Pi means X leads 
%                   Y (at that freq), an angle b/t Pi and 2Pi means Y leads X.
%
%                   Addition on 090429- coh can also be the partial
%                   coherence of the two signals, if JustPartFlag is set to
%                   1
%
%	    F		=  Units of Frequency axis for COH.
%       Sx      =  The spectrum of the signal associated with X, the first
%                   input signal, in the same format and size as COH.
%       Sy      =  The spectrum of the signal associated with Y, the second
%                   input signal, in the same format and size as COH and Sx
% 
%                   The spectrum outputs will be PSD estimates (typically 
%                   recommended) in units of mV^2/Hz, but by changing an
%                   option at the start of this file, it can be made to
%                   output the mean-square spectrum, in units of mV^2.
%       Pcoh    =  Partial coherence. This is the coherence of the signal 
%                  after removing coherence between them accounted for by 
%                  the alignment event. Essentially this is the coherence
%                  of the Fourier coefficient residuals.  
%       PSx     =  The partial spectrum of X, i.e. the power of the
%                  residuals of X.
%       PSy     =  The partial spectrum of Y, i.e. the power of the
%                  residuals of Y.
%       N       =  Final Exact Length of the Time Window, in s
%       dN      =  Final Exact Length of the Time Step, in s
%       nwin      =  Final Exact number of windows
%       nReps   =   The number of trials x the number of tapers used for 
%               the estimate provided by a given function call... This is
%               useful in case one wants to transform (or untransform) the
%               data post-hoc
%	    ERR 	=  A data structure with different fields and substructures
%                   depending on the inputs to this function.
%
%               When performing the Monte Carlo permutation tests:
%               err.wintimes- a 1 x nwin vector denoting the center of the 
%                   time windows for all tests done. 
%               err.Coh, err.Spec1, err.PCoh, err.PSpec1, etc. - a
%                   substructure containing results on the tests for that
%                   particular measurement type... further examples in this
%                   comment are shown for err.Coh
%               err.CohNormAboveThresh, etc. - the same as err.Coh, but
%                   with the NormAboveThresh option set to 1, while it'e 
%                   set to 0 below. This is output automatically so the 
%                   userone doesn't have to spend teh processing time 
%                   reshuffling to see how the results look differently by
%                   toggling this option. See comments in teh default for
%                   ClucShuffOpts to explain what the paramter
%                   NormAboveThreshStats does
%               err.Coh.NullTestStatDist- a nShuffs x 1 vector containing
%                   the distribution of the test statistic (the maximum
%                   cluster sum) under the null hypothesis
%               err.Coh.SigThresh- The Cluster Sum that is deemed to be the
%                   threshhold for significance given the pval input
%               err.Coh.Pos, err.Coh.Neg- Information about clusters
%                   positively above or negatively below the threshhold,
%                   respectively... further examples in this comment shown
%                   for err.Coh.Pos
%               err.Coh.Pos.NSigClus- the numbe rof significant positive
%                   clusters
%               err.Coh.Pos.SigClusSums- The test statistic (i.e. positive
%                   cluster sums) for all the significant clusters
%               err.Coh.Pos.SigClusPVals- The pval for each sig. clus
%               err.Coh.Pos.SigClusTFCens- a NSigClus x 2 array showing the
%                   mean time (column 1) and frequency (column 2) for each
%                   significant cluster
%               err.Coh.Pos.SigClusAssign- a nwin x nfreq array that
%                   denotes the location of the significant clusters. The
%                   values of SigClusAssign are the value of the cluster
%                   number corresponding to that particular time and freq, 
%                   or 0 if there is no cluster in that location.
%               err.Coh.Pos.Clu- a NSigClus x 1 substructure. For each
%                   suignificant cluster, this substructure has fields
%                   RawCoords- which denotes the indices in ClusAssign for
%                   this cluster, and AllTFVals, which translate those
%                   RawCoords into time and freq vals, and TFCen, which
%                   shows the mean time and frequency for all points in the
%                   cluster.
%               err.Coh.Pos.AllClusSums, AllClusAssign, AllPVals, AllTFCens
%                   have the same info as the corresponding SigClusSums,
%                   etc. but for every possible cluster, significant or
%                   non-significant. A cluster is any adjacent group of
%                   time-freq windows with test statistics above teh
%                   threshhold, and can be as small as 1 time-freq window
%
%
%       *Note,  calculating error bars does take awhile; so the code only 
%               calculates them if the function call has the needed amount 
%               of output arguments. Be prepared to wait if you do this               
%
%        *Also note- you usually want to include half a time-window 
%               before, and half a time window after your time of interest
%               in the data inputted to the function
%
%       Matt Nelson
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%set options that are specific to this type of analysis (needed in dmtUbiq_S later)   
TwoSigsFlag=1;
SpkFlag=[0 0];

scale=1;
FSPadFlag=0;    % Set to 1 if you want the number of points in the FFT to be a the next power of 2 "relative to multiple of the Sampling rate in Hz" rather than always a power of 2. 
                % The advantage of this is that the specific frequencymeasurements you make will be done at more round numbers.
                % The disadvantage is that if Fs is not a power of 2, this means the FFT algorithm will run more slowly
detrendflag=0;  % Set to 1 if you want to detrend the data before taking FFT
%normfreqs=0;    %to adjust the vals of spec if plotting by normalizing each freq across time... this makes it impossible to compare across freqs, but allows visualization of less dominant freqs simultaneously with more dominant freqs

PSDScaleFlag=1;     %set to 1 to scale (the optional spectral output) according to PSD, set to 0 to scale according to mean-square spectrum... note that only odd taper numbers can be included for the scaling according to the mean-square spectrum b/c the even tapers all sum to zero
%note that scaling according to PSD maintains a meaningful area under the curve, while scaling according the mean-square
%spectrum maintain values proportional to the power of the sinusoid of a given height...

NoPadForClusShuff=1;    %setting this to 1 will force there to be no zero-padding if cluster shuffling is used

if nargin<15 || isempty(ClusShuffOpts);        ClusShuffOpts=[];      end
            
if nargin < 14 || isempty(ZTransFlag);    ZTransFlag=0;     end
if nargin < 13 || isempty(errType);    errType=2;     end
if nargin < 12 || isempty(JustPartFlag);    JustPartFlag=0;     end
%if nargin < 12 || isempty(flag) flag = 1; end       %not- this option is no longer supported... there was no reason to use it...
if nargin < 11 || isempty(pval) pval = 0.05; end
if nargin < 10 || isempty(pad) pad = 1; end
if nargin < 9 || isempty(normfreqs);    normfreqs=0;    end    %to adjust the vals of spec if plotting by normalizing each freq across time... this makes it impossible to compare across freqs, but allows visualization of less dominant freqs simultaneously with more dominant freqs
if nargin < 8 || isempty(t0)  t0=0; end
if nargin < 7 || isempty(plotflag)  plotflag=1; end
if nargin<6 || isempty(fk)  fk = [0,200]; end
if nargin<5 || isempty(dn) dn=.01; end %In seconds. 
%if nargin < 4 dn = n/10; end % Bijan's default within tfspec, where n is the length of the tapers in seconds
if nargin<4 || isempty(sampling)   sampling=1000; end

if nargin>2 && isstruct(tapers)
    options=tapers;
    tapers=[];
    
    fieldlist=fieldnames(options);
    for ifld=1:length(fieldlist)
        %code below tests to see if the field name in options is ClusShuffOpts, and only writes over specific fields of ClusShuffOpts      
        if strcmp(fieldlist{ifld},'ClusShuffOpts')
            tmpStruc=options.(fieldlist{ifld});
            
            tmpfieldlist=fieldnames(tmpStruc);
            for ifld2=1:length(tmpfieldlist)
                if length(tmpStruc.(tmpfieldlist{ifld2}))>1     %this section in general may not be the best way to do this, but it works...   
                    if size(tmpStruc.(tmpfieldlist{ifld2}),1)>1     
                        ClusShuffOpts.(tmpfieldlist{ifld2})=tmpStruc.(tmpfieldlist{ifld2});
                    else
                        eval(['ClusShuffOpts.' tmpfieldlist{ifld2} '=[' num2str(tmpStruc.(tmpfieldlist{ifld2})) '];']);
                    end
                else
                    eval(['ClusShuffOpts.' tmpfieldlist{ifld2} '=' num2str(tmpStruc.(tmpfieldlist{ifld2})) ';']);
                end
            end
        else            
            if length(options.(fieldlist{ifld}))>1
                eval([fieldlist{ifld} '=[' num2str(options.(fieldlist{ifld})) '];']);
            else
                eval([fieldlist{ifld} '=' num2str(options.(fieldlist{ifld})) ';']);
            end
        end
    end    
end

MTClusShuffOptsDefaults 

if length(fk) == 1;    fk = [0,fk];      end
if fk(2)>sampling/2;  fk(2)=sampling/2;   end

if nargin<3 || isempty(tapers)
    tapers(1) = .200; %This is N, the window length, in seconds
    tapers(2) = 5; %This is W, the frequency resolution, in Hz.
    
    %n = floor(nt./10)./sampling;
    %if nargin < 2 tapers = [n,3,5]; end  %Bijan's default within tfspec, perhaps useful for reference later    
end   
if length(tapers) == 2
    n = tapers(1);
    w = tapers(2);
    k = floor(2*n*w-1);
    tapers = [n,w,k];
    %   disp(['Using ' num2str(k) ' tapers.']);
end
if length(tapers) == 3
    %disp('in LFPSPec checking tapers')
    
    if tapers(3)> floor(2*tapers(1)*tapers(2)-1) %this adjusts k automatically and notifies the user if they enter a value for k larger than the usable amount 
        disp(['Had to decrease number of tapers from: ' num2str(tapers(3)) ' to 2*n*w-1, which is: ' num2str(floor(2*tapers(1)*tapers(2)-1))])
        tapers(3)=floor(2*tapers(1)*tapers(2)-1);
    end
    tapers(2)=tapers(2)*tapers(1);  %convert to [n,p,k] form for dpsschk and matlab's dpss
    tapers(1) = tapers(1).*sampling; %# of samples in window
    
    if ~isint(tapers(1))
        tapers(1)=round(tapers(1));
        disp(['Had to adjust window length to ' num2str(tapers(1)) ' samples for a ' num2str(tapers(1)/sampling*1e3) ' msec window.'])
    end    
    tapers = dpss(tapers(1),tapers(2),tapers(3))';   %try this to see if it improves speed... We don't really need to check the taper inputs       
    %tapers = dpsschk(tapers);   %Note: These are already normalized to have a total energy of one
    
    %                               i.e. sum(tapers.^2,1) = 1 for each
    %                               taper (with each down each column of tapers)

%     if scale    % But we may want sum(tapers)=1, which is the equivalent of dividing by the number of samples at the end
%         tmpsum=sum(abs(tapers));
%         for it=1:size(tapers,2) 
%             tapers(:,it)=tapers(:,it)/tmpsum(it);
%             tmpsum(it);
%             sum(tapers(:,it));
%         end
%     end

    %tapers = tapers*sqrt(sampling);
    %NOTE- instead of taking the sqrt of tapers, I deal with that later...
    %after the windowed FFT to corrcetly account for the units
end

% Determine outputs
if nargout > 5 || JustPartFlag;     CalcPart = 1;    else        CalcPart = 0;       end
if nargout > 11; errorchk = 1;    else        errorchk = 0;       end
if nargout > 3; CalcSpec = 1;    else        CalcSpec = 0;       end
if nargout > 6 || JustPartFlag;     CalcPartSpec = 1;    else        CalcPartSpec = 0;       end
if errorchk && ~any([ClusShuffOpts.CohTest ClusShuffOpts.SpecTest ClusShuffOpts.PCohTest ClusShuffOpts.PSpecTest])
    errorchk=0;
end
if NoPadForClusShuff && errorchk && errType==2       
    pad=0;
    disp(['Setting zero-padding factor to 0 (no padding) for Cluster Shuffle Test'])
    %Note- because for speed the cluster shuffling we do does not recalculate the FFT every shuffle,
    %There should be no zero-padding to provide a fair comparison between the shuffled data and the real data.
    %If zero-padding with shuffling is desired, it would be necessary to rewrite the code to recalcluate the FFTs every shuffle, which in trun would slow the code down considerably      
end

if nargout > 5 && JustPartFlag;
    %disp('In LFP_LFP Coh., calcing just the partial coh, given in first output (coh). 6th output (PCoh) will be empty.')
    Pcoh=[];
end

if CalcSpec
    if PSDScaleFlag;     estStr='PSD';      else    estStr='MS Spectrum';      end
    %disp(['In LFP_LFP Coh., and will calc spec also. Spec output units will be: ' estStr])
end

%this is where tfFFCoh_S used to be called...
sX = size(X);
nt = sX(2);              % calculate the number of points
nch = sX(1);               % calculate the number of channels

sY = size(Y);
nt2 = sY(2);              % calculate the number of points
nch2 = sY(1);               % calculate the number of channels

if nt ~= nt2 error('Error: Input time series are not the same length'); end 
if nch ~= nch2 error('Error: Input time series have different numbers of trials'); end 

[K N] = size(tapers); %K is # of tapers, N is number of Samples in a taper
%[N K] = size(tapers); %if going down dim 1... K is # of tapers, N is number of Samples in a taper    
if N > nt error(['Error: You probably need to transpose (rotate) your input data. Taper length: ' num2str(N) ' is longer than the time series, length: ' num2str(nt)]); end

dn = dn.*sampling;  %convert to number of samples
if ~isint(dn)
    dn=round(dn);
    disp(['Had to round dn to ' num2str(dn) ' samples for a ' num2str(dn/sampling*1e3) ' ms slide.'])
end

%for speed- I'm removing the insistance that 256 be the min # of points for the fft 
if pad==0
    nf=N;
else
    if FSPadFlag    nf = sampling*pad*2^nextpow2(N/sampling);  %nf = max(sampling*2^nextpow2(256/sampling), sampling*pad*2^nextpow2(N/sampling));
    else    nf = pad*2^nextpow2(N+1);    end    %nf = max(256, pad*2^nextpow2(N+1));     end %# of points for FFT
end

fstep=sampling/nf;
nfk(1)=floor(fk(1)/fstep)+1;    %this gives the index we go to for the FFT. It's plus 1 because the first index is the DC value. Note we can't always get any arbitrary frequency unless its a multiple of fstep
nfk(2)=ceil(fk(2)/fstep)+1;
nrecf=nfk(2)-nfk(1)+1;
f=(nfk(1)-1)*fstep:fstep:(nfk(2)-1)*fstep;
if iseven(nf) && f(end)==sampling/2 incNy=1;
else incNy=0;   end

% nfk = floor(fk/sampling*nf);  %Older not quite correct way of doing this
% f = linspace(fk(1),fk(2),diff(nfk));

nwin = (nt-N)/dn+1;           % calculate the number of windows
if ~isint(nwin)
    nwin=floor(nwin);
    %disp('Had to round nwin down and cut off some of the data')
end

%t0=0; %ms time for first data sample; which is not actually included in x-axis plot
Nms=N*1000/sampling; %convert back to ms
dnms=dn*1000/sampling; %convert back to ms
tout=([0:nwin-1])*dnms+t0+Nms/2; %center of win- used for plotting


% Pooling across trials
coh = zeros(nwin,diff(nfk)+1);
%coh = zeros(diff(nfk)+1,nwin);     %if going down dim 1

if CalcPart && ~JustPartFlag
    Pcoh=coh;
end
if CalcSpec
    Sx=coh;
    Sy=coh;
    if CalcPartSpec && ~JustPartFlag
        PSx=coh;
        PSy=coh;
    end
end
%if errorchk     err = zeros(2,nwin,diff(nfk)+1);        end

%Init vals for ShuffTest
nReps=nch*K;
SplitTrsFlag=false;
if errorchk && errType==2   
    if isstr(ClusShuffOpts.TestType)
        if ClusShuffOpts.TestType=='vsBase';    ClusShuffOpts.TestType=1;
        elseif ClusShuffOpts.TestType=='vsCond';    ClusShuffOpts.TestType=2;
        else
            errorchk=flase;
            warning('Attempting to do a shuffling test, but ClusShuffOpts.TestType was not recognized.')
            disp('No shuffling or error checking being done.')
        end
    end
        
    if ClusShuffOpts.TestType==2 && isempty(ClusShuffOpts.TrType) && errorchk       
        errorchk=flase;
        warning('ClusShuffOpts.TestType==2 for across Cond shuffling, but ClusShuffOpts.TrType was not entered or is empty.')
        disp('No shuffling or error checking being done.')
    else
        MTShuffTestInit_S
    end
    
    if errorchk && ClusShuffOpts.TestType==2;        
        SplitTrsFlag=true;       
        Tr1Inds=ClusShuffOpts.TrType==1;
        Tr2Inds=ClusShuffOpts.TrType==2;
    end    
end

if SplitTrsFlag
    err.TrType1.coh = coh;
    err.TrType2.Pcoh=coh;
    if CalcPart && ~JustPartFlag
        err.TrType1.Pcoh=coh;
        err.TrType2.Pcoh=coh;
    end
    if CalcSpec
        err.TrType1.Sx=coh;
        err.TrType2.Sx=coh;
        err.TrType1.Sy=coh;
        err.TrType2.Sy=coh;
        if CalcPartSpec && ~JustPartFlag
            err.TrType1.PSx=coh;
            err.TrType2.PSx=coh;
            err.TrType1.PSy=coh;
            err.TrType2.PSy=coh;
        end
    end
end

%X=X';
%Y=Y';
for win = 1:nwin
    dat1 = X(:,(win-1)*dn+1:(win-1)*dn+N);   %changed to win-1 becasue that ignored the first few samples, also added 1 to nwin above
    dat2 = Y(:,(win-1)*dn+1:(win-1)*dn+N);
    %tmp1 = X((win-1)*dn+1:(win-1)*dn+N,:);   %changed to win-1 becasue that ignored the first few samples, also added 1 to nwin above
    %tmp2 = Y((win-1)*dn+1:(win-1)*dn+N,:);
    
    %dmtFFCoh_S
    dmtUbiq_S    
end

if errorchk 
    if SplitTrsFlag
        MTShuffCondsTest_S
    else
        MTShuffTest_S   %This script performs either the shuffle test or the quick and easy analytical assumption test, based on the value of errType
    end
end

if ZTransFlag
    MTZTrans_S
else
    tmpdf1=repmat(2*nReps,nwin,nrecf);
    tmpdf2=repmat(2*nReps,nwin,nrecf);
end

if plotflag
    if plotflag==1  figure;   end
    normplot=0;
    if normplot
        mcoh=max(max( abs(coh) ));
        coh=coh/mcoh;
    end
        
    if normfreqs    %subtract mean across time for each freq
        %coh=coh-repmat(min(coh),size(coh,1),1);
        coh=(coh-repmat(mean(coh),size(coh,1),1)) ./ repmat(mean(coh),size(coh,1),1);
    end
    
    %imagesc(log10(abs(coh'+1e-20)))
    imagesc((abs(coh'))) %[-8 -7.99] add 1e-8 to avoid plotting log of zero, it happens with fake data sometimes
    axis xy
    colorbar
    axhand=gca;
    
    %I don't think a log trans is needed for displaying coh
    
    numYTicks=6;
    numXTicks=6;
    freqind=round(linspace(1,length(f),numYTicks));
    freqvals=round(f(freqind));
    freqind(1)=.5;
    set(axhand,'YTickLabel',freqvals);
    set(axhand,'YTick',freqind);

    tind=round(linspace(1,nwin,numXTicks));
    tvals=(tind-1)*dnms+t0+Nms/2;
    tind(1)=.5;
    set(axhand,'XTickLabel',tvals);
    set(axhand,'XTick',tind);
    
    ylabel('Frequency (Hz)')
    xlabel('Center of Time window (ms)')
    title(['MT Field/Field coherence mag with ' num2str(Nms) ' ms window sliding ' num2str(dnms) ' at a time.'])
end
    
%inc Pcoh, PSx, PSy as an output here if needed...
if JustPartFlag
    if nargout>5;    Pcoh=coh;   end
    if nargout>6;    PSx=Sx;   end
    if nargout>7;    PSy=Sy;   end
end