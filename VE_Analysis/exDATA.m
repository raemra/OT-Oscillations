%clear all

%fldr = 'PPIC_25_6micron';
%bead = 6; % Diameter in microns

%request info instead to prevent forgetting to change bead size
% fldr = input('Data folder to be compiled.... (string)  ');
% bead = input('Bead size (in microns)  ');
% ampORfreq = input('Amplitude or frequency measurement?   (a or f, string)  ');

fldr = 'TEST';
bead = 4.5;
ampORfreq = 'f';

% rootA = 'C:\users\Rae Anderson\desktop\Cody2\tests\';
% filesA = dir(rootA);
% filesA = filesA(3:size(filesA,1));
location = ['Data\' fldr '\'];
filesA = dir(location);
filesA = filesA(3:size(filesA,1)); 

ff = dir(location);
ff = ff(3:size(ff,1));
cc = cell(size(filesA,1)+1,16);
cc{1,1} = 'Name';
cc{1,2} = 'ampPSD';
cc{1,3} = 'ampPSD2';
cc{1,4} = 'ampSTAGE';
cc{1,5} = 'ampPSDadj';
cc{1,6} = 'ampPSD2adj';
cc{1,7} = 'ampSTAGEadj';
cc{1,8} = 'phasePSD'; 
cc{1,9} = 'phasePSD2'; 
cc{1,10} = 'phaseSTAGE';
cc{1,11} = 'Period';
cc{1,12} = 'Start';
cc{1,13} = 'End';
cc{1,14} = 'diffPSD';
cc{1,15} = 'diffPSD2';
cc{1,16} = 'diffSTAGE';

for jjkk = 2:(size(filesA,1) + 1)
    
    nm = ff(jjkk-1).name;
    load([location nm])
    nm = ff(jjkk-1).name;
    cc{jjkk,1} = set; % Name
    cc{jjkk,2} = aP; % Selected amplitude PSD
    cc{jjkk,3} = aP2; % Selected amplitude PSD2
    cc{jjkk,4} = aS; % Selected amplitude Stage
    cc{jjkk,5} = ampPSDnew; % Adjusted amplitude PSD
    cc{jjkk,6} = ampPSD2new; % Adjusted amplitude PSD2
    cc{jjkk,7} = ampSTAGEnew; % Adjusted amplitude Stage
    cc{jjkk,8} = phasePSD; % PSD phase
    cc{jjkk,9} = phasePSD2; % PSD2 phase
    cc{jjkk,10} = phaseSTAGE; % Stage phase
    cc{jjkk,11} = period; % Period
    cc{jjkk,12} = ceil(x(1)); % Starting point
    cc{jjkk,13} = ceil(x(2)); % End point
    cc{jjkk,14} = min(totSQUAREpsd)/size(psdNEW,2);
    cc{jjkk,15} = min(totSQUAREpsd2)/size(psdNEW,2);
    cc{jjkk,16} = min(totSQUAREstage)/size(psdNEW,2);
end

%%%% Catch high error sets here before passing to mEXCEL2/3

cc2 = cc; %to pass to mEXCEL2
cc3 = cc; %to pass to mEXCEL3

err2 = [];
err3 = [];

thresh = .06;%1.5; % Can set higher or lower as desired
for i = 2:size(cc,1)
    if cc{i,15} > thresh %% PSD2 refers to fixed in cc
        err2 = [err2, i];
    end
    
    if cc{i,14} > thresh
        err3 = [err3, i];
    end
end   
    
err2 = fliplr(err2);
err3 = fliplr(err3);
for i = err2
    cc2(i,:) = [];
end

for i = err3
    cc3(i,:) = [];
end
%%%%


[fin_fixed,b_f] = mEXCEL2(cc2,fldr,bead,ampORfreq,axs);
[fin_mirror,b_m] = mEXCEL3(cc3,fldr,bead,ampORfreq,axs);
 
c=clock;
save(['VE_Data-' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(1)) '-' num2str(c(4)) '_' num2str(c(5)) '.mat'],'fin_fixed','fin_mirror')
