function n = norm21(y)
    nve = sum(y.^2, 3); nve = sqrt(nve);
    n = sum(sum(nve));
end
