function sendolmail(to,subject,body,attachments)
  %Sends email using MS Outlook. The format of the function is
  %Similar to the SENDMAIL command.
  %Ref: https://www.mathworks.com/matlabcentral/answers/94446-can-i-send-e-mail-through-matlab-using-microsoft-outlook
  if ischar(attachments)
    attachments = {attachments};
  end
  if iscell(body)
    body = char(body);
  end
  if iscell(subject)
    subject = char(subject);
  end
  if length(to) > 1
    to = strjoin(to,';');
  end
  % Create object and set parameters.
  h = actxserver('outlook.Application');
  mail = h.CreateItem('olMail');
  mail.Subject = subject;
  mail.To = to;
  mail.BodyFormat = 'olFormatHTML';
  mail.HTMLBody = body;
  % Add attachments, if specified.
  if nargin == 4
    for i = 1:length(attachments)
      mail.attachments.Add(attachments{i});
    end
  end
  % Send message and release object.
  mail.Send;
  h.release;
end