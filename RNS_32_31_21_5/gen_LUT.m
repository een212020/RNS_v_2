n_bits = 16;
max_n = 2^n_bits -1;
m = 105;
size = 431;

filename = ['LUT_mod_' num2str(m) '.txt'];
fileID = fopen(filename, 'w');

size_bits = ceil(log2(m+1))
LUT_size = (size-m+1)*size_bits

for i = m:size
    n = mod(i,m);
    n_bin = dec2bin(n,size_bits);
    fprintf(fileID, "%s", n_bin);
end