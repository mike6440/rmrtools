function [fn]=FindFile(fpath,fname)

b='FindFileMissing';
str=sprintf('[a,b]=system(''find %s -name "*%s*" -d 1 -print'');',fpath,fname);
eval(str);
fprintf('str=%s\n',str);
if a ~= 0, error('search fails'), end
fn=strcat(b,'');
return

