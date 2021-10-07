clear all; clc;
%% Radar Specifications 
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frequency of operation = 77GHz
% Max Range = 200m
% Range Resolution = 1 m
% Max Velocity = 100 m/s
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% User Defined Range and Velocity of target
% Define the target's initial position and velocity. Note : Velocity remains contant
d0 = 100;
v0 = 20;  %v0 is relative velocity

%% FMCW Waveform Generation
% Design the FMCW waveform by giving the specs of each of its parameters.
% Calculate the Bandwidth (Bsweep), Chirp Time (Tchirp) and Slope (alpha) of the FMCW chirp using the requirements above.
d_res = 1;              % Range Resolution = 1 m
c = 3*10^8;             % speed of light
RMax = 200;             % Max Range = 200m 
Bsweep = c/(2*d_res);   % Bandwidth
Tchirp = 5.5*2*RMax/c;  % chirp time
alpha = Bsweep/Tchirp;  % slope of chirps
fc= 77e9;               % carrier freq, Frequency of operation = 77GHz
Nd = 128;               % The number of chirps in one sequence.
                        % Its ideal to have 2^ value for the ease of running the FFT for Doppler Estimation.  
Nr = 1024;              % The number of samples on each chirp.

% Timestamp for running the displacement scenario for every sample on each chirp
t = linspace(0,Nd*Tchirp,Nr*Nd);    % total time for samples

% Creating the vectors for Tx, Rx and Mix based on the total samples input.
Tx = zeros(1,length(t));  % transmitted signal
Rx = zeros(1,length(t));  % received signal
Mix = zeros(1,length(t)); % beat signal

% Similar vectors for range_covered and time delay.
r_t = zeros(1,length(t));
td = zeros(1,length(t));

%% Signal generation and Moving Target simulation
% Running the radar scenario over the time. 
for i = 1:length(t)             
    % For each time stamp update the Range of the Target for constant velocity. 
    r_t(i) = d0 + v0*t(i);
    td(i) = 2*r_t(i)/c;
    
    % For each time sample we need update the transmitted and received signal. 
    Tx(i) = cos(2*pi*(fc*t(i) + alpha*t(i)^2/2));
    Rx(i) = cos(2*pi*(fc*(t(i)-td(i)) + (alpha*(t(i)-td(i))^2)/2)) + randn(size((t(i)-td(i))));
    
    % Now by mixing the Transmit and Receive generate the beat signal
    % This is done by element wise matrix multiplication of Transmit and Receiver Signal
    Mix(i) = Tx(i).*Rx(i);  % Beat Signal
end

%% RANGE DOPPLER RESPONSE
% This will run a 2DFFT on the mixed signal (beat signal) output and generate a range doppler map.
% Range Doppler Map Generation.
% The output of the 2D FFT is an image that has reponse in the range and doppler FFT bins. 
% So, it is important to convert the axis from bin sizes to range and doppler based on their Max values.
Mix = reshape(Mix,[Nr,Nd]);

% 2D FFT using the FFT size for both dimensions.
sig_fft2 = fft2(Mix,Nr,Nd);

% Taking just one side of signal from Range dimension.
sig_fft2 = sig_fft2(1:Nr/2,1:Nd);
sig_fft2 = fftshift(sig_fft2);
RDM = abs(sig_fft2);
RDM = 10*log10(RDM) ;

% ㅕse the surf function to plot the output of 2DFFT and to show axis in both dimensions
doppler_axis = linspace(-100,100,Nd);
range_axis = linspace(-200,200,Nr/2)*((Nr/2)/400);
figure,surf(doppler_axis,range_axis,RDM);
xlabel('measured velocity (m/s)');
ylabel('measured range (m)');