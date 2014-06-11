function [SpkTimes,SpkHist]=gen_SpikeTrain(FRinHz,NTrials,varargin)
%function [SpkTimes,SpkHist]=gen_SpikeTrain(FRinHz,NTrials,varargin)
%Generate trials for a given firing rate(scalar/vector)
%Braden Purcell


%BinWidth For Histogram
Plotsimu=0;

PlotProgress=0;
BinWidth=1;
DefaultTrialTime=2000;
%%%%
HTime=[];
Model=numel(FRinHz);
if Model==1
   ModelIs='Homogenous';
   if nargin==3
      TrialTime=varargin{1};   
   else
      TrialTime=DefaultTrialTime;%default   
   end
   HTime=[1:TrialTime]';
   BinWidth=1;
elseif Model>1
   ModelIs='InHomogenous';
   Temp=FRinHz;
   [r,c]=size(Temp);
   if (r==2 & c>2)%if two rows, more than two columns
      HTime=Temp(1,:);
      FRinHz=Temp(2,:);
   elseif (r>2 & c>=2)%if more than two grows, two or more columns
      HTime=Temp(:,1);
      FRinHz=Temp(:,2);
   elseif length(Temp)==numel(Temp)%if only one row of FR
      HTime=[1:length(Temp)]';%HTime=column vector 1:length(firing times)
      FRinHz=Temp(:);%FRinHz=column vector of firing rate over time
   end
   BinWidth=unique(diff(HTime)); %1
   TrialTime=length(HTime);   % 911
end
clear Temp
HTime=HTime(:);
FRinHz=FRinHz(:);
DeltaT=1e-3;%1 ms Bins (i.e. delta from David Heeger paper)
Crit=FRinHz*DeltaT;

%left with Crit=FRinHz in milliseconds


if Model==1
   Crit=repmat(Crit,1,TrialTime);   
end
Crit=Crit(:)';
SpkTimes=[];
for trl=1:NTrials
   temp=[];st=[];
   temp=rand(1,TrialTime);
   st=find((temp-Crit)<=0);
   if ~isempty(st)
      SpkTimes(trl,1:length(st))=st;
   else
      SpkTimes(trl,1)=0;
   end
   if Plotsimu==1 & trl<10 
   figure(99)
   plot(SpkTimes,'r')
    
   figure(100)
   plot(Crit,'b')
   figure(101)
   plot(temp,'g')
   
   pause;
   end;    
   
   
end

%Plot the Histogram
PreTime=min(HTime);
PostTime=max(HTime);
SpNan=SpkTimes;
SpNan(find(SpNan==0))=nan;

SpNan=SpNan-repmat(abs(PreTime),size(SpNan,1),size(SpNan,2));
SpkTimes=SpNan;
SpNan=SpNan(:);
Temp=hist(SpNan,HTime);
Temp=Temp(:)./NTrials;
TempN=convn(Temp,1000,'same');%NoFilter
Ker=get_boxcar;
TempB=convn(Temp,Ker,'same');%Boxcar filter
Ker=get_psp;
TempP=convn(Temp,Ker,'same');%psp filter
SpkHist=[HTime TempN TempP TempB];
if PlotProgress
   h=findobj('type','figure');
   if ~isempty(h)
      figure(max(h)+1)
   else
      figure(1)
   end
   plot(SpkHist(:,1),SpkHist(:,2))
   hold on
   plot(SpkHist(:,1),SpkHist(:,3),'r.')
   hold off
end

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
function Kernel=get_boxcar
Factor=1000;
BinSize=20;% default
if(isempty(BinSize)), BinSize=20;,end
Half_BW=(round(BinSize)/2);
BinSize=Half_BW*2;
Kernel=ones(1,(Half_BW*2)+1);
Kernel=Kernel.*Factor/sum(Kernel);
Kernel=Kernel';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Kernel=get_psp
Growth=1;Decay=20;
Half_BW=round(Decay*8);
BinSize=(Half_BW*2)+1;
Kernel=[0:Half_BW];
Half_Kernel=(1-(exp(-(Kernel./Growth)))).*(exp(-(Kernel./Decay)));
Half_Kernel=Half_Kernel./sum(Half_Kernel);
Kernel(1:Half_BW)=0;
Kernel(Half_BW+1:BinSize)=Half_Kernel;
Kernel=Kernel.*1000;
Kernel=Kernel';