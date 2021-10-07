freq = 77 * 10^9; %frequency
P_t = 0.003;     %Transmitted power
G_t = 10000;     %TX antenna gain
P_min = 10^-10;  %Minimum detectable power
sigma = 100^2;   %RCS
c = 3*10^8;   %velocity of  light

%calculate lamda
lambda = c/freq;

%calculate R(detect range)
inside = (P_t * G_t * lambda^2 * sigma) / (P_min * (4*pi)^3);
R = nthroot(inside,4);


range_resolution = 1*10^3; %so, d_res = c/2*B_sweep
B_sweep = c / 2 * range_resolution;
measured_Beat_freq = [0 1.1*10^6 13*10^6 24*10^6]';
T_s = 5.5 * 2 * R /c;

%so calculate estimated range
estimated_range = (c * T_s )/ (2 * B_sweep) * measured_Beat_freq;

