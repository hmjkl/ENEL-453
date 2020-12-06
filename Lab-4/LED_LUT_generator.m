clear;

% N = the maximum size of our duty_cycle value.
N = 255;
% M = The maximum value of distance in. In our case we take distance / 4
% into our lut, so M = 255
M = 255;

%brightness = [0 12.5 25 37.5 50 70 85 95 100];
%duty_cycle = [0 1 5 12.5 24 37.5 60 78 100];

distance_meas = [3778 2500 1469 427];
distance_meas_norm = 100 * (255 - distance_meas / 16) / 255;
brightness = [4 60 80 100];
duty_cycle = distance_meas_norm;

% The start, use these brightness and duty_cycle values. Then note the
% actual brightness at every duty cycle and adjust accordingly.
%brightness = [10 20 30 40 50 60 70 80 90 100];
%duty_cycle = [10 20 30 40 50 60 70 80 90 100];


%brightness = [0 10 33 80 95.6 100];
%duty_cycle = [0 7.4 39 63.95 89.53 100];
plot(brightness, duty_cycle);

distance = brightness * M / 100;
duty_cycle_normalized = duty_cycle * N / 100;

coeff = polyfit(distance, duty_cycle_normalized, 3);
x = [0:M];
plot(x,floor(polyval(coeff,x)));

%%
%% Data exporting
%%
quant = floor(polyval(coeff,x));
quant(quant < 0) = 0;
quant(quant > 255) = 255;

LUT_data = sprintf('( %d ),\n',quant);
LUT_data(end-1) = ' ';

preamble = {
'library IEEE;'
'use IEEE.STD_LOGIC_1164.ALL;'
'package LED_LUT_pkg is'
sprintf('type array_1d is array (0 to %d) of integer;',M)
'constant d2d_LUT : array_1d := ('
};

post = {
');'
'end package LED_LUT_pkg;'
};
LUT_data = strcat(sprintf("%s\n",preamble{:}),LUT_data,sprintf("%s\n",post{:}));

file = fopen('LED_LUT.vhd','w');
fprintf(file,"%s",LUT_data);
fclose(file);