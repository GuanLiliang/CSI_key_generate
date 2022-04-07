% get q+ and q-
function ret = threshold(a)
    alpha = 0.5;
    m = mean(a);
    s = std(a);
    ret(1) = m + s * alpha;
    ret(2) = m - s * alpha;
end