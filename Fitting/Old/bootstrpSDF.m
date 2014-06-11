function Plt_Spike=bootstrpSDF(inmat,nboot)
p_mglobs

Hist_raw=[];
[ntrials samples]=size(inmat);
indexmat=unidrnd(ntrials,nboot,samples);
for ii=1:nboot
    for jj=1:samples
        whichtrial=indexmat(ii,jj);
        Hist_raw(ii,jj)=inmat(whichtrial,jj);
    end
end

Smooth=get(PM_Histogram,'value');
switch Smooth
case 1
   BinSize=str2num(get(EB_BinSize,'String'));
   if(isempty(BinSize)), BinSize=20;,end
   if(BinSize <= 0), BinSize=20; elseif(BinSize > 200),BinSize=200;,else,end
   Half_BW=(round(BinSize)/2);
   BinSize=Half_BW*2;
   set(EB_BinSize,'String',num2str(BinSize));
   Kernel=ones(1,(Half_BW*2)+1);
   Kernel=Kernel.*1000/sum(Kernel);
   smooth_it(Hist_raw,Half_BW,Kernel);
case 2
   Sigma=str2num(get(EB_Sigma,'String'));
   if(isempty(Sigma)),Sigma=20;,end
   if(Sigma <=0 ),Sigma=20;,elseif(Sigma > 100),Sigma=100;,else,end
   set(EB_Sigma,'String', num2str(Sigma));
   Kernel=[-5*Sigma:5*Sigma];
   BinSize=length(Kernel);
   Half_BW=(BinSize-1)/2;
   Kernel=[-BinSize/2:BinSize/2];
   Factor=1000/(Sigma*sqrt(2*pi));
   Kernel=Factor*(exp(-(0.5*((Kernel./Sigma).^2))));
   smooth_it(Hist_raw,Half_BW,Kernel);
case 3
   Growth=str2num(get(EB_Growth,'string'));
   Decay=str2num(get(EB_Decay,'string'));
   if(isempty(Growth)),Growth=2;,end
   if(isempty(Decay)),Decay=10;,end
   if(Growth <= 0), Growth=1.0; elseif(Growth >10),Growth=10;,else,end
   if(Decay > 40), Decay=20;elseif(Decay <= 0),Decay=20;else, end
   Half_BW=round(Decay*8);
   BinSize=(Half_BW*2)+1;
   set(EB_Growth,'String',num2str(Growth));
   set(EB_Decay,'String',num2str(Half_BW/8));
   Kernel=[0:Half_BW];
   Half_Kernel=(1-(exp(-(Kernel./Growth)))).*(exp(-(Kernel./Decay)));
   Half_Kernel=Half_Kernel./sum(Half_Kernel);
   Kernel(1:Half_BW)=0;
   Kernel(Half_BW+1:BinSize)=Half_Kernel;
   Kernel=Kernel.*1000;
   smooth_it(Hist_raw,Half_BW,Kernel);
otherwise
end
%%%%%%%%%%%%%%%%%%%%%%%%SUBFUNCTION : SMOOTH_IT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function smooth_it(Hist_raw,Half_BW,Kernel)
global Plt_Spike
Hist_smooth=[];Plt_Spik=[];
Hist_smooth=convn(Hist_raw,Kernel,'same');
Plt_Spike=Hist_smooth;