%generate normally distributed sample
function [] = Gaussian_MLE_example_full(start_u,start_sigma)

data = normrnd(start_u,start_sigma,1000,1);

%now lets obtain the liklihood functions given a gaussian with an different means and variances
for u = 1:100
    
    for sigma = 1:100
        L(u,sigma) = sum(log(normpdf(data,u,sigma)));
    end
end




%This gives rise to a surface of the two parameters mu and sigma

% figure
% surf(L)


%TO recover the best fitting parameters, we need to find the minimum along each dimension

[~,BestFit_Mu] = max(max(L,[],2))
[~,BestFit_Sigma] = max(max(L,[],1))


%now lets use fminsearch to minimize -LL (because we actually want to maximize LL)
u_guess = 1;
sigma_guess = 1;
solution = fminsearch(@(param_input) calcLL(param_input,data),[u_guess ; sigma_guess],['Display','iter'])

end


function [LL] = calcLL(param_input,data)
u = param_input(1);
sigma = param_input(2);

LL = -sum(log(normpdf(data,u,sigma)));
end