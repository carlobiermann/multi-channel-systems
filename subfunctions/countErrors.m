function [nErr, idx, ber]=countErrors(x,bits)

% Vergleich zwischen generierten Sendebits und dem Gedemappten Empfangsbits, Summe der ungleichen Bits 
nErr=sum(x~=bits);

% vektorielle Addition der gesendeten Daten mit den empfangenen Daten (0 und 2 =
% sind gleich, 1 bedeutet Abweichung und somit Fehler)
k=x+bits;
% Auffinden der Positionen der "1" im Vektor und Erzeugen Vektorm mit
% unterschiedlicher Länge ja nach SNR und damit Fehleranzahl mit den
% Positionen der Fehler - Länge entspricht der Fehleranzahl pro SNR)
idx=find(k==1);

% Bitfehlerrate bestehend aus den aufgetretenen Fehlern zu der Anzahl der
% gesendeten Bits
ber=(nErr/length(bits));

end