function t=AmperiadouExe3Fun1(data,m,country,confirmed,totaldays)
%The initial size of data from 1/1/20%

%"Clean" the data%
nanelm=find(isnan(data));
data(nanelm)=0;%Delete the NaN elements in cases and deaths%
x=[];%create an array for the stochastic variable: "day" for the cases or deaths%
indexzeros=find(data ~= 0, 1, 'first');%Delete the first zero elements in order to determine the begining of the wave
data=data(indexzeros:end);

for i=1:length(data)
    for j=1:data(i)
        x=[x,i];
    end
end
%Create an array of y=fx(xi)=ni/n (the frequencys of each day),assuming that
%our stochastic variable is the day which can have the
%values:1,2,......end_day. It is actually the number of cases for each
%day/total cases%
y=data(1,:)./sum(data);
%Calculates the probability density function for a known distribution which
%comes from our data and compare to the probabilities in matrix y1%
distributions={'Normal','Exponential','Gamma','Lognormal','Weibull','GeneralizedExtremeValue','ExtremeValue','InverseGaussian','Logistic','LogLogistic','Nakagami','NegativeBinomial','Poisson','Rayleigh','Rician','tLocationScale'};
for i=1:length(distributions)
dist=char(distributions(i));
pd=fitdist(x',dist);
f(i,:)=pdf(pd,[1:1:length(data)]);
mse(i)=sum((y(1,:)-f(i,:)).^2)/length(y);
end
%Th best distribution for the data corresponds to the minimum mse%
kc=find(mse==min(mse));
disp(['Country:',country]);
disp(['The best parametric distribution for the data of the Confirmed ',confirmed,' is:',distributions{kc}]);
sse=sum((y(1,:)-f(kc,:)).^2);
sst=sum((y(1,:)-mean(y)).^2);
R2=1-(sse/sst);
figure('Name',char(country))
histogram(x,80);
hold on
plot([1:1:length(data)],sum(data)*f(kc,:));
title(['Histogram of confirmed ', confirmed,' with parametric fitting']);
xlabel('NoDay');
ylabel('Cases');
legend('histogram of data',distributions{kc});
annotation('textbox', [0.15, 0.4, 0.1,0.1],'String',{sprintf('R^2=%d',R2)});
%Find the maximum of the fitted distribuions which corresponds to the day
%of the maximized wave for cases or deaths%
maxday=find(f(kc,:)==max(f(kc,:)),1);
daysout=totaldays-length(data);
t=maxday+daysout;
end



