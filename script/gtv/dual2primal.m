function x = dual2primal(u, y, kD)
    x = y - kD' * u;
end
