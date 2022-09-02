function [nd, mindist] = min_avg_dist(G, V)
    %outputs the node which is most central to the set of nodes given by V
    mindist = inf; %dummy value
    num = size(G.Nodes,1);
    for i=1:num
        dist = av_d(G, i, V);
        if dist < mindist
            mindist = dist;
            nd = i;
        end
    end
end