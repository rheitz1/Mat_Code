function [f] = PDFDif(t,x,Par)

% Function to derive the PDF of the DDM using an approximation method

%  t = response time (in SECONDS)
%  x = choice response (x=0 or x=1)
%  Par is the parameter vector
%   Par = [ a  Ter  eta  z  sZ  st  nu  ]
%    a = boundary separation
%    Ter = mean non-decisional component time
%    eta = standard deviation of normal drift distribution
%    z = mean starting point
%    sZ = spread of starting point distribution
%    st = spread of non-decisional component time distribution
%    nu = mean drift rate
%
% RPH


dt = 5e-4;

%get P, probability of a response (instead of integrating, I'm going to try to use infinity
P = CDFDif(inf,x,Par);

%have to divide by P to ensure it integrates to 1 (reverse the defective cdf to regular cdf)
% update 9/11/2012: dividing by P seems to be incorrect.
 %f1 = CDFDif(t + dt,x,Par);% / P;
 %f2 = CDFDif(t,x,Par);% / P;


%9/11/2012: CDFDif is not really set up for vectors.
parfor index = 1:length(t)
    
    if isnan(t(index))
        F1(index) = NaN;
        F2(index) = NaN;
        continue
    else
        F1(index) = CDFDif(t(index) + dt,x,Par);
        F2(index) = CDFDif(t(index),x,Par);
    end
end



f = (F1 - F2) / dt;

%     f = quad(@(dt)getdt(dt,t),t-.005,t);
%     %f = quad(@(t)getdt(t),t-.005,t);
%     %f = quad(@getdt,t-.005,t);
%     
%     
%     %function dt = getdt(t)
%     function dt = getdt(dt,t)
%         %t = evalin('caller','t');
%         x = evalin('caller','x');
%         Par = evalin('caller','Par');
%         
%         %for node = 1:length(t)
%         for node = 1:length(dt)
%             %dt(node) = CDFDif(t(node),x,Par) - CDFDif(t,x,Par);
%             dt(node) = (CDFDif(t+dt(node),x,Par) - CDFDif(t,x,Par))/dt(node);
%         end
%     end
end