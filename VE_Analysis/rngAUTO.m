function [x, period, psdNEW, psdNEW2, stageNEW] = rngAUTO(set,instr,psdA, psd2A)
%RNG Range of data to analyze
%   Import dataset, select range to analyze. Output range, period,
%   amplitude.
    
    root = 'tests\';

    %data = load([root set]);
    data = importdata([root set]);
    
    flat = zeros(1,floor(size(data,2)/100-1));
    for kk = 1:floor(size(data,2)/100-1)
        %flat(kk) = data(instr,(kk+1)*100) - data(instr,(kk)*100);
        %flat(kk) = std(data(instr,(kk-1)*100+1:kk*100));
        if abs(data(instr,(kk+1)*100)) > 1.0005 * abs(data(instr,(kk)*100)) % 1.0005
            flat(kk) = 1;
        elseif abs(data(instr,(kk+1)*100)) < .9995 * abs(data(instr,(kk)*100)) % 9995
            flat(kk) = 1;
        else 
            flat(kk) = 0;
        end
    end
    %plot(flat,'-x')
    
    % Check to make sure 'flat' was sensitive enough (Sometimes comes out
    % all 0's for low frequency)
    if max(flat) == 0
        flat = zeros(1,floor(size(data,2)/100-1));
        for kk = 1:floor(size(data,2)/100-1)
            %flat(kk) = data(instr,(kk+1)*100) - data(instr,(kk)*100);
            %flat(kk) = std(data(instr,(kk-1)*100+1:kk*100));
            if abs(data(instr,(kk+1)*100)) > 1.0003 * abs(data(instr,(kk)*100)) % 1.0005
                flat(kk) = 1;
            elseif abs(data(instr,(kk+1)*100)) < .9997 * abs(data(instr,(kk)*100)) % 9995
                flat(kk) = 1;
            else 
                flat(kk) = 0;
            end
        end
        %plot(flat,'-x')
    end
    
    jj = 0;
    dummy = floor(size(data,2)/100-1);
        
    %%%% Added this section to catch unknown error
    try
        while jj == 0
            jj = flat(dummy);
            dummy = dummy - 1;
        end
        x(1) = 2;
        x(2) = dummy * 100;
    catch
        x(1) = 2;
        x(2) = size(data,2)*0.8;
    end


    range = floor(x(1)):floor(x(2));
    try
        psd = data(psdA,range) - mean(data(psdA,range));
        psd2 = data(psd2A,range) - mean(data(psd2A,range));
        stage = data(instr,range) - mean(data(instr,range));
    catch
        size(data,2)
        set
        range = 100:size(data,2)*0.7;
        psd = data(psdA,range) - mean(data(psdA,range));
        psd2 = data(psd2A,range) - mean(data(psd2A,range));
        stage = data(instr,range) - mean(data(instr,range));
    end
      
     %%%% Smooth out psd signal
    psdNEW = psd;
    psdNEW2 = psd2;
    stageNEW = stage;
    block = 100;
    for i = (block+1):(size(psd,2)-(block+1))
        psdNEW(i) = mean(psd(i-block:i+block));
        psdNEW2(i) = mean(psd2(i-block:i+block));
        %stageNEW(i) = mean(stage(i-block:i+block));
    end
    
    % Create separate stage file
    block2 = 200;
    for i = (block2+1):(size(psd,2)-(block2+1))
        stageNEW(i) = mean(stage(i-block2:i+block2));
    end
    close all
    
    %%%% Find Period
    dil = 100; % First, dilute the stage signal so can find peaks
    for i = 1:size(stageNEW,2)/dil
        dilSTAGE(i) = stageNEW(dil*(i-1)+1);
    end
    [aa,bb]=findPEAKS(dilSTAGE,'MINPEAKHEIGHT',.05); % 0.2 for 0.8V or 0.1 for 0.4V (need to fine tune)
    
    for i = 1:(size(bb,2)) % Convert from diluted, back to regular values
        bb(i) = dil*(bb(i)-1)+1;
    end
    try
        for k = 1:(size(bb,2)-2) % And get the actual period (neglect final peak)
            roughPERIOD(k) = bb(k+1) - bb(k); 
        end
        %%%period = mean(roughPERIOD); %%%%% THis line adjusted here
        period = mean(roughPERIOD(2:size(roughPERIOD,2))); %%%%% THis line adjusted here
    catch %#ok<CTCH>
        period = 1;
        display('period_error')
    end
end

