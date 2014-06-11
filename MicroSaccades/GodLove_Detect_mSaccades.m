function [mSaccBegin...
    mSaccEnd...
    mSaccAmplitude...
    mSaccDirection...
    mSaccVelocity...
    mSaccDuration...
    radial_vel...
    vel_x...
    vel_y...
    thresh_x...
    thresh_y...
    thresh_cross...
    mSaccBegin_x...
    mSaccBegin_y...
    mSaccEnd_x...
    mSaccEnd_y...
    SaccsNBlinks] = Detect_mSaccades(EyeX_,...
    EyeY_,...
    TrialStart_,...
    Eot_,...
    force_thresh)
% This function detects saccades using the method of Enbert and Kliegl.
% (2003. VisRes).  This method was originally developed for microsaccades.
% It then performs some common sense checks and throws out detections which 
% don't match criteria for real saccades.  See the code as there are many 
% options which may need to be tweaked for your particular setup.
% 
% Written by david.c.godlove@vanderbilt.edu 08-2011
% 
% INPUT:
%     EyeX_          = Analog channel containing horizontal eye postion
%                      IN DEGREES sampled at 1kH. (Center at 0.  Leftward 
%                      movement denoted by negative numbers.)
%     EyeY_          = Analog channel containing vertical eye postion.
%                      (Conventions as above. Upward denoted by negative.)
%
% OPTIONAL INPUT:
%     TrialStart_    = Column vector containing absolute start time for 
%                      each trial in ms.
%     Eot_           = Column vector containing trial end times in ms. (If
%                      sacc detection during inter-trial interval is 
%                      desired, enter [TrialStart(2:end) - 1;length(EyeX_)
%                      - 1]
%     force_thresh   = Set a velocity threshold (in deg/s) for sacc
%                      detection. If ommitted or empty thresholds are
%                      determined on trial by trial basis based on
%                      background noise.
%
% OUTPUT:
%     mSaccBegin     = (m X n) matrix of timestamps (ms)denoting saccade start
%                      times where m is the number of trials and n is the
%                      number of saccades in a given trial.
%                      produce a single ERP for the data.
%     mSaccEnd       = See mSaccBegin
%     mSaccAmplitude = Same format as above but values are sacc amplutude
%                      (start to end point) in degrees.
%     mSaccDirection = Same format as above but values are sacc direction
%                      in polar degrees (right=0 left=180).
%                      (start to end point) in degrees.
%     mSaccVelocity  = Same format as above but values are peak velocity in
%                      radial deg/s.
%     mSaccDuration  = Same format as above but values are sacc duration in
%                      ms.  
% [mSaccBegin...
%     mSaccEnd...
%     mSaccAmplitude...
%     mSaccDirection...
%     mSaccVelocity...
%     mSaccDuration] = Detect_mSaccades(EyeX_,...
%     EyeY_,...
%     TrialStart_,...
%     Eot_,...
%     force_thresh)
% 
% see also Detect_Saccades.m

debug = 1;

if nargin < 4, TrialStart_ = 1; Eot_ = length(EyeX_)-1; end
if nargin < 5, force_thresh = []; end

%__________________________________________________________________________
% Step #1.  Take 1st derivitave (velocity) across 20ms window (for
% smoothing), and raw 1st derivitave plus instantaneous change in angle for
% use later.
% (Enbert and Kliegl. 2003. VisRes)
%__________________________________________________________________________

fprintf('\nSmoothing and differentiating x trace...')
temp_x = integrate20(EyeX_);
fprintf('done!\n\n')
fprintf('Smoothing and differentiating y trace...')
temp_y = integrate20(EyeY_);
fprintf('done!\n\n')
temp_x_raw = [nan;diff(EyeX_)];
temp_y_raw = [nan;diff(EyeY_)];
temp_theta = mod((180/pi * atan2(temp_y_raw,temp_x_raw)),360);
temp_theta = [nan;diff(temp_theta)];



%__________________________________________________________________________
% Step #2.  Put all of the saccade data into an array representing trials
%__________________________________________________________________________
fprintf('Rearranging data into arrays...')
% if length(Eot_) > 1
%     too_long_check = Eot_; % the user may pause the task leading to a long iti.  this can cause memory issues.
%     too_long       = 3 * std(too_long_check);
%     too_long_check(too_long_check > too_long) = nan;
%     Eot_(isnan(too_long_check)) = max(too_long_check);
% end
trial_ends     = TrialStart_ + Eot_;
longest        = max(Eot_);
vel_x(1:length(TrialStart_),1:longest) = nan;
vel_y          = vel_x;
vel_x_raw      = vel_x;
vel_y_raw      = vel_x;
inst_theta     = vel_x;

for ii = 1:length(TrialStart_)
    start_  = TrialStart_(ii);
    end_    = trial_ends(ii);
    length_ = Eot_(ii) + 1;
    vel_x(ii,1:length_)      = temp_x(start_:end_);
    vel_y(ii,1:length_)      = temp_y(start_:end_);
    vel_x_raw(ii,1:length_)  = temp_x_raw(start_:end_);
    vel_y_raw(ii,1:length_)  = temp_y_raw(start_:end_);
    inst_theta(ii,1:length_) = temp_theta(start_:end_);
end

clear temp_x temp_y temp_x_raw temp_y_raw temp_theta

radial_vel = sqrt((vel_x.^2) + (vel_y.^2));
fprintf('done!\n\n')



%__________________________________________________________________________
% Step #3.  Figure out the amount of noise in the recording on a trial by
% trial basis. Set threshold, and record threshold crossings
% (Enbert and Kliegl. 2003. VisRes) - aka furball analysis
%__________________________________________________________________________
fprintf('Finding threshold crossings...')
lambda   = 6; % Enbert and Kliegl used 6
cutoff   = 30; % for removing macro saccades


temp_x = vel_x;
temp_y = vel_y;
% Enbert and Kliegl did not remove macro saccades before starting
% ***************
temp_x(temp_x > cutoff) = nan;
temp_x(temp_x < -cutoff) = nan;
temp_y(temp_y > cutoff) = nan;
temp_y(temp_y < -cutoff) = nan;
% ***************

sigma_x  = (nanmedian((temp_x .^2),2)) - ((nanmedian(temp_x,2)) .^2);
sigma_y  = (nanmedian((temp_y .^2),2)) - ((nanmedian(temp_y,2)) .^2);

if isempty(force_thresh)
    thresh_x = lambda * sigma_x;
    thresh_y = lambda * sigma_y;
else
    thresh_x = sigma_x;
    thresh_y = sigma_y;
    thresh_x(:) = force_thresh;
    thresh_y(:) = force_thresh;
end

thresh_x = repmat(thresh_x,1,length(vel_x(1,:)));
thresh_y = repmat(thresh_y,1,length(vel_y(1,:)));

warning('off','MATLAB:divideByZero')
theta   = abs(atan(vel_y./vel_x)); % angles
warning('on','MATLAB:divideByZero')
cir_rho = sqrt((vel_x .^2) + (vel_y .^2)); % polar coordinates for circle (pythagorean theorem)
ell_rho = ellipse_rho(thresh_x,thresh_y,theta);

thresh_cross = cir_rho > ell_rho;

if debug
    display_saccs(vel_x,vel_y,thresh_x,thresh_y,thresh_cross)
end
fprintf('done!\n\n')



%__________________________________________________________________________
% Step #4.  Remove saccades which turn by >15 degrees between successive
% time points.
% (Martinez-Conde, Macknik, & Hubel. 2000. Nature)
%__________________________________________________________________________
% straight   = inst_theta < 15; %LOOK AT NEG AND POS
% sacc_logic = thresh_cross & straight;
sacc_logic = thresh_cross; %Actually, turns out we get better looking main sequences without this weirdness!



%__________________________________________________________________________
% Step #5.  Figure out when saccades began and ended and record dynamics
% etc.  (See Detect_Saccades.m)
%__________________________________________________________________________
fprintf('Calculating saccade dynamics...')
[numTrials maxSamples] = size(sacc_logic);
% Preallocate matrices with all values set to NaN
mSaccBegin(1:numTrials,1:maxSamples)     = NaN;
mSaccEnd(1:numTrials,1:maxSamples)       = NaN;
mSaccAmplitude(1:numTrials,1:maxSamples) = NaN;
mSaccDirection(1:numTrials,1:maxSamples) = NaN;
mSaccVelocity(1:numTrials,1:maxSamples)  = NaN;
mSaccDuration(1:numTrials,1:maxSamples)  = NaN;
mSaccBegin_x(1:numTrials,1:maxSamples)   = NaN;
mSaccBegin_y(1:numTrials,1:maxSamples)   = NaN;
mSaccEnd_x(1:numTrials,1:maxSamples)     = NaN;
mSaccEnd_y(1:numTrials,1:maxSamples)     = NaN;


% Get threshold test
zeropad(1:numTrials,1) = 0;
sacc_logic(:,1) = 0; %b/c I don't care about saccades happening during trial start.
ThresholdTest = [zeropad diff(sacc_logic,1,2)];

% Find saccade starts and ends
for ii = 1:numTrials
    curr_thresh_test = ThresholdTest(ii,:);
    curr_starts = find(curr_thresh_test == 1);
    curr_ends   = find(curr_thresh_test == -1);
    curr_ends(curr_starts == 2) =[];
    curr_starts(curr_starts == 2) = [];

    % check for screw ups.
    if length(curr_starts) > length(curr_ends)
        curr_starts(end) = [];
    end
    if length(curr_starts) ~= length(curr_ends) |...
            min(curr_ends - curr_starts) <= 0 %#ok<OR2> suppress mlint warning
        error('Error: Unhandled exception parsing saccade starts and ends. (Call David.)')
    end

    mSaccBegin(ii,1:length(curr_starts)) = curr_starts;
    mSaccEnd(ii,1:length(curr_ends))     = curr_ends;

    % Get saccade dynamics
    curr_trl_start = TrialStart_(ii);
    curr_x_s_pos = EyeX_(curr_trl_start + curr_starts);
    curr_y_s_pos = EyeY_(curr_trl_start + curr_starts);
    curr_x_e_pos = EyeX_(curr_trl_start + curr_ends);
    curr_y_e_pos = EyeY_(curr_trl_start + curr_ends);

    mSaccBegin_x(ii,1:length(curr_starts)) = curr_x_s_pos;
    mSaccBegin_y(ii,1:length(curr_starts)) = curr_y_s_pos;
    mSaccEnd_x(ii,1:length(curr_starts)) = curr_x_e_pos;
    mSaccEnd_y(ii,1:length(curr_starts)) = curr_y_e_pos;

    for jj = 1:length(curr_starts)
        this_start           = curr_starts(jj);
        this_end             = curr_ends(jj);
        mSaccVelocity(ii,jj) = max(radial_vel(ii,this_start:this_end));
    end
end

mSaccDuration = mSaccEnd - mSaccBegin;
deltaX = mSaccEnd_x - mSaccBegin_x;
deltaY = mSaccEnd_y - mSaccBegin_y;
mSaccDirection = mod((180/pi * atan2(deltaY,deltaX)),360);
mSaccAmplitude = sqrt((deltaX.^2) + (deltaY.^2));
fprintf('done!\n\n')

%__________________________________________________________________________
% Step #6.  Remove and noise using common-sense checks
%__________________________________________________________________________
fprintf('Deleting junk...')

isi_cutoff = 50;
isi = mSaccBegin - circshift(mSaccEnd,[0 1]);
while sum(sum(isi < isi_cutoff))
    
    % remove offending saccades
    mSaccBegin    (isi < isi_cutoff) = nan;
    mSaccEnd      (isi < isi_cutoff) = nan;
    mSaccDirection(isi < isi_cutoff) = nan;
    mSaccVelocity (isi < isi_cutoff) = nan;
    mSaccDuration (isi < isi_cutoff) = nan;
    mSaccAmplitude(isi < isi_cutoff) = nan;
    mSaccBegin_x(isi < isi_cutoff) = nan;
    mSaccBegin_y(isi < isi_cutoff) = nan;
    mSaccEnd_x(isi < isi_cutoff) = nan;
    mSaccEnd_y(isi < isi_cutoff) = nan;
    
    % push all nans to the right of the arrays
    for ii = 1:length(mSaccBegin(:,1))
        
        curr_nums = find(~isnan(mSaccBegin(ii,:)));
        
        jj = length(curr_nums);
        
        mSaccBegin    (ii,1:jj) = mSaccBegin    (ii,curr_nums);
        mSaccEnd      (ii,1:jj) = mSaccEnd      (ii,curr_nums);
        mSaccDirection(ii,1:jj) = mSaccDirection(ii,curr_nums);
        mSaccVelocity (ii,1:jj) = mSaccVelocity (ii,curr_nums);
        mSaccDuration (ii,1:jj) = mSaccDuration (ii,curr_nums);
        mSaccAmplitude(ii,1:jj) = mSaccAmplitude(ii,curr_nums);
        mSaccBegin_x  (ii,1:jj) = mSaccBegin_x  (ii,curr_nums);
        mSaccBegin_y  (ii,1:jj) = mSaccBegin_y  (ii,curr_nums);
        mSaccEnd_x    (ii,1:jj) = mSaccEnd_x    (ii,curr_nums);
        mSaccEnd_y    (ii,1:jj) = mSaccEnd_y    (ii,curr_nums);
        
        mSaccBegin    (ii,jj+1:end) = nan;
        mSaccEnd      (ii,jj+1:end) = nan;
        mSaccDirection(ii,jj+1:end) = nan;
        mSaccVelocity (ii,jj+1:end) = nan;
        mSaccDuration (ii,jj+1:end) = nan;
        mSaccAmplitude(ii,jj+1:end) = nan;
        mSaccBegin_x  (ii,jj+1:end) = nan;
        mSaccBegin_y  (ii,jj+1:end) = nan;
        mSaccEnd_x    (ii,jj+1:end) = nan;
        mSaccEnd_y    (ii,jj+1:end) = nan;
        
    end
    
    % and look again
    isi = mSaccBegin - circshift(mSaccEnd,[0 1]);
    
end


% 0.01 degrees is the published lower res limit for eye-link
mSaccBegin    (mSaccAmplitude < .01 | mSaccAmplitude > 15) = nan;
mSaccEnd      (mSaccAmplitude < .01 | mSaccAmplitude > 15) = nan;
mSaccDirection(mSaccAmplitude < .01 | mSaccAmplitude > 15) = nan;
mSaccVelocity (mSaccAmplitude < .01 | mSaccAmplitude > 15) = nan;
mSaccDuration (mSaccAmplitude < .01 | mSaccAmplitude > 15) = nan;
mSaccAmplitude(mSaccAmplitude < .01 | mSaccAmplitude > 15) = nan;

SaccsNBlinks = mSaccBegin; %for truncating ERPs etc.


% delete saccades recorded outside of calibrated area (central 22 degrees).
out = abs(mSaccBegin_x) > 11 | abs(mSaccBegin_y) > 11 | abs(mSaccEnd_x) > 11 | abs(mSaccEnd_y) > 11;
mSaccBegin    (out) = nan;
mSaccEnd      (out) = nan;
mSaccDirection(out) = nan;
mSaccVelocity (out) = nan;
mSaccDuration (out) = nan;
mSaccAmplitude(out) = nan;
mSaccBegin_x  (out) = nan;
mSaccBegin_y  (out) = nan;
mSaccEnd_x    (out) = nan;
mSaccEnd_y    (out) = nan;

% delete saccades with super short or long durations (arrived at values by inspection of main sequences).
long_short = mSaccDuration < 10 | mSaccDuration > 65;
mSaccBegin    (long_short) = nan;
mSaccEnd      (long_short) = nan;
mSaccDirection(long_short) = nan;
mSaccVelocity (long_short) = nan;
mSaccAmplitude(long_short) = nan;
mSaccDuration (long_short) = nan;
mSaccBegin_x  (long_short) = nan;
mSaccBegin_y  (long_short) = nan;
mSaccEnd_x    (long_short) = nan;
mSaccEnd_y    (long_short) = nan;


% push all nans to the right of arrays
for ii = 1:length(mSaccBegin(:,1))
    
    curr_nums = find(~isnan(mSaccBegin(ii,:)));
    
    jj = length(curr_nums);
    
    mSaccBegin    (ii,1:jj) = mSaccBegin    (ii,curr_nums);
    mSaccEnd      (ii,1:jj) = mSaccEnd      (ii,curr_nums);
    mSaccDirection(ii,1:jj) = mSaccDirection(ii,curr_nums);
    mSaccVelocity (ii,1:jj) = mSaccVelocity (ii,curr_nums);
    mSaccDuration (ii,1:jj) = mSaccDuration (ii,curr_nums);
    mSaccAmplitude(ii,1:jj) = mSaccAmplitude(ii,curr_nums);
    mSaccBegin_x  (ii,1:jj) = mSaccBegin_x  (ii,curr_nums);
    mSaccBegin_y  (ii,1:jj) = mSaccBegin_y  (ii,curr_nums);
    mSaccEnd_x    (ii,1:jj) = mSaccEnd_x    (ii,curr_nums);
    mSaccEnd_y    (ii,1:jj) = mSaccEnd_y    (ii,curr_nums);
    
    mSaccBegin    (ii,jj+1:end) = nan;
    mSaccEnd      (ii,jj+1:end) = nan;
    mSaccDirection(ii,jj+1:end) = nan;
    mSaccVelocity (ii,jj+1:end) = nan;
    mSaccDuration (ii,jj+1:end) = nan;
    mSaccAmplitude(ii,jj+1:end) = nan;    
    mSaccBegin_x  (ii,jj+1:end) = nan;
    mSaccBegin_y  (ii,jj+1:end) = nan;
    mSaccEnd_x    (ii,jj+1:end) = nan;
    mSaccEnd_y    (ii,jj+1:end) = nan;
    
end



% delete the last n rows which have no saccades in them
nancheck = nansum(mSaccBegin);
nancheck = fliplr(nancheck);
first_number = find(nancheck ~= 0,1,'first') - 1;

mSaccBegin    (:,end-first_number+1:end) = [];
mSaccEnd      (:,end-first_number+1:end) = [];
mSaccDirection(:,end-first_number+1:end) = [];
mSaccVelocity (:,end-first_number+1:end) = [];
mSaccDuration (:,end-first_number+1:end) = [];
mSaccAmplitude(:,end-first_number+1:end) = [];
mSaccBegin_x  (:,end-first_number+1:end) = [];
mSaccBegin_y  (:,end-first_number+1:end) = [];
mSaccEnd_x    (:,end-first_number+1:end) = [];
mSaccEnd_y    (:,end-first_number+1:end) = [];
fprintf('done!\n\n')

end





%__________________________________________________________________________
% sub fuction for displaying threshold crossing in debugging
function display_saccs(vel_x,vel_y,thresh_x,thresh_y,thresh_cross)
for ii = 1:length(vel_x(:,1))
    curr_thresh_x = thresh_x(ii,1);
    curr_thresh_y = thresh_y(ii,1);
    all_thetas = 0:.01:2*pi;
    all_rhos = ellipse_rho(curr_thresh_x,curr_thresh_y,all_thetas);
    [x y] = pol2cart(all_thetas,all_rhos);
    curr_cross = thresh_cross(ii,:);
    curr_x = vel_x(ii,:);
    curr_y = vel_y(ii,:);
    hold off
    plot(x,y,'k--')
    hold on
    plot(curr_x,curr_y,'color',[.5 .5 .5])
    curr_x(~curr_cross) = nan;
    curr_y(~curr_cross) = nan;
    plot(curr_x,curr_y,'k','linewidth',2)
    xlim([-50 50])
    ylim([-50 50])
    drawnow
end
end



%__________________________________________________________________________
% sub fuction for integrating and smoothing data
function vel = integrate20(data)
time = 10;
deriv_matrix(1:length(data) + 21-1,1:21-1) = nan; %derivation matrix
ct = 1;
for ii = 1:21;    
    if ii ~= ceil(21 / 2);
        deriv_matrix(ct:length(data)+ct-1,ct) = data;
        ct = ct + 1;
    end
end
deriv_matrix(:,ceil(21/2):end) = deriv_matrix(:,ceil(21/2):end) .* -1;
deriv                                     = sum(deriv_matrix,2);
vel                                       = deriv .* time;
vel(1:floor(21/2))             = [];
vel(end-(floor(21/2)):end)     = [];
vel                                       = [nan;vel];
vel = vel';
end



%__________________________________________________________________________
% sub fuction for calculating elipses
function rho = ellipse_rho(a,b,theta)

sin_theta = sin(theta);
cos_theta = cos(theta);

left_denom  = b .* cos_theta;
right_denom = a .* sin_theta;
left_denom  = left_denom .^2;
right_denom = right_denom .^2;

denom = left_denom + right_denom;
denom = sqrt(denom);

numer = a .* b;

warning('off','MATLAB:divideByZero')
rho = numer ./ denom;
warning('on','MATLAB:divideByZero')
end

 
