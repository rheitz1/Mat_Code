function [microSRT] = getMicroSaccades(EyeX_,EyeY_,ASL_Delay,monkey,thresh,plotFlag)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to return microsaccade times.  Functionally just using
% a rather low threshold value to detect eye movement
%
% Richard P. Heitz
% Vanderbilt
%
%
% Example File: Q102710001-RH_SEARCH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 6; plotFlag = 1; end


Target_ = evalin('caller','Target_');
if nargin < 3 %if not specified, check back with caller
    
    
    try
        newfile = evalin('base','newfile');
        Target_ = evalin('base','Target_');
    catch
        newfile = evalin('caller','newfile');
        Target_ = evalin('caller','Target_');
    end
    
    if length(newfile) == 23 %new naming convention: year/month/day
        mo = str2num(newfile(6:7));
        yr = str2num(newfile(4:5));
    else
        mo = str2num(newfile(2:3));
        yr = str2num(newfile(6:7));
    end
    
    monkey = newfile(1);
    ASL_Delay = 0;
    
    %determine date recorded to set ASL_Delay
    
    
    
    %Eye tracker was used with S from early 07 until 3/08.  Files older
    %than that and files newer than that used eye coil.
    if monkey == 'S' & yr == 8 & mo < 4
        ASL_Delay = 1;
    elseif monkey == 'S' & yr == 7
        ASL_Delay = 1;
    else
        ASL_Delay = 0;
    end
    
end

if ASL_Delay == 1
    ASL_DELAY_CORRECTION = 1;
else
    ASL_DELAY_CORRECTION = 0;
end




%At 240Hz, 3 frames (ASL lags 3 frames) = (1000/240)*3 = 12.5
ASL_DELAY = 12.5;


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


if nargin < 5
    if ASL_DELAY_CORRECTION == 0 & monkey == 'Q' & yr < 10
        thresh = 5e-6%.00008
    elseif ASL_DELAY_CORRECTION == 0 & monkey == 'Q' & yr <= 10 & mo < 8
        thresh = 9e-6%.00008
%         %thresh = .000016 %use to pick up half-assed saccades
    elseif ASL_DELAY_CORRECTION == 0 & monkey == 'Q' & yr >= 10 & mo >= 8
        thresh = 8e-4%.005
    elseif monkey == 'D'
        thresh = 4e-4
    elseif monkey == 'E'
        thresh = 1e-4
    
%     elseif ASL_DELAY_CORRECTION == 0 & monkey == 'Q' & yr >= 11
%         thresh = 5e-3
%     elseif ASL_DELAY_CORRECTION == 1 & monkey == 'S'
%         %Seymour w/ eye tracker
%         thresh = 6e-4%.0006
%         disp('ASL Delay correction active')
%     elseif ASL_DELAY_CORRECTION == 0 & monkey == 'S' & yr > 5 & yr < 9
%         disp('Seymour basic T/L task detected')
%         thresh = 7e-6 %.000007
%     elseif ASL_DELAY_CORRECTION == 0 & monkey == 'S' & yr >= 9 & yr < 11
%         disp('Seymour uStim Data Set Detected')
%         thresh = 5e-6 %.000005
%     elseif monkey == 'S' && yr == 5
%         disp('Seymour Woodman EEG-only dataset detected')
%         thresh = 4e-5
%     elseif monkey == 'S' && yr >= 11
%         thresh = 5e-3
%         %thresh = 2e-3
%     elseif ASL_DELAY_CORRECTION == 0 & monkey == 'P'
%         thresh = 3e-5
%         disp('Pep data set detected')
%     elseif monkey=='F';
%         nTrls=size(absXY,1);
%         pct75=nan(nTrls,1);
%         for trl=1:nTrls
%             pct75(trl)=prctile(absXY(trl,:),75);
%         end
%         thresh=100*nanmedian(pct75)
%     elseif monkey=='E';
%         thresh = 2e-3
%     elseif monkey=='D';
%         thresh = 2e-3
%     elseif monkey == 'Z';
%         thresh = 2e-3
%     end

    end


else
    disp('Using manually set threshold...')
end


saccMat = zeros(size(absXY));
saccMat(find(absXY > thresh)) = 1;
%clear absXY

diff_saccMat = diff(saccMat')';
clear saccMat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get saccade vector direction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%alter Eye information based on TEMPO gain settings
%need to do this to compute saccade direction vectors
if ASL_DELAY_CORRECTION == 0
    EyeX_gain = EyeX_;%*14;
    EyeX_gain = EyeX_; %+ EyeY_*1;
    
    EyeY_gain = EyeY_;%*14;
    EyeY_gain = EyeY_;% + EyeX_*1;
elseif ASL_DELAY_CORRECTION == 1
    EyeX_gain = EyeX_ * 14;
    EyeY_gain = EyeY_ * 12;
end

for trl = 1:size(diff_saccMat,1)

    tempbegin = find(diff_saccMat(trl,:) == 1);
  
    
    if ~isempty(tempbegin)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  Set actual SRT times, and correct if necessary
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %note: no need to subtract 500 ms because we begin our search at 500
        %add 30 because we start search at 530 to eliminate trials with
        %saccade artifacts near time 0.
        if ASL_DELAY_CORRECTION == 1
            microSRT(trl,1:length(tempbegin)) = tempbegin - ASL_DELAY - Target_(1,1);
            
        else
            microSRT(trl,1:length(tempbegin)) = tempbegin - Target_(1,1);
            
        end
    else
        microSRT(trl,1) = NaN;
        
        
    end
end

if plotFlag
    figure
    for trl = 1:size(EyeX_,1)
        plot(-3500:2500,EyeX_(trl,:),'r',-3500:2500,EyeY_(trl,:),'b')
        xlim([-3500 2500])
        vline(nonzeros(microSRT(trl,:)),'k')
        pause
        cla
    end
end

