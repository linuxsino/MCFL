function pu = PG(funObj, u, funProj, step, stopc)

	stop=inf;
	STOP=stopc;

    uold = u;
	[fold, gold] = funObj(u);

	while (stop > STOP)
        u = funProj(uold - step * gold);
        [f, g] = funObj(u);

        stop = abs(f - fold);
        fold = f; gold = g; uold = u;
	end
    pu = u;
end