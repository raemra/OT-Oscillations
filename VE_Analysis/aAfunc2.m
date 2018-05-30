function [] = aAfunc2(type,axs)
%aAfunc2 - Will analyze all data found in 'TESTS' folder
% analyzeALL in function form
% Input is 'f' for frequency measurements and 'a' for amplitude
% measurements
    if axs == 'x'
        instr = 10;
        psd1 = 1;
        psd2 = 5;
    elseif axs == 'y'
        instr = 9;
        psd1 = 2;
        psd2 = 6;
    else
        return
    end
    
    if type == 'f'
        rootA = 'tests\';
        filesA = dir(rootA);
        filesA = filesA(3:size(filesA,1));
        for i = 1:size(filesA,1)
            set = filesA(i).name;
%             instr = 6; %Stage (5 for x, 6 for y) %% For 'withSUMS'
%             psd1 = 2; %Mirror (1 for x, 2 for y)
%             psd2 = 4; %Fixed (3 for x, 4 for y)

            [x, period, psdNEW, psdNEW2, stage] = rngAUTO(set,instr,psd1,psd2);

            aP = std(psdNEW)*1.4;
            aP2 = std(psdNEW2)*1.4;
            aS = std(stage)*1.4;

            idealPER = 20000/str2num(set(1:(findstr(set,'_')-1))); %If set is named freq_trial (ie, 1.5_3 is freq = 1.5Hz and trial #3)

            %In case period is way off 
            if period < (idealPER * 0.7); %11000
                period = idealPER; %12567;
            elseif period > idealPER * 1.3 %14000
                period = idealPER; %12567;
            else
            end
            
            save([set '_data.mat'])
            display(['set ' num2str(i) ' of ' num2str(size(filesA,1)) ' completed'])
        end

        bad = checkRNG2();
        for i = 1:size(bad,2)
            set = filesA(bad(i)).name;

            [x, period, psdNEW, psdNEW2, stage] = rng(set,instr,psd1,psd2);

            aP = std(psdNEW)*1.4;
            aP2 = std(psdNEW2)*1.4;
            aS = std(stage)*1.4;

            idealPER = 20000/str2num(set(1:(findstr(set,'_')-1))); %If set is named freq_trial (ie, 1.5_3 is freq = 1.5 and trial #3)

            %In case period is way off 
            if period < (idealPER * 0.7); %11000
                period = idealPER; %12567;
            elseif period > idealPER * 1.3 %14000
                period = idealPER; %12567;
            else
            end
            
            save([set '_data.mat'])
            display(['set ' num2str(i) ' of ' num2str(size(bad,2)) ' completed'])
        end
    elseif type == 'a'
        rootA = 'tests\';
        filesA = dir(rootA);
        filesA = filesA(3:size(filesA,1));
        for i = 1:size(filesA,1)
            set = filesA(i).name;
            instr = 5;
            psd1 = 1;
            psd2 = 3;

            [x, period, psdNEW, psdNEW2, stage] = rngAUTO(set,instr,psd1,psd2);

            aP = std(psdNEW)*1.4;
            aP2 = std(psdNEW2)*1.4;
            aS = std(stage)*1.4;

            idealPER = 20000; %Period here is 1.0 (aka 20000)

            %In case period is way off 
            if period < (idealPER * 0.7); %11000
                period = idealPER; %12567;
            elseif period > idealPER * 1.3 %14000
                period = idealPER; %12567;
            else
            end

            save([set '_data.mat'])
            display(['set ' num2str(i) ' of ' num2str(size(filesA,1)) ' completed'])
        end

        bad = checkRNG2();
        for i = 1:size(bad,2)
            set = filesA(bad(i)).name;

            [x, period, psdNEW, psdNEW2, stage] = rng(set,instr,psd1,psd2);

            aP = std(psdNEW)*1.4;
            aP2 = std(psdNEW2)*1.4;
            aS = std(stage)*1.4;

            idealPER = 20000/str2num(set(1:(findstr(set,'_')-1))); %If set is named freq_trial (ie, 1.5_3 is freq = 1.5 and trial #3)

            %In case period is way off 
            if period < (idealPER * 0.7); %11000
                period = idealPER; %12567;
            elseif period > idealPER * 1.3 %14000
                period = idealPER; %12567;
            else
            end

            save([set '_data.mat'])
            display(['set ' num2str(i) ' of ' num2str(size(bad,2)) ' completed'])
        end
    else
        display('ERROR')
    end
        
    clear all
    rootA = 'tests\';
    filesA = dir(rootA);
    filesA = filesA(3:size(filesA,1));

    for iii = 1:size(filesA,1)
        set = filesA(iii).name;
        load([set '_data.mat'])

        %In case file is too large (crashes matlab)
        if size(psdNEW,2) > 40000
            psdNEW = psdNEW(1,1:40000);
            psdNEW2 = psdNEW2(1,1:40000);
            stage = stage(1,1:40000);
            %display(['Trials cropped for memory purposes, trial ' num2str(iii)])
        else
        end

        [phasePSD, phasePSD2, phaseSTAGE] = sinFUNC2(aP, aP2, aS, period, psdNEW, psdNEW2, stage);
        close all

        tic
        [ampPSDnew, ampPSD2new, ampSTAGEnew, totSQUAREpsd, totSQUAREpsd2, totSQUAREstage] = ...
            fineSINE2(aP, aP2, aS, period, psdNEW, psdNEW2, stage, phasePSD, phasePSD2, phaseSTAGE);
        toc
        close all

        display(iii)
        save([set '_data.mat'])
    end
end

