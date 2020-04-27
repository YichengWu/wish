function SLM = process_SLM(slm,N,Nim,delta3)
% scale the SLM to the correct size
    delta_SLM = 6.4e-6;
    
    if isa(slm,'uint8')
        slm = im2single(slm);
    end
    slm2 = slm(:,421:1500,1:Nim);
    SLM = exp(1j*2*pi*slm2);
    SLM = imresize(SLM,delta_SLM/delta3);
    SLM = padarray(SLM,[round((N-size(SLM,1))/2) round((N-size(SLM,2))/2)]);
    if size(SLM,1)>N
        SLM(N+1:end,:,:) = [];
    end
    if size(SLM,2)>N
        SLM(:,N+1:end,:) = [];
    end