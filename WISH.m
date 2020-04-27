% Simulation code for paper "WISH: wavefront imaging sensor with high
% resolution"
% Author: Yicheng Wu @ Rice University
% Date: 11/07/2019

clear
close all

g = gpuDevice(1);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generate simulation data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% load parameters and field
load('resChart.mat');

u40 = padarray(im2single(im),[256,256]);

wvl = 532e-9;  
z3 = 30e-3;

delta4 = 1.85e-6;

N = size(u40,1);
delta3 = wvl*z3/(N*delta4);
u30 = u4Tou3(u40, delta4, wvl, z3);

%% forward prop to the sensor plane with SLM modulation

display('Generating simulation data images ...')

noise = 0.01;
Nim = 4;
ims = gen_ims(u30,z3,delta3,wvl,Nim,noise);
display('Captured images are simulated')

clear a30

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% reconstruction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% pre-process the data

% for the SLM
load('slm60_resize10.mat');
SLM = process_SLM(slm,N,Nim,delta3);

% the captured image
y0 = process_ims(ims,N);



%% Recon initilization

N_os = 15;            % number of images per batch
if Nim < N_os
    N_os = Nim;
end
N_iter = 1000;        % number of iterations
N_batch = floor(Nim/N_os);        % number of batches

u4_est = WISHrun(y0,SLM,wvl,z3,delta3,delta4,N_os,N_iter,N_batch);  
u4_est = gather(u4_est);



figure,
subplot(2,2,1)
imshow(abs(u40),[0 1])
title('Amplitude GT')
subplot(2,2,2)
imshow(angle(u40),[])
title('Phase GT')
subplot(2,2,3)
imshow(abs(u4_est),[0 1])
title('Amplitude estimation')
subplot(2,2,4)
imshow(angle(u4_est),[])
title('Phase estimation')

