% Aligns eye movement trajectories.
% Only makes assumption that the mean of a distribution of saccade
% endpoints is representative to where the saccade actually fell in
% reference to distal stimulus.
% 
% RPH
function [newEyeX_,newEyeY_] = fixEye(plotFlag)

%get global variables
EyeX_ = evalin('caller','EyeX_');
EyeY_ = evalin('caller','EyeY_');
Target_ = evalin('caller','Target_');
SRT = evalin('caller','SRT');
Correct_ = evalin('caller','Correct_');

if nargin < 1; plotFlag = 0; end

%==========================================================
% Get eye movement information
seekWindow = 50;
for trl = 1:size(EyeX_,1)
    if ~isnan(SRT(trl,1)) & SRT(trl,1) < 2000 & SRT(trl,1) > 50
        pos.X(trl,1:151) = EyeX_(trl,SRT(trl,1) + 500 - 50:SRT(trl,1) + 500 + 100);
        pos.Y(trl,1:151) = EyeY_(trl,SRT(trl,1) + 500 - 50:SRT(trl,1) + 500 + 100);
        
        loc_start_X = mean(EyeX_(trl,400:500));
        loc_start_Y = mean(EyeY_(trl,400:500));
        loc_end_X = mean(EyeX_(trl,SRT(trl,1)+500+100:SRT(trl,1)+500+200));
        loc_end_Y = mean(EyeY_(trl,SRT(trl,1)+500+100:SRT(trl,1)+500+200));
        
        pos.deltaX(trl,1) = loc_end_X - loc_start_X;
        pos.deltaY(trl,1) = loc_end_Y - loc_start_Y;
        
        angle_deg(trl,1) = mod((180/pi*atan2(loc_end_Y-loc_start_Y,loc_end_X-loc_start_X)),360);
        angle_rad(trl,1) = deg2rad(angle_deg(trl,1));
    else
        pos.X(trl,:) = NaN;
        pos.Y(trl,:) = NaN;
        pos.deltaX(trl,1) = NaN;
        pos.deltaY(trl,1) = NaN;
        angle_deg(trl,1) = NaN;
        angle_rad(trl,1) = NaN;
    end
end


%separate by trials so we can compare
pos0 = find(Correct_(:,2) == 1 & Target_(:,2) == 0);
pos1 = find(Correct_(:,2) == 1 & Target_(:,2) == 1);
pos2 = find(Correct_(:,2) == 1 & Target_(:,2) == 2);
pos3 = find(Correct_(:,2) == 1 & Target_(:,2) == 3);
pos4 = find(Correct_(:,2) == 1 & Target_(:,2) == 4);
pos5 = find(Correct_(:,2) == 1 & Target_(:,2) == 5);
pos6 = find(Correct_(:,2) == 1 & Target_(:,2) == 6);
pos7 = find(Correct_(:,2) == 1 & Target_(:,2) == 7);



% Equation from Tempo
% eyeX = eyeH * XGAIN/100 + eyeV * XYF/100;
% eyeY = eyeV * YGAIN/100 + eyeH * YXF/100;

        
%compare mean X position for position 2 vs position 6.  This will tell you
%how far apart they are and determine a conversion factor
mX_2 = mean(pos.deltaX(pos2));
mY_2 = mean(pos.deltaY(pos2));
mX_6 = mean(pos.deltaX(pos6));
mY_6 = mean(pos.deltaY(pos6));

%solve for x
XYFtemp1 = -mX_2 / mY_2;
if XYFtemp1 < 0
    sign = -1;
else
    sign = 1;
end

XYFtemp2 = -mX_6 / mY_6;

%average pos 2 and 6.  Have retained sign already.
XYF = (( abs(XYFtemp1) + abs(XYFtemp2) ) / 2) * sign;

%========
newEyeX_ = EyeX_ + EyeY_ * XYF;
%========

%====================================
% RE RUN SINCE CORRECTING X DIMENSION
%==========================================================
% Get eye movement information
seekWindow = 50;
for trl = 1:size(EyeX_,1)
    if ~isnan(SRT(trl,1)) & SRT(trl,1) < 2000 & SRT(trl,1) > 50
        pos.X(trl,1:151) = newEyeX_(trl,SRT(trl,1) + 500 - 50:SRT(trl,1) + 500 + 100);
        pos.Y(trl,1:151) = EyeY_(trl,SRT(trl,1) + 500 - 50:SRT(trl,1) + 500 + 100);
        
        loc_start_X = mean(newEyeX_(trl,400:500));
        loc_start_Y = mean(EyeY_(trl,400:500));
        loc_end_X = mean(newEyeX_(trl,SRT(trl,1)+500+100:SRT(trl,1)+500+200));
        loc_end_Y = mean(EyeY_(trl,SRT(trl,1)+500+100:SRT(trl,1)+500+200));
        
        pos.deltaX(trl,1) = loc_end_X - loc_start_X;
        pos.deltaY(trl,1) = loc_end_Y - loc_start_Y;
        
        angle_deg(trl,1) = mod((180/pi*atan2(loc_end_Y-loc_start_Y,loc_end_X-loc_start_X)),360);
        angle_rad(trl,1) = deg2rad(angle_deg(trl,1));
    else
        pos.X(trl,:) = NaN;
        pos.Y(trl,:) = NaN;
        pos.deltaX(trl,1) = NaN;
        pos.deltaY(trl,1) = NaN;
        angle_deg(trl,1) = NaN;
        angle_rad(trl,1) = NaN;
    end
end
%======================================


%now for Y dimension
mX_0 = mean(pos.deltaX(pos0));
mY_0 = mean(pos.deltaY(pos0));
mX_4 = mean(pos.deltaX(pos4));
mY_4 = mean(pos.deltaY(pos4));

%First figure out the extent of x-dimension movements for positions 2 and 6.
%Then, use YXF based off position 4 for leftward saccades (< minimum of x dimension
% for pos 2 & 6), and likewise, use YXF based off position 0 for rightward saccades only.
%Note that the Y dimension for positions 2 & 6 remain unchanged.
breakpoint_X(1) = (mean([mX_2+mY_2*XYF;mX_6+mY_6*XYF])) - (3 * std(pos.deltaX([pos2;pos6])));
breakpoint_X(2) = (mean([mX_2+mY_2*XYF;mX_6+mY_6*XYF])) + (3 * std(pos.deltaX([pos2;pos6])));

saccades_left = find(pos.deltaX < breakpoint_X(1));
saccades_right = find(pos.deltaX > breakpoint_X(2));

%solve for x

YXFtemp1 = -mY_0 / mX_0;
YXFtemp2 = -mY_4 / mX_4;

newEyeY_ = EyeY_;
newEyeY_(saccades_right,:) = (EyeY_(saccades_right,:) + (EyeX_(saccades_right,:) * YXFtemp1));
newEyeY_(saccades_left,:) = (EyeY_(saccades_left,:) + (EyeX_(saccades_left,:) * YXFtemp2));


if plotFlag == 1
    getVec(EyeX_,EyeY_,SRT,1,0);
    [ax h] = suplabel('UNCORRECTED','t');
    
    getVec(newEyeX_,newEyeY_,SRT,1,0);
    [ax h] = suplabel('CORRECTED','t');
end
