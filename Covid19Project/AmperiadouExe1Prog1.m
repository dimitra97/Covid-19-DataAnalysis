%%
%Amperiadou Dimitra%
%AEM:4386%
%Country:Czechia%
%P.S My first country according to the number of AEM was Bulgaria. However I changed
%to Czechia because the data from Bulgaria wasn't enough and it wasn't easy
%to determine the first wave%
%%
%The best fitting for the confirmed cases%
%Loading the data for the country%
cases= xlsread('Covid19Confirmed', 'D36:EY36');
deaths=xlsread('Covid19Deaths','D36:EY36');
nanelm=find(isnan(cases));
cases(nanelm)=0;%Delete the NaN elements in cases and deaths%
deaths(nanelm)=0;
nanelm=find(isnan(deaths));
deaths(nanelm)=0;
cases(nanelm)=0;
index = find(cases ~= 0, 1, 'first'); %We consider the start of 1st wave for cases is the first day that one or more cases are found
cases = cases(index : end);
index2 = find(deaths ~= 0, 1, 'first'); %We consider different time interval for the 1st wave for deaths
deaths = deaths(index2 : end);
x=[];%create an array for the stochastic variable: "day" for the cases%
v=[]; %crate an array for the stochastic variable:"day" for the deaths%
%We consider that our stochastic variable is the day which can have
%values:1,2,3,....last_day_of_wave, and the cases for each day is the
%frequency for each of the above values of the day%
%The arrays we create have form like that:1,1,1,1,2,2,2,2....
%The number 1 is the first day and the times that this day appears in the
%array is the cases of this day etc.%
for i=1:length(cases)
    for j=1:cases(i)
        x=[x,i];
    end
end

for i=1:length(deaths)
    for j=1:deaths(i)
        v=[v,i];
    end
end
%Create an array of y=fx(xi)=ni/n (the frequencys of each day),assuming that
%our stochastic variable is the day which can have the
%values:1,2,......end_day. It is actually the number of cases for each
%day/total cases%
y1=cases(1,:)./sum(cases);
y2=deaths(1,:)./sum(deaths);

    
%Calculates the probability density function for a known distribution which
%comes from our data and compare to the probabilities in matrix y1%
distributions={'Normal','Exponential','Gamma','Lognormal','Weibull','GeneralizedExtremeValue','ExtremeValue','InverseGaussian','Logistic','LogLogistic','Nakagami','NegativeBinomial','Poisson','Rayleigh','Rician','tLocationScale'};
for i=1:length(distributions)
dist=char(distributions(i));
pd=fitdist(x',dist);
fc(i,:)=pdf(pd,[1:1:length(cases)]);
msec(i)=sum((y1(1,:)-fc(i,:)).^2)/length(y1); %mse of cases for all the distributions%
end
%Th best distribution for the data corresponds to the minimum mse%
kc=find(msec==min(msec));
disp(['The best parametric distribution for the data of the Confirmed cases is:',distributions{kc}]);
ssecases=sum((y1(1,:)-fc(kc,:)).^2);
sstcases=sum((y1(1,:)-mean(y1)).^2);
R2cases=1-(ssecases/sstcases); %We can use the R^2 coefficient which can shows if the distribution is suitable (ideally R^2=1), the idea comes from regression models
figure('Name','Czechia:Distributon of the Confirmed cases')
clf;
histogram(x,(max(x)-min(x)));
hold on
plot([1:1:length(cases)],sum(cases)*fc(kc,:));
title('Histogram of confirmed cases with parametric fitting');
xlabel('NoDay');
ylabel('Cases');
legend('histogram of data',distributions{kc});
annotation('textbox', [0.7, 0.4, 0.1,0.1],'String',{sprintf('R^2=%d',R2cases)});




%%
%The best fitting for the confirmed deaths%

%Calculates the probability density function for a known distribution which
%comes from our data and compare to the probabilities in matrix y2%
distributions={'Normal','Exponential','Gamma','Lognormal','Weibull','GeneralizedExtremeValue','ExtremeValue','InverseGaussian','Logistic','LogLogistic','Nakagami','NegativeBinomial','Poisson','Rayleigh','Rician','tLocationScale'};
for i=1:length(distributions)
dist=char(distributions(i));
pd=fitdist(v',dist);
fd(i,:)=pdf(pd,[1:1:length(deaths)]);
msed(i)=sum((y2(1,:)-fd(i,:)).^2)/length(y2); %mse of deaths for all the distributions%
end
%Th best distribution for the data corresponds to the minimum mse%
kd=find(msed==min(msed));
disp(['The best parametric distribution for the data of the Confirmed Deaths is:',distributions{kd}]);
ssedeaths=sum((y2(1,:)-fd(kd,:)).^2);
sstdeaths=sum((y2(1,:)-mean(y2)).^2);
R2deaths=1-(ssedeaths/sstdeaths);
figure('Name','Czechia:Distributon of the Confirmed deaths')
clf;
histogram(v,(max(v)-min(v)));
hold on
plot([1:1:length(deaths)],sum(deaths)*fd(kd,:));
title('Histogram of confirmed deaths with parametric fitting');
xlabel('NoDay');
ylabel('Deaths/Total Deaths');
legend('histogram of data',distributions{kd});
annotation('textbox', [0.7, 0.4, 0.1, 0.1],'String',{sprintf('R^2=%d',R2deaths)});


%%
%Check if the best parametric distribution for cases is suitable for
%%deaths and vice versa%
ssedeaths=sum((y2(1,:)-fd(kc,:)).^2);
sstdeaths=sum((y2(1,:)-mean(y2)).^2);
R2deaths=1-(ssedeaths/sstdeaths);
figure('Name','Czechia:Confirmed deaths with GenralizedExtremeValue fitting')
clf;
histogram(v,(max(v)-min(v)));
hold on
plot([1:1:length(deaths)],sum(deaths)*fd(kc,:));
title('Histogram of confirmed deaths with cases` parametric fitting');
xlabel('NoDay');
ylabel('Deaths');
legend('histogram of data',char(distributions(kc)));
annotation('textbox', [0.7, 0.4, 0.1, 0.1],'String',{sprintf('R^2=%d',R2deaths)});
disp(['The mse of the',char(distributions(kd)),'for deaths is:',num2str(msed(kd))]);
disp(['The mse of the ',char(distributions(kc)),' for deaths is: ',num2str(msed(kc))]);


%%
%Check if the best parametric distribution for deaths is suitable for cases%
ssecases=sum((y1(1,:)-fc(kd,:)).^2);
sstcases=sum((y1(1,:)-mean(y1)).^2);
R2cases=1-(ssecases/sstcases);
figure('Name','Czechia:Histogram of confirmed cases with parametric fitting')
clf;
histogram(x,(max(x)-min(x)));
hold on
plot([1:1:length(cases)],sum(cases)*fc(kd,:));
title('Histogram of confirmed cases with deaths` parametric fitting');
xlabel('NoDay');
ylabel('Cases');
legend('histogram of data',char(distributions(kd)));
annotation('textbox', [0.7, 0.4, 0.1,0.1],'String',{sprintf('R^2=%d',R2cases)});
disp(['The mse of the ',char(distributions(kc)),' for cases is: ',num2str(msec(kc))]);
disp(['The mse of the ',char(distributions(kd)),' for cases is: ',num2str(msec(kd))]);
sorted_msec=sort(msec);


%After applying the parametric distribution of cases to the data of deaths and vice versa%
% we consider that the fitting is acceptable if the mse that corresponds to
% the best parametric distribution (this is the minimum mse we can get) is close enough (2 significant digits)%
% to the mse that corresponds to the tested distribution.%
%This is an arbritrary chosen criterion which can be more or less strict%
 if abs((msed(kc)-msed(kc))/msed(kd))<0.05
    disp('The distribution of cases performs well in the data of deaths');
 else
     disp('The distribution of cases cannot be used to describe the deaths');
 end
 
 if abs((msec(kd)-msec(kc))/msec(kc))<0.05
     disp('The distribution of deaths perform well in the data of cases');
 else
     disp('The distribution of deaths cannot be used to describe the cases');
 end






