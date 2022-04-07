function ret = compare(a,b)
    k = 0;
    num = min(size(a, 2), size(b, 2));
    for i = 1:num
        if (a(i) == b(i))
            k = k + 1;
        end
    end
    ret = k /num;
end
