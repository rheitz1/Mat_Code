function OutDat=MTPostHocTrans(InDat,df,InSpc,OutSpc,CohOrSpec)
% function OutDat=MTPostHocTrans(InDat,df,InSpc,OutSpc,CohOrSpec)
%
% Given the data and dfs, this will transform MT Coh or Spec Vals b/t raw,
% bias-corrected, and z-transformed spaces.
%
% NOTE- originally I was doing this wrong. These transformations were meant
% to be done on the coherency magnitude (which technically is what is meant
% by "coherence"). For coh, the code now will do this on teh magnitude,
% while still preserving the phase using an additional line of code. 
%
% INPUTS: 
%   InDat:      The input data, typically in a 2D [Time x Freq] array that
%               is the output of LFP_LFPCoh or similar programs.
%   df:         The dfs, could be a scalar, or an arry ,atching the size of
%               InDat (which is given as teh final outputs of programs like
%               LFP_LFPCoh, etc.
%   InSpc:      What space teh input data is in. Could be: 'Raw' (1),
%               'BiasCorrected' (2) or 'ZTrans' (3). Both numbers or the
%               corresponding strings are acceptable for this input.
%               DEFAULTS to 1.
%   OutSpc:     Same as InSpc, but this denotes the space you want the
%               value converted to. Not if this equals InSpc, the program
%               does nothing. DEFAULTS to 2.
%   CohOrSpec:  Denotes whether InDat is coherence or a spectral power 
%               data. could be 1 or 2, true or false, or 'coh' or 'spec',
%               respectively. Defaults to coherence.
% 
% OUTPUTS:
%   OutDat:     The data from InDat (in the same shape array) converted
%               to the desired space.

if nargin<2 error('Need at least 2 inputs to run MTPostHocTrans. Data and df information are necessary.');      end
if nargin<5 || isempty(CohOrSpec);      CohOrSpec=true;
else
    switch CohOrSpec
        case true
            CohOrSpec=true;
        case false
            CohOrSpec=false;
        case 1
            CohOrSpec=true;
        case 'coh'
            CohOrSpec=true;
        case 'Coh'
            CohOrSpec=true;
        case 'COH'
            CohOrSpec=true;
        case 2
            CohOrSpec=false;
        case 'spec'
            CohOrSpec=false;
        case 'Spec'
            CohOrSpec=false;
        case 'SPEC'
            CohOrSpec=false;
        otherwise
            error(['Input for CohOrSpec is: ' CohOrSpec '. Not recognized.'])
    end
end
if nargin<4 || isempty(OutSpc);      OutSpc=2;         else
    if isstr(OutSpc)
        switch OutSpc
            case 'Raw'      
                OutSpc=1;
            case 'BiasCorrected'    
                OutSpc=2;
            case 'ZTrans'       
                OutSpc=3;
        end
    end
end
if nargin<3 || isempty(InSpc);      InSpc=2;         else
    if isstr(InSpc)
        switch InSpc
            case 'Raw'      
                InSpc=1;
            case 'BiasCorrected'    
                InSpc=2;
            case 'ZTrans'       
                InSpc=3;
        end
    end
end
if ndims(df)~=ndims(InDat) || ~all(size(df)==size(InDat,1)) 
    if numel(df)>1;     disp('warning in MTPostHocTrans. df was non-scalar but it''s size did not match InDat. going with first element of df as teh df everywhere.');      end
    df=repmat(df(1),size(InDat));
end

if OutSpc==InSpc
    warning(['In MTPostHocTrans. outSpc and InSpc were the same and both equal to: ' num2str(OutSpc) ' . program returning without doing anything.'])
    OutDat=InDat;
    return
end

InAng=angle(InDat);     %for re-application to the data after performing the translation
InDat=abs(InDat);

if CohOrSpec        %coh data
    switch InSpc
        case    1
            if OutSpc==2    %go from raw to Bias Corrected
                OutDat=tanh( atanh(InDat)-1./(df-2) );
            elseif OutSpc==3    %go from raw to ZTrans
                OutDat=sqrt(df-2).*atanh(InDat)-1./sqrt(df-2);
                %the above is equivalent to: z=( atanh(coh)-1/(df-2) )/(sqrt(1/(df-2)));   
            end
        case    2
            if OutSpc==1    %go from Bias Corrected to raw
                OutDat=tanh( atanh(InDat)+1./(df-2) );
            elseif OutSpc==3    %go from BiasCorrected to ZTrans
                OutDat= atanh(InDat)./sqrt(1./(df-2));
            end
        case    3
            if OutSpc==1    %go from ZTrans to Raw
                OutDat= tanh( (sqrt(1./(df-2)).*InDat)+1./(df-2) );
            elseif OutSpc==2    %go from ZTrans to Bias Corrected
                OutDat=tanh( sqrt(1./(df-2)).*InDat );                
            end
    end
    
else        %Spec data
    switch InSpc        
        case    1
            if OutSpc==2    %go from raw to Bias Corrected
                OutDat=exp( ( log(InDat)-(psi(df/2)-log(df/2)) ) );
            elseif OutSpc==3    %go from raw to ZTrans
                OutDat=( log(InDat)-(psi(df/2)-log(df/2)) )./sqrt(psi(1,df/2));                  
            end
        case    2
            if OutSpc==1    %go from Bias Corrected to raw
                OutDat=exp( log(InDat) + (psi(df/2)-log(df/2)) );
            elseif OutSpc==3    %go from BiasCorrected to ZTrans                
                OutDat= log(InDat)./sqrt(psi(1,df/2));
            end
        case    3
            if OutSpc==1    %go from ZTrans to Raw                
                OutDat= exp( sqrt(psi(1,df/2)).*InDat+(psi(df/2)-log(df/2)) );
            elseif OutSpc==2    %go from ZTrans to Bias Corrected
                OutDat=exp( sqrt(psi(1,df/2)).*InDat );                
            end
    end
end

OutDat=OutDat.*exp(1i*InAng);
            
            
            
