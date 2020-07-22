function [] = unit_ts(path,outpath)
if(nargin < 2)
    outpath = path;
end
psm = load('psMod');
fs = dir([path,'/*.mat'])';
a = struct('data',{},'pos',{});
for f = fs
    dep = str2double(f.name(f.name>='0' &f.name<='9'));
    a(end+1) = struct('data',load([f.folder,'\',f.name]),'pos',dep);
end
%% depth interp
[dep,ord] = sort([a.pos]);
a = a(ord);
l = inf;r = -inf;
for i = a
    l = min(l, i.data.doy(1));
    r = max(r, i.data.doy(end));
end
doy = l:r;
l = l-1;
z = zeros(1,r-l);
y = 0;

for i = 1:length(a)
    if(~isfield(a(i).data,'pres'))
        continue;
    end
    y = [y;a(i).pos];
    s = a(i).data.('doy')(1)-l;
    z(end+1,:) = nan;
    z(end,s:s+length(a(i).data.('doy'))-1) = a(i).data.('pres');
    z(end,:) = fillmissing(z(end,:),'nearest');
end
[xq,yq] = meshgrid(doy,dep);
pres = interp2(doy,y,z,xq,yq);
%% 
pres_s = nan(0,r-l);
pres_t = nan(0,r-l);
temp = nan(0,r-l);
ts = nan(0,r-l);
sali = nan(0,r-l);
for i = 1:length(a)
    s = a(i).data.('doy')(1)-l;
    if(isfield(a(i).data,'temp'))
        temp(end+1,:) = nan;
        temp(end,s:s+length(a(i).data.('doy'))-1) = a(i).data.('temp');
        pres_t(end+1,:) = pres(i,:);
        ts(end+1,:) = nan;
        if(isfield(a(i).data,'sali'))
            ts(end,s:s+length(a(i).data.('doy'))-1) = a(i).data.('sali');
        else
            ts(end,:) = interp1(psm.pres,psm.sali,pres(i,:));
        end
    end
    if(isfield(a(i).data,'sali'))
        sali(end+1,:) = nan;
        sali(end,s:s+length(a(i).data.('doy'))-1) = a(i).data.('sali');
        pres_s(end+1,:) = pres(i,:);
    end
end
ptmp = sw_ptmp(ts,temp,pres_t,0);
save([outpath,'\','ts'],'doy','pres_t','ptmp','temp','pres_s','sali');
end