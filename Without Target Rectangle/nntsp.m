function [tot_cost, path1, path2] = nntsp(G,agnd, acttar, mode)
    %function to perform nearest neighbor
    %different modes are gives different ways to cluster/divide the targets
    %between the agents. In mode 0 it is not convinient to create cluster
    %beforehand so it is written differently than the other modes
    clus1 = []; clus2 = [];
    path1 = []; path2 = [];
    
    if mode == 1 %both agents covers according to nearest neighbor
        for targ = acttar
            [~, dis1] = shortestpath(G, agnd(1), targ);
            [~, dis2] = shortestpath(G, agnd(2), targ);
            if dis1 < dis2
                clus1 = [clus1 targ];
            else
                clus2 = [clus2 targ];
            end
        end
    elseif mode == 2
        clus1 = acttar;
    else
        clus2 = acttar;
    end
    tot_cost = 0;
    if mode ~= 0
    
        while size(clus1,2) ~= 0
            clt = cltar(G,agnd(1), clus1);
            [path, cost] = shortestpath(G,agnd(1),clt);
            agnd(1) = clt;
            tot_cost = tot_cost + cost;
            path1 = [path1 path];
            clus1(clus1 == clt) = [];
        end
    
        while size(clus2,2) ~= 0
            clt = cltar(G,agnd(2), clus2);
            [path, cost] = shortestpath(G,agnd(2),clt);
            agnd(2) = clt;
            tot_cost = tot_cost + cost;
            path2 = [path2 path];
            clus2(clus2 == clt) = [];
        end
    else
        while size(acttar,2) ~= 0
            acttemp = acttar;
            clt1 = cltar(G, agnd(1), acttemp);
            [path11, d11] = shortestpath(G,agnd(1),clt1);
            acttemp(acttemp == clt1) = [];
            if size(acttemp,2) ~= 0
                clt2 = cltar(G, agnd(2), acttemp);
                [path12,d12] = shortestpath(G,agnd(2),clt2);
            else
                d12 = 0;
                path12 = agnd(2);
            end
            sum1 = d11 + d12;
            
            acttemp = acttar;
            clt2 = cltar(G, agnd(2), acttemp);
            [path22, d22] = shortestpath(G, agnd(2), clt2);
            acttemp(acttemp==clt2) = [];
           
            if size(acttemp,2) ~= 0
                clt1 = cltar(G, agnd(1), acttemp);
                [path21, d21] = shortestpath(G, agnd(1),clt1);
            else
                d21 = 0;
                path21 = agnd(1);
            end
            sum2 = d21 + d22;
            
            if sum1 < sum2
                tot_cost = tot_cost + d11 + d12;
                path1 = path11; path2 = path12;
                agnd(1) = path11(end);
                agnd(2) = path12(end);
                acttar(acttar == agnd(1)) = [];
                acttar(acttar == agnd(2)) = [];
            else
                path1 = path21; path2 = path22;
                tot_cost = tot_cost + d21 + d22;
                agnd(1) = path21(end);
                agnd(2) = path22(end);
                acttar(acttar == agnd(1)) = [];
                acttar(acttar == agnd(2)) = [];
            end
        end

end