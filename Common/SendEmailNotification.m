function []=SendEmailNotification(Recipient,Subject,Message,Attachment)
% SendViaGmail(Recipient,Subject,Message,Attachment)
% RECIPIENT is either a string specifying a single address, or a cell 
% array of addresses.  
% SUBJECT is a string.  
% MESSAGE is either a string or a cell array.  
% ATTACHMENTS is a string or a cell array of strings listing files to send 
% along with the message.  
% Only TO and SUBJECT are required.
% 
% see sendmail for more details
% written by erik.emeric@gmail.com

% Define these variables appropriately:
mail = 'richmatlab@gmail.com'; %Your GMail email address
password = 'Vanderbilt'; %Your GMail password

% Then this code will set up the preferences properly:
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

% Send the email
if ~nargin
    sendmail(mail,'No email recipient defined','SendEmailNotification.m');
elseif nargin==3
    sendmail(Recipient,Subject,Message);
elseif nargin==4
    sendmail(Recipient,Subject,Message,Attachment);
end
