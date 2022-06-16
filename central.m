function cen = central(x, V)
    %x is the point whose centrality is being calculated wrt the vertices
    %in V
    tdist = 0;
    for i  = 1:size(V,1)
        tdist = tdist + dis(x,[V(i,1) V(i,2)]);
    end
    
    cen = tdist/size(V,1);
    %disp(cen)

end