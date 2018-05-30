function [ampPSDnew, ampPSD2new, ampSTAGEnew, totSQUAREpsd, totSQUAREpsd2, totSQUAREstage] = fineSINE2(aP, aP2, aS, period, psdNEW, psdNEW2, stage, phasePSD, phasePSD2, phaseSTAGE)
%FINESINE Take coarse sine fit and finely tune
    
    range = 0.1:0.01:6;

    fitPSD = zeros(size(psdNEW,2),size(range,2));
    fitPSD2 = zeros(size(psdNEW,2),size(range,2));
    fitSTAGE = zeros(size(psdNEW,2),size(range,2));

    for i = 1:size(psdNEW,2)
        fitPSD(i,91) = aP*cos(2*pi*i/(period)+(phasePSD*pi)/180);
        fitPSD2(i,91) = aP2*cos(2*pi*i/(period)+(phasePSD2*pi)/180);
        fitSTAGE(i,91) = aS*cos(2*pi*i/(period)+(phaseSTAGE*pi)/180);
        %display(i) %%%%%%%%%%%%%%%%%%
    end

    for j = 1:size(range,2)
        amp = aP*(range(1) + (j-1)/100);
        amp2 = aP2*(range(1) + (j-1)/100);
        ampSTAGE = aS*(range(1) + (j-1)/100);
        
        fitPSD(:,j) = (fitPSD(:,91)*amp)/aP;
        fitPSD2(:,j) = (fitPSD2(:,91)*amp2)/aP2;
        fitSTAGE(:,j) = (fitSTAGE(:,91)*ampSTAGE)/aS;
        %display(j) %%%%%%%%%%%%%%%%%
    end

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

%     plot(totSQUAREpsd)
%     figure
%     plot(totSQUAREpsd2)
%     figure
%     plot(totSQUAREstage)
%     
    [val,aPSDnew] = min(totSQUAREpsd);
    [val2,aPSD2new] = min(totSQUAREpsd2);
    [val3,aSTAGEnew] = min(totSQUAREstage);
    
    ampPSDnew =  aP*(range(1) + (aPSDnew-1)/100);
    ampPSD2new =  aP2*(range(1) + (aPSD2new-1)/100);
    ampSTAGEnew =  aS*(range(1) + (aSTAGEnew-1)/100);
    
    totSQUAREpsd = totSQUAREpsd/ampPSDnew^2; %Normalize by amplitude
    totSQUAREpsd2 = totSQUAREpsd2/ampPSD2new^2;
    totSQUAREstage = totSQUAREstage/ampSTAGEnew^2;
    
end

