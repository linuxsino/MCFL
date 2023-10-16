% % **************************************************************************************************************
% % This is a code for solves a Multi-Channel Fused Lasso problem:
% %
% %
% %     min_x 1/2 ||A x - y||^2 + lam1 ||x||_{2,1} + lam2 MCTV(x),
% %
% % Inputs:
% %  A: Given dictionary for foreground, here, the identity matrix I_m*m is used
% %  y: residual signal, foreground candidates
% %  lam1, lam2: regularization parameters 
% %  d1, d2: Dimensions of Inputs.
% %  options: Options such as maximum iteritions
% %
% % Output:
% %  x: coefficient vector for foreground binarization
% %  iters: number of iterations.
% %

function [x,iters] =  MCFL(A,y,lam1,lam2,d1,d2,options)


    Ab = A;   
    d3 = size(y, 2);

    x0 = zeros(size(Ab,2),d3); 
    Ay = Ab' * y; 
    AA = Ab' * Ab; 

    % Compute Lipschitz constant.
    options.disp = 0; 
    L = eigs(AA, 1, 'lm', options) / size(Ab, 1);

  
    % FISTA.
    if (lam1 > 0)
        [x, iters] =  FISTA(x0, @funcobj, @grad, @prox, L, lam1, options.stopc);
    else
        [x, iters] =  FISTA(x0, @funcobj, @grad, @prox, L, lam2, options.stopc);
    end
    
    function v = funcobj(x)    
        v = 0.5 * norm(Ab * x - y, 2)^2 / size(Ab, 1) + lam1 * norm21(x) / size(Ab, 2);
        xm = reshape(x(1:end), d1, d2, d3);
        v = v + lam2 * gtv2D(xm) / size(Ab, 2);
    end

    function g = grad(x)
        g = (AA * x - Ay) / size(Ab, 1);
    end

    function p = prox(x, l)
        xm = reshape(x(1:end), d1, d2, d3);
        if (lam1 > 0)
            l2 = l / lam1 * lam2;
        else
            l2 = l; l = 0;
        end

        xm = dykstra(xm, @prox_TVL21, {l2 / size(Ab, 2)}, @prox_L21, {l / size(Ab, 2)}, options.stopc);
        p = reshape(xm, d1*d2, d3);
    end
end