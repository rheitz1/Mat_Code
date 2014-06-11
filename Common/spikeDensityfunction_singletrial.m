function SDF = spikeDensityfunction_singletrial(Spike, Align_Time, Plot_Time)

% 1.3. Pre-Time & Post-Time
Pre_Time = Plot_Time(1)-100; Post_Time = Plot_Time(2);
BinCenters = [round(Pre_Time):round(Post_Time)]';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Create raw histogram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
times = nonzeros(Spike)-Align_Time;
times = times(times >= Pre_Time & times <= Post_Time);



% 2.2. divide by vector of number of trials for each milisecond bin
if(~isempty(times))

    temp_hist=hist(times,BinCenters);

    %    temp_hist = temp_hist./(length(triallist));


else

    temp_hist = zeros(length(BinCenters),1);
    poslist=[];temp=[];temp_hist=[];pl=[];

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Convolute with exponential Kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Growth=1; Decay=20;
%Decay*8 controls how far out you want the decaying function to go:
%with decay * 8, function continues to 160 ms, where little activation is
%left; if we changed it to 6, the function would continue only until 120,
%which probably wouldn't change all that much.
Half_BW=round(Decay*8);
%Half_BW indicates the duration of the activation function. Because the
%function will have an effect forward in time on the next spike, make bin
%sizes twice the length of the activation function??
BinSize=(Half_BW*2)+1;
%Kernel will be the actual activation function, which will range from 0 ms
%to Half_BW, which is the duration of the activation function
Kernel=[0:Half_BW];
%activation function: left part is activation, right is decay
%left part increases according to exponential growth, second part takes
%changing fraction of that activation (the fraction of which decays
%according to exponential). At time 0, we multiply by 1, so there is no
%decay.  at 1 ms, we take .9512% of activation; note also that this
%activation (left side) increases over time as well, but essentially
%becomes 1 by 10 ms.
Half_Kernel=(1-(exp(-(Kernel./Growth)))).*(exp(-(Kernel./Decay)));
%Change activation values from exponential to proportions?  Afterwards,
%sum(Half_Kernel) == 1.  Not sure why we do this.
Half_Kernel=Half_Kernel./sum(Half_Kernel);
Kernel(1:Half_BW)=0;
%set activation function to second half of bin.  I think this has something
%to do with the fact that Pre_Time = Plot_Time(1) - 100.
Kernel(Half_BW+1:BinSize)=Half_Kernel;
%Is 1000 arbitrary?  changes fractions into large numbers.  First value
%with current parameters is 31.7149...DOES NOT MATTER: shape of function
%convolved with histogram
Kernel=Kernel.*1000;
Kernel=Kernel';

SDF = convn(temp_hist',Kernel,'same');

if ~isempty(SDF) == 1
    SDF(1:100) = [];
else
    SDF = zeros(length(Plot_Time(1):Plot_Time(2)),1);
end
% if ~isempty(SDF)
%     SDF(1:100,:,:)=[];
% else
%     SDF(1:100) = 0;
% end