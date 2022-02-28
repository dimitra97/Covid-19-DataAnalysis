function [R2cases R2deaths]=AmperiadouExe2Fun1(m,start1,end1,start2,end2,country)

%Fit the found distribution for Belgium to other selected European countries%
distributionc='LogLogistic';
distributiond='Lognormal';
str1=num2str(m);
range1=strcat(start1,str1);
range2=strcat(end1,str1);
range3=strcat(start2,str1);
range4=strcat(end2,str1);
cases=xlsread('Covid19Confirmed',[range1,':',range2]);
deaths=xlsread('Covid19Deaths',[range3,':',range4]);
%Perform some methods and criteria in order to "clean" the data%
nanelm=find(isnan(cases));
cases(nanelm)=0;%Delete the NaN elements in cases and deaths%
deaths(nanelm)=0;
negelmnts=find(cases<0);
cases(negelmnts)=[];%Delete the cases that have negative value
deaths(negelmnts)=[];
negelmnts=find(deaths<0);
deaths(negelmnts)=[];
cases(negelmnts)=[];
index = find(cases ~= 0, 1, 'first'); %Determine first wave
cases = cases(index : end);
index2 = find(deaths ~= 0, 1, 'first');
deaths = deaths(index2 : end);

 %Create the stochastic variable (day) for the country for cases and
 %deaths%
x=[];%create an array for the stochastic variable: "day" for the cases%
v=[]; %crate an array for the stochastic variable:"day" for the deaths%
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
%values:1,2,......278. It is actually the number of cases for each
%day/total cases%
y1=(cases(1,:)./sum(cases));
y2=(deaths(1,:)./sum(deaths));

%Fit the distributon 'GeneralizedExtremeValue' which is found in the previous
%exercise%
%Cases%
pd=fitdist(x',distributionc);
fc=pdf(pd,[1:1:length(cases)]);
msec=sum((y1(1,:)-fc(1,:)).^2)/length(y1);
ssecases=sum((y1(1,:)-fc(1,:)).^2);
sstcases=sum((y1(1,:)-mean(y1)).^2);
R2cases=1-(ssecases/sstcases);
figure('Name',country)
clf;
histogram(x,(max(x)-min(x)));
hold on
plot([1:1:length(cases)],sum(cases)*fc(1,:));
title('Histogram of confirmed cases with parametric fitting');
xlabel('NoDay');
ylabel('Cases');
legend('histogram of data',distributionc);
annotation('textbox', [0.7, 0.4, 0.1, 0.1],'String',{sprintf('R^2=%d',R2cases)});

%Deaths%
%Distribution for check: LogLogistic%
pd=fitdist(v',distributiond);
fd=pdf(pd,[1:1:length(deaths)]);
ssedeaths=sum((y2(1,:)-fd(1,:)).^2);
sstdeaths=sum((y2(1,:)-mean(y2)).^2);
msed=sum((y2(1,:)-fd(1,:)).^2)/length(y2);
R2deaths=1-(ssedeaths/sstdeaths);
figure('Name',country)
clf;
histogram(v,(max(v)-min(v)));
hold on
plot([1:1:length(deaths)],sum(deaths)*fd(1,:));
title('Histogram of confirmed deaths with parametric fitting');
xlabel('NoDay');
ylabel('Deaths');
legend('histogram of data',distributiond);
annotation('textbox', [0.7, 0.4, 0.1, 0.1],'String',{sprintf('R^2=%d',R2deaths)});
fprintf(2,'%s\n',country);
fprintf('\n');
disp(['The mse of ',distributionc,' for cases is:', num2str(msec)]);
disp(['The mse of ',distributiond,' for deaths is:',num2str(msed)]);
end




