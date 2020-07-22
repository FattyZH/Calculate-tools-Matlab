path = '.';
vars = 'pres';
fs = dir([path,'/*.mat'])';
data = struct('doy',{},'dep',{},vars,{});
for f = fs
    x = load([f.folder,'\',f.name]);
    dep = str2double(f.name(f.name>='0' &f.name<='9'));
    if(isfield(x,'preso'))
        data(end+1) = struct('doy',x.doy',vars,x.(vars),'dep',dep);
    else
        data(end+1) = struct('doy',x.doy',vars,[],'dep',dep);
    end
end

[~,ord] = sort([data.dep]);
data = data(ord);fs = fs(ord);
dep = [data.dep];
l = min([data.doy])-1;
r = max([data.doy]);
doy = l+1:r;
z = zeros(1,r-l);
y = 0;

for i = 1:length(data)
    if(isempty(data(i).(vars)))
        continue;
    end
    y = [y;data(i).dep];
    s = data(i).doy(1)-l;
    z(end+1,:) = nan;
    z(end,s:s+length(data(i).doy)-1) = data(i).(vars);
    z(end,:) = fillmissing(z(end,:),'nearest');
end
[xq,yq] = meshgrid(doy,dep);
zq = interp2(doy,y,z,xq,yq);
%%
for i = 1:length(data)
    if(~isempty(data(i).(vars)))
        continue;
    end
    mf = matfile([fs(i).folder,'\',fs(i).name],'Writable',true);
    s = data(i).doy(1)-l;
    mf.pres = zq(i,s:s+length(data(i).doy)-1)';
end