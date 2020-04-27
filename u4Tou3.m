function u3 = u4Tou3(u4, delta4, wvl, z3)
    u4GT = gpuArray(u4);
    N = size(u4GT,1);
    array = single(-(N-1)/2 : 1 : (N-1)/2);
    [XX,YY] = meshgrid(array);
    RR2 = (XX.^2+YY.^2);
    %% prop back to the SLM plane
    u3 = prop3(u4GT,RR2,wvl,delta4,-z3);
