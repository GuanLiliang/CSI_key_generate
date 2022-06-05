% according sample of alice and bob to get keys
function ret = generate_key(a, b)
    qa = threshold(a);
    list_one = seq(a, qa);
    if (list_one(1) == 0)
        ret = -1;
        return;
    end
    qb = threshold(b);
    list_two = seq(a, qb);
    if (list_two(1) == 0)
        ret = -1;
        return;
    end
    for i = 1: size(list_one,2)
        pos = list_one(i);
        rss = a(pos);
        flag = quant(rss, qa);
        if (flag == 1)
            ret(1, i) = 1;
        else 
            ret(1, i) = 0;
        end
    end
    for i = 1: size(list_two, 2)
        pos = list_two(i);
        rss = b(pos);
        flag = quant(rss, qb);
        if (flag == 1)
            ret(2, i) = 1;
        else 
            ret(2, i) = 0;
        end
    end
end