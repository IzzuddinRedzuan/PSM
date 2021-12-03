conn = database('test','root','');

% x = fetch(conn,'select temperature from pemantauan_db.dht11');
% bar(x);

query = ['SELECT * ' ...
    'FROM pemantauan_db.dht11'];
data = fetch(conn,query);


% figure
% 
% stackedplot(data,{'humidity','temperature'})

% f = uifigure('Name','Recorded Data');
% f.Position(3:4) = [480 360];

stackedplot(data,{'humidity','temperature'});

% uit = uitable(f, 'Data', data);
% 
% uit.Position(3) = 389; 

saveas(gcf,'Barchart.jpeg')