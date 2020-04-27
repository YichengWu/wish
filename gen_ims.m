function ims = gen_ims(a30,z3,delta3,wvl,Nim,noise)
% generate ims on the sensor plane
    if Nim>60
        error('max Nim is 60.')
    end

    N = size(a30,1);
    array = single(-(N-1)/2 : 1 : (N-1)/2);
    [XX,YY] = meshgrid(array);
    RR2 = (XX.^2+YY.^2);

    delta_SLM = 6.4e-6;
    L_SLM = 6.4e-6*1080;
    A_SLM = (abs(XX)*delta3<L_SLM/2).*(abs(YY)*delta3<L_SLM/2);

    load('slm60_resize10.mat');
    if isa(slm,'uint8')
        slm = im2single(slm);
    end

    ims = zeros(N,N,Nim,'single');

    for i = 1:Nim
        i
        slm0 = im2single(slm(:,421:1500,i));
        slm1 = imresize(slm0,delta_SLM/delta3);
        slm1 = padarray(slm1,[round((N-size(slm1,1))/2) round((N-size(slm1,2))/2)]);
        if size(slm1,1)>N
            slm1(N+1:end,:,:) = [];
        end
        if size(slm1,2)>N
            slm1(:,N+1:end,:) = []; 
        end

        a31 = a30.*A_SLM.*exp(1j*slm1*2*pi);
        a4 = prop3(a31,RR2,wvl,delta3,z3);

        w = noise*randn(N,N);
        ya = max(abs(a4).^2+w,0);
        ims(:,:,i) = gather(ya);
    end
