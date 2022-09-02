function dist = av_d(G, nd, V)
    %V is  subset of all nodes and nd is the node from which the aerage
    %distance to V is being calculated
    dist = 0;
    for v=V
        [~, d] = shortestpath(G, nd, v);
        dist = dist + d ;
    end
    dist = dist/size(V,2);
end