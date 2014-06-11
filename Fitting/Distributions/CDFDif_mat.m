function y = CDFDif_mat(t,x,Par)
%CDFDif  Cumulative Distribution Function for the Diffusion model
% Function that computes the cumulative distribution function of the diffusion model 
% with random drift, random starting point and random non-decisional component ter. 
% The function returns F_{X,T}(x,t) = Pr(X=x,T<=t).
%
% y = CDFDif(t,x,Par)
%  t = response time
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
% Author : Francis Tuerlinckx, Department of Psychology, University of Leuven, Belgium.
% email: francis.tuerlinckx@psy.kuleuven.ac.be
%
% Last change : May 4, 2004

%====================
%RPH 10/12/2012:  This code is not set up for vectors (some if statements exist to check if t > or t <
%something; Thus, fail if vector

if ~isscalar(t); error('Non-scalar input...'); end


%====================
%RPH 10/12/2012:  Deal with NaNs.
if isnan(t)
    y = NaN; 
    return
end


%%%%%%%%%%% initialization of parameters
a = Par(1); 
a2 = a^2;
Ter = Par(2);
eta = Par(3);
z = Par(4);
sZ = Par(5);
st = Par(6);
nu = Par(7);

Z_U = (1-x)*z+x*(a-z)+sZ/2; % upper boundary of starting point distribution
Z_L = (1-x)*z+x*(a-z)-sZ/2; % lower boundary of starting point distribution
lower_t=Ter-st/2; % lower boundary of non-decisional component time distribution

%%%%%%%%%% defining the constants
%%%%%%%%%%%%% note that eps is the Floating Point Relative Precision
%%%%%%%%%%%%% (and that it is machine-dependent)
v_max = 5000; % maximum number of terms in a partial sum approximating infinite series
delta = 1.e-29; % convergence values for terms added to partial sum
epsilon = 1.e-7; % value to check deviation from zero
min_RT=0.001; % realistic minimum time to complete the decision process
s2 = 0.1^2; % scale factor
nr_nu = 10; % number of Gauss-Hermite quadrature points
nr_z = 10; % number of Gaussian quadrature points

%%%%%%%%%% 10 Gauss-Hermite quadrature nodes and weights
gr_gh = [  -3.43615911883774  -2.53273167423279  -1.75668364929988  -1.03661082978951  -0.34290132722370 ...  
        0.34290132722370   1.03661082978951   1.75668364929988   2.53273167423279   3.43615911883774];
gk = sqrt(2)*gr_gh*eta+nu; % appropriate scaling of GH quadrature nodes based on normal kernel
w_gh = [   0.00000764043286   0.00134364574678   0.03387439445548   0.24013861108230   0.61086263373530 ...  
        0.61086263373530   0.24013861108230   0.03387439445548   0.00134364574678   0.00000764043286];
w_gh = w_gh/sqrt(pi); % appropriate weighting of GH quadrature weights based on normal kernel

%%%%%%%%%% 10 Gaussian quadrature nodes and weights
gr_g = [ -0.973906528517172 -0.865063366688985 -0.679409568299024 -0.433395394129247 -0.148874338981631 ...
        0.148874338981631 0.433395394129247 0.679409568299024 0.865063366688985 0.973906528517172];
gz = sZ/2*gr_g+z; % appropriate scaling of Gaussian quadrature nodes
w_g = [  0.066671344308688 0.149451349150581 0.219086362515982 0.269266719309996 0.295524224714753 ...
        0.295524224714753 0.269266719309996 0.219086362515982 0.149451349150581 0.066671344308688];

%%%%%%%%%% compute integrated probability Pr(X=1)
sum_z=0;
for i=1:nr_z  % numerical integration with respect to z_0
    sum_nu=0;
    for m=1:nr_nu  % numerical integration with respect to xi
        if (abs(gk(m))>epsilon) % test for gk(m) being close to zero
            sum_nu=sum_nu+(exp(-2*gz(i)*gk(m)/s2)-1)/(exp(-2*a*gk(m)/s2)-1)*w_gh(m);
        elseif (abs(gk(m))<epsilon)
            sum_nu=sum_nu+gz(i)/a*w_gh(m);
        end
    end
    sum_z=sum_z+sum_nu*w_g(i)/2;
end
prob=sum_z;

%%%%%%%%% compute second part distribution function

if (t-Ter+st/2>min_RT) % is t larger than lower boundary non-decisional component time distribution?
    upper_t=min([t Ter+st/2]);
    p1=prob*(upper_t-lower_t)/st; % integrate probability with respect to t
    p0=(1-prob)*(upper_t-lower_t)/st;
    if (t>Ter+st/2) % is t larger than upper boundary non-decisional component time distribution?
        sum_hist=zeros(3,1);
        for v=1:v_max % infinite series
            sum_hist(1:2)=sum_hist(2:3);
            sum_nu=0;
            for m=1:nr_nu % numerical integration with respect to xi
                denom=(gk(m)^2/s2+(pi^2)*(v^2)*s2/a2);
                upp=exp((2*x-1)*Z_U*gk(m)/s2-3*log(denom)+log(w_gh(m))+2*log(s2));
                low=exp((2*x-1)*Z_L*gk(m)/s2-3*log(denom)+log(w_gh(m))+2*log(s2));
                sifa=pi*v/a;
                fact=upp*((2*x-1)*gk(m)*sin(sifa*Z_U)/s2-sifa*cos(sifa*Z_U)) ...
                    -low*((2*x-1)*gk(m)*sin(sifa*Z_L)/s2-sifa*cos(sifa*Z_L));
                exdif=exp((-0.5*denom*(t-upper_t))+log(1-exp(-0.5*denom*(upper_t-lower_t))));
                sum_nu=sum_nu+fact*exdif;
            end
            sum_hist(3)=sum_hist(2)+v*sum_nu;
            if ((abs(sum_hist(1)-sum_hist(2))<delta) & (abs(sum_hist(2)-sum_hist(3))<delta) & (sum_hist(3)>0))
                break
            end
        end
        Fnew=(p0*(1-x)+p1*x)-sum_hist(3)*4*pi/(a2*sZ*st); % cumulative distribution function for t and x
    elseif (t<=Ter+st/2) % is t lower than upper boundary non-decisional component time distribution?
        sum_nu=0;
        for m=1:nr_nu
            if (abs(gk(m))>epsilon)
                sum_z=0;
                for i=1:nr_z
                    zzz=(a-gz(i))*x+gz(i)*(1-x);
                    ser=-((a^3)/((1-2*x)*gk(m)*pi*s2))*sinh(zzz*(1-2*x)*gk(m)/s2)/(sinh((1-2*x)*gk(m)*a/s2)^2)+(zzz*a2)/((1-2*x)*gk(m)*pi*s2)*cosh((a-zzz)*(1-2*x)*gk(m)/s2)/sinh((1-2*x)*gk(m)*a/s2);
                    sum_hist=zeros(3,1);
                    for v=1:v_max
                        sum_hist(1:2)=sum_hist(2:3);
                        sifa=pi*v/a;
                        denom=(gk(m)^2/s2+(pi*v)^2*s2/a2);
                        sum_hist(3)=sum_hist(2)+v*sin(sifa*zzz)*exp(-0.5*denom*(t-lower_t)-2*log(denom));
                        if ((abs(sum_hist(1)-sum_hist(2))<delta)& (abs(sum_hist(2)-sum_hist(3))<delta) & (sum_hist(3)>0))
                            break
                        end
                    end
                    sum_z=sum_z+0.5*w_g(i)*(ser-4*sum_hist(3))*(pi*s2)/(a2*st)*exp((2*x-1)*zzz*gk(m)/s2);
                end
            elseif (abs(gk(m))<epsilon)
                sum_hist=zeros(3,1);
                su=-(Z_U^2)/(12*a2)+(Z_U^3)/(12*a^3)-(Z_U^4)/(48*a^4);
                sl=-(Z_L^2)/(12*a2)+(Z_L^3)/(12*a^3)-(Z_L^4)/(48*a^4);
                for v=1:v_max
                    sum_hist(1:2)=sum_hist(2:3);
                    sifa=pi*v/a;
                    denom=(pi*v)^2*s2/a2;
                    sum_hist(3)=sum_hist(2)+(pi*v)^(-4)*(cos(sifa*Z_L)-cos(sifa*Z_U))*exp(-0.5*denom*(t-lower_t));
                    if ((abs(sum_hist(1)-sum_hist(2))<delta) & (abs(sum_hist(2)-sum_hist(3))<delta) & (sum_hist(3)>0))
                        break
                    end
                end
                sum_z=4*(a^3)/(st*sZ*s2)*(sl-su-sum_hist(3));
            end
            sum_nu=sum_nu+sum_z*w_gh(m);
        end
        Fnew=(p0*(1-x)+p1*x)-sum_nu;
    end
elseif (t-Ter+st/2<=min_RT) % is t lower than lower boundary non-decisional component time distribution?
    Fnew=0;
end
y=Fnew*(Fnew>eps);
