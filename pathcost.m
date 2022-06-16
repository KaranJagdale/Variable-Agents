function pcost = pathcost(sloc,eloc, acttar)
    pcost = {};
    pcost{1} = 0;
    pcost{2} = [];
    pcost{3} = sloc;
    while ~(sloc(1) == eloc(1) && sloc(2) == eloc(2))
        act = con(sloc, eloc);
        sloc = dyn(sloc, act);
        
        for i=1:size(acttar,1)
            if sloc(1)==acttar(i,1) && sloc(2) == acttar(i,2)
                pcost{2} = [pcost{2} i];
            end 
        end
        pcost{1} = pcost{1} + 1;
        pcost{3} = [pcost{3};sloc];
    end
    %disp(pcost)
end