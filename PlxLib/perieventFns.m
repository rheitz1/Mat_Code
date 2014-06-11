function perieventFns(action)
% functions used by ADperieventGui

global INTERUPT S PARS CONNECTED RUNNING

switch action
      
case 'connect'
   if ~isempty(RUNNING) | ~isempty(CONNECTED)
      dialogString=char('Already Connected to Server');
      DialogDisplay(dialogString);
      return
   end
   S=0;
   S=PL_InitClient(0);
   if S == 0
      dialogString=char('Error: Cannot Connect to Server');
      DialogDisplay(dialogString);
      return
   else
      CONNECTED=1;
      dialogString=char('Connected to Server');
      DialogDisplay(dialogString);
      PARS=PL_GetPars(S);
      NumADchan=PARS(7);
      SetADchanList(char(num2str([1:NumADchan]')));
   end
   
case 'disconnect'
   if ~isempty(RUNNING)
      perieventFns stop;
      pause(0.5);
   end
   if ~isempty(CONNECTED)
      dialogString=char('Disconnected from Server');
      DialogDisplay(dialogString);
      PL_Close(S);
      S=[];
      CONNECTED=[];
   end
   
case 'plot'
   if isempty(CONNECTED)
      dialogString=char('Error: First Connect to Server');
      DialogDisplay(dialogString);
      return
   end
   if ~isempty(RUNNING) 
      return
   end
   dialogString=char('Ploting AD Perievent Data');
   DialogDisplay(dialogString);
   RUNNING=1;
   INTERUPT=0;
   NumADchan=PARS(7);
   ADfreq=PARS(8); %AD freq in Hz
   lfp_pre=GetPreTime; %Pre-event time in sec
   lfp_post=GetPostTime; %Post-event time in sec
   event=GetEvent;
   ADchan=GetADchan;
   eventCue=[];
   totNumEvents=0;
   SetNumEvents(totNumEvents)
   
   [num,ts]=PL_GetTS(S);
   lfp_ave=zeros(round((lfp_pre+lfp_post)*ADfreq+1),NumADchan);
   [n,t,d]=PL_GetAD(S);
   while ~INTERUPT
      serverEventIn=0;
      while serverEventIn==0
         pause((lfp_pre+lfp_post)*2);
         serverEventIn=PL_WaitForServer(S,(lfp_pre+lfp_post)*1000);
      end
      [num,ts]=PL_GetTS(S);
      nn=n;tt=t;dd=d;
      [n,t,d]=PL_GetAD(S);
      eventCue=[eventCue; (ts(find((ts(:,1)==4).*(ts(:,2)==event)),4))];
      nn=nn+n;
      dd=[dd;d];
      while ~INTERUPT & length(eventCue)>0 & ( ceil((tt+(nn-1)/ADfreq-eventCue(1))*ADfreq)/ADfreq > lfp_post )
         lfp_start=round((eventCue(1)-lfp_pre-tt)*ADfreq)+1;
         lfp_stop=lfp_start+(lfp_pre+lfp_post)*ADfreq;
         totNumEvents=totNumEvents+1;
         if Average
            lfp_ave=((totNumEvents-1)*lfp_ave + dd(lfp_start:lfp_stop,:))/totNumEvents;
         else
            lfp_ave=dd(lfp_start:lfp_stop,:);
         end
         x=-1*lfp_pre:1/ADfreq:lfp_post;
         y=lfp_ave(:,ADchan);
         plot(x,y,'b')
         hold on
         set(gca,'XLim',[-1*lfp_pre lfp_post])
         ylim=get(gca,'YLim');
         plot(x*0,[ones(1,length(y)-1)*ylim(1),ylim(2)],'k:')
         hold off
         SetNumEvents(totNumEvents)
         eventCue=eventCue(2:length(eventCue));
      end

   end
   
case 'stop'
   INTERUPT=1;
   RUNNING=[];
   if ~isempty(RUNNING)
      dialogString=char('Stopped Perievent Plotting');
      DialogDisplay(dialogString);
   end

end

%-----------------------------------------------------

function y=GetPreTime()
% get pre-event time
preTimeHandle=findobj(gcbf,'Tag','pre');
y=str2num(get(preTimeHandle,'String'));

function y=GetPostTime()
% get post-event time
postTimeHandle=findobj(gcbf,'Tag','post');
y=str2num(get(postTimeHandle,'String'));

function y=GetEvent()
% get pre-event time
eventHandle=findobj(gcbf,'Tag','eventBox');
y=str2num(get(eventHandle,'String'));

function SetNumEvents(n)
% Set the #Events text string
numEventsHandle=findobj(gcbf,'Tag','numEvents');
set(numEventsHandle,'String',sprintf('%5.0f',n))

function SetADchanList(textstring)
% Set the AD Channels listbox
ADchanListHandle=findobj(gcbf,'Tag','ADchanList');
set(ADchanListHandle,'String',textstring)

function y=GetADchan()
% get AD channel
ADchanListHandle=findobj(gcbf,'Tag','ADchanList');
value = get(ADchanListHandle,'Value');
string = get(ADchanListHandle,'String');
string=cellstr(string);
y=str2num(string{value});

function y=Average()
% Set the plot mode to single or average
plotModeHandle=findobj(gcbf,'Tag','mode');
value = get(plotModeHandle,'Value');
string = get(plotModeHandle,'String');
if strcmp(string{value},'average')
   y=1;
else
   y=0;
end


function DialogDisplay(textstring)
% Display textstring in dialog box
dialogHandle=findobj(gcbf,'Tag','dialogBox');
set(dialogHandle,'String',textstring);


