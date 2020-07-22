function [] = sbe2mat(path)
    suf = extractAfter(path,strfind(path,'.'));
    if(~strcmp(suf,'cnv'))
        return
    end
    fid = fopen(path,'r');
    while(true)
        s = fgetl(fid);
        if(s(1) == '#')
            break;
        end
    end
    n = sscanf(s,'# nquan = %d');
    m = sscanf(fgetl(fid),'# nvalues = %d');
    title = textscan(fid,'# name %*d = %*s%s',n,'HeaderLines' ,1,'Delimiter', ':','TextType','string');title = title{1};
    inv = cell2mat(textscan(fid,'# interval = seconds: %f',1,'HeaderLines' ,n+1,'Delimiter', ''));
    t0 = datenum(string(textscan(fid,'# start_time = %s',1,'Delimiter', '')));
    
    while(~strcmp(fgetl(fid),'*END*'));end
    data = cell2mat(textscan(fid,repmat('%f',1,n)));
    fclose(fid);
    path = extractBefore(path,strfind(path,'.'));

    findcol = @(y)find(arrayfun(@(x)startsWith(x,y),title));

    doyo = t0+(0:m-1)'*inv/86400;
    preso = data(:,findcol('Pressure'));
    tempo = data(:,findcol('Temperature'));
    salio = data(:,findcol('Salinity'));
    oxygo = data(:,findcol('Oxygen'));

    %% get range
    good = abs(tempo-nanmedian(tempo))<1;
    l = find(good,1);r = find(good,1,'last');
    l = find( doyo >= ceil(doyo(l)) , 1 ); r = find( doyo < floor(doyo(r)) ,1,'last');
    %% Write Data
    mf = matfile(path,'Writable',true);
    
    doyo = doyo(l:r); doy = (floor(doyo(1)):floor(doyo(end)))';
    sz = [length(doyo)/length(doy),length(doy)];
    tempo = tempo(l:r); temp = nanmean(reshape(tempo,sz))';
    
    mf.doyo = doyo; mf.doy = doy;
    mf.tempo = tempo; mf.temp = temp;
    
    if(~isempty(preso))
        preso = preso(l:r); pres = nanmean(reshape(preso,sz))';
        mf.preso = preso; mf.pres = pres;
    end
    if(~isempty(salio))
        salio = salio(l:r);sali = nanmean(reshape(salio,sz))';
        mf.salio = salio; mf.sali = sali;
    end
    if(~isempty(oxygo))
        oxygo = oxygo(l:r); oxyg = nanmean(reshape(oxygo,sz))';
        mf.oxygo = salio; mf.oxyg = oxyg;
    end
end