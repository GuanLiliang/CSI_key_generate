% Xianjun Jiao. xianjun.jiao@imec.be; putaoshu@msn.com

clear all;
close all;

num_eq = 8;

a = load('data/512bob_csi.txt');
len_a = floor(length(a)/4)*4;
a = a(1:len_a);

b = reshape(a, [4, length(a)/4])';
num_data_in_each_side_info = 2+56+num_eq*52;
num_side_info = floor(size(b,1)/num_data_in_each_side_info);

side_info = zeros(num_data_in_each_side_info, num_side_info);
timestamp = zeros(1, num_side_info);
freq_offset = zeros(1, num_side_info);
csi = zeros(56, num_side_info);
equalizer = zeros(num_eq*52, num_side_info);
save = zeros(60, num_side_info);
for i=1:num_side_info
    sp = (i-1)*num_data_in_each_side_info + 1;
    ep = i*num_data_in_each_side_info;
    timestamp(i) = b(sp,1) + (2^16)*b(sp,2) + (2^32)*b(sp,3) + (2^48)*b(sp,4);
    min = fix(fix(timestamp(i) / 1000000) / 60);
    save(1, i) = fix(min / 60);% hour
    save(2, i) = mod(min, 60);% min
    save(3, i) = mod(fix(timestamp(i)/1000000), 60);% sec
    save(4, i) = mod(timestamp(i), 1000000);% usec
    freq_offset(i) = (20e6*b(sp+1,1)/512)/(2*pi);
    side_info(:,i) = b(sp:ep,1) + 1i.*b(sp:ep,2);
    save(5:60, i) = side_info(3:58, i);
    csi(:,i) = side_info(3:58,i);
    equalizer(:,i) = side_info(59:end,i);
end

% csi = [csi(29:end,:); csi(1:28,:)];
save(5:60, :) = [save(33:end,:); save(5:32,:)];
% csi = abs(csi);
% csi = real(csi);
% save = real(save);
writematrix(abs(save'), '512bob_abs.txt');
equalizer = equalizer(:);
equalizer(equalizer == 32767+1i*32767) = NaN;

% subplot(2,1,1); plot(abs(csi)); title('CSI'); ylabel('abs'); grid on;
% subplot(2,1,2); plot(angle(csi)); ylabel('phase'); xlabel('subcarrier'); grid on;

%if ~isempty(equalizer)
%    scatterplot(equalizer); grid on;
%end

% figure; plot(timestamp); title('time stamp (TSF value)'); ylabel('us'); xlabel('packet');  grid on;
% figure; plot(freq_offset); title('freq offset (Hz)'); ylabel('Hz'); xlabel('packet'); grid on;

% csi_1 = readmatrix('alice0408.csv');