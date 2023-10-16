function x = dykstra(y, fun1, arg1, fun2, arg2, stop, maxiter)
    if (nargin < 7)
        maxiter = 1e3;
    end

    st = inf;
    x = y;
    u = zeros(size(y)); w = zeros(size(y));
    iter = 0;

    while (st > stop)
        iter = iter + 1;
        xold = x;

        v = fun1(x + u, arg1{:});
        u = x + u - v;

        x = fun2(v + w, arg2{:});
        w = v + w - x;

        st = mean(abs(x(:) - xold(:)));
        % fprintf(1, ' [%.2e] ', st);
        if (iter > maxiter)
            return;
        end
    end
end