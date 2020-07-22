function [] = rsk2mat(path)

fnow = cd;
f = dir(path);
suf = extractAfter(f.name,strfind(f.name,'.'));
if(~strcmp(suf,'rsk'))
    return
end
cd(f.folder);
data = RSKreaddata(RSKopen(f.name));

name = extractBefore(f.name,strfind(f.name,'.'));

doyo = data.data.tstamp;
tempo = data.data.values;
doy = ceil(doyo(find(tempo<20,1))):floor(doyo(find(tempo<20,1,'last'))-1);
tempo = tempo(doy(1)<=doyo & doyo<doy(end)+1);
temp = nanmean(reshape(tempo,[length(tempo)/length(doy),length(doy)]));
doy = doy';temp = temp';
save(name, 'doy', 'temp');
cd(fnow);
end

