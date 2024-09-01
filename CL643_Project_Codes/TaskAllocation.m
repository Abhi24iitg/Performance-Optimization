function f=TaskAllocation(x)
%% Importing Data
[credit,efficiency,time,total_hour]=data;

Np=length(credit); % Total no. of Subjects (n)
Y=NaN(Np,1); % Column Vector to store Normalized Subject Completion Factor
S=NaN(Np,1); % efficieny adjusted score
grade=NaN(Np,1); % Column Vector to store Grade for each Subject
grade_penalty=zeros(Np,1); % Grade Penalty
Time_penalty=0; % Time Penalty

%% If total time exceeds the time we have then penalty is imposed. 
if(sum(x)>total_hour)
    Time_penalty=10^5;
end

%% Calculating Normalized Subject Completion Factor Y(i)
for i=1:Np
    if (x(i)<=time(i)/4)
        Y(i)=2*x(i)/time(i);
    else
        Y(i)=(2/(3*time(i)))*(x(i)-(time(i)/4))+0.5;
    end
end

%% Efficieny adjusted score S(i)
for i=1:Np
    S(i)=efficiency(i)*Y(i);
end

%% Assigning grade for each Subject based on S(i) in that Subject
for i=1:Np
    if  S(i)>=0.875
        grade(i)=10;
    elseif  S(i)>=0.75 && S(i)<0.875
        grade(i)=9;
    elseif  S(i)>=0.65 && S(i)<0.75
        grade(i)=8;
    elseif  S(i)>=0.55 && S(i)<0.65    
        grade(i)=7;
    elseif  S(i)>=0.45 && S(i)<0.55    
        grade(i)=6;
    elseif  S(i)>=0.35 && S(i)<0.45    
        grade(i)=5;
    elseif  S(i)>=0.20 && S(i)<0.35    
        grade(i)=4;
    else
        grade_penalty(i)=10^5; % Grade Penalty if grade goes below 4.
    end
end

%% Overall Score/Grade Score
total=0;
for i=1:Np
    total=total+grade(i)*credit(i);
end

%% Fitness Function
f=-(total/sum(credit))+sum(grade_penalty)+Time_penalty;