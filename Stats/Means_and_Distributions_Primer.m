

% Geometric Mean
   %Used for numbers that differ markedly in scale.  Normalizes numbers s.t. no one metric has greater
   %pull.
   % If n = number of values (X) entering into mean, geomean = nth root of prod(x) (Or, prod(x)^(1/n))
   
   g = geomean([2 80000])
   g1 = prod([2 80000])^(1/2)
   
   
% Harmonic Mean
    %Used for the average of rates and ratios
    % is computed as the reciprocal of the arithmatic mean of the reciprocals:
    % 1 / mean([1/x1 1/x2 1/x3 1/x4])
    
    h = harmmean([2 4 6])
    h1 = 1 / (mean([1/2 1/4 1/6]))
    
    %example: speed
        % constant distance, varying speed
        % if one travels a distance of d at 40 mph and the same distance d at 60 mph, the average
        % speed is harmmean([40 60]) = 48mph.  This means that over an IDENTICAL TRAVEL TIME, moving at
        % 48mph will carry you the same distance as 40 and then 60mph.
        
        % constant time, varying speed
        % HOWEVER, if one travels at different rates for identical amounts of time, one uses the arithmatic mean.
        % travel at 40 mph for t and 60mph for t = mean([40 60]) = 50
    
        
        % Harmonic mean for 2 resistors in parallel
        % Arithmatic mean for 2 resistors in series
        
        
% Root-mean-square (RMS)
    % used to find the magnitude of a varying signal, often when parts of the signal are both positive
    % and negative (as in a sinusoidal wave)
        % computed as the square root of the arithematic mean of the squares
        % 1, subtract the mean from the time series to center it
        % 2, square these values as a method of rectifying
        % 3, take the average of the squared values
        % 4, take the square root of the average to put back on non-squared metric
        
        %RMS = sqrt(mean([x1^2 x2^2 x3^2]))
        
        % sine wave = amp*sin(2*pi*Hz*t);  where t = 0:.001:1
        
        r1 = rms([-4 -2 2 4])
        r2 = sqrt(mean(([-4 -2 2 4] - mean([-4 -2 2 4])).^2))
        
        % EXAMPLE: sine waves
        t = 0:.001:1;
        
        %differing in amplitude (same frequency)
        sn1 = 2*sin(2*pi*30*t);
        sn2 = 20*sin(2*pi*30*t);
        
        %These differ in amplitude by 1 order of magnitude, and so will the RMS
        R1a = rms(sn1)
        R1b = rms(sn2)
        
        %differing in frequency (same amplitude)
        sn3 = 2*sin(2*pi*30*t);
        sn4 = 2*sin(2*pi*300*t);
        
        
        %These differ in frequency but have the same amplitude, so the RMS will be the same
        R2a = rms(sn3)
        R2b = rms(sn4)
        
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DISTRIBUTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Geometric Distribution



% Hypergeometric Distribution
    % k successes in N draws from a finite population of size N that contains m successes (WITHOUT REPLACEMENT)

    % This is like the binomial, except draws are made w/o replacement and instead of a base-rate
    % probability P, we have a base number of successes
    
    % I THINK THIS DESCRIBES A NONSTATIONARY BINOMIAL
        % There is an urn of 100 marbles, 10 of which are red (success)  [analogous to binomial w/ base rate of .10
        % you are going to take a sample of 9 marbles, w/o replacement.  What is probability that 1 is
        % red?
        x = 1; M = 100; k = 10; N = 9;
        h = hygepdf(x,M,k,N)
        
        
        % Now consider 100 marbles, 10 of which are red, and you are going to take a sample of 1 marble.
        % What is probability that 1 is red?
        x = 1; M = 100; k = 10; N = 1;
        h = hygepdf(x,M,k,N)
        

        % vs. Binomial Distribution
        % Note that this is identical to binomial probability with P = .10
    
        b = binopdf(1,1,.1);
        
        
        
% Inverse Hypergeometric CDF    






% Fisher's Exact-test
        