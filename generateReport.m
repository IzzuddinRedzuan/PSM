%% Make connection to database
conn = database('test','root','');

%Set query to execute on the database
query = ['SELECT * ' ...
    'FROM pemantauan_db.dht11'];


%% Execute query and fetch results
data = fetch(conn,query);

% filename = 'TestData.xlsx';
% writetable(data,filename,'Sheet',1,'Range','D1')

fh = figure(); 
fh.PaperOrientation   = [11, 8.5] 
fh.PaperSize          = 'portrait'

orient(fh,'landscape')
fh.PaperOrientation  % = [8.5, 11] 
fh.PaperSize         % = 'landscape'
now save it
saveas(gcf,'report','pdf')


close(conn)

%% Clear variables
clear conn query