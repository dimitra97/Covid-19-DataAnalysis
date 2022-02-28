%%
%Amperiadou Dimitra%
%AEM:4386%
%Country:Czechia%
%Countries for exe5: Austria,France,Germany,Italy,Spain%
%%
[~,countries]=xlsread('Covid19Confirmed','A1:A157');
indexcntr=[9 36 49 53 68 131 ]; %indexes for each country%
lags=0:20;
alpha=0.05;

 for i=1:length(indexcntr)
       
       
    if indexcntr(i)==49 || indexcntr(i)==53 || indexcntr(i)==68 
             cases=xlsread('Covid19Confirmed',[strcat('D',num2str(indexcntr(i))),':',strcat('GC',num2str(indexcntr(i)))]);
             deaths=xlsread('Covid19Deaths',[strcat('D',num2str(indexcntr(i))),':',strcat('GC',num2str(indexcntr(i)))]);
           
      
    else 
             cases=xlsread('Covid19Confirmed',[strcat('D',num2str(indexcntr(i))),':',strcat('EY',num2str(indexcntr(i)))]);
             deaths=xlsread('Covid19Deaths',[strcat('D',num2str(indexcntr(i))),':',strcat('GC',num2str(indexcntr(i)))]);  
          
  
    end
    
nanelm=find(isnan(cases));
cases(nanelm)=0;%Delete the NaN elements in cases and deaths%
nanelm=find(isnan(deaths));
deaths(nanelm)=0;
negelmnts=find(cases<0);
cases(negelmnts)=[];%Delete the cases that have negative value
deaths(negelmnts)=[];
negelmnts=find(deaths<0);
deaths(negelmnts)=[];
cases(negelmnts)=[];
indexzeros=find(cases ~= 0, 1, 'first');%Delete the first zero elements in order to determine the begining of the wave
cases=cases(indexzeros:end);%We consider that wave for deaths and cases has the same start day and strats from the day that the fist cases have been found
deaths=deaths(indexzeros:end);
n=length(cases);
for m=1:length(lags)
    x=[];
    y=[];
        for j=1:n-lags(m)
             x=[x,cases(j)];
             y=[y,deaths(j+lags(m))];
        end
         
        %Calculate the coefficients of linear regression for x,y for each
        %value of lags
      k=1;
        b1=pearson(x,y)*std(y)/std(x);
        bo=mean(y)-b1*mean(x);
        yhat=bo+b1*x;
        ei=y-yhat;
        eistar=ei/std(ei);
        R2(m) = 1-(sum(ei.^2))/(sum((y-mean(y)).^2));
        adjR2(m) =1-((n-1)/(n-(k+1)))*(sum(ei.^2))/(sum((y-mean(y)).^2));
        figure(m)
        subplot(1,2,1)
        scatter(x,y);
        hold on
        plot(x,yhat);
        title(['Linear Regression model for ',char(countries(indexcntr(i))),' ô=',num2str(lags(m))]);
        ylabel('Deaths/day');
        xlabel(['Cases ',num2str(lags(m)),' days before']);
        text(max(x),max(y),sprintf('R^2=%f\n adjR^2=%f\n',R2(m),adjR2(m)));
        hold off
 
        subplot(1,2,2)
        scatter(y,eistar);
        hold on
        plot(y,norminv(1-alpha/2)*ones(size(y)));
        plot(y,-norminv(1-alpha/2)*ones(size(y)));
        xlabel('y:Deaths/day');
        ylabel('ei*=ei/se');
        hold off
               
end
adjR2max(i)=max(adjR2(:))
lagofcntr(i)=lags(find(adjR2==max(adjR2)));
pause;
 end
