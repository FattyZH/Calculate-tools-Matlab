function [] = unit_uv(path,outpath)
if(nargin < 2)
    outpath = path;
end
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
z = interp2(doy,y,z,xq,yq);
%% 
pres = nan(0,r-l);
u = nan(0,r-l);
v = nan(0,r-l);
for i = 1:length(a)
    s = a(i).data.('doy')(1)-l;
    if(isfield(a(i).data,'u') && isfield(a(i).data,'v'))
        u(end+1,:) = nan; v(end+1,:) = nan;
        u(end,s:s+length(a(i).data.('doy'))-1) = a(i).data.('u');
        v(end,s:s+length(a(i).data.('doy'))-1) = a(i).data.('v');
        pres(end+1,:) = z(i,:);
    end
end
save([outpath,'\','uv'],'doy','pres','u','v');
end