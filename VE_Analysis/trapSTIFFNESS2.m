function [trap_st] = trapSTIFFNESS2(bead,trap,axs)
%TRAPSTIFFNESS Summary of this function goes here
%   Detailed explanation goes here
    
    ts = zeros(3,2,2); % Bead size, trap, axis
    
    %%% 2 micron
    ts(1,1,1) = 1; % 2 micron, Mirror, x-axis
    ts(1,1,2) = 1; % 2 micron, Mirror, y-axis 
    ts(1,2,1) = 1; % 2 micron, Fixed, x-axis
    ts(1,2,2) = 1; % 2 micron, Fixed, y-axis
    
    %%% 4.5 micron
    ts(2,1,1) = 2.433E-11; %******* 4.5 micron, Mirror, x-axis -  7-10-14
    ts(2,1,2) = 1; % 4.5 micron, Mirror, y-axis 
    ts(2,2,1) = 2.8218E-11; %******* 4.5 micron, Fixed, x-axis -  7-10-14
    ts(2,2,2) = 1; % 4.5 micron, Fixed, y-axis
    
    %%% 6 micron
    ts(3,1,1) = 5.58E-11; % 6 micron, Mirror, x-axis
    ts(3,1,2) = 5.83E-11; % 6 micron, Mirror, y-axis 
    ts(3,2,1) = 8.89E-11; % 6 micron, Fixed, x-axis
    ts(3,2,2) = 1.43E-10; % 6 micron, Fixed, y-axis
    
    if bead == 2
        b = 1;
    elseif bead == 4.5
        b = 2;
    elseif bead == 6
        b = 3;
    else
        display('Incorrect bead size')
    end
    
    if axs == 'x'
        xs = 1;
    elseif axs == 'y'
        xs = 2;
    else 
        display('Incorrect axis')
    end
    
    trap_st = ts(b,trap,xs);
end