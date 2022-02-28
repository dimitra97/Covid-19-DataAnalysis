%%
%Amperiadou Dimitra%
%AEM:4386%
%Country:Czechia%
%Countries for exe4: Austria,France,Germany,Italy,Spain%
%%
[~,countries]=xlsread('Covid19Confirmed','A1:A157');
indexcntr=[9 36 49 53 68 131 ]; %indexes for each country%
lags=-20:20;
corrlags=[];
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
deaths(nanelm)=0;
indexzeros=find(cases ~= 0, 1, 'first');%Delete the first zero elements in order to determine the begining of the wave
cases=cases(indexzeros:end);%We consider that wave for deaths and cases has the same start day and strats from the day that the fist cases have been found
deaths=deaths(indexzeros:end);
n=length(cases);

for k=1:length(lags)
    x=[];
    y=[];
    if lags(k)>0
        for j=1:n-lags(k)
             x=[x,cases(j)];
             y=[y,deaths(j+lags(k))];
         end
    end
    if lags(k)<0
        for j=n:-1:(1+abs(lags(k)))
            x=[x,cases(j)];
            y=[y,deaths(j+lags(k))];
        end
    end
    covmatrix=corrcoef(x,y);
    pearson(k)=covmatrix(1,2);            
end
corrlags(i)=lags(find(pearson(:)==max(pearson(:))));

disp(['The lag for which the cases and deaths are most correlated for ',char(countries(indexcntr(i))),' is:',num2str(corrlags(i))]);
 end

    
