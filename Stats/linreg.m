% %how to do linear regression in matlab.
% x = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41];
% y = [8.76775401246844,11.1089616548085,10.5735416475504,9.80973868593456,10.3073281865293,11.9280371607433,13.1063672237473,14.8590805559090,16.6684289110479,17.8450809373290,18.7728505601924,18.8693465724714,19.4119158963400,20.0331067628565,19.3475752847906,18.2419821225830,20.4170082922825,20.1838706809743,21.2160318080749,21.3224801298213,20.4110763066585,19.1770743634720,18.5548149158384,20.8876365096966,22.7506475088555,25.0392002718980,27.4300040390313,29.1380535221577,29.8388424395399,30.8689547162715,30.6491803671096,28.6671414486195,27.5076895271558,27.3514952233720,28.1615499399576,27.8958443061237,28.0258178941773,28.8970713233490,32.0206377907600,33.8143821099527,36.4413026521512];

%NOTE: using matlab's function "regress" you have to include a first column of 1's in the predictor
%variables for the constant term.  Otherwise the output will not make sense.
%
% RPH

function [m,b,r] = linreg(y,x,plotFlag)

if nargin < 3; plotFlag = 0; end

if ~isempty(find(isnan(x))) || ~isempty(find(isnan(y)))
    %disp('Removing NaNs');
    z = removeNaN([x y]);
    if isempty(z) || size(z,1) < 2
        disp('Missing Data')
        m = NaN;
        b = NaN;
        r = NaN;
        return
    end
    x = (0:1)'; y = z(:,2);
end



h = leverage([x y],'linear');

%find leverage values that are extreme by a sd criterion
outlier_cut = mean(h) + 3*std(h);
outlier = find(h >= outlier_cut);
cleanX = x;
cleanY = y;

cleanX(outlier) = [];
cleanY(outlier) = [];



%compute the linear regression of y on x
%[b,bint,r,rint,stats] = regress(y',x')
[p S] = polyfit(cleanX,cleanY,1);

%compute Y predicted

y_pred = polyval(p,cleanX);

m = p(1);
b = p(2);




if size(x,2) > 1; error('Input must be nx1 vector'); end
r_all = corr(x,y);
r = corr(cleanX,cleanY);

if plotFlag
    figure
    plot(x,y,'o')
    hold on
    
    %plot the outlier values via h statistic
    plot(x(outlier),y(outlier),'or')
    plot(cleanX,y_pred,'r','linewidth',2)
    
    %reformat for text
    M = round(p(1)*1000)/1000;
    B = round(p(2)*1000)/1000;
    R = round(corr(cleanX,cleanY)*1000)/1000;
    Rsq = round((((corr(cleanX,cleanY))^2)*1000))/1000; %do this here so that our rounding above doesn't mess with values
    
    text(.01,.95,['Y = ' mat2str(M) 'x + ' mat2str(B)],'units','normalized','fontsize',20,'fontweight','bold')
    text(.01,.85,['r = ' mat2str(R)],'units','normalized','fontsize',20,'fontweight','bold')
    text(.01,.75,['r^2 = ' mat2str(Rsq)],'units','normalized','fontsize',20,'fontweight','bold')
    
    box off
end