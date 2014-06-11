%%%%% :) 09/28/2004

clear all;
Menu_task = menu('What kind of Protocol','Countermanding','Visual Search','Anti saccade');

[A B]= xlsread('T:\Tempo_events\toto_b.xls');
Events_code=[];
Task=[];
Events_value=A(:,6);
Task=A(:,7);

if Menu_task== 1
name_task=B{7,5}
elseif Menu_task==2
name_task=B{8,5}
elseif Menu_task==3
name_task=B{9,5}  
end;

if name_task(1:11)=='Countermand'
code_task=Task(7)
elseif name_task(1:11)=='Visual Sear'
code_task=Task(8)    
elseif name_task(1:11)=='Antissaccad'
code_task=Task(9)
end;    

Events_value(find(Task==code_task))

