function chisq = ChiSquare_RT(RTdist, simRTdist)
global modelNo
% Define a fit value as a CHI SQUARE value for each RT distribution

% RTdist = RTonSStrials; simRTdist=simRTonSStrials;
% RTdist = dataReal; RTonSStrials; dataReal;
% RTdist = []; RTdist = RTonSStrials;dataReal;  
% simRTdist=[]; simRTdist =dataSim;
% RTdist = [];simRTdist = [];
% RTdist =  (normrnd(350, 500, 200, 1));
% simRTdist =RTdist(1:100);%(normrnd(400, 20, 200, 1));


%========================================================
% how many quartiles do you want to divide it into?
%========================================================
tile = 5;  

%========================================================
% Real data - GOs
% outputs NUMBER of trials per RT bin
%========================================================
validInd = []; sortdata = [];
validInd = find(~isnan(RTdist));
uniqueData = sort((RTdist(validInd)));
% numNOGO_nss = length(RTdist) - length(uniqueData);

[a b] = size(uniqueData);
num = max([a b]);
RealNum = num;

g = 0;
for i = 1:1:tile
    percen(i) = ceil(num*(i/tile));             % count up to this decile
    gg(i) = percen(i) - g;
    g = percen(i);
    cdfRT(i) = mean(uniqueData(1:percen(i)));     % mean RT in this this decile
    RTatPercen(i) = uniqueData(percen(i));        % RT value at this this decile

    if i==1
        percenNum(i) = percen(i);               % count in this bin
    else
        percenNum(i) = (percen(i)-percen(i-1));   % count in this bin
    end
end

%========================================================
% Simulated data - GOs
% outputs PERCENTAGE of trials per RT bin because need to 
% equate for number of trials in data and simulation 
%========================================================
validInd = []; Simsortdata = [];
validInd = find(~isnan(simRTdist));
SimuniqueData = sort(simRTdist(validInd)); 
SimnumNOGO_nss = length(simRTdist) - length(SimuniqueData);

[a b]= size(SimuniqueData);
num = max([a b]);

for i = 1:1:tile
    if i==1
        SpercenNum(i) = (length(find(SimuniqueData<=RTatPercen(i))))/num;
    else if i == tile
         SpercenNum(i) = (length(find(SimuniqueData>RTatPercen(i-1))))/num;
        else
            SpercenNum(i) = (length(find(SimuniqueData<=RTatPercen(i) & SimuniqueData>RTatPercen(i-1))))/num;
        end
    end
    
    if SpercenNum(i) == 0
        SpercenNum(i) = .00000000001;  % because you can't divide by 0
    end
end
% for i = 1:1:tile
%         if i==1
%             SpercenNum(i) = (length(find(SimuniqueData<=RTatPercen(i))))/num;
%         else
%             SpercenNum(i) = (length(find(SimuniqueData<=RTatPercen(i) & SimuniqueData>RTatPercen(i-1))))/num;
%         end
%     
%     if SpercenNum(i) == 0
%         SpercenNum(i) = .00000000001;  % because you can't divide by 0
%     end
% end
% sum(SpercenNum)

% REAL data in COUNT form
cpercenNum = percenNum;  
cpercenNum = cpercenNum+.00000000000001;
% SIMULATED data converted into COUNT form
cSpercenNum=SpercenNum.*RealNum;  
% cSpercenNum = round(cSpercenNum);
cSpercenNum = round(cSpercenNum)+.00000000000001;
% sum(cSpercenNum)
% sum(cpercenNum)

%==============================================================
% Chi square for trials in which a movement was made
%==============================================================
% chisq_GOtrials = nansum(((cpercenNum-cSpercenNum).^2)./cSpercenNum);
chisq_GOtrials = nansum(((cpercenNum-cSpercenNum).^2)./cSpercenNum);

%==============================================================
% Chi square for trials in which a movement was NOT made
%==============================================================
% SimnumNOGO_nss = length(find(isnan(simRTdist)));
SimNOGO = (SimnumNOGO_nss/length(simRTdist))*length(RTdist);

% can't divide by 0
if SimNOGO == 0
    SimNOGO = .00000000001;
end

% chisq_NOGOtrials = nansum(((SimNOGO-numNOGO_nss).^2)./SimNOGO);
if modelNo==48
    numNOGO_nss=0;
    chisq_NOGOtrials = ((SimNOGO-numNOGO_nss)^2)./SimNOGO;
else
    chisq_NOGOtrials = 0;
end
%==============================================================
% TOTAL Chi square
%==============================================================
chisq = chisq_GOtrials + chisq_NOGOtrials;