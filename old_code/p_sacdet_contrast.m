%***************NOT YET INTEGRATED*******************
%p_sacdet
% called by: Cstandard
% calls: fuse_saccdet
%
%function p_sacc(In_x, In_y, InMatrix)
%Author:
%chenchal.subraveti@vanderbilt.edu
%kirk.thompson@vanderbilt.edu
% last change: June 12 / 99
% by Takashi Sato
%last change: june 30, '05
%   erik.emeric@vanderbilt.edu
%   added call to function AD2DegConvFactor
%               less abitrary method of determining the conversion factor between AD values to Deg
function [varargout]=p_sacdet_contrast(file_path,filename)
%clear all
%close all



%[filename,file_path] = uigetfile('C:\Documents and Settings\Rich\Desktop\Mat_Code\Contrast Sensitivity','Choose MATLAB File to Process');%c:\data\basic
if isequal(filename,0)|isequal(file_path,0)
    disp('File not found')
    return
else
    disp(['File ', file_path, filename, ' found'])
    Filename =[file_path, filename];
end


%get data and set parameter
q='''';c=',';qcq=[q c q];
PLOTS='np'; % 'p' == display saccades, 'np' == don't plot
PrintFlag=1; % 1 means print plots, 0 means do not print MWL
SAVEVARS=1;
global EyeX_ EyeY_ EmStart_ Eot_ TrialStart_
VARS2LOAD={'EyeX_','EyeY_','EmStart_','Eot_', 'Stimulus_','TrialStart_','Target_','Correct_'};
for ii=1:size(VARS2LOAD,2)
    eval(['load(',q,[file_path,filename],qcq,VARS2LOAD{ii},qcq,'-mat',q,')'])
end
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%')


%if exist('Stimulus_')
%     [andyADconv, Vel_Thresh]= AD2DegConvFactor_search (file_path, filename);
%     Noise_Thresh= Vel_Thresh/3;
%else
%    Vel_Thresh=4; %SQRT(diff(X)^2+diff(Y)^2)
%     Noise_Thresh=3.5;
andyADconv =30/7; %approximate ad conversion in ad/deg
% end



N_Trials=size(TrialStart_,1);
TrialStart_=TrialStart_+500;
Eot_(:,1)=TrialStart_(:,1)+900;
EmStart_(1:N_Trials,1:2) = [ zeros(size(TrialStart_,1),1)  ,  repmat( 1 , size(TrialStart_,1) , 1)   ];

EmStart_(:,2)=4;
e_rate=EmStart_(1,2); %should be 4!




Vel_Thresh=0.003;%0.01; %SQRT(diff(X)^2+diff(Y)^2)
Noise_Thresh=0.085;%0.085%3.5;

%SMFilter=[1/16 4/16 6/16 4/16 1/16]';%Polynomial
SMFilter=[1/64 6/64 15/64 20/64 15/64 6/64 1/64]';%Polynomial
Diff_X=[];Diff_Y=[];
[maxros maxcols]=size(EyeY_); TrialNo_=0;
%maxrows is the number of trials.

%**************************************************************
%***WRITE TO MULTIPLE FILES IF TRIAL NO EXCEEDS PRESET VALUES***
maxTrialNo=100;
MultiFileFlag=0;
multifileNo=0;
multifile=0;
tempfile=['c:\temp\temp']; %use 'temp' because folder is always there
MULTIFILE=[num2str(multifile),' separate saccdet files that are merged'];
adjustment = 0;  % for debugging
%****************************************************************

if maxros>maxTrialNo
    MultiFileFlag=1;
end
multifileNo=floor(maxros/maxTrialNo);
residual=maxros-(multifileNo*maxTrialNo);
if residual == 0
    multifileNo = multifileNo -1;
    residual = maxTrialNo;
end

for ii=0:multifileNo

    % clearing the previous data
    SaccBegin = []; SaccEnd = []; SaccDir = []; SaccAmp = [];
    ADbeginX = []; ADbeginY = []; ADendX = []; ADendY = [];
    if ii==multifileNo
        OrgMaxTrialNo = maxTrialNo; maxTrialNo = residual;
        adjustment = (OrgMaxTrialNo - residual) * multifileNo; %100 is the original maxTrialNo.
    end
    %Begin with smoothing eye position
    smEyeX_= convn(EyeX_((ii*maxTrialNo+1+adjustment):((ii+1)*maxTrialNo+adjustment),:)',SMFilter,'same')';
    smEyeY_= convn(EyeY_((ii*maxTrialNo+1+adjustment):((ii+1)*maxTrialNo+adjustment),:)',SMFilter,'same')';


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
    smnum = (1+length(SMFilter))/2;% smooth number: can't use the first few and last few eye positions because of smoothing
    for trl=1:maxTrialNo
        % MaxEyes is the last time index for the current trial used for Saccade detection
        MaxEyes=floor((Eot_	((ii*maxTrialNo)+adjustment+trl,1)-EmStart_((ii*maxTrialNo)+adjustment+trl,1))/e_rate);
        if (MaxEyes > size(Diff_XX,2))|(isnan(MaxEyes))
            MaxEyes = size(Diff_XX,2);
        elseif (MaxEyes > size(Diff_YY,2))
            MaxEyes = size(Diff_YY,2);
        end
        Diff_X(trl,smnum+1:MaxEyes-smnum+1)=Diff_XX(trl,smnum:MaxEyes-smnum);
        Diff_Y(trl,smnum+1:MaxEyes-smnum+1)=Diff_YY(trl,smnum:MaxEyes-smnum);
        % one bin added to account for effect of 'diff' function
    end
    clear Diff_XX Diff_YY;
    Thresh_XY=((Diff_X.^2)+(Diff_Y.^2));
    % Thresh_XY=(convn(UThresh_XY',SMFilter,'same'))';
    Cross_Thresh=zeros(size(Thresh_XY));

    % FIND THE VELOCITIES WHICH ARE GREATER THAN THE VELOCITY CRITERIA ...
    % CROSS_THRESH, BOOLEAN, ONES WHERE THE VELOCITY IN THAT TIMEBIN IS GREATER THAN
    % THE CRITERIA
    Cross_Thresh(find(Thresh_XY >= Vel_Thresh))=1; % The velocity is larger than the criteria.
    clear Diff_X Diff_Y;
    Index_End_Sac=[];Begin_Sac=[];

    tic

    for trl=1:maxTrialNo

%                 plot(Thresh_XY(trl,:),'m.')
%                 set(gca,'ylim',[0 max(Thresh_XY(trl,:))])
%                 pause
        temp=[];nsac=[];t=[];ncols=[];
        %TO DETERMINE THE  BEGINNING AND END OF SACCADES...
        % CROSS_THRESH (BOOLEAN)
        % WHERE VELOCITIES FIRST > CRITERIA 0 --> 1 ==> SACCADE BEGIN
        % WHERE VELOCITIES DROP TO  < CRITERIA 1 --> 0 ==> SACCADE BEGIN
        tempbegin=find(diff(Cross_Thresh(trl,:))==1);%Index to Begin of saccade
        tempend=find(diff(Cross_Thresh(trl,:))==-1);%Index to End of saccade
%                 disp('_')
%                 disp('_')
%                 disp(trl)
%                 disp(tempbegin)
%                 disp(tempend)
%                 disp('press a key')%MWL
        %         pause
        % IF NO ELEVATED VELOCITIES...
        if (isempty(tempbegin)|isempty(tempend))
            End_Sac(trl,1)=0; Begin_Sac(trl,1)=0;
            tempbegin=0; tempend=0;
            disp(['No saccades have been found in trial: ',int2str((ii*maxTrialNo)+adjustment+trl)])
            % if no saccades in the trial
        else
            % begin of saccade detection
            if(tempend(1)<tempbegin(1))
                [dummy ncols]=size(tempbegin);
                t=tempbegin; tempbegin = tempend;
                tempbegin(1) = 1;
                tempbegin(2:ncols+1) = t;
            end
            begsac=length(tempbegin);
            endsac=length(tempend);


            %if there are more saccade begins than saccade ends, add one saccade end to
            % the matrix.
            if (begsac>endsac)
                % Assign the time of the Eot_ to be the end of the last saccade
                tempend(begsac)=(Eot_((ii*maxTrialNo)+adjustment+trl,1)-EmStart_((ii*maxTrialNo)+adjustment+trl,1))/e_rate;
            end

            disp(['Doing Trial : ',num2str((ii*maxTrialNo)+adjustment+trl)]);
            % FIND THE BEGINNING OF EACH SACCADE
            for nsac=1:length(tempbegin)
                count=0;
                reached_trial_start = 0;
                Index=tempbegin(nsac);
                if(Index == 1)

                    Begin_Sac(trl,nsac)=1;
                else
                    %WORK BACKWARD IN TIME TO FIND THE FIRST VELOCITY GREATER THAN THE
                    %SACCADE CRITERIA
                    while(Thresh_XY(trl,Index-count) > Noise_Thresh)
                        %Thresh_XY is the speed of eye movement at each time point.
                        %Finding the time point when the velocity first goes over Noise_Thresh
                        count=count+1;
                        if((Index-count)== 1)
                            reached_trial_start = 1;
                            break;
                        end
                    end
                    if (reached_trial_start == 1)
                        Begin_Sac(trl,nsac)=1;
                        reached_trial_start = 0;
                    else
                        Begin_Sac(trl,nsac)=tempbegin(nsac)-count+1;
                    end
                end
            end
            % find ends
            %WORK FORWARD IN TIME TO FIND THE FIRST VELOCITY LESS THAN THE
            %SACCADE CRITERIA
            for nsac=1:length(tempend)
                count=0;
                reached_trial_end = 0;
                Index=tempend(nsac);
                if(Index >= length(Thresh_XY(trl,:)))
                    End_Sac(trl,nsac)=tempend(nsac);
                else
                    while(Thresh_XY(trl,Index+count)>Noise_Thresh)
                        count=count+1;
                        if((Index+count) >= length(Thresh_XY(trl,:)))
                            break;
                        end
                    end
                    End_Sac(trl,nsac)=tempend(nsac)+count;
                end
            end
        end
    end

    clear Cross_Thresh Thresh_XY;
    toc

    % Check, if size of Matrices equals # of trials in chunk (maxTrialNo + adjustment)


    Maxsac = length(Begin_Sac(1,:));
    % gets rid of identical saccades in matrix
    % finds A/D eye positions before and after each saccade
    for trl=1:maxTrialNo
        nsac = 0;
        MaxEyes=floor((Eot_((ii*maxTrialNo)+adjustment+trl,1)-EmStart_((ii*maxTrialNo)+adjustment+trl,1))/e_rate);
        if (isnan(MaxEyes))
            MaxEyes = size(EyeX_,2);
        end
        for sac=1:Maxsac
            % I think this should be... if (nsac == 0)...kgt
            if (nsac == 0)
                nsac = nsac + 1;
                SaccBegin(trl,nsac)=Begin_Sac(trl,sac);
                SaccEnd(trl,nsac)=End_Sac(trl,sac);
                % if no saccade is found on this trial...
                if (SaccBegin(trl,nsac)==0)
                    break;
                end
                if (SaccBegin(trl,nsac) > 5)
                    ADbeginX(trl,nsac) = mean(EyeX_((ii*maxTrialNo)+adjustment+trl,SaccBegin(trl,nsac)-5:SaccBegin(trl,nsac)-1));
                    ADbeginY(trl,nsac) = mean(EyeY_((ii*maxTrialNo)+adjustment+trl,SaccBegin(trl,nsac)-5:SaccBegin(trl,nsac)-1));
                    ADendX(trl,nsac) = mean(EyeX_((ii*maxTrialNo)+adjustment+trl,SaccEnd(trl,nsac)+1:SaccEnd(trl,nsac)+5));
                    ADendY(trl,nsac) = mean(EyeY_((ii*maxTrialNo)+adjustment+trl,SaccEnd(trl,nsac)+1:SaccEnd(trl,nsac)+5));
                else
                    ADbeginX(trl,nsac) = mean(EyeX_((ii*maxTrialNo)+adjustment+trl,1:SaccBegin(trl,nsac)-1));
                    ADbeginY(trl,nsac) = mean(EyeY_((ii*maxTrialNo)+adjustment+trl,1:SaccBegin(trl,nsac)-1));
                    ADendX(trl,nsac) = mean(EyeX_((ii*maxTrialNo)+adjustment+trl,SaccEnd(trl,nsac)+1:SaccEnd(trl,nsac)+5));
                    ADendY(trl,nsac) = mean(EyeY_((ii*maxTrialNo)+adjustment+trl,SaccEnd(trl,nsac)+1:SaccEnd(trl,nsac)+5));
                end
            end
            if ((nsac>0)&(Begin_Sac(trl,sac)~=SaccBegin(trl,nsac)))
                nsac = nsac + 1;
                SaccBegin(trl,nsac)=Begin_Sac(trl,sac);
                SaccEnd(trl,nsac)=End_Sac(trl,sac);
                % if last saccade has been reached on this trial, break...
                if (SaccBegin(trl,nsac)==0)
                    break;
                end
                ADbeginX(trl,nsac)=mean(EyeX_((ii*maxTrialNo)+adjustment+trl,SaccBegin(trl,nsac)-5:SaccBegin(trl,nsac)-1));
                ADbeginY(trl,nsac)=mean(EyeY_((ii*maxTrialNo)+adjustment+trl,SaccBegin(trl,nsac)-5:SaccBegin(trl,nsac)-1));
                if (SaccEnd(trl,nsac)<MaxEyes-5)
                    ADendX(trl,nsac) = mean(EyeX_((ii*maxTrialNo)+adjustment+trl,SaccEnd(trl,nsac)+1:SaccEnd(trl,nsac)+5));
                    ADendY(trl,nsac) = mean(EyeY_((ii*maxTrialNo)+adjustment+trl,SaccEnd(trl,nsac)+1:SaccEnd(trl,nsac)+5));
                elseif (SaccEnd(trl,nsac)<MaxEyes)
                    ADendX(trl,nsac) = mean(EyeX_((ii*maxTrialNo)+adjustment+trl,SaccEnd(trl,nsac)+1:MaxEyes));
                    ADendY(trl,nsac) = mean(EyeY_((ii*maxTrialNo)+adjustment+trl,SaccEnd(trl,nsac)+1:MaxEyes));
                else
                    ADendX(trl,nsac) = EyeX_((ii*maxTrialNo)+adjustment+trl,MaxEyes);
                    ADendY(trl,nsac) = EyeY_((ii*maxTrialNo)+adjustment+trl,MaxEyes);
                end
            end
            % tests amlitude and duration relation to get rid of slow eye movements that are not saccades.
            CurrSaccADamp = sqrt((ADendY(trl,nsac)-ADbeginY(trl,nsac))^2+(ADendX(trl,nsac)-ADbeginX(trl,nsac))^2);
            CurrSaccAmp = CurrSaccADamp/andyADconv;
            CurrSaccDur = (SaccEnd(trl,nsac) - SaccBegin(trl,nsac))*e_rate;
            % allows saccades that are less than 25 ms longer than expected
            % based on the equation:  Duration = 25 + 2.5(Amplitude)
            if (CurrSaccDur > (25+25)+(2.5*CurrSaccAmp))
                SaccBegin(trl,nsac)=0;
                SaccEnd(trl,nsac)=0;
                ADbeginX(trl,nsac) = 0;
                ADbeginY(trl,nsac) = 0;
                ADendX(trl,nsac) = 0;
                ADendY(trl,nsac) = 0;
                nsac = nsac-1;
            end
        end
    end

    % Check, if size of Matrices equals # of trials in chunk (maxTrialNo + adjustment)

    if ii==multifileNo; curCompTrlNo = residual; else; curCompTrlNo = maxTrialNo; end
    VARS2LOAD={'ADbeginX','ADbeginY','ADendX','ADendY','Begin_Sac','End_Sac','SaccBegin','SaccEnd'};
    for jj=1:size(VARS2LOAD,2)
        %eval(['size(',VARS2LOAD{ii},')'])
        eval(['A = isequal(size(',VARS2LOAD{jj},',1),curCompTrlNo);'])
        if ~A
            eval([VARS2LOAD{jj},'((size(',VARS2LOAD{jj},',1)+1):curCompTrlNo,:) = 0;'])
        end
    end

    % find direction, duration and amplitude of each saccade
    SaccDir = mod((180/pi*atan2(ADendY-ADbeginY,ADendX-ADbeginX)),360);
    % get rid of negative Angles in SaccDir
    for currentRow=1:size(SaccDir,1)
        [NegAngle] = find(nonzeros(SaccDir(currentRow,:))<0);
        if ~isempty(NegAngle)
            SaccDir(currentRow,NegAngle) = SaccDir(currentRow,NegAngle) + 360;
        end
    end
    SaccADamp = sqrt((ADendY-ADbeginY).^2+(ADendX-ADbeginX).^2);
    % ADconv dependent on monkey
    SaccAmp = SaccADamp./andyADconv;
    SaccDur = (SaccEnd - SaccBegin)*e_rate;

    % plot SACCADES if wanted
    if (PLOTS=='p')%&(ii==3)
        I_x=EyeX_((ii*maxTrialNo+adjustment+1):((ii+1)*maxTrialNo+adjustment),:);
        I_y=EyeY_((ii*maxTrialNo+adjustment+1):((ii+1)*maxTrialNo+adjustment),:);
        Pgtemp = tempend;
        for plts=1:maxros
            %      Nsac=length(nonzeros(Begin_Sac(plts,:)));
            Nsac=length(nonzeros(SaccBegin(plts,:)));



            for sac=1:Nsac %this loop plots each saccade detected individually
                disp(['Trial ',num2str(plts),'  Saccade  No ',num2str(sac)])
                %         minX1=Begin_Sac(plts,sac)-10;
                %         minX=max(End_Sac(plts,1),minX1);
                %         maxX1=End_Sac(plts,sac)+10;
                %         maxX=min(End_Sac(plts,Nsac),maxX1);
                minX1=SaccBegin(plts,sac)-10;
                minX=max(SaccEnd(plts,1),minX1);
                maxX1=SaccEnd(plts,sac)+10;
                maxX=min(SaccEnd(plts,Nsac),maxX1);

                maxIx=max(abs(I_x(plts,minX:maxX)));
                maxIy=max(abs(I_y(plts,minX:maxX)));
                maxxy=max(maxIx,maxIy);

                if maxxy==0
                    maxxy=1;
                end;

                %                 axisv=[-maxX maxX -maxxy maxxy];%MWL
                %                 %axisv=[minX maxX -maxxy maxxy];
                %                 axis(axisv);
                %                 plot([minX:maxX],I_x(plts,minX:maxX),'b.');%horz
                %                 hold on
                %                 plot([minX:maxX],I_y(plts,minX:maxX),'r.');%vert
                %                 %  size(Begin_Sac(plts,sac))
                %                 %         plot([Begin_Sac(plts,sac) Begin_Sac(plts,sac)],[-maxxy maxxy],'m-')
                %                 %         plot([End_Sac(plts,sac) End_Sac(plts,sac)],[-maxxy maxxy],'k-.')
                %                 plot([SaccBegin(plts,sac) SaccBegin(plts,sac)],[-maxxy maxxy],'m-')%sacc onset
                %                 plot([SaccEnd(plts,sac) SaccEnd(plts,sac)],[-maxxy maxxy],'k-.')%sacc offset
                %                 title([filename,'   Trial ',num2str(plts),'  Saccade  No ',num2str(sac)])
                %                 drawnow
                %                 hold off
                %                 if PrintFlag==1%MWL
                %                     print
                %                 end
                %                 pause
            end
            % now plot entire trial, showing all saccades with onsets and
            % offsets marked
            plot(I_x(plts,1:500),'b.');
            hold on
            plot(I_y(plts,1:500),'r.');
            stem(nonzeros(Begin_Sac(plts,:)),ones(length(nonzeros(Begin_Sac(plts,:)))).*-maxxy,'m-')
            stem(nonzeros(End_Sac(plts,:)),ones(length(nonzeros(End_Sac(plts,:)))).*-maxxy,'k-.')
            stem(nonzeros(Begin_Sac(plts,:)),ones(length(nonzeros(Begin_Sac(plts,:)))).*maxxy,'m-')
            stem(nonzeros(End_Sac(plts,:)),ones(length(nonzeros(End_Sac(plts,:)))).*maxxy,'k-.')
            stem(nonzeros(SaccBegin(plts,:)),ones(length(nonzeros(SaccBegin(plts,:)))).*-maxxy,'m-')
            stem(nonzeros(SaccEnd(plts,:)),ones(length(nonzeros(SaccEnd(plts,:)))).*-maxxy,'k-.')
            stem(nonzeros(SaccBegin(plts,:)),ones(length(nonzeros(SaccBegin(plts,:)))).*maxxy,'m-')
            stem(nonzeros(SaccEnd(plts,:)),ones(length(nonzeros(SaccEnd(plts,:)))).*maxxy,'k-.')
            title([filename,'   Trial ',num2str(plts)])
            hold off
            %             if PrintFlag==1;%MWL
            %                 print
            %             end
            pause
        end
    end

    % save to temporary file
    multifile=multifile+1;
    file=[tempfile,num2str(multifile)];
    save(file,'SaccBegin','SaccEnd','SaccDir','SaccAmp');
    disp(['Trial No ',num2str(((multifile-1)*maxTrialNo)+adjustment+1),' to ',...
        num2str((multifile*maxTrialNo)+adjustment),' written to temporay file ',...
        file])

end

%OUTPUTS
%Save outputs to the file
if(SAVEVARS==1)&(~MultiFileFlag)
    if max(SaccBegin(:))
        save([file_path,filename],'SaccBegin','SaccEnd','SaccDir','SaccAmp','-append');
        % SaccBegin & SaccEnd are in Eyeposition-Units (* 4 ms to get time in msec)
    end
else
    % CALL TO FUNCTION ... FUSE_SACCDET.M
    %Now FUSE (Merge is for merging MNAP and PDP files)
    TrialNo_=fuse_saccdet([file_path,filename],tempfile,multifile);
    disp(['Total Trials ',num2str(TrialNo_)])
    disp('    ')
    file=[tempfile,'*','.mat'];
    delete(file)
end

VARS2LOAD={'SaccBegin','SaccEnd','SaccDir','SaccAmp'};
for ii=1:size(VARS2LOAD,2)
    eval(['load(',q,[file_path,filename],qcq,VARS2LOAD{ii},qcq,'-mat',q,')'])
end

nout = max(nargout,1);
if nout>1
    varargout(1) = {SaccBegin}; SAVEVARS=0;
    if nout>=2
        varargout(2) = {SaccEnd}; SAVEVARS=0;
        if nout>=3
            varargout(3) = {SaccDir}; SAVEVARS=0;
            if nout>=4
                varargout(4) = {SaccAmp}; SAVEVARS=0;
            end
        end
    end
end

