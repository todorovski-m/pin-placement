function s = sprintz(z, fmt)
if nargin == 1
    fmt = '%.4f';
end
r = real(z);
x = imag(z);
znak = '';
if x >= 0
    znak = '+';
end
s = [sprintf(fmt,r) znak sprintf(fmt,x) 'j'];