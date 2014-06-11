%translate "zap" file; saccades elicited in the dark
tic
disp('Executing...')
plotFlag = 1;

%If no filename or path provided, request user input
if nargin < 2
    file_path = 'C:\Data\ToTranslate\';
    cd 'C:\Data\ToTranslate\'
    [filename,file_path] = uigetfile([file_path,'*.plx']);
    if isequal(filename,0) | isequal(file_path,0)
        disp('File not found')
    else
        disp(['File...',filename,'...found'])
        fileID = filename(1:end-4);
        outfile = [filename(1:end-4) '_all'];
    end
elseif nargin == 2
    disp(['File...',filename,'...accepted'])
    fileID = filename(1:end-4);
    outfile = [filename(1:end-4) '_all'];
end

if ~filename
    disp('Translation Aborted')
    return
end

newfile = filename;
getMonk


[nStrobes,Strobe_Times,Strobe_Values] = plx_event_ts([file_path,filename], 257);

%find times of manual zapping
zap_times = Strobe_Times(find(Strobe_Values == 7013));
zap_times = zap_times*1000;
%get Eye channels.  Chan = chan - 1; Plexon has 0 base
[adfreq, nad, tsad, fnad,EyeX_tmp] = plx_ad_v([file_path filename],17);
[adfreq, nad, tsad, fnad,EyeY_tmp] = plx_ad_v([file_path filename],18);

for trl = 1:length(zap_times)
    EyeX_(trl,1:401) = EyeX_tmp(zap_times(trl)-100:zap_times(trl)+300);
    EyeY_(trl,1:401) = EyeY_tmp(zap_times(trl)-100:zap_times(trl)+300);
end


%find SRT (evoked saccade)
SMFilter=[1/64 6/64 15/64 20/64 15/64 6/64 1/64]';%Polynomial

smEyeX_= convn(EyeX_',SMFilter,'same')';
% clear EyeX_

smEyeY_= convn(EyeY_',SMFilter,'same')';
% clear EyeY_

Diff_XX=(diff(smEyeX_'))'; %Successive differences in X
clear smEyeX_

Diff_YY=(diff(smEyeY_'))'; %Successive differences in Y
clear smEyeY_

absXY = (Diff_XX.^2)+(Diff_YY.^2);
clear Diff_XX Diff_YY

if monkey == 'Q'
    thresh = .00008
elseif monkey == 'S'
    thresh = 5e-6
end


saccMat = zeros(size(absXY));
saccMat(find(absXY > thresh)) = 1;
%clear absXY

diff_saccMat = diff(saccMat')';
clear saccMat

%get positions
for trl = 1:length(zap_times)
    if ~isempty(find(diff_saccMat(trl,30:270) == 1))
        tempbegin = find(diff_saccMat(trl,30:270) == 1);
        SRT(trl,1:length(tempbegin)) = tempbegin + 30;
        
        loc_start_X = mean(EyeX_(trl,49:51));
        loc_end_X = mean(EyeX_(trl,99:101));
        loc_start_Y = mean(EyeY_(trl,49:51));
        loc_end_Y = mean(EyeY_(trl,99:101));
        
        
        deltaX(trl,1) = loc_end_X - loc_start_X;
        deltaY(trl,1) = loc_end_Y - loc_start_Y;
        
        
        %take 4-quadrant inverse tangent
        saccDir(trl,1) = mod((180/pi*atan2(loc_end_Y-loc_start_Y,loc_end_X-loc_start_X)),360);
        
        
        
        if saccDir(trl) > 337.5 || saccDir(trl) <= 22.5
            saccLoc(trl,1) = 0;
        elseif saccDir(trl) > 22.5 && saccDir(trl) <= 67.5
            saccLoc(trl,1) = 1;
        elseif saccDir(trl) > 67.5 && saccDir(trl) <= 112.5
            saccLoc(trl,1) = 2;
        elseif saccDir(trl) > 112.5 && saccDir(trl) <= 157.5
            saccLoc(trl,1) = 3;
        elseif saccDir(trl) > 157.5 && saccDir(trl) <= 202.5
            saccLoc(trl,1) = 4;
        elseif saccDir(trl) > 202.5 && saccDir(trl) <= 247.5
            saccLoc(trl,1) = 5;
        elseif saccDir(trl) > 247.5 && saccDir(trl) <= 292.5
            saccLoc(trl,1) = 6;
        elseif saccDir(trl) > 292.5 && saccDir(trl) <= 337.5
            saccLoc(trl,1) = 7;
        else
            saccLoc(trl,1) = NaN;
        end
    else
        SRT(trl,1) = NaN;
        saccDir(trl,1) = NaN;
        saccLoc(trl,1) = NaN;
    end
end


% if plotFlag == 1
%     x = baseline_correct(EyeX_,[1 10]);
%     y = baseline_correct(EyeY_,[1 10]);
%     
%     
%     figure
%     hold
%     for trl = 1:size(SRT,1)
%         if ~isnan(SRT(trl,1))
%             plot(x(trl,:),y(trl,:))
%         end
%     end
% end