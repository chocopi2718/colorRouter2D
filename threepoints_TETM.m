function fom = threepoints_TETM(img,num_layers, num_grating, wavs, n1, n2, period, h_grating, h_substrate,nns)
    add = zeros(length(wavs),1);
    for i =1:length(wavs)
        add(i) = singlewav_TETM(img,num_layers, num_grating, wavs(i), n1, n2, period, h_grating, h_substrate,nns);
    end
    fom = mean(add,'all');
end


