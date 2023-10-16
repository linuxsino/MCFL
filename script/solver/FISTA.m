function [x,iters] =  FISTA(x0, funcobj, grad, prox, L, lam, stopc)
    % Inicialization.
    step = 1 / L;
    stop = inf;
    z = x0; x = z;
    t = 1; iters = 0;
    val = inf;

    while (stop > stopc)
        % Update variables.
        xPrev = x; tPrev = t; valPrev = val;

        % Compute gradient.
        g = grad(z);

        % Solve proximity operator.
        x = z - step * g;
        x = prox(x, step * lam);

        % Update adjustment parameter.
        t = (1 + sqrt(1 +4 * t^2)) / 2;

        % Readjustment step.
        z = x + (tPrev-1) / t * (x - xPrev);

        % Compute objective value.
        val = funcobj(x);

        % Stopping criterion.
        stop = abs(val - valPrev);
        % fprintf(1, '%.2e ', stop);

        % Iterations.
        iters = iters+1;
    end
end