%script to determine what the target was for the session, if the variable
%'Stimuli_' was encoded
if exist('Stimuli_') == 0 | isempty(find(~isnan(Stimuli_))) == 1
    disp('Stimuli_ variable not encoded')
else

    Ts = nonzeros(Stimuli_(find(Stimuli_ < 20)));
    Ls = nonzeros(Stimuli_(find(Stimuli_ >= 20 & Stimuli_ < 30))); %sometimes there's a '2727' in there. Limit to remove
    
    %if all the same, its our target variable.
    
    if length(unique(Ls)) == 1
        Targ = 'L'
        Targ_ID = unique(Ls);
        if Ls(1) == 21
            orien = 'Up'
        elseif Ls(1) == 22
            orien = 'Right'
        elseif Ls(1) == 23
            orien = 'Down'
        elseif Ls(1) == 24
            orien = 'Left'
        end
        
    elseif length(unique(Ts)) == 1
        Targ = 'T'
        Targ_ID = unique(Ts);
        if Ts(1) == 11
            orien = 'Up'
        elseif Ts(1) == 12
            orien = 'Right'
        elseif Ts(1) == 13
            orien = 'Down'
        elseif Ts(1) == 14
            orien = 'Left'
        end
        
    else
        disp('Error')
    end
    
    clear Ls Ts
end