%attempt to recover trial-by-trial LBA parameter estimates
%qload_SAT2
%first, fit model

[solution,LL,AIC,BIC,CDF,Trial_Mat] = fitLBA_SAT([1 3 1 1],0);


slow_correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 1);
slow_errors = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 1);
med_correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 2);
med_errors = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 2);
fast_correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 3);
fast_errors = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 3);


[A b.slow b.med b.fast v T0] = disperse(solution);





for trl = 1:length(Trial_Mat(:,4))
    if Trial_Mat(trl,3) == 1
        if Trial_Mat(trl,5) == 1
            if Trial_Mat(trl,4) <= ( ((b.slow - A) / v) + T0 )
                d(trl,1) = (b.slow - A) / (Trial_Mat(trl,4) - T0);
                a(trl,1) = A;
            elseif ( (b.slow-A) / v ) + T0 < Trial_Mat(trl,4) & Trial_Mat(trl,4) < (b.slow/v)+T0
                d(trl,1) = v;
                a(trl,1) = b.slow - (Trial_Mat(trl,4) - T0) * v;
            elseif Trial_Mat(trl,4) >= (b.slow/v)+T0
                d(trl,1) = b.slow/(Trial_Mat(trl,4) - T0);
                a(trl,1) = 0;
            else
                error('Undefined')
            end
        elseif Trial_Mat(trl,5) == 2
            if Trial_Mat(trl,4) <= ( ((b.slow - A) / v) + T0 )
                d(trl,1) = (b.med - A) / (Trial_Mat(trl,4) - T0 );
                a(trl,1) = A;
            elseif ( (b.med-A) / v ) + T0 < Trial_Mat(trl,4) & Trial_Mat(trl,4) < (b.med/v)+T0
                d(trl,1) = v;
                a(trl,1) = b.med - (Trial_Mat(trl,4) - T0) * v;
            elseif Trial_Mat(trl,4) >= (b.med/v)+T0
                d(trl,1) = b.med/(Trial_Mat(trl,4) - T0);
                a(trl,1) = 0;
            else
                error('Undefined')
            end
        elseif Trial_Mat(trl,5) == 3
            if Trial_Mat(trl,4) <= ( ((b.fast - A) / v) + T0 )
                d(trl,1) = (b.fast - A) / (Trial_Mat(trl,4) - T0 );
                a(trl,1) = A;
            elseif ( (b.fast-A) / v ) + T0 < Trial_Mat(trl,4) & Trial_Mat(trl,4) < (b.fast/v)+T0
                d(trl,1) = v;
                a(trl,1) = b.fast - (Trial_Mat(trl,4) - T0) * v;
            elseif Trial_Mat(trl,4) >= (b.fast/v)+T0
                d(trl,1) = b.fast/(Trial_Mat(trl,4) - T0);
                a(trl,1) = 0;
            else
                error('Undefined')
            end
        end
    elseif Trial_Mat(trl,3) == 0
        if Trial_Mat(trl,4) <= ( ((b.slow - A) / 1-v) + T0 )
            d(trl,1) = (b.slow - A) / (Trial_Mat(trl,4) - T0 );
            a(trl,1) = A;
        elseif ( (b.slow-A) / 1-v ) + T0 < Trial_Mat(trl,4) & Trial_Mat(trl,4) < (b.slow/1-v)+T0
            d(trl,1) = 1-v;
            a(trl,1) = b.slow - (Trial_Mat(trl,4) - T0) * v;
        elseif Trial_Mat(trl,4) >= (b.slow/1-v)+T0
            d(trl,1) = b.slow/(Trial_Mat(trl,4) - T0);
            a(trl,1) = 0;
        else
            error('Undefined')
        end
    elseif Trial_Mat(trl,5) == 2
        if Trial_Mat(trl,4) <= ( ((b.slow - A) / 1-v) + T0 )
            d(trl,1) = (b.med - A) / (Trial_Mat(trl,4) - T0 );
            a(trl,1) = A;
        elseif ( (b.med-A) / 1-v ) + T0 < Trial_Mat(trl,4) & Trial_Mat(trl,4) < (b.med/1-v)+T0
            d(trl,1) = 1-v;
            a(trl,1) = b.med - (Trial_Mat(trl,4) - T0) * v;
        elseif Trial_Mat(trl,4) >= (b.med/1-v)+T0
            d(trl,1) = b.med/(Trial_Mat(trl,4) - T0);
            a(trl,1) = 0;
        else
            error('Undefined')
        end
    elseif Trial_Mat(trl,5) == 3
        if Trial_Mat(trl,4) <= ( ((b.fast - A) / 1-v) + T0 )
            d(trl,1) = (b.fast - A) / (Trial_Mat(trl,4) - T0 );
            a(trl,1) = A;
        elseif ( (b.fast-A) / 1-v ) + T0 < Trial_Mat(trl,4) & Trial_Mat(trl,4) < (b.fast/1-v)+T0
            d(trl,1) = 1-v;
            a(trl,1) = b.fast - (Trial_Mat(trl,4) - T0) * v;
        elseif Trial_Mat(trl,4) >= (b.fast/1-v)+T0
            d(trl,1) = b.fast/(Trial_Mat(trl,4) - T0);
            a(trl,1) = 0;
        else
            error('Undefined')
        end
    end
end
