%ae 483 hw 3 problem 5 part g
% Splitting the control loops into inner and outer sections, complete control with
% dts different for each loop corresponding to a system with different measurement rates
% October 24, 2015
clc;clear all;clf;
g = 9.81;
J2 = .01;

Acc = [0 1 0 0;
      0 0 -g 0;
      0 0 0 1;
      0 0 0 0];
  
 Bcc = [0;
       0;
       0;
       1/J2];
 
 dt = .001;
 Add = eye(4) + dt*Acc;
 Bdd = Bcc*dt;

Ac = [0 1;0 0];
 dtouter = .02;
 dtinner = .001;
 
 Bcinner = [0;1/J2];
 Bcouter = [0;-g*dtouter];
 
 Adouter = eye(2) + dtouter*Ac;
 Adinner = eye(2) + dtinner*Ac;
 
 Bdouter = Bcouter*dtouter;
 Bdinner = Bcinner*dtinner;
 
 Q = eye(2);
 R = 1;
 n=5000;
 Pinner{n+1} = eye(2);
 for i=n:-1:1
    Pinner{i} = Q + Adinner'*Pinner{i+1}*Adinner - Adinner'*Pinner{i+1}*Bdinner*inv(R+Bdinner'*Pinner{i+1}*Bdinner)*Bdinner'*Pinner{i+1}*Adinner;
    Kinner(i,:) = inv(R+Bdinner'*Pinner{i+1}*Bdinner)*Bdinner'*Pinner{i+1}*Adinner;
 end
Pouter{n+1} = eye(2);
 for i=n:-1:1
    Pouter{i} = Q + Adouter'*Pouter{i+1}*Adouter - Adouter'*Pouter{i+1}*Bdouter*inv(R+Bdouter'*Pouter{i+1}*Bdouter)*Bdouter'*Pouter{i+1}*Adouter;
    Kouter(i,:) = inv(R+Bdouter'*Pouter{i+1}*Bdouter)*Bdouter'*Pouter{i+1}*Adouter;
 end

phi = 10;
xdesignouter = [1;0];
xdesigninner = [phi;0];
udesignouter = [0];
udesigninner = [0];

xd = [];
xd(1:2,1) = [0;0];
xd(3:4,1) = [0;0];
xd(1:2,5002) = [0;0];

udouter = -Kouter*([0;0] - xdesignouter) + udesignouter;

for i=1:5000
    if (~mod(i,.02/.001)) 
        udouter = -Kouter(i,:)*(xd(1:2,i) - xdesignouter) + udesignouter;
    end
    
    xdinnerdes = [udouter;0];
    udinnerdes = [0];
    
    ud(:,i) = udesigninner  - Kinner(i,:)*(xd(3:4,i) - xdesigninner);
    
    xd(:,i+1) = Add*xd(:,i) + Bdd*ud(:,i);
    
end

plot(1:i,xd(1,1:5000),'.',1:i,xd(2,1:5000),'.',1:i,xd(3,1:5000),'.',1:i,xd(4,1:5000),'.')




