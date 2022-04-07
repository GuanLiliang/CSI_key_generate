function ret = correlation(a, b, num, sub_index)
    [r, lags] = xcorr(a, b, num);
    [number, index] = max(r);
    ret = lags(index);
    pca = plot(lags,r);
    pic_name = "image/pic"+ num2str(sub_index) +".png";
    saveas(pca, pic_name);
end
