clc
close all

load('mocap');
mocapn = transpose(mocap);


t = mocapn(1,:);
dt = mocapn(1,2:end) - mocapn(1,1:end-1);
x_pos = mocapn(6,:); y_pos = mocapn(7,:); z_pos = mocapn(8,:);
theta_x = mocapn(9,:); theta_y = mocapn(10,:); theta_z = mocapn(11,:);
q10 = mocapn(6:8,:);

%Use these mat files from Lab1
% CREATE WORLD OBJECTS
load('world.mat');  % this will load variables:   w0  wsz  wcolors

% CREATE A QUADROTOR
load('quadmodel.mat');  % this will load variables:  p1   faces   colors

R02 = [ 1  0  0; 0 -1  0; 0  0 -1 ];

% SETUP THE PLOT
clf;
set(gcf,'Renderer','zbuffer');
axis([-4 4 -4 4 -0.1 3.5]);
axis equal;
hold on;

R = [cos(theta_y(1))*cos(theta_z(1)), -cos(theta_y(1))*sin(theta_z(1)), sin(theta_y(1));
    cos(theta_x(1))*sin(theta_z(1))+cos(theta_z(1))*sin(theta_x(1))*sin(theta_y(1)), cos(theta_x(1))*cos(theta_z(1))-sin(theta_x(1))*sin(theta_y(1))*sin(theta_z(1)), -cos(theta_y(1))*sin(theta_x(1));
    sin(theta_x(1))*sin(theta_z(1))-cos(theta_x(1))*cos(theta_z(1))*sin(theta_y(1)), cos(theta_z(1))*sin(theta_x(1))+cos(theta_x(1))*sin(theta_y(1))*sin(theta_z(1)), cos(theta_x(1))*cos(theta_y(1))];

% ROTATE FROM BODY FRAME TO MATLAB PLOT FRAME
%%%%%
%Enter your code here:
%%%%%
p2 = R02*R*p1;

% ROTATE FROM WORLD FRAME TO MATLAB PLOT FRAME
w2 = R02*w0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scatter3(w2(1,:), w2(2,:), w2(3,:), wsz, wcolors,'filled');
plot3(0,0,0,'k.','markersize',16);
h = patch('Vertices',p2','Faces',faces,...
          'CData',colors,'FaceColor','flat');
hTitle = title(sprintf('t = %4.2f',0));
lighting flat
light('Position',[0 -2 -1])
light('Position',[0 -2 1])
xlabel('x'); ylabel('y'); zlabel('z');
drawnow;
pause(0.5);

% ANIMATE THE RESULTS
i = 1;
tic;
while (i<length(t)-1)
    if (toc > dt(i))
        tic;
        i = i+1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % YOUR CODE HERE TO COMPUTE p0
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        R = [cos(theta_y(i))*cos(theta_z(i)), -cos(theta_y(i))*sin(theta_z(i)), sin(theta_y(i));
             cos(theta_x(i))*sin(theta_z(i))+cos(theta_z(i))*sin(theta_x(i))*sin(theta_y(i)), cos(theta_x(i))*cos(theta_z(i))-sin(theta_x(i))*sin(theta_y(i))*sin(theta_z(i)), -cos(theta_y(i))*sin(theta_x(i));
             sin(theta_x(i))*sin(theta_z(i))-cos(theta_x(i))*cos(theta_z(i))*sin(theta_y(i)), cos(theta_z(i))*sin(theta_x(i))+cos(theta_x(i))*sin(theta_y(i))*sin(theta_z(i)), cos(theta_x(i))*cos(theta_y(i))];
        
        % TRANSFORM FROM BODY TO WORLD FRAME
        %%%%%
        %Enter your code here:
        %%%%%
        p0 = R*p1;
        
        p0 = p0+repmat(q10(:,i),1,294);

        
        % TRANSFORM FROM WORLD FRAME TO MATLAB DISPLAY FRAME
        p2 = R02*p0;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % UPDATE GRAPHICS OBJECT VERTICES
        set(h,'Vertices',p2');
        set(hTitle,'string',sprintf('t = %4.2f',t(i)));
        drawnow;
    end
end