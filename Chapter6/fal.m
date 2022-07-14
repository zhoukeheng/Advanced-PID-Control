function ret = fal(expc, alfa, delta)
    if abs(expc) > delta
        ret = abs(expc)^alfa * sign(expc);
    else
        ret = expc / (delta ^ (1 - alfa));
    end
end