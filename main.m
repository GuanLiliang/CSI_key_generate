global m;
m = 1;

pwd

file_alice = "alice_csi.txt";
file_bob = "bob_csi.txt";
csi_alice = readmatrix(file_alice);
csi_bob= readmatrix(file_bob);

gap = 4;
key = [0;0];

for index = 20:30
    ret = [0;0];
    % cor = correlation(csi_alice_first(index,:), csi_bob_first(index, :), 200, index);
    % if (cor < 0)
    %     csi_alice = csi_alice_first(:, abs(cor):end);
    %     csi_bob = csi_bob_first(:,:);
    % else 
    %     csi_alice = csi_alice_first(:, :);
    %     csi_bob = csi_bob_first(:, abs(cor): end);
    % end
    alice = extract_m_csi(csi_alice, index);
    bob = extract_m_csi(csi_bob, index);
    num_one = floor(size(alice, 2) / gap);
    num_two = floor(size(bob, 2) / gap);
    num = min(num_one, num_two);
    for i = 1:num  
        sindex = (i - 1) * gap + 1;
        eindex = sindex + gap - 1;
        % generate_key(alice(sindex, eindex));
        % generate_key(bob(sindex, eindex));
        generate_key(alice(sindex: eindex), bob(sindex: eindex))
        if (ans ~= -1)
            ret = [ret ans];
        end
    end
    key = [key ret];
end

temp = compare(key(1,:), key(2, :))

key_alice = key(1,:);
key_bob = key(2, :);
num1 = 0;
for i = 1:length(key_alice)
    if (key_alice(i) == 1)
        num1 = num1 + 1;
    end
end
num1

num2 = 0;
for i = 1:length(key_bob)
    if (key_bob(i) == 1)
        num2 = num2 + 1;
    end
end
num2

fa = fopen('key/alice', 'wb');
fb = fopen('key/bob', 'wb');
fwrite(fa, key_alice);
fwrite(fb, key_bob);

fclose(fa);
fclose(fb);