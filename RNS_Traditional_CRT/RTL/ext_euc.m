% for calculation of modulo inverses using Extended Euclidean Algorithm for
% given moduli set

n = 4;
m = [32, 31, 21, 5]
Q = ones(n,1);

% open file
filename = ['mod_inv_coeff_' strrep(num2str(m(:)'), '  ', '_') '.txt'];
fileID = fopen(filename, "w");

% number who's modulo inverse is to be calculated
for i=1:n
    for j=1:n
        if i~=j
            Q(i) = Q(i)*m(j);
        end
    end
    A(i) = extended_euclid(Q(i), m(i))
end
dec2bin(A)

% write to file
for i=1:n
    fprintf(fileID, "%s", dec2bin(A));
end
fclose(fileID);

% function for finding modulo inverse of a number using extended euclidean
% algorithm
function [x,y,d]=extended_euclid(a,b)
    if b==0
        x=1;
        y=0;
        d=a;
        return;
    end
    [x1,y1,d1]=extended_euclid(b,mod(a,b));  

    x=y1;
    y=x1-floor(a/b)*y1;
    d=d1;

end 