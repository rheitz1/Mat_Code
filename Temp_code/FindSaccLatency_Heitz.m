%code to calculate difference between target_in and target_out in
%reference to a diffusion process.  Runs on data from Jeremiah's paper,
%easy/hard search
close all
plotOption = 1;
SRT = [];

SMFilter=[1/64 6/64 15/64 20/64 15/64 6/64 1/64]';%Polynomial

thresh = 5;

 smEyeX_= convn(EyeX_',SMFilter,'same')';
 smEyeY_= convn(EyeY_',SMFilter,'same')';


    I_x=EyeX_;
    I_y=EyeY_;

    smI_x=smEyeX_;
    smI_y=smEyeY_;


%         for trl=1:maxros
%           hold off
%           plot(I_x(trl,:),'b')
%           hold on
%           plot(I_y(trl,:),'r')
%           plot(smI_x(trl,:),'m')
%           plot(smI_y(trl,:),'g')
%           pause
%         end
    Diff_XX=(diff(smEyeX_'))'; %Successive differences in X
    Diff_YY=(diff(smEyeY_'))'; %Successive differences in Y

    absDiffX = abs(Diff_XX);
    absDiffY = abs(Diff_YY);

    %combine X and Y channels
    absXY = absDiffX + absDiffY;
    

    saccMat = zeros(size(absXY));
    saccMat(find(absXY > thresh)) = 1;
    
    for trl = 1:size(EyeX_,1)
        if Correct_(trl,2) == 1
                disp(trl)
            saccDex = find(saccMat(trl,:) == 1);
            
            %consider times > 625 to eliminate saccades TO fixation point
            %upon its appearance (at 500 ms)
       %     SRT(trl) = min(saccDex(find(saccDex >= 625))) - 500;
             SRT(trl) = min(saccDex(find(saccDex >= 625 & saccDex <= 2000)))*4 - 3;
        else
            SRT(trl) = NaN;
        end
    end
        
    SRT = SRT';
        
    if plotOption == 1
        %find saccade latencies
        for i = 1:size(EyeX_,1)
            if Correct_(i,2) == 1
                subplot(2,1,1)
                plot(plottime,EyeX_(i,:))
                subplot(2,1,2)
                plot(plottime,EyeY_(i,:))
                hold on
                %line([SRT(i) + 500 SRT(i) + 500],[EyeY_(i,SRT(i) + 450) EyeY_(i,SRT(i) + 550)],'Color','g');
                line([SRT(i) SRT(i)],[EyeY_(i,SRT(i)-50) EyeY_(i,SRT(i)+50)],'Color','g');
                pause
                hold off
            end
        end
    end