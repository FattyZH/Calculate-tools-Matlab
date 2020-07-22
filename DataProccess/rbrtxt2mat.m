function [] = rbrtxt2mat(path,ss)
if(nargin<2)
    ss = 86400;
end
p = strfind(path,'.');
name = extractBefore(path,p(end));
f = fopen(path);
a = textscan(f,'%s%f','Delimiter', ',', 'HeaderLines' ,1);
fclose(f);
%%
n = length(a{1});
p = [1,n];
while(a{2}(p(1))>20)
    p(1)=p(1)+1;
end
while(a{2}(p(2))>20)
    p(2)=p(2)-1;
end
doy = (ceil(datenum(a{1}{p(1)})):floor(datenum(a{1}{p(2)})-1))';
p = p(1)+round((doy(1)-datenum(a{1}{p(1)}))*ss);
temp = zeros(length(doy),1);

for i = 1:length(doy)
    temp(i) = nanmean(a{2}(p+ss*(i-1):p+ss*i-1));
end
% clear('a');
save(name,'doy','temp');
end