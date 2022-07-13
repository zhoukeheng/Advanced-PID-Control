function ret = fst(x1, x2, delta, h)
    % Delta is coefficient to decide follow ratio
    % h is sampling ratio

    d = delta * h;
    d0 = h * d;
    y = x1 + h * x2;
    a0 = sqrt(d * d + 8 * delta * abs(y));

    if (abs(y) > d0)
       a = x2 + (a0 - d)/2 * sign(y);
    else
       a = x2 + y/h;
    end

    if (abs(a) > d)
        ret = -delta * sign(a);
    else
        ret = -delta * a / d;
    end
end