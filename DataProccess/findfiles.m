function [files] = findfiles(path, suf)
    if(nargin == 1)
        suf = '';
    end
    files = [];
    flist = dir(path);
    for f = flist'
        if(strcmp(f.name,'.') || strcmp(f.name,'..'))
            continue;
        end
        if(f.isdir)
            files = [files, findfiles([f.folder,'\',f.name], suf)];
        elseif(endsWith(f.name,suf))
            f.('path') = [f.folder,'\',f.name];
            files = [files,f];
        end
    end
end