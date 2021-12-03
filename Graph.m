if ~isempty(instrfind)
fclose(instrfind);
delete(instrfind);
end

s=serial('COM3','BaudRate',9600);
time = 100;
i=1;

datasource = 'test';
tablename = 'pemantauan_db.dht11';
conn = database(datasource,'root','');
    
while(i<time)
 
  fopen(s)
  fprintf(s, 'Your serial data goes here')
  out=fscanf(s,'%s')
  

  T=str2num(out(1:4));
  H=str2num(out(5:9));
  

%     data = table(H,T,...
%     'VariableNames',{'humidity','temperature'});
% 
%     sqlwrite(conn,'pemantauan_db.dht11',data)
  
  if any(T>=30)
      
      c={H T 'Danger'}
  data = cell2table(c,...
    'VariableNames',{'humidity','temperature','status'});

    sqlwrite(conn,'pemantauan_db.dht11',data)
    
  else
      c={H T 'Safe'}
  data = cell2table(c,...
    'VariableNames',{'humidity','temperature','status'});

    sqlwrite(conn,'pemantauan_db.dht11',data)
  end
  
   Temp(i)=str2num(out(1:4));
   subplot(211);
   plot(Temp,'r', 'LineWidth',2);
   axis([0 time 20 50]);
   title('DHT11 SENSOR TEMP READING');
   xlabel('time');
   ylabel('temp_{celsius}');
   grid;
   
   Humi(i)=str2num(out(5:9));
   subplot(212);
   plot(Humi,'g','LineWidth',2);
   axis([0 time 25 100]);
   title('DHT11 SENSOR HUMIDITY READING');
    xlabel('time');
    ylabel('% of Humidity');  
    grid;
    
    if any(T>=30)
         h = msgbox('High temperature detected','DANGER ALERT','error');
    else

    end
    

    fclose(s);
    i=i+1;
 
    drawnow;
    
    pause(4)
    end
    
close(conn)
delete(s)
clear s