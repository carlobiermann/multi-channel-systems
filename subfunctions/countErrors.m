function [nErr, idx, ber] = countErrors(x,bits)

nErr=sum(x~=bits);
k=x+bits;
idx=find(k==1);
ber=(nErr/length(bits));

end