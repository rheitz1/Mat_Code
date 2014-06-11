function [corrCurAD] = masterCorrect(curAD,headstage)
TFfilepath='C:\Mat_Code\CorrectionCode\';
LFPoptions.ViewNonInterpSpec=0;
LFPoptions.ViewInterpSpec=0;
LFPoptions.magcap=1;
LFPoptions.setph=1;
LFPoptions.setmag=1;
LFPoptions.RevFilt=0;
SmoothCorr=0;
adfreq=1000;
maxADSize=5e6;  %break up the exp into Frags, then reassemble if it's longer than this

BadLCutoff=9;   %Hz
%BadLCutoff=15;   %Hz
%BadLCutoff=25;   %Hz

if headstage == 'L'
    ADTFfilename='CombinedTF_Amp28ACMedImp';
elseif headstage == 'H'
    ADTFfilename='TF_Amp28';
end

LFPoptions.fphrange=[0 BadLCutoff 250 550];
LFPoptions.fmrange=LFPoptions.fphrange; 

%%%%%%%%%%%%%%%%%%%curAD=lfp9;
DCVal=mean(curAD);
tcurAD=curAD-DCVal;        %Correct any DC offset...

nFrag=ceil(length(curAD)/maxADSize);
    corrCurAD=repmat(0,length(curAD),1);
    
    for iFrag=1:nFrag
        st=1+(iFrag-1)*maxADSize;
        en=min( iFrag*maxADSize, length(curAD) );
        
        corrCurAD(st:en)=CorrectData(tcurAD(st:en),adfreq,ADTFfilename,TFfilepath,LFPoptions);        
    end

%LOW PASS FILTER - DO NOT USE
    if SmoothCorr       corrCurAD=filtfilt([.5 .5],1,corrCurAD);    end
%%%%%%%%%%%%%%%%%%%%%corrCurAD9=corrCurAD;

