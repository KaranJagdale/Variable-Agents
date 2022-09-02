function arr = av_d_arr(G, V)
%gives average distance array from all nodes to the nodes given by V
    nodes = size(G.Nodes,1);
    arr = zeros(1,nodes);

    for i=1:nodes
        dist = av_d(G,i,V);
        arr(i) = dist;
    end
end
