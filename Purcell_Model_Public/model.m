function [RT,response,Tunit,Dunit]= model(Tinput,Dinput,diff_start,time_index,Criterion,Tballistic,leakage,gate,beta,noiseT,noiseD,u)

%fix excitatory weights at 1
w=1;

%run model
    for index = diff_start+1:length(Tinput)
        Tinput_current=Tinput(index);
        Dinput_current=Dinput(index);
        %                 %last value   +   current value -  feedforward(from opposing vis)    - gate   - leakage(of current vis)  - lateral inhibition (opposing move)  + noise
        Tinput(index) = Tinput(index-1)+max((w*Tinput_current)-(u*Dinput_current)-(gate),0)-(leakage*Tinput(index-1))-(Dinput(index-1)*beta)+noiseT(index);
        Tinput(index)=max(Tinput(index),0);
        Dinput(index) = Dinput(index-1)+max((w*Dinput_current)-(u*Tinput_current)-(gate),0)-(leakage*Dinput(index-1))-(Tinput(index-1)*beta)+noiseD(index);
        Dinput(index)=max(Dinput(index),0);
    end

%rename
    Tunit=Tinput;
    Dunit=Dinput;
    
%get RT/response
    %get first RT to pass criterion
    RT_T = time_index(find(Tunit>Criterion,1,'first'))+1;
    RT_D = time_index(find(Dunit>Criterion,1,'first'))+1;

    %save current RTpred
    if isempty(RT_T),RT_T=inf;end
    if isempty(RT_D),RT_D=inf;end
    winner = min(RT_T,RT_D);

    %save correct winning RTs
    if RT_T == winner && ~isinf(winner)
        RT = RT_T+Tballistic;
        response=1;
    elseif RT_D == winner && ~isinf(winner)
        RT = RT_D+Tballistic;
        response=0;
    elseif isinf(winner)
        RT = nan;
        response=nan;
    end
                
end
    
    
    



