function y0 = process_ims(ims,N)
    y0 = real(sqrt(ims));      % change from intensity to magnitude
    y0 = padarray(y0,[round((N-size(y0,1))/2) round((N-size(y0,2))/2)]);
    if size(y0,1)>N
        y0(N+1:end,:,:) = [];
        y0(:,N+1:end,:) = [];
    end