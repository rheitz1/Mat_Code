function TapersOut=PreGenTapers(tapers,sampling)
% function TapersOut=PreGenTapers(tapers,sampling)
%
% Will pre-generate TapersOut for passage in to LFPSpec (or related
% programs) multiple times without having to regenerate the tapers inside
% of LFPSpec, thus saving time.
%
% tapers and sampling are the inputs needed to do this, which are accepted
% in the same they are accepted in LFPSpec. Their explanation is reproduced
% below
%
%       TAPERS  =   Typically in [N,W] form, where N is the window length in seconds,
%                   and W is the frequency resolution (half-bandwidth), in 
%                   Hz. Defaults are .2 for N, and 5 for W (this default is
%                   the one slep. spec. with a bandwidth of 5 Hz)
%
%                   The number of slep sequences typically used is 2*NW-1.
%                   SO: SET NW EQUAL TO 1 TO JUST GET THE FIRST TAPER.
%                   
%                   Can also accept [N,W,K] form, where K is the number
%                   of tapers you want to keep, starting with the first
%
%                   Can also accept [TIME,K] form where the tapers are already
%                   calculated, with each taper you want to use down each
%                   column. Useful if you want to use this sliding window code for
%                   non-Slepian tapers, like Gaussian or rectangular, etc.
%               
%	    SAMPLING 	=  Sampling rate of time series X in Hz. 
%				Defaults to 1000 Hz (for the Lo Sampling data)
%
%       Matt Nelson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%setMWorkPath

%if nargin<3
if nargin<2 || isempty(sampling);   sampling=1000; end
if nargin<1 || isempty(tapers)
    tapers(1) = .200; %This is N, the window length, in seconds
    tapers(2) = 5; %This is W, the frequency resolution, in Hz.   
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
    tapers(1) = tapers(1).*sampling; % # of samples in window
    
    if ~isint(tapers(1))
        tapers(1)=round(tapers(1));
        disp(['Had to adjust window length to ' num2str(tapers(1)) ' samples for a ' num2str(tapers(1)/sampling*1e3) ' msec window.'])
    end
    %disp('Creating tapers via dpss')
    TapersOut = dpss(tapers(1),tapers(2),tapers(3))';
    
    %disp('Creating tapers via dpsschk')
    %TapersOut = dpsschk(tapers);   %Note: These are already normalized to have a total energy of one
    %                               i.e. sum(tapers.^2,1) = 1 for each
    %                               taper (with each down each column of
    %                               tapers)
else
    disp('Input Tapers length was not 1x2 or 1x3... tapers not being created, assigning input tapers to output')
    TapersOut=tapers;
end