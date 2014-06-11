%compute d', bias (beta), and A' (area under ROC curve) given:
    %n signal present, respond present (n_Hit)
    %n signal present, respond not present (n_Miss)
    %n signal absenst, respond present (n_FA)
    %n signal absent, respond absent (n_Crj)
    
    
function [d_prime beta c] = getdPrime(n_Hit,n_Miss,n_FA,n_Crj)

    hit_rate = n_Hit / (n_Hit + n_Miss);
    FA_rate = n_FA / (n_FA + n_Crj);
    
    
    %d-prime is the difference between the z-scores associated with given proportions.  To get the z-scores
    %given a cumulative proportion, use inverse cumulative normal CDF
    %value of d-prime indicates the number of standard deviations the signal and noise distributions are
    %separated by
    d_prime = norminv(hit_rate) - norminv(FA_rate);
    
    
    %bias - measure of subjects' willingness to respond 'signal present'
    %is ratio of the z-scores used to compute d-prime
    %beta = (normpdf(hit_rate) / normpdf(FA_rate));
    beta = exp(( (norminv(FA_rate))^2 - (norminv(hit_rate))^2)/2);
    
    %a_prime = 5; 
   
   
   
    %From wickens:
    c = -norminv(FA_rate);
end