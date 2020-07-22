function [] = alct2mat(path)
    suf = extractAfter(path,strfind(path,'.'));
    if(~strcmp(suf,'csv'))
        return
    end
    fid = fopen(path,'r');
    data = textscan(fid, ['%D',repmat('%f',1,5)], 'Delimiter', ',', 'HeaderLines' ,80);
    fclose(fid);
    path = extractBefore(path,strfind(path,'.'));

%%
    doyo = datenum(data{1});
    tempo = data{2};
    salio = data{3};
%% day mean
    good = abs(tempo-nanmedian(tempo))<0.1;
    
    l = find(good,1);r = find(good,1,'last');
    l = find( doyo >= ceil(doyo(l)) , 1 ); r = find( doyo < floor(doyo(r)) ,1,'last');

    doyo = doyo(l:r);doy = (floor(doyo(1)):floor(doyo(end)))';
    sz = [length(doyo)/length(doy),length(doy)];
    tempo = tempo(l:r); temp = nanmean(reshape(tempo,sz))';
    salio = salio(l:r); sali = nanmean(reshape(salio,sz))';

    save(path,'doy','temp','sali','doyo','tempo','salio');
end