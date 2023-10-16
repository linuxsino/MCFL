function v = gtv1D(y)
    if (size(y, 1) > 1)
        dy = y(2:end,:,:) - y(1:end-1,:,:);
        v = norm21(dy);
    else
        if (size(y, 2) > 1)
            dy = y(:,2:end,:) - y(:,1:end-1,:);
            v = norm21(dy);
        else
            v = 0;
        end
    end
end
