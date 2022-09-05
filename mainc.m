env2
s = eg(:,1); t = eg(:,2);


G = graph(s,t,wt,nn);
figure(2)
H = plot(G,'EdgeLabel', G.Edges.Weight);
stnd = [1 2];

highlight(H,tar,'Nodecolor','red','LineWidth',2)
%%

acttar = tar;
agnd= stnd;
joined = false; %initially the agents are separated
gamma = 1; %a parameter in deciding the feasibility of join
ag1pth = agnd(1); ag2pth = agnd(2);
tot_cost = 0;
loopcn = 0;
exec = '';
allowjn = true;
while size(acttar,2) ~= 0 
    loopcn = loopcn + 1;
    if joined
        %clt = cltar(G,agnd(1),acttar);
        %will find optimal splitting location      
        stbsp = 0; %steps before split        
        mincost = inf; %dummy value
        
        while true
            
            acttemp = acttar;
            agndtemp = agnd;
            costtemp = 0;
            for i=1:stbsp
                if size(acttemp,2) == 0
                    break
                end                
                clt = cltar(G,agndtemp(1),acttemp);                
                [path, ~] = shortestpath(G,agndtemp(1),clt);
                costtemp = costtemp + edgewt(eg, wt, agndtemp(1),path(2));
                agndtemp(1) = path(2);
                agndtemp(2) = agndtemp(1);
                if agndtemp(1) == clt
                    acttemp(acttemp == agndtemp(1)) = [];
                end
            end

            if size(acttemp,2)~=0
                
               
                [spcost, p1, p2] = nntsp(G, agndtemp, acttemp, 0);
%                 if loopcn == 2 && stbsp == 3
%                     disp(costtemp)
%                     disp(spcost)
%                 end
                costtemp = costtemp + spcost;
            end
           % disp(loopcn)
            if (loopcn == 2) && (stbsp == 1 || stbsp == 2 || stbsp == 3 || stbsp == 8)
                disp('stbsp')
                disp(stbsp)
                disp(acttemp)
                disp(agndtemp)
                fprintf('costtemp : %f \n',costtemp)
                fprintf('spcost : %f \n', spcost)
                fprintf('mincost : %f \n', mincost)
                disp('p1')
                disp(p1)
                disp('p2')
                disp(p2)
                disp('')
            end
            if costtemp < mincost
                mincost = costtemp; 
                stbspopt = stbsp;
            end
            if size(acttemp,2) == 0
                break
            end
            stbsp = stbsp + 1;
        end

        %now implementing the optimal split 
        for i = 1:stbspopt
            clt = cltar(G,agnd(1),acttar);
            [path, ~] = shortestpath(G,agnd(1),clt);
            tot_cost = tot_cost + edgewt(eg, wt, agnd(1), path(2));
            agnd(1) = path(2);
            agnd(2) = agnd(1);
            ag1pth = [ag1pth agnd(1)];
            ag2pth = [ag2pth agnd(2)];
            if agnd(1) == clt
                acttar(acttar == agnd(1)) = [];
            end
        end

        
        joined = false;
        allowjn = false;

        exec = "split at node: " + int2str(agnd(2));

      
    else
        av_arr = av_d_arr(G, agnd);
        minval = min(av_arr);
        mindis = inf;
        for i=1:size(av_arr,2)
            if av_arr(i) == minval
                clt = cltar(G, i, acttar);
                [~, dist] = shortestpath(G, i, clt);
                if dist < mindis
                    mindis = dist;
                    bestjn = i;
                end
            end
        end
        ndcl_tar = cltar(G, bestjn, acttar);
        [~,ndcen_tar] = shortestpath(G, bestjn, ndcl_tar);
        [~, agdis] = shortestpath(G, agnd(1), agnd(2));
        if size(acttar,2) > 1
            splitbn = true;
        else
            splitbn = false; %as no point in splitting if the remaining targets are less than 1
        end

        if loopcn == 1
            disp(agdis)
            disp(gamma*ndcen_tar)
            disp(splitbn)
            disp(allowjn)
        end
        if agdis < gamma*ndcen_tar && splitbn && allowjn
            [path1, ag1dis] = shortestpath(G,agnd(1),bestjn);
            [path2, ag2dis] = shortestpath(G,agnd(2),bestjn);
            ag1pth = [ag1pth path1(2:end)];
            ag2pth = [ag2pth path2(2:end)];
            agnd(1) = ag1pth(end); agnd(2) = ag2pth(end);
            tot_cost = tot_cost + ag1dis + ag2dis;
            joined = true;
            exec = "joined at node : " + int2str(bestjn);
            %ideally delete the target in the acttar if the agent covered
            %it while coming to joining location
        elseif size(acttar,2) == 1
            [path1, ag1dis] = shortestpath(G, agnd(1), acttar(1));
            [path2, ag2dis] = shortestpath(G, agnd(2), acttar(1));
            if ag2dis > ag1dis
                ag1pth = [ag1pth path1(2:end)];
                tot_cost = tot_cost + ag1dis;
                agproc = 1;
            else
                ag2pth = [ag2pth path2(2:end)];
                tot_cost = tot_cost + ag2dis;
                agproc = 2;
            end
            exec = "last taget so proceeded with agent : " + int2str(agproc);
            acttar = [];
        else
            allowjn = true;
            %ci : path lengths obtained with mode i
            c = zeros(1,3);
            c(1) = nntsp(G, agnd, acttar, 0);
            c(2) = nntsp(G, agnd, acttar, 2);
            c(3) = nntsp(G, agnd, acttar, 3);

            [~, im] = min(c);
            if im==1
                nextnd = bestnext(G, acttar, agnd);
                if agnd(1) ==9 && agnd(2) == 9
                    disp('nextnd')
                    disp(nextnd)
                end
                cost1 = edgewt(eg, wt, nextnd(1), agnd(1));
                cost2 = edgewt(eg, wt, nextnd(2), agnd(2));
                %cost update
                tot_cost = tot_cost + cost1 + cost2;
                %agent location update
                agnd(1) = nextnd(1);
                agnd(2) = nextnd(2);
%                 if loopcn == 1
%                     disp(path1)
%                     disp(path2)
%                 end
                ag1pth = [ag1pth agnd(1)];
                ag2pth = [ag2pth agnd(2)];
                if ag1pth(size(ag1pth,2)-1) == 9
                    disp('agpths')
                    disp(ag1pth)
                    disp(ag2pth)
                end
                %Delete the targets if the agents have covered them
                idel = [];
                for i=1:size(acttar,2)
                    if acttar(i) == agnd(1) || acttar(i) == agnd(2)
                        idel = [idel i];
                    end
                end
                idel = sort(idel,'descend');
                for del_e=idel
                    acttar(del_e) = [];
                end
                exec = "proceeded with both agents";
            elseif im == 2
                clt1 = cltar(G, agnd(1), acttar);
                [path1, ag1dis] = shortestpath(G, agnd(1), clt1);
                cost1 = edgewt(eg, wt, path1(2),agnd(1));
                %update cost
                tot_cost = tot_cost + cost1;
                %update agent location
                agnd(1) = path1(2);
                ag1pth = [ag1pth agnd(1)];
                %delete the targets if the agent have covered them
                %idel = [];
                for i=1:size(acttar,2)
                    if acttar(i) == agnd(1)
                        acttar(i) = [];
                        break
                    end
                end
                exec = "proceeded with only agent : " + int2str(1);

            else
                clt2 = cltar(G, agnd(2), acttar);
                [path2, ag2dis] = shortestpath(G, agnd(2), clt2);
                cost2 = edgewt(eg, wt, path2(2), agnd(2));
                %update cost
                tot_cost = tot_cost + cost2;
                %update agent location
                agnd(2) = path2(2);
                ag2pth = [ag2pth agnd(2)];
                %delete targets if the agent have coveed them
                for i=1:size(acttar,2)
                    if acttar(i) == agnd(2)
                        acttar(i) = [];
                        break
                    end
                end
                exec = "proceeded with only agent : " + int2str(2);
            end
        end
    end
%     if loopcn < 20
%         fprintf('agent 1 node : %i \n', agnd(1))
%         fprintf('agent 2 node : %i \n', agnd(2))
%         fprintf('Joined : %i \n', joined)
%     end
%     if loopcn > 20
%         break
%     end
%     disp(loopcn)
%     disp(exec)
%     disp('ag1pth')
%     disp(ag1pth)
%     disp('ag2pth')
%     disp(ag2pth)
end
s1 = ag1pth(1:size(ag1pth,2)-1);
t1 = zeros(1,size(ag1pth,2)-1); 
for i = 1: size(ag1pth,2)-1
    t1(i) = ag1pth(i+1);
end

s2 = ag2pth(1:size(ag2pth,2)-1);
t2 = zeros(1,size(ag2pth,2)-1);
for i = 1: size(ag2pth,2)-1
    t2(i) = ag2pth(i+1);
end

highlight(H,s1,t1,"EdgeColor","green",'LineWidth',2.5)
highlight(H, s2, t2, "EdgeColor","black",'LineWidth',2.5)

 
            







