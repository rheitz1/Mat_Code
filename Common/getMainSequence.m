function [PeakAmp PeakVel] = getMainSequence(plotFlag)

if nargin < 1; plotFlag = 0; end

filter_eye_traces = 1;

NaN_outliers = 1;
NaN_sd_criterion = 2; %remove anything < or > 2 * standard deviation

saccLoc = evalin('caller','saccLoc');
EyeX_ = evalin('caller','EyeX_');
EyeY_ = evalin('caller','EyeY_');
SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');

loc0 = find(saccLoc == 0);
loc1 = find(saccLoc == 1);
loc2 = find(saccLoc == 2);
loc3 = find(saccLoc == 3);
loc4 = find(saccLoc == 4);
loc5 = find(saccLoc == 5);
loc6 = find(saccLoc == 6);
loc7 = find(saccLoc == 7);

if filter_eye_traces %this just prevents local maxima from having undue influence on velocities.
    EyeX_ = filtSig(EyeX_,50,'lowpass');
    EyeY_ = filtSig(EyeY_,50,'lowpass');
end

%grab 400 ms chunks of eye data around first saccade

% start by response-aligning

EyeX_resp = response_align(EyeX_,SRT,[-200 200]);
EyeY_resp = response_align(EyeY_,SRT,[-200 200]);

%Now baseline correct
EyeX_resp_bc = baseline_correct(EyeX_resp,[1 50]);
EyeY_resp_bc = baseline_correct(EyeY_resp,[1 50]);


%Calculate mean trajectories and call that the eccentricity in degrees. Deviations about that will
%reflect amplitude differences.
%
% Note, taking abs() so that negative voltage swings stay negative after division
avX_pos0 = abs(nanmean(nanmean(EyeX_resp_bc(loc0,250:400))));
avX_pos4 = abs(nanmean(nanmean(EyeX_resp_bc(loc4,250:400))));
volt2deg.X = mean([avX_pos0 avX_pos4]);

avY_pos2 = abs(nanmean(nanmean(EyeY_resp_bc(loc2,250:400))));
avY_pos6 = abs(nanmean(nanmean(EyeY_resp_bc(loc6,250:400))));
volt2deg.Y = mean([avY_pos2 avY_pos6]);



%Now that we have a conversion factor, we can translate the original EyeX_ and EyeY_ channels to degrees

%Convert to degrees visual angle by dividing by the average at saccade endpoint (to normalize to 1) and
%then multiply by eccentricity to scale. Note that eccentricity could change trial-by-trial, so need to
%take that into account

degX_ = (EyeX_resp_bc ./ volt2deg.X) .* repmat(Target_(:,12),1,size(EyeX_resp_bc,2));
degY_ = (EyeY_resp_bc ./ volt2deg.Y) .* repmat(Target_(:,12),1,size(EyeY_resp_bc,2));


% To calculate velocity, take the first derivative
delta_degX = [zeros(size(EyeX_,1),1) diff(degX_,1,2)];
delta_degY = [zeros(size(EyeY_,1),1) diff(degY_,1,2)];

% Use pythagorean theorem to combine both X and Y voltages

velocityXY = sqrt((delta_degX.^2) + (delta_degY.^2));


%Assuming 1 kHz sampling rate, multiply by 1000 to convert to degrees/sec instead of degrees/ms
velocityXY = velocityXY .* 1000;

%Now take the max value for peak velocity
PeakVel = max(velocityXY,[],2);

%=====================================================================
% Calculate Peak Amplitudes
% Same Pythagorean theorem again, but on undifferentiated eye channels
Amp = sqrt((degX_.^2) + (degY_.^2));

%calculate the peak amplitude as the average within a 51 ms window centered 50 ms after the saccade
%(these are response aligned -200:200, so saccade is detected at time 200)
PeakAmp = mean(Amp(:,225:275),2);


if NaN_outliers
    Vel_crit_high = mean(PeakVel) + 2 * std(PeakVel);
    Vel_crit_low = mean(PeakVel) - 2 * std(PeakVel);
    Amp_crit_high = mean(PeakAmp) + 2 * std(PeakAmp);
    Amp_crit_low = mean(PeakAmp) - 2 * std(PeakAmp);
    
    PeakVel(find(PeakVel > Vel_crit_high | PeakVel < Vel_crit_low)) = NaN;
    PeakAmp(find(PeakAmp > Amp_crit_high | PeakAmp < Amp_crit_low)) = NaN;
end

if plotFlag
    x = removeNaN([PeakAmp PeakVel]);
    linreg(x(:,2),x(:,1),1)
    xlabel('Saccade Amplitude (degrees)','fontsize',15,'fontweight','bold')
    ylabel('Saccade Velocity (degrees/sec)','fontsize',15,'fontweight','bold')
end
