% Script for writing LUT file for given module for period based residue 
% generator
n_bits = 16; % max input bits
max_n = 2^n_bits -1; % max value of input
m = 105; % moduli value
size = 431; % value till which LUT is to be generated

% open file
filename = ['LUT_mod_' num2str(m) '.txt'];
fileID = fopen(filename, 'w');

% find period
for j=1:n_bits*2
    res = mod(2^j,m);
    if(res == 1)
        period = j
        break
    elseif (j==n_bits*2)
        disp('Period does not exist within the required range');
        period = 0;
    end
end

% If period exists
if period ~=0 && period+1 < n_bits 
    %find number of bits required to pad
    rem_max_n = mod(n_bits,period)
    max_bin = dec2bin(max_n, n_bits + period-rem_max_n)
    
    no_of_g = ceil(n_bits/period)
    g = zeros(1,no_of_g);
    sum = 0;
    % find reduced sum
    for k=1:no_of_g
        str_val = max_bin((k-1)*period+1: k*period);
        g(k) = bin2dec(str_val);
        sum = sum+g(k);
    end
    % find number of bits required to store reduced value
    bits = ceil(log2(no_of_g+1));
    
    temp_size = period+bits
    % repeat procedure
    if(temp_size > period+1)
        sum_bits = ceil(log2(sum+1))
        rem_sum_n = mod(sum_bits,period)
        sum_bin = dec2bin(2^sum_bits-1, sum_bits + period-rem_sum_n)
        no_of_g = ceil(sum_bits/period)
        g1 = zeros(1,no_of_g);
        new_sum = 0;
        for k=1:no_of_g
            str_val = sum_bin((k-1)*period+1: k*period);
            g1(k) = bin2dec(str_val);
            new_sum = new_sum+g1(k);
        end
        size = new_sum
    else
        size = sum;
    end
    % check if LUT is needed after reduction of number
    if size > m
        size_bits = ceil(log2(m+1))
        LUT_size = (size-m+1)*size_bits
        for i = m:size
            n = mod(i,m);
            n_bin = dec2bin(n,size_bits);
            fprintf(fileID, "%s", n_bin);
        end
    else
        fprintf("LUT not needed\n");
    end
    
else
    size_bits = ceil(log2(m+1))
    LUT_size = (size-m+1)*size_bits

    for i = m:size
        n = mod(i,m);
        n_bin = dec2bin(n,size_bits);
        fprintf(fileID, "%s", n_bin);
    end
end


fclose(fileID);