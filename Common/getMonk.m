%determine monkey and ASL_delay

if newfile(1) == 'Q'
    monkey = 'Q';
    ASL_Delay = 0;
elseif newfile(1) == 'S'
    
    monkey = 'S';
    %determine date recorded to set ASL_Delay
    mo = str2num(newfile(2:3));
    yr = str2num(newfile(6:7));
    
    if yr == 8 & mo < 4
        ASL_Delay = 1;
    elseif yr == 7
        ASL_Delay = 1;
    else
        ASL_Delay = 0;
    end
    
    clear mo yr
end
    