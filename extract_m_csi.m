% extract specfic subcarrier csi sample
function ret = extract_m_csi(csi, index)
    ret = csi(index,:);
end