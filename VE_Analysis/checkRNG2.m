function [bad] = checkRNG2()
%CHECKRNG Summary of this function goes here
%   Detailed explanation goes here
    rootA = 'tests\';
    filesA = dir(rootA);
    filesA = filesA(3:size(filesA,1));
    
    keys{49} = 1;
    keys{50} = 2;
    keys{51} = 3;
    keys{52} = 4;
    keys{53} = 5;
    
    bad = [];
    
    if mod(size(filesA,1),5) == 0
        figure('position',[10,90,1900,900])
        jj=1;
        while jj <= size(filesA,1)
            figure('position',[10,90,1900,900])  
            c = 1;
            for ii = 1:5
                set = filesA(jj).name;
                load([set '_data.mat'])
                subplot(3,5,ii)
                plot(psdNEW)
                title(['Mirror ' set])
                subplot(3,5,ii+5)
                plot(psdNEW2)
                title(['Fixed ' set])
                subplot(3,5,ii+10)
                plot(stage)
                title(['Stage ' set])
                jj = jj + 1;
            end
            while c ~= 32
                [a,b,c] = ginput(1);
                if c == 32
                else
                    bad = [bad, jj - 6 + keys{c}];
                end
            end

            close all
        end
    else
        figure('position',[10,90,1900,900])
        jj=1;
        while jj <= size(filesA,1)-mod(size(filesA,1),5)
            figure('position',[10,90,1900,900])  
            c = 1;
            for ii = 1:5
                set = filesA(jj).name;
                load([set '_data.mat'])
                subplot(3,5,ii)
                plot(psdNEW)
                title(['Mirror ' set])
                subplot(3,5,ii+5)
                plot(psdNEW2)
                title(['Fixed ' set])
                subplot(3,5,ii+10)
                plot(stage)
                title(['Stage ' set])
                jj = jj + 1;
            end
            while c ~= 32
                [a,b,c] = ginput(1);
                if c == 32
                else
                    bad = [bad, jj - 6 + keys{c}];
                end
            end

            close all
        end
        
        figure('position',[10,90,1900,900])  
        c = 1;
        for ii = 1:mod(size(filesA,1),5)
            set = filesA(jj).name;
            load([set '_data.mat'])
            subplot(3,5,ii)
            plot(psdNEW)
            title(['Mirror ' set])
            subplot(3,5,ii+5)
            plot(psdNEW2)
            title(['Fixed ' set])
            subplot(3,5,ii+10)
            plot(stage)
            title(['Stage ' set])
            jj = jj + 1;
        end
        while c ~= 32
            [a,b,c] = ginput(1);
            if c == 32
            else
                bad = [bad, jj - 6 + keys{c}];
            end
        end

        close all
    end       
end
