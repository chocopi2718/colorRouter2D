function [fom] = singlewav_TETM(img,num_layers, num_grating, wav, n1, n2, period, h_grating, h_substrate, nns)
    addpath('reticolo_allege');
    img = reshape(img, [num_layers, num_grating]);
    %% refractive index
    n_air=1;
    

    %% grating profile
    division_grating = [1:num_grating] * period / num_grating-period/2;
    index_grating = img * (n2-n1) + n1;

    %% reticolo
    [prv,vmax]=retio([],inf*1i);
    retio;
    textures = cell(1,num_layers+3);
    textures{1} = {n_air};
    for i = 1:num_layers
        textures{1+i} = {division_grating, index_grating(i,:)};   % Down textures
    end
    profile = {[0, (ones(num_layers,1)*h_grating/num_layers)', h_substrate,0], [1:(num_layers+3)]};
    textures{2+num_layers} = {n1};
    textures{3+num_layers} = {n1};
    
    
    parm = res0;
    parm.res1.champ = 1;      % calculate precisely
    % parm.res1.trace = 1;      % trace

    k_parallel = 0;
    angle_delta = 0;
    aa = res1(wav,period,textures,nns,k_parallel,angle_delta,parm);
    result = res2(aa, profile, parm);
    
    %% T

    einc = result.TEinc_top.PlaneWave_TE_Eu;
    sample = zeros(1,num_layers+3);
    sample(end) = 1;
    parm.res3.npts = sample;
    x = [0 1]*period;

    [e,z,index, wZ, loss_per_layer, loss_of_Z, loss_of_Z_X, X, wX] = res3(x,aa,profile,einc,parm);
    Ex = e(:,:,1);
    Ey = e(:,:,2);
    Ez = e(:,:,3);

    T = result.TEinc_top_transmitted.efficiency;
    Tsum = sum(T);

    intensity = abs(Ex).^2+abs(Ey).^2+abs(Ez).^2;
    [~,Rb] = max(X>period/4);
    [~,Bst] = max(X>period/2);
    [~,Bend] = max(X>period*3/4);
    weighted = wX'.*intensity;
    red =   sum(weighted(1:Rb-1));
    green1= sum(weighted(Rb:Bst-1));
    blue =  sum(weighted(Bst:Bend-1));
    green2= sum(weighted(Bend:end));
    total = sum(weighted);
    green = green1+green2;
    if (wav<=500e-9)
        fom1 = blue/total*Tsum;
    elseif (wav<600e-9)
        fom1 = green/total*Tsum;
    else
        fom1 = red/total*Tsum;
    end

    %% TM
    einc = result.TMinc_top.PlaneWave_TM_Eu;
    sample = zeros(1,num_layers+3);
    sample(end) = 1;
    parm.res3.npts = sample;
    x = [0 1]*period;

    [e,z,index, wZ, loss_per_layer, loss_of_Z, loss_of_Z_X, X, wX] = res3(x,aa,profile,einc,parm);
    
    Ex = e(:,:,1);
    Ey = e(:,:,2);
    Ez = e(:,:,3);
    T = result.TMinc_top_transmitted.efficiency;
    Tsum = sum(T);

    intensity = abs(Ex).^2+abs(Ey).^2+abs(Ez).^2;
    [~,Rb] = max(X>period/4);
    [~,Bst] = max(X>period/2);
    [~,Bend] = max(X>period*3/4);
    weighted = wX'.*intensity;
    red =   sum(weighted(1:Rb-1));
    green1= sum(weighted(Rb:Bst-1));
    blue =  sum(weighted(Bst:Bend-1));
    green2= sum(weighted(Bend:end));
    total = sum(weighted);
    green = green1+green2;
    if (wav<=500e-9)
        fom2 = blue/total*Tsum;
    elseif (wav<600e-9)
        fom2 = green/total*Tsum;
    else
        fom2 = red/total*Tsum;
    end
    fom = (fom1+fom2)/2;
end

