load("FIR_Coef.mat");
k  = floor(log2(127/max(Num)));
FinalCoef = round(2^k * Num);
display(FinalCoef);