function [] = adi2mat(path)
suf = extractAfter(path,strfind(path,'.'));
if(~strcmp(suf,'txt'))
    return
end
fileID = fopen(path,'r');
for i = 1:5
    fgetl(fileID);
end
titles = split(fgetl(fileID),char(9));
data = textscan(fileID, ['%d%s',repmat('%f',1,length(titles)-2)], 'Delimiter', '\t', 'ReturnOnError', false);
fclose(fileID);
path = extractBefore(path,strfind(path,'.'));

findcol = @(s)find(cellfun(@(x)contains(x,s,'IgnoreCase',true),titles));

doyo = datenum(data{findcol('Time tag')},'dd.mm.yy HH:MM:SS');
uo = data{findcol('East')}./100;
vo = data{findcol('North')}./100;
preso = data{findcol('Pressure')}/10;
tempo = data{findcol('Temperature')};
tilt = data{findcol('Abs Tilt')};
%% data deal
good = abs(tilt)<15 | abs(preso-nanmedian(preso))<200;
uo(~good) = NaN; vo(~good) = NaN;

l = find(good,1);r = find(good,1,'last');
l = find( doyo >= ceil(doyo(l)) , 1 ); r = find( doyo < floor(doyo(r)) ,1,'last');
doyo = doyo(l:r);doy = (floor(doyo(1)):floor(doyo(end)))';
sz = [length(doyo)/length(doy),length(doy)];
uo = uo(l:r); u = nanmean(reshape(uo,sz))';
vo = vo(l:r); v = nanmean(reshape(vo,sz))';
preso = preso(l:r); pres = nanmean(reshape(preso,sz))';
tempo = tempo(l:r); temp = nanmean(reshape(tempo,sz))';
%%
save(path,'doy','u','v','pres','temp','doyo','vo','uo','preso','tempo');
end