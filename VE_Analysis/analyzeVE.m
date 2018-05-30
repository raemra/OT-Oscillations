function [] = analyzeVE(axs)
%ANALYZEVE Summary of this function goes here
%   Detailed explanation goes here

    aAfunc2('f',axs);
    fls = ls;
    
    mv = 0;
    count = 0;
    for i = 1:size(fls,1)
        a = strfind(fls(i,:), '_data.mat');
        if isempty(a)
        else
            count = count+1;
            mv(count) = i; %#ok<AGROW>
        end
    end
    
    delete('Data\TEST\*.mat')
    
    for j = 1:size(mv,2)
        movefile(fls(mv(j),:),'Data\TEST\');
    end
    exDATA    

end

