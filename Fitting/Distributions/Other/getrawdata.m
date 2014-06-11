function rts=getrtdata(exp,sub,message,setsize)
% GETRTDATA     Returns an array of response times when given a search
% type ('feature', 'conjunction', or 'serial'), a subject number (1-10), a
% condition ('HIT' or 'TNEG'), and a set size (3, 6, 12, or 18).
%
% RT_ARRAY = GETRTDATA (EXP, SUBNUM, MESSAGE, SETSIZE)

% Written by: Evan McHughes Palmer 9/01/04
%             BWH Visual Attention Lab
%
% New contact information:
%            Evan M. Palmer
%            Dept. of Psychology
%            Wichita State University
%            evan.palmer@wichita.edu

% Normalizing input
if strcmp(exp,'Serial')|strcmp(exp,'serial')|strcmp(exp,'SERIAL')|strcmp(exp,'ser')|strcmp(exp,'Ser')|strcmp(exp,'S')|strcmp(exp,'s')
    exp='SER';
elseif strcmp(exp,'Feature')|strcmp(exp,'feature')|strcmp(exp,'FEATURE')|strcmp(exp,'feat')|strcmp(exp,'Feat')|strcmp(exp,'F')|strcmp(exp,'f')
    exp='FEAT';
elseif strcmp(exp,'Conjunction')|strcmp(exp,'conjunction')|strcmp(exp,'CONJUNCTION')|strcmp(exp,'Conj')|strcmp(exp,'conj')|strcmp(exp,'C')|strcmp(exp,'c')
    exp='CONJ';
end;

if strcmp(message,'hit')|strcmp(message,'Hit')|strcmp(message,'H')|strcmp(message,'h')|strcmp(message,'Hits')|strcmp(message,'hits')|strcmp(message,'HITS')
    message='HIT';
elseif strcmp(message,'miss')|strcmp(message,'Miss')|strcmp(message,'M')|strcmp(message,'m')|strcmp(message,'Misses')|strcmp(message,'misses')|strcmp(message,'MISSES')
    message='MISS';
elseif strcmp(message,'fa')|strcmp(message,'Fa')|strcmp(message,'F')|strcmp(message,'f')
    message='FA';
elseif strcmp(message,'tneg')|strcmp(message,'Tneg')|strcmp(message,'T')|strcmp(message,'t')|strcmp(message,'Tnegs')|strcmp(message,'tnegs')|strcmp(message,'TNEGS')
    message='TNEG';
end;


% Error checking
if nargin == 0
    error('Please specify experiment type, subject number, trial type and set size.');
end;
if strcmp(exp,'SER')~=1 & strcmp(exp,'FEAT')~=1 & strcmp(exp,'CONJ')~=1
    error('Please enter FEAT, CONJ, or SER to specify experiment type');
end;
if setsize~=3 & setsize~=6 & setsize~=12 & setsize~=18
    error('Please enter 3, 6, 12, or 18 for the set size.');
end;
if strcmp(message,'HIT')~=1 & strcmp(message,'MISS')~=1 & strcmp(message,'FA')~=1 & strcmp(message,'TNEG')~=1
    error('Please enter HIT, TNEG, MISS, or FA for the trial type.');
end;
if sub<1 | sub>10
    error('Please enter a subject number from 1 to 10.');
end;

% Reading the appropriate file.
if strcmp(exp,'SER')
    [sinit,tp_yn,ss,sub_resp,err,mess,rt] = textread('Serial_Raw.txt','%s %d %d %s %d %s %d',42000);
elseif strcmp(exp,'FEAT')
    [sinit,tp_yn,ss,sub_resp,err,mess,rt] = textread('Feature_Raw.txt','%s %d %d %s %d %s %d',42000);
elseif strcmp(exp,'CONJ')
    [sinit,tp_yn,ss,sub_resp,err,mess,rt] = textread('Conj_Raw.txt','%s %d %d %s %d %s %d',42000);
end;

subs=unique(sinit);

% Pulling out index locations of correct RTs.
data=find(strcmp(sinit,subs(sub)) & strcmp(mess,message) & ss==setsize);

% Putting correct RTs into ouput variable.
rts=rt(data);

return;
