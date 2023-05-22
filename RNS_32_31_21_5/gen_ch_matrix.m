%% Code to generate the characteristic matrix for a given moduli set based 
% on the new Chinese Remainder Theorem I given by Wang (2000)

% Specify number of moduli and the moduli to be used in n-mod and P
% respectively
clear

n_mod = 4;
P= [32, 31, 21, 5];

% This generates a file with the moduli in the filename 
filename = ['ch_mat_coeff_' strrep(num2str(P(:)'), '  ', '_') '.txt'];
fileID = fopen(filename, "w");

M_prod = 1;
for j = 1:n_mod
    M_prod = M_prod*P(j);
end

M = M_prod;
A = 1;
for i = 1:n_mod-1
    A = A*P(i);
    M = M/P(i);
    k(i) = modInv(A,M);
end

M = M_prod;
for i = 1:n_mod
    if i==1
        a(i) = mod(1-k(i)*P(i), M);
    elseif (i==n_mod)
        a(i) = mod(k(n_mod - 1), M);
    else
        a(i) = mod(k(i-1) - k(i)*P(i), M);
    end
    M = M/P(i);
end

% Construct the characteristic matrix for the given moduli set
A_T = zeros(n_mod, n_mod);

for i = 1:n_mod
    x = zeros(1,n_mod);
    for j = i:n_mod
       x(j) = mod(a(i),P(j));
    end
    for j = i:n_mod
        if j==i
            A_T(i,j) = x(j);
        else
            inv_p = modInv(P(i),P(j));
            temp = (x(j)- A_T(i,i))*inv_p;
            temp_A_T = mod(temp, P(j));
            for k=i+2:j
                inv_p = modInv(P(k-1),P(j));
                temp = (temp-A_T(i,k-1))*inv_p;
                temp_A_T = mod(temp, P(j));
            end
            A_T(i,j) = temp_A_T;
        end
    end
end

A_ch_mat = A_T.'
mat_bits = ceil(log2(max(A_ch_mat,[],'all')+1)) 
P_max = (P-1).'
max_B = A_ch_mat*P_max


P_prod = 1;
max_Y = 0;
for i=1:n_mod
    P_prod = P_prod*P(i);
end

for i=1:n_mod-1
    P_prod = P_prod/P(i)
    if P_prod < max_B(i+1)
        fprintf("Need modulo for %d upto %d\n", P_prod, max_B(i+1))
    end
end

% The coefficients are written into the file into a single line with each
% coefficient being mat_bits long
for i=1:n_mod
    for j=1:n_mod
        A_bin = dec2bin(A_ch_mat(i,j),mat_bits);
        fprintf(fileID, "%s", A_bin);
    end
end
fclose(fileID);


%% function for generating the modulo inverse of A wrt mod M
function [ModMultInv] = modInv(A, M)
    [G, C, ~] = gcd(A,M);
    if G==1  % The inverse of a(mod b) exists only if gcd(a,b)=1
        ModMultInv = mod(C,M);
    else 
        disp('Modular multiplicative inverse does not exist for these values');
    end
end