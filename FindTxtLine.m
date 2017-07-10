function [str,nline, nposition] = FindTxtLine(FILEID, strin)
%function [str,nline, nposition] = FindTxtLine(FILEID, strin)
%======================================================
% 1. Open the file with FILEID.
% The text file with handle FILEID is read line by line to find the 
% first line that contains the string 'strin'.
% Be sure to rewind first to search the entire file
% Case insensitive.
%
% Returns str = nan if the search fails
% If success, the FILEID is positioned at the desired line.
%=======================================================
 
nline = 0;
str = NaN;
nposition = [];
nc = [];
strinu=upper(strin);

while ~feof(FILEID),
    s = fgetl(FILEID);
    su=upper(s);
    nline = nline + 1;
    %fprintf('%s\n',s);
    if length(s) >= length(strin),
        %fprintf('  length okay...\n');
        nposition = findstr(su,strinu);

        if ~isempty(nposition),
            %fprintf('   String found on line %d, end search\n',nline);
            str = s;
            break;
        end
    end
end

return

        
