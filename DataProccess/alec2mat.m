function [] = alec2mat(path)
suf = extractAfter(path,strfind(path,'.'));
if(~strcmp(suf,'csv'))
    return
end
fid = fopen(path,'r');
data = textscan(fid, ['%D',repmat('%f',1,14)], 'Delimiter', ',', 'HeaderLines' ,86);
fclose(fid);
path = extractBefore(path,strfind(path,'.'));

%%
doyo = datenum(data{1});
vo = data{4}./100;
uo = data{5}./100;
preso = data{6}*100;
tempo = data{7};
tiltx = data{13};
tilty = data{14};
%%
bad = abs(tiltx)>10 | abs(tilty)>10;
uo(bad) = NaN; vo(bad) = NaN;
%% day mean
good = abs(preso - nanmedian(preso)) <= 200;

l = find(good,1);r = find(good,1,'last');
l = find( doyo >= ceil(doyo(l)) , 1 ); r = find( doyo < floor(doyo(r)) ,1,'last');

doyo = doyo(l:r);doy = (floor(doyo(1)):floor(doyo(end)))';
sz = [length(doyo)/length(doy),length(doy)];
uo = uo(l:r); u = nanmean(reshape(uo,sz))';
vo = vo(l:r); v = nanmean(reshape(vo,sz))';
preso = preso(l:r); pres = nanmean(reshape(preso,sz))';
tempo = tempo(l:r); temp = nanmean(reshape(tempo,sz))';

save(path,'doy','u','v','pres','temp','doyo','vo','uo','preso','tempo');
end
