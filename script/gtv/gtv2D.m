function v = gtv2D(y)

    v = 0;
    for i=1:size(y, 1)
        v = v + gtv1D(y(i,:,:));
    end

    for i=1:size(y, 2)
        v = v + gtv1D(y(:,i,:));
    end
end
