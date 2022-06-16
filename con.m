function act = con(loc, tar)
    %act = 1: west, 2:North, 3: east, 4: south
    if loc(1)>tar(1)
        act = 2;
    elseif loc(1)<tar(1)
        act = 4;
    else
        if loc(2) > tar(2)
            act = 1;
        else
            act = 3;
        end
    end
end