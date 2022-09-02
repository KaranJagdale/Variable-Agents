function clt =  cltar(G, nd, acttar)
    mindist = inf;
    for targ = acttar
        [~,d] = shortestpath(G, nd, targ);
            if d < mindist
                mindist = d;
                clt = targ;
            end
    end
end