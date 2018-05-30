function [fin,bNEW2] = mEXCEL2(cc,fldr,bead,ampORfreq,axs)
%MEXCEL2 Summary of this function goes here
%   Detailed explanation goes here

    b = zeros(size(cc,1)-1,size(cc,2)+1);
    
    for aa = 1:(size(cc,1)-1)
        for bb = 1:size(cc,2)-4
            b(aa,bb) = cc{aa+1,bb+4};
        end
    end

    calSTAGE = 5.158e-6; %stage calibration (meters/Volt) 
    k1 = trapSTIFFNESS2(bead,1,axs); %X trap stiffness (N/V)
    %k2 = 5.3173e-11; %4.8649e-11 (old value)
    %k2 = 5.4206e-011; % ReCalibrated on 11/15/12
    k2 = trapSTIFFNESS2(bead,2,axs);
    
    %%% OLD %%% k2 = 3.2745e-11; %X
    % k1 = 3.3681e-012;% FOR Y
    % k2 = 2.4517e-011;% FOR Y
    radius = (bead/2)*10^-6; %radius of trapped bead (normal beads are 1e-6), 2.25 for larger beads
    values1 = zeros(size(b,1),4);
    values2 = zeros(size(b,1),4);

    if ampORfreq == 'f'
        for i = 1:size(b,1)
            values1(i,1) = b(i,1)/b(i,3); % ampPSD/ampSTAGE
            values1(i,2) = 2*pi*abs(b(i,6) - b(i,4))/360; % phase diff
            values1(i,3) = (values1(i,1)/(6*pi*radius))*(k1/calSTAGE)*(cos(values1(i,2))); %gP
            values1(i,4) = (values1(i,1)/(6*pi*radius))*(k1/calSTAGE)*(sin(values1(i,2))); %gPP
            values1(i,5) = sqrt(((values1(i,3).^2) + (values1(i,4).^2)))/(2*pi*str2num(cc{i+1,1}(1:(findstr(cc{i+1,1},'_')-1)))); %complex viscosity

            values2(i,1) = b(i,2)/b(i,3); % ampPSD2/ampSTAGE
            values2(i,2) = 2*pi*abs(b(i,6) - b(i,5))/360; % phase diff
            values2(i,3) = (values2(i,1)/(6*pi*radius))*(k2/calSTAGE)*(cos(values2(i,2))); %gP
            values2(i,4) = (values2(i,1)/(6*pi*radius))*(k2/calSTAGE)*(sin(values2(i,2))); %gPP
            values2(i,5) = sqrt(((values2(i,3).^2) + (values2(i,4).^2)))/(2*pi*str2num(cc{i+1,1}(1:(findstr(cc{i+1,1},'_')-1)))); %complex viscosity
        end
    elseif ampORfreq == 'a'
        for i = 1:size(b,1)
            values1(i,1) = b(i,1)/b(i,3); % ampPSD/ampSTAGE
            values1(i,2) = 2*pi*abs(b(i,6) - b(i,4))/360; % phase diff
            values1(i,3) = (values1(i,1)/(6*pi*radius))*(k1/calSTAGE)*(cos(values1(i,2))); %gP
            values1(i,4) = (values1(i,1)/(6*pi*radius))*(k1/calSTAGE)*(sin(values1(i,2))); %gPP
            values1(i,5) = sqrt(((values1(i,3).^2) + (values1(i,4).^2)))/(1*2*pi); %complex viscosity (frequency of 1 Hz)

            values2(i,1) = b(i,2)/b(i,3); % ampPSD2/ampSTAGE
            values2(i,2) = 2*pi*abs(b(i,6) - b(i,5))/360; % phase diff
            values2(i,3) = (values2(i,1)/(6*pi*radius))*(k2/calSTAGE)*(cos(values2(i,2))); %gP
            values2(i,4) = (values2(i,1)/(6*pi*radius))*(k2/calSTAGE)*(sin(values2(i,2))); %gPP
            values2(i,5) = sqrt(((values2(i,3).^2) + (values2(i,4).^2)))/(1*2*pi); %complex viscosity (frequency of 1 Hz)
        end
    else
        display('ampORfreq Error!')
    end
    values2(:,4) = abs(values2(:,4)); % Make up for potential difference of pi
    values1(:,4) = abs(values1(:,4)); % Make up for potential difference of pi    
    
    b(:,size(cc,2)-3:size(cc,2)+1) = values2;

    % Now, order the data sets
    slot = zeros(size(b,1),3);
    for i = 1:size(b,1)
        slot(i,1) = str2num(cc{i+1,1}(1:(findstr(cc{i+1,1},'_')-1)));
        slot(i,2) = str2num(cc{i+1,1}((findstr(cc{i+1,1},'_')-1)+2:size(cc{i+1,1},2)));
        slot(i,3) = i;
    end
    [d, IX] = sort(slot);
    
    bNEW = zeros(size(cc,1)-1,size(cc,2)+1);
    for i = 1:size(b,1)
        %bNEW(IX(i,1),:) = b(i,:);%%%%% Messing with this line
        bNEW(i,:) = b(IX(i,1),:);
    end
    
    bNEW2(:,1) = d(:,1);
    bNEW2(:,2) = slot(:,2);
    bNEW2(:,3:size(b,2)+2) = bNEW;
    
    %Now organize bNEW2 into an exportable xls file (after taking means,
    %stdev)
    sets = unique(bNEW2(:,1)); % Number of unique data sets
    num = size(sets,1);
    
    a = cell(num,1);
    for i = 1:num
        rows = find(bNEW2(:,1) == sets(i));
        a{i} = bNEW2(rows,:); %#ok<FNDSB>
    end
    for j = 1:num
        ht = size(a{j},1);
        wid = size(a{j},2);
        for i = 3:wid
            a{j}(ht+1,i) = mean(a{j}(1:ht,i));
            a{j}(ht+2,i) = std(a{j}(1:ht,i));
        end
    end
    
    fin = cell(300,19);
    fin{1,1} = 'Name';
    fin{1,2} = 'Trial'; 
    fin{1,3} = 'ampPSD';
    fin{1,4} = 'ampPSD2';
    fin{1,5} = 'ampSTAGE';
    fin{1,6} = 'phasePSD';
    fin{1,7} = 'phasePSD2';
    fin{1,8} = 'phaseSTAGE'; 
    fin{1,9} = 'Period'; 
    fin{1,10} = 'Start';
    fin{1,11} = 'End';
    fin{1,12} = 'diffPSD';
    fin{1,13} = 'diffPDS2';
    fin{1,14} = 'diffSTAGE';
    fin{1,15} = 'ampPSD/ampSTAGE';
    fin{1,16} = 'phaseDIFF';
    fin{1,17} = 'gP';
    fin{1,18} = 'gPP';
    fin{1,19} = 'n';
    
    usedROWS = 1;
    for i = 1:num
        for j = 1:size(a{i},1)
            for k = 1:size(a{i},2)
                fin{usedROWS + j,k} = a{i}(j,k);
            end
        end
        fin{usedROWS +j - 1,1} = 'MEAN';
        fin{usedROWS +j,1} = 'STDEV';
        usedROWS = usedROWS + size(a{i},1) + 1;
        endSect(i) = usedROWS - 2;
    end
    
    for i = 1:num
        fin{usedROWS + i,1} = a{i}(1,1)*2*pi;
        fin{usedROWS + i,2} = fin{endSect(i),17};
        fin{usedROWS + i,3} = fin{endSect(i)+1,17};
        fin{usedROWS + i,4} = fin{endSect(i),18};
        fin{usedROWS + i,5} = fin{endSect(i)+1,18};
        fin{usedROWS + i,6} = fin{endSect(i),19};
        fin{usedROWS + i,7} = fin{endSect(i)+1,19};
    end
    
    fin{usedROWS + 3,10} = fldr; % Name of the data set

end

