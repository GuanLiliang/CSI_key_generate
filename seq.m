% get 0 and 1 from csi , qa/qb
function ret = seq(sample, q)
    global m;
    ret(1) = 0;
    k = 1;
    j = 0;
    flag = 0;
    rss = 0;
    len = size(sample, 2);
    i = 1;
    while (i <= len -m + 1)
        rss = sample(i);
        flag = quant(rss, q);
        if (flag == 0) 
            i = i + 1;
            continue;
        end
        j = 1;
        while (j < m)
            rss = sample(i + j)
            if (flag ~= quant(rss, q))
                break;
            end
            j = j + 1;
        end
        if (j == m) 
            ret(k) = i;
            k = k + 1;
            i = i + m;
        else 
            i = i + 1;
        end
    end
end