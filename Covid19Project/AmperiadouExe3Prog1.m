%%
%Amperiadou Dimitra%
%AEM:4386%
%Country A:Czechia%
%Countries for exe3: Austria,Belgium,Croatia,France,Germany,Italy,Norway,Serbia,Spain,Switzerland,Turkey

%%
%Index for each country that we want to check%
[~,countries]=xlsread('Covid19Confirmed','A1:A157');
indexcntr=[9 14 34 49 53 68 104 122 131 135 144];
dt=[];

   for i=1:length(indexcntr)
       
       
    if indexcntr(i)==49 || indexcntr(i)==53 || indexcntr(i)==68 
             cases=xlsread('Covid19Confirmed',[strcat('D',num2str(indexcntr(i))),':',strcat('GC',num2str(indexcntr(i)))]);
             deaths=xlsread('Covid19Deaths',[strcat('D',num2str(indexcntr(i))),':',strcat('GC',num2str(indexcntr(i)))]);
             totaldaysc=182;
             totaldaysd=182;
      
    elseif  indexcntr(i)==36 || indexcntr(i)==9 || indexcntr(i)==131 || indexcntr(i)==135
             cases=xlsread('Covid19Confirmed',[strcat('D',num2str(indexcntr(i))),':',strcat('EY',num2str(indexcntr(i)))]);
             deaths=xlsread('Covid19Deaths',[strcat('D',num2str(indexcntr(i))),':',strcat('GC',num2str(indexcntr(i)))]);  
             totaldaysc=152;
             totaldaysd=182;
    else
        cases=xlsread('Covid19Confirmed',[strcat('D',num2str(indexcntr(i))),':',strcat('EY',num2str(indexcntr(i)))]);
        deaths=xlsread('Covid19Deaths',[strcat('D',num2str(indexcntr(i))),':',strcat('EY',num2str(indexcntr(i)))]);
        totaldaysc=152;
        totaldaysd=152;
    end
       

tcases=AmperiadouExe3Fun1(cases,indexcntr(i),char(countries(indexcntr(i))),'cases',totaldaysc);
tdeaths=AmperiadouExe3Fun1(deaths,indexcntr(i),char(countries(indexcntr(i))),'deaths',totaldaysd);
dt=[dt,tdeaths-tcases];
   end
   
   %95% confidence interval%
   %%
%Parametric Confidence interval%
[h,p,ci,stats]=ttest(dt,14);
%Non-Parametric/Bootstrap Confidence interval%
M=1000;
n=length(dt);
alpha=0.05;
for i=1:M
    indices=unidrnd(n,n,1);
    x=dt(indices);
    meanx(i)=mean(x);
end
mx_sorted=sort(meanx);
ci_boostrap=[mx_sorted(M*alpha/2) mx_sorted(M*(1-alpha/2))];
disp(['The parametric confidence interval under the assumption that the mean of the days between the maximum of deaths and the maximum of cases comes from Normal Distribution is: ',num2str(ci)]);
disp(['The bootsrap confidence interval of the mean of the days between the maximum of deaths and the maximum of cases is: ',num2str(ci_boostrap)]);

disp('According to the parametric check:');
if h==0
    disp('We can accept the null Hypothesis at 95% confidence level that the time interval between the maximization of cases and deaths is 14');
else
    disp('We cannot accept the null Hypothesis at 95% confidence level that the time interval between the maximization of cases and deaths is 14');
end
 disp('According to the found boostrap confidence interval:')
 
 if ci_boostrap(1)<14 && ci_boostrap(2)>14
     disp('We can accept the null Hypothesis at 95% confidence level hat the time interval between the maximization of cases and deaths is 14');
 else
     disp('We cannot accept the null Hypothesis at 95% confidence level that the time interval between the maximization of cases and deaths is 14');
 end
     