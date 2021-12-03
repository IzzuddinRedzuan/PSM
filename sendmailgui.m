function sendmailgui

props = java.lang.System.getProperties;
props.setProperty( 'mail.smtp.starttls.enable', 'true' )

bkgcolor = 0.8*[1 1 1];  % or a basic short name...
frgcolor = [0 0 0];      % ...like 'y','b' etc.

hMainGui = figure('NumberTitle','off','MenuBar','none','Visible','on',...
    'Color',bkgcolor,'Units','pixels','Name','sendmail GUI',...
    'Position',[50 50 592 400]);
%scrsz = get(0,'ScreenSize');
%set(hMainGui,'Position',[10 10 scrsz(3) scrsz(4)-128]); 
movegui(hMainGui,'center')

hSubj = uicontrol(hMainGui,'Style','edit','FontSize',12,...
    'Units','normalized','Position',0.01*[5 80 40 10],...
    'Tag','Subj',...
    'BackgroundColor','w','ForegroundColor','k',...
    'Callback',{@edit_text_callback});

hSubjText = uicontrol(hMainGui,'Style','Text','String','Subject:',...
    'FontWeight','bold','FontSize',10,...
    'HorizontalAlignment','left',...
    'BackgroundColor',bkgcolor,'ForegroundColor',frgcolor,...
    'Units','normalized','Position',0.01*[5 90 20 5]);

hTo = uicontrol(hMainGui,'Style','edit','FontSize',12,...
    'Units','normalized','Position',0.01*[5 45 40 25],...
    'Max',500,'Min',0,'Tag','To',...
    'BackgroundColor','w','ForegroundColor','k',...
    'Callback',{@edit_text_callback});

hToText = uicontrol(hMainGui,'Style','Text',...
    'FontWeight','bold','FontSize',10,...
    'String','To (each address on a separate line):',...
    'HorizontalAlignment','left',...
    'BackgroundColor',bkgcolor,'ForegroundColor',frgcolor,...
    'Units','normalized','Position',0.01*[5 70 40 5]);

hAttach = uicontrol(hMainGui,'Style','listbox',...
    'Value',[],'FontSize',10,'String','No attachments',...
    'Enable','off','BackgroundColor','w','ForegroundColor','k',...
    'Units','normalized','Position',0.01*[5 5 40 15],...
    'Max',500,'Min',0);

hAttachButton = uicontrol(hMainGui,...
    'Style','pushbutton','String','Attach',...
    'Units','normalized',...
    'Position',0.01*[5 33 20 7],...
    'BackgroundColor',bkgcolor,'ForegroundColor',frgcolor,...
    'Callback',@perform_attach);

hClearAttach = uicontrol(hMainGui,'Style','pushbutton',...
    'String','clear attachments',...
    'Units','normalized','Position',0.01*[5 25 20 7],...
    'BackgroundColor',bkgcolor,'ForegroundColor',frgcolor,'Enable','off',...
    'Callback',@perform_clear_attach);

hSend = uicontrol(hMainGui,'Style','pushbutton','String','SEND',...
    'FontWeight','bold','FontSize',12,...
    'Units','normalized','Position',0.01*[30 25 15 15],...
    'BackgroundColor',bkgcolor,'ForegroundColor',frgcolor,...
    'Callback',@go_Callback);

hMessage = uicontrol(hMainGui,'Style','edit',...
    'FontSize',10,'Units','normalized','Position',0.01*[50 5 45 65],...
    'Max',500,'Min',0,'Tag','Msg',...
    'BackgroundColor','w','ForegroundColor','k',...
    'HorizontalAlignment','left',...
    'Callback',{@edit_text_callback});
hMessageText = uicontrol(hMainGui,'Style','Text',...
    'FontWeight','bold','FontSize',10,...
    'String','Your message:','HorizontalAlignment','left',...
    'BackgroundColor',bkgcolor,'ForegroundColor',frgcolor,...
    'Units','normalized','Position',0.01*[50 71 40 5]);

try
    E_mail = getpref('Internet','E_mail');
catch ME
    E_mail =  'your_account_here@example.com';
    setpref('Internet','E_mail',E_mail)
    
%     password = 'T@m@n4181';
%     setpref('Internet','SMTP_Password',password);
%     
%     setpref('Internet','SMTP_Username',E_mail);
% setpref('Internet','SMTP_Password',password);
end

try
    SMTP_Server=getpref('Internet','SMTP_Server');
catch ME
    SMTP_Server = 'mail.example.com';
    setpref('Internet','SMTP_Server',SMTP_Server);
end

hSenderPanel = uipanel('Title','Sender Info',...
    'FontWeight','bold','FontSize',10,...
    'BackgroundColor',bkgcolor,'ForegroundColor',frgcolor,...
	'Position',0.01*[50 80 45 20]);

hEmailText = uicontrol(hSenderPanel,'Style','Text',...
    'String',['From: ',E_mail],'HorizontalAlignment','left',...
    'BackgroundColor',bkgcolor,'ForegroundColor',frgcolor,...
    'Tag','Email',...
    'Units','normalized','Position',0.01*[5 45 55 40]);

hSMTPText = uicontrol(hSenderPanel,'Style','Text',...
    'String',['SMTP: ',SMTP_Server],'HorizontalAlignment','left',...
    'BackgroundColor',bkgcolor,'ForegroundColor',frgcolor,...
    'Tag','SMTP',...
    'Units','normalized','Position',0.01*[5 5 55 40]);

hSenderButton = uicontrol(hSenderPanel,'Style','pushbutton',...
    'String','Change',...
    'Units','normalized','Position',0.01*[75 10 20 85],...
    'BackgroundColor',bkgcolor,'ForegroundColor',frgcolor,...
    'HorizontalAlignment','left',...
    'Callback',@emailpref);


handles=[hMessageText,hToText,hSubjText,hMessage,hAttach,hTo,hSubj,...
    hClearAttach,hEmailText,hEmailText,hSMTPText,hSenderButton];

    function edit_text_callback(source,eventdata)
        temp = get(source,'String');
        tag = get(source,'Tag');
        switch tag
            case 'To'
                [Rows,Cols]=size(temp); %#ok<NASGU>
                To = cell(1,Rows);
                for ind = 1:Rows
                    temp2=double(temp(ind,:));
                    temp2(temp2==9)=[];
                    temp2(temp2==32)=[];
                    temp2(temp2==10)=[];
                    temp2(temp2==13)=[];
                    To(ind) = {char(temp2)};
                end
                setappdata(hMainGui,'To',To)
            case 'Msg'
                [Rows,Cols]=size(temp); %#ok<NASGU>
                Msg = cell(1,Rows);
                for ind = 1:Rows
                    temp2=double(temp(ind,:));
                    temp2(temp2==9)=[];
                    temp2(temp2==10)=[];
                    temp2(temp2==13)=[];
                    Msg{ind}=char(temp2);
                end
                setappdata(hMainGui,'Msg',Msg)
            case 'Subj'
                setappdata(hMainGui,'Subj',temp)
        end
    end

    function emailpref(source,eventdata)
        
        SMTP_Server=getpref('Internet','SMTP_Server');
        E_mail = getpref('Internet','E_mail');
        defaultanswer={E_mail,SMTP_Server};
        prompt={'Your email address','SMTP Server'};
        name='Sender Info';
        numlines=1;
        answer=inputdlg(prompt,name,numlines,defaultanswer);
        if isempty(answer)  %cancel button
            msgbox('Sender info not changed')
        else
            if isempty(answer{1}) || isempty(answer{2})
            	errordlg('Blank fields are forbidden','setpref error');
            else
                setpref('Internet','E_mail',answer{1});
                setpref('Internet','SMTP_Server',answer{2});
                set(hEmailText,'String',['From: ',answer{1}]);
                set(hSMTPText,'String',['SMTP: ',answer{2}]);
            end
        end
    end

    function go_Callback(source,eventdata)
        Subj = getappdata(hMainGui,'Subj');
        To = getappdata(hMainGui,'To');
        send_ok = 1;
        
        if isempty(Subj)
            send_ok = 0;
            errormessage = 'Subject required';
        end
        
        if iscell(To)
            send_okv = zeros(1,length(To));
            for ind = 1:length(To)
                send_okv(ind) = isempty(findstr(To{ind},'@'));
            end
            if any(send_okv)
                send_ok = 0;
                errormessage = 'Invalid To-field';
            end
        else
            isempty(findstr(To,'@'))
            send_ok = 0;
            errormessage = 'Invalid To-field';
        end
        
        if isempty(To) || not(send_ok)
            msgbox(errormessage)
        else
            filenames = getappdata(hMainGui,'filename');
            setappdata(hMainGui,'filename',{filenames})
            Msg = getappdata(hMainGui,'Msg');
            
            SMTP_Server=getpref('Internet','SMTP_Server');
            E_mail = getpref('Internet','E_mail');
            defaultanswer={E_mail,SMTP_Server};
            prompt={'Your email address','SMTP Server'};
            name='press OK to send';
            numlines=1;
            answer=inputdlg(prompt,name,numlines,defaultanswer);
            if isempty(answer)  %cancel button
                msgbox('Message not sent');
            else
                if isempty(answer{1}) || isempty(answer{2})
                    errordlg('Blank fields are forbidden','setpref error');
                else
                    setpref('Internet','E_mail',answer{1});
                    setpref('Internet','SMTP_Server',answer{2});

                    
                    % save sendmaildata To Subj Msg filenames
                    
                    if iscell(filenames)
                        if length(filenames)==1
                            filenames = filenames{1};
                        end
                    end

                    sendmail(To,Subj,Msg,filenames) %this is it

                    set(handles,'Enable','off')
                    set(hSend,'String','New Msg',...
                        'Callback','close,sendmailgui')
                    set(hAttachButton,'String','Quit',...
                        'Callback','close')
                end
            end
        end
    end

    function perform_attach(source,eventdata)
        [filename,pathname] = uigetfile('*.*', 'Pick a file');
        if not(filename==0)
            filenames = getappdata(hMainGui,'filename');
            filenames = [filenames,{[pathname,filename]}];
            setappdata(hMainGui,'filename',filenames)
            set(hAttach,'String',filenames)
            %set(hAttach,'Enable','on')
            set(hClearAttach,'Enable','on')
        end
    end

    function perform_clear_attach(source,eventdata)
        %set(hAttach,'Enable','off')
        set(hAttach,'Selected','off')
        setappdata(hMainGui,'filename','')
        set(hAttach,'String','No attachments')
        
        set(hClearAttach,'Enable','off')
        
    end
end