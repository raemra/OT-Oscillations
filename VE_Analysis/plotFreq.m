function [] = plotFreq(f,mORf,phaseAdj)
%PLOTFREQ Summary of this function goes here
%   Detailed explanation goes here
    
    choice = 0;
    
    rt = 'Data\TEST\';
    fls = ls(rt); fls = fls(3:end,:);

    dmy = [];
    for i = 1:size(fls,1)
        if strcmp(fls(i,1:size(f,2)),f)
            dmy = [dmy, i]; %#ok<AGROW>
        end
    end

    on_or_off = ones(size(dmy,2),1);
    
    fls = fls(dmy,:);
    opts = cell(0);
    opts{1} = 'Quit';
    data = cell(0);
    for i = 2:size(fls,1)+1
        opts{i} = [fls(i-1,:) num2str(on_or_off(i-1))];        
        load([rt strtrim(fls(i-1,:))],'psdNEW','psdNEW2','phasePSD','phasePSD2')
        if phaseAdj
            newStart = 20000*(360-phasePSD2)/(str2num(f)*360);
            psdNEW2 = psdNEW2(newStart:end);
        end
        if mORf == 'm'
            data{i-1} = psdNEW;
        else
            data{i-1} = psdNEW2;
        end
    end
      
    figure('Position',[800 0 1100 1000])
    for i = 1:size(fls,1)
        plot(data{i}); hold all;
    end
    lgnd = fls(on_or_off==1,:);
    legend(lgnd);
    while choice ~= 1
        opts = cell(0);
        opts{1} = 'Quit';
        for i = 2:size(fls,1)+1
            opts{i} = [fls(i-1,:) num2str(on_or_off(i-1))];
        end
        choice = menu('Title',opts);
        close all
        if choice ~= 1
            if on_or_off(choice-1)
                on_or_off(choice-1) = 0;
            else
                on_or_off(choice-1) = 1;
            end
        end     
        
        a = figure('Position',[800 0 1100 1000]);
        for i = 1:size(fls,1)
            if on_or_off(i)
                plot(data{i}); hold all;
            end
        end
        lgnd = fls(on_or_off==1,:);
        legend(lgnd);
    end

end

