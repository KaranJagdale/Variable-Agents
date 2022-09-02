eg = [1 3; 2 3; 3 4; 3 5 ; 5 6; 5 9; 5 10; 6 7; 6 8; 8 9; 9 10; 9 11];
s = eg(:,1); t = eg(:,2);
wt = [1 1 1 3 2 1 1.5 1 1 1 1 1];
nn = {'n1', 'n2', 'n3', 'n4', 'n5', 'n6', 'n7', 'n8', 'n9', 'n10', 'n11'};
G = graph(s,t,wt);%,nn);

H = plot(G,'EdgeLabel', G.Edges.Weight);
highlight(H,[6 7 10 11],'Nodecolor','red')