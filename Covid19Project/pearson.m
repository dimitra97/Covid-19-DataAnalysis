function corrcoeff= pearson(x,y)
n=length(x);
meanx=mean(x);
meany=mean(y);
sx=std(x);
sy=std(y);
sxy=(sum(x.*y)-n*meanx*meany)/(n-1);
corrcoeff=sxy/(sx*sy);
end
