n_bits = 16;
max_n = 2^n_bits -1;
m = 143;
% mention for generating LUT without period
%size = 496;

% open file
filename = ['LUT_mod_' num2str(m) '.txt'];
fileID = fopen(filename, 'w');

% find half-period
flag = 0;
for j=1:n_bits*2
    res = mod(2^j,m);
    if(res == m-1 && flag==0)
        flag = j
    elseif (res == 1)
        half_period = j - flag
        break
    elseif (j==n_bits*2)
        disp('Half-period does not exist within the required range');
        half_period = 0;
    end
end

% If half-period exists
if half_period ~=0 && half_period+1 < n_bits 
    %find number of bits required to pad
    rem_max_n = mod(n_bits,half_period)
    max_bin = dec2bin(2^n_bits-1, n_bits + mod(half_period-rem_max_n,half_period))
    max_bin(1: half_period) = dec2bin(2^half_period-1)
    no_of_g = ceil(n_bits/half_period)
    
    g = zeros(1,no_of_g);
    sum = 0;
    % find reduced sum
    for k=1:no_of_g
        str_val = max_bin((k-1)*half_period+1: k*half_period);
        g(k) = bin2dec(str_val);
        sum = sum+g(k);
    end
    % add correction value
    sum = sum + 2*floor(no_of_g/2)
    % find number of bits required to store reduced value
    bits = ceil(log2(no_of_g+1));
    
    temp_size = half_period+bits
    % repeat procedure
    if(temp_size > half_period+1)
        sum_bits = ceil(log2(sum+1))
        rem_sum_n = mod(sum_bits,half_period)
        sum_bin = dec2bin(2^sum_bits-1, sum_bits + mod(half_period-rem_sum_n,half_period))
        no_of_g1 = ceil(sum_bits/half_period)
        sum_bin(1: half_period) = dec2bin(2^half_period-1)
        
        g1 = zeros(1,no_of_g1);
        new_sum = 0;
        for k=1:no_of_g1
            str_val = sum_bin((k-1)*half_period+1: k*half_period);
            g1(k) = bin2dec(str_val);
            new_sum = new_sum+g1(k);
        end

        new_sum = new_sum + 2*floor(no_of_g1/2)
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