% this is one step propagation
% this is better than prop, optimized for GPU, especially large batch size
% all intermediate variables are same (U) to save memory

%function [Uout,x2] = prop(Uin,lambda,delta1,z)
function U = prop3(U,RR2,lambda,delta1,z)

N = size(U,1);
k=2*pi/lambda;
delta2 = abs(z)*lambda/(N*delta1);

U = U .* exp(1j * k/(2*z) *single(delta1)^2.*RR2);
if z>0
    % ft2 part
    U = ifftshift(U);
    U = fft2(U);
    U = fftshift(U);
    U = U* delta1^2;

else
    % ift2 part
    U = ifftshift(U);
    U = ifft2(U);
    U = fftshift(U);
    U = U* (N*delta1)^2;
    
end

U = U.* exp(1j * k/(2*z) *single(delta2)^2.*RR2);
U = 1 / (1j*lambda*z).*U;
% 
% Uout(1:round(N/4),:) = 0;
% Uout(round(3*N/4):end,:) = 0;
% Uout(:,1:round(N/4)) = 0;
% Uout(:,round(3*N/4):end) = 0;

end
