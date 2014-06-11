%for tests, use t = .001:.001:1 (note: its in SECONDS not milliseconds)

%inputs:
% t = time in SECONDS
% v = mean drift rate across trials
% a = boundary
% z = start point
% eta = across-trial standard deviation of drift
% s = scaling parameter (.10)
% xi = current drift rate
% sz = range of uniform start point distribution
% st = range of uniform Ter distribution
% Ter = nondecision time

function Q = diffusion3(t)
%TEST VALUES
global v a z eta s sz_start st_start Ter
%t = .2;
v = .2;
a = .16;
z = a/2;
eta = .08;
% xi = .8, a = .04 z = a/2
s = .10;
Ter = .1;
sz_start = .04;
st_start = .04;
%sz = sz_start;
%st = st_start;

%t = t - Ter;

%send xi as the value to be evaluated; other parameters as constants
%Q = quad(@(xi)getG1(xi,[t,v,a,z,eta,s]),-4*eta,4*eta);
% integrate_over_xi = quad(@(xi)getG1(xi,t),-4*eta,4*eta);
% integrate_over_sz = quad(@(sz)getG2(sz,integrate_over_xi),z-(sz_start./2),z+(sz_start./2));
% F = quadgk(@(st)getF(st,integrate_over_sz),Ter-(st_start/2),min((Ter+(st_start/2)),t));

% 
%     function F = getF(st,integrate_over_sz)
%         F = integrate_over_sz .* (1./st);
%     end
% 
%     function G2 = getG2(sz,integrate_over_xi)
%         G2 = integrate_over_xi .* (1./sz);
%     end
% 
%     function G1 = getG1(xi,t)
%         
%         outg = getG(t,xi,a,z,s);
% 
%         
%         
%     end

    F = @(xi,sz_start,st_start)getG(xi,sz_start,st_start,t);
    Q = triplequad(F,-4*eta,4*eta,z-(sz_start./2),z+(sz_start./2),Ter-(st_start/2),min((Ter+(st_start/2)),t));
    
    
    function F = getG(xi,sz,st,t)
        %infinite sum handling
        tol = 1e-29;
        
        for k = 1:inf
            part_a = 2*k*sin(k*pi*z/a) .* exp(-.5.*( (xi.^2./s^2) + (pi^2*k^2*s^2/a^2)).*t);
            part_b = ( (xi.^2./s^2) + (pi^2*k^2*s^2/a^2) );
            
            %inf_sum(1:length(t),k) = part_a ./ part_b;
            inf_sum(1:length(xi),k) = part_a ./ part_b;
            
            %break if we've hit tolerance
            if k > 1
                if abs(inf_sum(k)) < tol && abs(inf_sum(k-1)) < tol
                    break
                end
            end
        end
        
        P = getP(xi,a,z,s);
        
        part1 = P;
        part2 = (  (pi*s^2) / a^2  ) .* exp(-(xi.*z ./ s^2));
        
        outg = part1 - part2 .* sum(inf_sum);
        
        
        clear part1 part2
        
        part1 = 1 / sqrt(2*pi*eta^2);
        part2 = exp(-(  ((v-xi).^2) ./ (2*eta^2) ));
        
        G1 = outg .* part1 .* part2;
        
        clear part1 part2
        
        G2 = G1 .* (1/sz);
        
        F = G2 .* (1/st);
    end



    function P = getP(xi,a,z,s)
        %returns probability of an error.
        % to return probabiltity of a correct response, change:
            %z = a-z
            %xi = -xi
            %from Tuerlinckx, 2004 Beh. Res. Methods, Instru. & Comp.
        P = (  exp(-(2.*xi.*a ./ s^2)) - exp(-(2.*xi.*z./s^2))  )     /   (exp(-(2.*xi.*a./s^2)) - 1);
    end



end

