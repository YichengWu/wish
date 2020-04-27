function u4_est = WISHrun(y0,SLM,wvl,z3,delta3,delta4,N_os,N_iter,N_batch)
    
    %% parameters
    N = size(y0,1);
    array = single(-(N-1)/2 : 1 : (N-1)/2);
    [XX,YY] = meshgrid(array);
    RR2 = (XX.^2+YY.^2);
    k = 2*pi/wvl;
    E4 = exp(1j * k/(2*z3) *single(delta4)^2.*RR2);

    u3_batch = zeros([N,N,N_os],'single','gpuArray');      % store all U3
    u4 = zeros([N,N,N_os],'single','gpuArray');
    y = zeros([N,N,N_os],'single','gpuArray');          % store all y (y is complex, y0 is real)
    
    %% initilize a3
    for ii = 1:N_os 
        SLM_batch = SLM(:,:,ii);
        y0_batch = y0(:,:,ii);

        u3_batch(:,:,ii) = prop3s(gpuArray(y0_batch./E4),wvl,delta4,-z3).*conj(SLM_batch);  
    end
    u3 = single(mean(u3_batch,3));      % average it

    %% Recon run
    for jj = 1:N_iter  
        u3_collect = zeros(size(u3),'single','gpuArray');
        for idx_batch = 1:N_batch
            % put the correct batch into the GPU
            SLM_batch = SLM(:,:,1+N_os*(idx_batch-1):N_os*idx_batch);
            y0_batch = y0(:,:,1+N_os*(idx_batch-1):N_os*idx_batch);

            u4 = prop3s(u3.*SLM_batch,wvl,delta3,z3);      % U4 is the field on the sensor
            y = y0_batch.*exp(1j*angle(u4));       % force the amplitude of y to be y0
            u3_batch= prop3s(y,wvl,delta4,-z3).*conj(SLM_batch);

            u3_collect = u3_collect + (mean(u3_batch,3));       % collect(add) U3 from each batch
            idx_converge0(idx_batch) = gather(mean(mean(mean(y0_batch,2),1)./sum(sum(abs(abs(u4)-y0_batch),2),1)));       %convergence index matrix for each batch    

        end

        u3 = (u3_collect/N_batch);           % average over batches    
        idx_converge(jj) = mean(idx_converge0);  % sum over batches

        u4_est = prop3s(u3,wvl,delta3,z3).*E4;
        assignin('base','u4_est',u4_est);
        
        if mod(jj,10)==0
            figure(77)
            subplot(121)
            imshow(abs(u4_est(:,:)),[])
            title('Amplitude')
            subplot(122)
            imshow(angle(u4_est(:,:)),[])
            title('Phase')
            title(num2str(jj));
            drawnow

            figure(88)
            plot(jj,idx_converge(jj),'*')
            xlabel('Iterations')
            ylabel('Convergence source')
            hold on
            drawnow
        end

        % exit if the matrix doesn't change much
        if jj>1
            if abs(idx_converge(jj)-idx_converge(jj-1))/idx_converge(jj)<1e-4
                disp('Converged. Exit the iteration...')
                break
            end
        end
    end  