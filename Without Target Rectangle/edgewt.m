function egwt = edgewt(eg, wt, n1, n2)
%returns weight of edge between n1 and n2
    for i=1:size(eg,1)
        if eg(i,1) == n1 && eg(i,2) == n2 || eg(i,1) == n2 && eg(i,2) == n1
            egwt = wt(i);
        end
    end

end