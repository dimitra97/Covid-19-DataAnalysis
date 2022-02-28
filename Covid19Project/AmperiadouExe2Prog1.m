%%
%Amperiadou Dimitra%
%AEM:4386%
%Country:Czechia%
%Countries for exe2:
%Austria,Belgium,Croatia,France,Germany,Italy,Norway,Serbia,Spain,Switzerland,Turkey
%%
%Index for each country that we want to check%
[~,countries]=xlsread('Covid19Confirmed','A1:A157');
indexcntr=[9 14 34 49 53 68 104 122 131 135 144]; %indexes for each country%
%We check how good the parametric fitting from 1st exercise is for some
%countries%
%For cases we check the LogLogistic and for deaths we check the
%LogNormal distribution found in 1st exercise%

%We use if statements for the countries because the 1st wave for each
%country is considered to have different end days. Also, the time interval of the 1st
%wave may be different for cases and deaths%

%We assume that the first wave for each country starts from the 1st day
%with non-zero cases/deaths and the end of the wave is considered to be the
%day that the cases or deaths have been reduced. We have it checked from other sources
%like 'Worldmeter' and so we estimate the time interval of 1st wave for
%each country%

%We load all the data from the date 1/1 until an estimated end day and then
%we clean the data in the function in order to determine the start of 1st
%wave for cases and deaths%

for i=1:length(indexcntr)

    
    if indexcntr(i)==49 || indexcntr(i)==53 || indexcntr(i)==68
       [R2cases(i) R2deaths(i)]= AmperiadouExe2Fun1(indexcntr(i),'D','GC','D','GC',char(countries(indexcntr(i))));
    elseif indexcntr(i)==14 || indexcntr(i)==9 || indexcntr(i)==131 || indexcntr(i)==135
       [R2cases(i) R2deaths(i)]= AmperiadouExe2Fun1(indexcntr(i),'D','EY','D','GC',char(countries(indexcntr(i))));
    else
       [R2cases(i) R2deaths(i)]= AmperiadouExe2Fun1(indexcntr(i),'D','EY','D','EY',char(countries(indexcntr(i))));
        
        
    end
end
sorted_R2cases=sort(R2cases);
sorted_R2deaths=sort(R2deaths);
%Sorting the countries from the country with the worst fitting to the
%country with the best fitting%
disp('<strong>Sorting of countries according to their response to LogLogistic fitting to the data of cases:</strong>');
disp('*Countries with bad fitting to countries with good fitting*');
for j=1:length(R2cases)
    ind=find(R2cases(:)==sorted_R2cases(j));
    disp([char(countries(indexcntr(ind))),' :R^2=',num2str(sorted_R2cases(j))]);   %Display the countries from the one with the smallest R^2 (worst response to fitting)%to the one with the biggest R^2 (best response to fitting
      
    %we choose as criterion R^2>0.6 because we dont have another mse from
    %others distribtions in order to compare it with the mse from
    %LogLogistic
    %and LogNormal distributions for each country%
    if sorted_R2cases(j)>0.6
        disp('The LogLogistic parametric distribution fits well to the data of cases');
    else
        disp('The LogLogistic parametric distribution doesnt fit well to the data of cases'); 
    end
end

disp('<strong>Sorting of countries according to their response to Lognormal fitting to the data of deaths:</strong>');
disp('*Countries with worst fitting to countries with best fitting*');

for j=1:length(R2deaths)
    ind=find(R2deaths(:)==sorted_R2deaths(j));
    disp([char(countries(indexcntr(ind))),' :R^2=',num2str(sorted_R2deaths(j))]);       %Display the countries from the one with the smallest R^2 (worst response to fitting)
                                                                                         %to the one with the biggest R^2 (best response to fitting
    if sorted_R2deaths(j)>0.6
        disp('The LogNormal parametric distribution fits well to the data of deaths');
    else
        disp('The LogNormal parametric distribution doesnt fit well to the data of deaths');
    end                    
end

%We consider that an acceptable fitting yields an R^2 coefficent>0.6 so the
%countries with R^2<0.6 don't appear to respond well to the fitting of the
%selected distribution from exercise1. However we set this criterion,since
%we don't have another value of mse from other distributions for each
%country in order to compare%
      


 
