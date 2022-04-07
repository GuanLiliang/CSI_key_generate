function ret = quant(rss, q)
    qh = q(1);
    ql = q(2);
    if (rss > qh) 
        ret = 1;
    elseif(rss < ql)
        ret = -1;
    else 
        ret = 0;
    end
end