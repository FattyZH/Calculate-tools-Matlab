function [] = aqd2mat(path)
suf = extractAfter(path,strfind(path,'.'));
if(~strcmp(suf,'dat'))
    return
end
data = load(path);
path = extractBefore(path,strfind(path,'.'));

uo = data(:,9);
vo = data(:,10);
pitch = data(:,19);
roll = data(:,20);
preso = data(:,21);
tempo = data(:,23);
doyo = datenum(data(:,[3,1,2,4,5,6]));
%% data select
uo(abs(pitch)>20 | abs(roll)>20) = nan;
vo(abs(pitch)>20 | abs(roll)>20) = nan;

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
%%
save(path,'doy','u','v','pres','temp','doyo','vo','uo','preso','tempo');
end