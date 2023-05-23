% for generating LUT for moduli who's period is not usable for given input
% size

n_bits = 16; % max input bits
max_n = 2^n_bits -1; % max value of input
m = 143; % moduli value
size = 496; % value till which LUT is to be generated

% open file
filename = ['LUT_mod_' num2str(m) '.txt'];
fileID = fopen(filename, 'w');

% calculate size of module for LUT size
size_bits = ceil(log2(m+1))
LUT_size = (size-m+1)*size_bits

% find mod and write to file
for i = m:size
    n = mod(i,m);
    n_bin = dec2bin(n,size_bits);
    fprintf(fileID, "%s", n_bin);
end