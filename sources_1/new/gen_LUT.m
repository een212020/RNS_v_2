n_bits = 9;
max_n = 2^n_bits -1;
m = 105;
size = 431;

filename = ['LUT_mod_' num2str(m) '.txt'];
fileID = fopen(filename, 'w');

% find period
for j=1:n_bits*2
    res = mod(2^j,m);
    if(res == 1)
        period = j
        break
    elseif (j==n_bits*2)
        disp('Period does not exist');
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
    for k=1:no_of_g
        str_val = max_bin((k-1)*period+1: k*period);
        g(k) = bin2dec(str_val);
        sum = sum+g(k);
    end
    
    bits = ceil(log2(no_of_g+1));
    
    temp_size = period+bits
    
    if(temp_size > period+1)
        sum_bits = ceil(log2(sum+1))
        rem_sum_n = mod(sum_bits,period)
        sum_bin = dec2bin(max_n, sum_bits + period-rem_sum_n)
        no_of_g = ceil(sum_bits/period)
        g = zeros(1,no_of_g);
        new_sum = 0;
        for k=1:no_of_g
            str_val = sum_bin((k-1)*period+1: k*period);
            g(k) = bin2dec(str_val);
            new_sum = new_sum+g(k);
        end
        size = new_sum
    else
        size = sum;
    end
    
    size_bits = ceil(log2(m+1));
    LUT_size = (size-m+1)*size_bits
    
    for i = m:size
        n = mod(i,m);
        n_bin = dec2bin(n,size_bits);
        fprintf(fileID, "%s", n_bin);
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