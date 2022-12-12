clear;
addpath('reticolo_allege');

tt = clock;
rng('default')
rng(round(tt(6)*1000))
tic;
num_grating = 32;
num_layers = 4;
period = 1e-6;
h_substrate = 0.5e-6;
h_grating = 1.5e-6;
nvar = num_layers*num_grating;
wavs = 405e-9:10e-9:695e-9;
% wavs = [450e-9, 550e-9, 650e-9];
n1=1.5;
n2=2.0;

pop = 200;
epochs = 100;
img = randi(2,1,nvar)-1;
nns = 20;
%%
gaoptions = optimoptions('ga', 'UseParallel', true, 'PlotFcn',{'gaplotbestf','gaplotbestindiv'},'MaxGenerations',  epochs, 'MaxStallGenerations', 15, 'FunctionTolerance', 1e-4, 'PopulationSize', pop, 'UseVectorized', false, 'PopulationType', 'bitString');
[x,fval,exitflag,output,population,scores] = ga(@(img) threepoints_TETM(img, num_layers, num_grating, wavs, n1, n2, period, h_grating, h_substrate,nns)*(-1),nvar,[],[],[],[],[],[],[],gaoptions);

% save(['PLANCK_RGGB_',nowstring,num2str([num_layers num_grating]),'.mat'])
% tgprintf2(['PLANCK_single_',num2str([num_layers num_grating]),'_',num2str(toc)])
