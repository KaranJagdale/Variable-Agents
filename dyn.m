function nloc = dyn(loc,act)
    nloc = loc;
    if act == 1
        nloc(2) = nloc(2)-1;
    elseif act == 2
        nloc(1) = nloc(1) - 1;
    elseif act == 3
        nloc(2) = nloc(2) + 1;
    else
        nloc(1) = nloc(1) + 1;
    end
end