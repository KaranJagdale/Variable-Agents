env; %import environment
idx = kmeans(tar,2);
idxw = idx; %idxw used in routing w/o split and join
acttar = tar; %active target list
%finding most central point wrt targets
c_tar = zeros(n);
for i = 1:n
    for j = 1:n
        %c_tar(8-j,i) = central([i j],tar);
        c_tar(i,j) = central([i j],tar);
    end
end
[m,im] = min(c_tar);
%curtar = im;
[mm, imm] = min(m);

curtar = [im(imm), imm];
agloc = stloc;
if dist(curtar, agloc(1,:)) > dist(curtar, agloc(2,:))
    jtar = agloc(1,:);
    agmov = 2;
else
    jtar= agloc(2,:);
    agmov = 1;
end

traj = {};
traj{1} = []; traj{2} = [];
cost = 0; %this will account the cost incurred by the systems as the agent moves
idel = [];
while ~(agloc(agmov,1) == jtar(1) && agloc(agmov,2) == jtar(2))
    act = con(agloc(agmov,:), jtar);
    agloc(agmov,:) = dyn(agloc(agmov,:),act);
    for i=1:size(acttar,1)
        if agloc(agmov,1)==acttar(i,1) && agloc(agmov,2) == acttar(i,2)
            idel = [idel i];
        end 
    end

    %disp(agloc(agmov,:))
    cost = cost + 1;
end
idel = sort(idel, "descend");
for i=1:size(idel)
    acttar(idel(i),:) = [];
    idx(idel(i)) = [];
end
%Now the agents will join

agloc = agloc(agmov,:);
disp('meeting point')
disp(agloc)
%Now this joined agent will move to curtar
idel = [];
while ~(agloc(1) == curtar(1) && agloc(2) == curtar(2))
    act = con(agloc, curtar);
    agloc = dyn(agloc, act);
    %disp(agloc)
    nacttar = size(acttar,1);
    disp(nacttar)
    disp(acttar)
    for i=1:nacttar
        if agloc(1)==acttar(i,1) && agloc(2) == acttar(i,2)
            idel = [idel i];
        end 
    end
    cost = cost + 1;
end
%deleting (5,3) and (5,6)
%disp(cost)
% disp(idel)
% disp(acttar)
idel = sort(idel, "descend");
for i=1:size(idel,2)
    acttar(idel(i),:) = [];
    idx(idel(i)) = [];
end
%disp(acttar)
%Here the agent will separate
agloc = [agloc;agloc];
it1 = [];
it2 = [];
for i=1:size(acttar,1)
    if idx(i) == 1
        it1 = [it1 i];
    else
        it2 = [it2 i];
    end
end
% it1 = [3, 4, 7, 8];
% it2 = [1, 2, 5, 6, 9];
it1_l = it1;

while size(it1_l,2) ~=0
    tdist = [];
    %disp(it1_l)
    for j = 1:size(it1_l,2)
        d = dis(agloc(1,:), acttar(it1_l(j),:));       
        tdist = [tdist d];
    end
    [mc,ic] = min(tdist);
    if agloc(1,1) == acttar(it1_l(ic),1) && agloc(1,2) == acttar(it1_l(ic),2)
        disp('danger')
    end
    pcost = pathcost(agloc(1,:), acttar(it1_l(ic),:),acttar);
    cost = cost + pcost{1};
    agloc(1,:) =  acttar(it1_l(ic),:);
    idel = pcost{2};
    it1_l(ic) = [];
    for id=idel
        it1_l(it1_l == id) = [];
    end      
end

it2_l = it2;
while size(it2_l,2) ~=0
    tdist = [];
    for j = 1:size(it2_l,2)
        tdist = [tdist dis(agloc(2,:), acttar(it2_l(j),:))];
    end
    [mc,ic] = min(tdist);
    disp('agloc')
    disp(agloc(2,:))

    disp('target')
    disp(acttar(it2_l(ic),:))

    pcost = pathcost(agloc(2,:),acttar(it2_l(ic),:),acttar);
    cost = cost + pcost{1};
    
    agloc(2,:) = acttar(it2(ic),:);
    idel = pcost{2};
    it2_l(ic) = [];
    for id=idel
        it2_l(it2_l == id) = [];
    end 
end

% figure(1)
% plot(tar(idx==1,1),tar(idx==1,2),'r.','MarkerSize',12)
% hold on
% plot(tar(idx==2,1),tar(idx==2,2),'b.','MarkerSize',12)

%Now implementing the routing without split and join

aglocw = stloc;

itw1 = [];
itw2 = [];
for i=1:size(tar,1)
    if idxw(i) == 1
        itw1 = [itw1 i];
    else
        itw2 = [itw2 i];
    end
end


itw1_l = itw1;
costw = 0;
l_ag1w = aglocw(1,:);
while size(itw1_l,2) ~=0
    tdist = [];
    %disp(it1_l)
    for j = 1:size(itw1_l,2)
        d = dis(aglocw(1,:), tar(itw1_l(j),:));
        
        tdist = [tdist d];
    end
    [mc,ic] = min(tdist);
    if aglocw(1,1) == tar(itw1_l(ic),1) && aglocw(1,2) == tar(itw1_l(ic),2)
        disp('danger')
    end
    pcost = pathcost(aglocw(1,:), tar(itw1_l(ic),:),tar);
    l_ag1w = [l_ag1w;pcost{3}];
    costw = costw + pcost{1};
    aglocw(1,:) =  tar(itw1_l(ic),:);
    idel = pcost{2};
    itw1_l(ic) = [];
    for id=idel
        itw1_l(itw1_l == id) = [];
    end
      
end

itw2_l = itw2;

while size(itw2_l,2) ~=0
    tdist = [];
    %disp(it1_l)
    for j = 1:size(itw2_l,2)
        d = dis(aglocw(2,:), tar(itw2_l(j),:));
        
        tdist = [tdist d];
    end
    [mc,ic] = min(tdist);
    if aglocw(2,1) == tar(itw2_l(ic),1) && aglocw(2,2) == tar(itw2_l(ic),2)
        disp('danger')
    end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    pcost = pathcost(aglocw(2,:), tar(itw2_l(ic),:),tar);
    costw = costw + pcost{1};
    aglocw(2,:) =  tar(itw2_l(ic),:);
    idel = pcost{2};
    itw2_l(ic) = [];
    for id=idel
        itw2_l(itw2_l == id) = [];
    end
      
end

plot(l_ag1w(:,1),l_ag1w(:,2))

box off

