function [p,z,x1j,y1j,x2j,y2j,r] = nSwivels(b,s1,s2,h,rt)
% [p,z,x1j,y1j,x2j,y2j,r] = nSwivels(b,s1,s2,h,rt)
% returns parameters for plotting n Carpenter style reciprobit plots on the same rt axis.
% In Carpenter's formulation, there are two processes that race to a barrier. The main process
% has slope, k1, drawn from N(b,s1), so that y1 = k1*t. When kt = h, the subject reacts. H is the barrier
% height. The second process has slope k2 drawn from N(0,s2). So y2 = k2 * t. Notice that on average y2 =0,
% so the process never reaches the barrier at y=h. The positive tails of N(0,s2) give rise to some
% ramps that beat the main process to a barrier. 
% This function allows the user to specify the model paramters as column vectors. Each row corresponds to 
% a different distribution. These must all be n by 1. The final rhs arg is rt, which is used 
% to specify the range of rt (in msec). It is best to sample this finely, e.g., [100:1000]';
% let nt = length(rt)
%      n = length(b) = length(s1) = length(s2) = length(h)
%
% Return args
% ~~~~~~ ~~~~
% p nt by n matrix whose columns are the cumulative probability at values in r
% z nt by n matrix given by norminv(p)
% x1j y1j  are 2 by n matrices that contain the lines that idealize the main process
%    e.g., line(x1j(:,1),y1j(:,1)) can be used to plot the  line for the 1st distribution
% x2j y2j  are 2 by n matrices that contain the lines that idealize the second process
%    e.g., line(x2j(:,1),y2j(:,1)) can be used to plot the  line for the 2nd distribution
% r the reciprocal time values in ascending order. plot(-r,z(:,1)) gives the function corresponding 
%    to b(1), s1(1), s2(1), h(1).

% 9/25/01 mns wrote it

sb = size(b);
if sb(2) ~= 1;
	error('params must be column vectors of identical length')
end

if any(size(s1) ~= sb) | any(size(s2) ~= sb) | any(size(h) ~= sb)
	error('params must be column vectors of identical length')
end

r = sort(1./rt(:));

n = length(b);
nr = length(r);
p = repmat(nan,nr,n);
z = repmat(nan,nr,n);
x1j = repmat(nan,2,n);
x2j = repmat(nan,2,n);
y1j = repmat(nan,2,n);
y2j = repmat(nan,2,n);

for i = 1:n
	% probability of seeing r from the main process is the likelihood of picking
	% r from N(b/h,s1/h) times the probability that the other process produces a longer
	% rt hence a smaller reciprocal rt. Notice that the negative half of the second process
	% must always give rise to a smaller reciprocal time. It's ok to integrate this part
	% of the distribution.
	p1 = normpdf(r,b(i)/h(i),s1(i)/h(i)) .* normcdf(r,0,s2(i)/h(i));
	% The prob of seeing r from the second "guess" process is the likelihood of picking
	% r from N(0,s2/h) conditional on getting a positive value times the probability that the main process produces a longer
	% rt hence a smaller reciprocal rt. Note that the conditionalization on getting
	% a positive value from the guess process is necessary because we are assuming that
	% this process actually gives rise to a barrier crossing. This necessitates the
	% multiplication by 2.
	p2 = normpdf(r,0,s2(i)/h(i)) .* normcdf(r,b(i)/h(i),s1(i)/h(i));
	p12 = p1 + p2;
	area = trapz(r,p12);
	
	p(:,i) = 1 - cumtrapz(r, p12)/area;
	z(:,i) = norminv(p(:,i));
	
	% What are the lines that define the two processes?
	x2j(:,i) = [-max(r) 0]';
	y2j(:,i) = [-max(r) * h(i)/s2(i) 0]';
	x1j(:,i) = [-3*s1(i)/h(i) - b(i)/h(i) 0]';
	y1j(:,i) = [-3  (b(i)/h(i)) * (h(i)/s1(i)) ]';
end
