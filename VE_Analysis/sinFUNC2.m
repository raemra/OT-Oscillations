function [phasePSD, phasePSD2, phaseSTAGE] = sinFUNC2(ampPSD, ampPSD2, ampSTAGE, period, psdNEW, psdNEW2, stage)
%SINFUNC Fit to sin function
%   Take data from 'rng' and fit to sin function
 

    fitPSD = zeros(size(psdNEW,2),360);
    fitPSD2 = zeros(size(psdNEW,2),360); %#ok<NASGU>

    for j = 1:360
        rad = (j*pi)/180;
        for i = 1:size(psdNEW,2)
            fitPSD(i,j) = ampPSD*cos(2*pi*i/(period)+rad);
        end
    end
    fitPSD2 = (fitPSD/ampPSD) * ampPSD2;
    fitSTAGE = (fitPSD/ampPSD) * ampSTAGE;

%     fitPSD = fitPSD';
%     fitPSD2 = fitPSD2';
%     fitSTAGE = fitSTAGE';
    psdNEW = psdNEW';
    psdNEW2 = psdNEW2';
    stage = stage';
    
    totSQUAREpsd = zeros(1,360);
    totSQUAREpsd2 = zeros(1,360);
    totSQUAREstage = zeros(1,360);
    for i = 1:360
        totSQUAREpsd(i) = sum((fitPSD(:,i) - psdNEW).^2);
        totSQUAREpsd2(i) = sum((fitPSD2(:,i) - psdNEW2).^2);
        totSQUAREstage(i) = sum((fitSTAGE(:,i) - stage).^2);
    end
    psdNEW = psdNEW';
    psdNEW2 = psdNEW2';
    stage = stage';
    
    %plot(totSQUAREpsd)
    %figure
    %plot(totSQUAREpsd2)
    %figure
    %plot(totSQUAREstage)

    [val,phasePSD] = min(totSQUAREpsd);
    [val2,phasePSD2] = min(totSQUAREpsd2);
    [val3,phaseSTAGE] = min(totSQUAREstage);

    %figure
    %plot(fitPSD(:,phasePSD))
    %hold on
    %plot(psdNEW,'r')

    %figure
    %plot(fitPSD2(:,phasePSD2))
    %hold on
    %plot(psdNEW2,'r')
    
    %figure
    %plot(fitSTAGE(:,phaseSTAGE))
    %hold on
    %plot(stage,'r')

%     clear squaresPSD squaresSTAGE diffPSD diffSTAGE fitPSD fitSTAGE
%     save(set)
%     clear all
%     close all

end

