file_alice = "512alice.csv";
file_bob = "512bob_csi.csv";
csi_alice_first = readmatrix(file_alice);
csi_bob_first = readmatrix(file_bob);


x = 1:56;
y = 1:(length(csi_bob_first(1,:))+30);
length(x)
length(y)
% [X,Y]=meshgrid(x,y);
z = csi_alice_first(x, y);
% surf(x,y,z)
mesh(y,x,z);
%title('alice csi');
ylabel('子载波');
xlabel('packet');

