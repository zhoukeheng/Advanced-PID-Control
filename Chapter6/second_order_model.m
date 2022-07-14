function dx = second_order_model(t, x, flag, p1, p2)
    ut = p1;
    dx = zeros(2, 1);
    dx(1) = x(2);
    dx(2) = -25 * x(2) + 133 * ut;
end