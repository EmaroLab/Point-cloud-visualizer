clc;
close all;
clear all;
%%
oculus_data=load('oculus.txt','-ascii');
person_thetas_o=zeros(10,1000);
person_t_o=zeros(10,1000);
oculus_theta=(oculus_data(:,end)-40.3);%because main camera in unity has offset
t_stamp_o=oculus_data(:,1);
k = find(~t_stamp_o);

subplot(2,1,1);
hold on
grid on
for i=1:size(k,1)
    if i~=size(k,1)
        person_thetas_o(i,1:size(oculus_theta(k(i):k(i+1)-1)))=oculus_theta(k(i):k(i+1)-1)';
        person_t_o(i,1:size(t_stamp_o(k(i):k(i+1)-1)))=t_stamp_o(k(i):k(i+1)-1)';
        plot(t_stamp_o(k(i):k(i+1)-1),person_thetas_o(i,1:size(oculus_theta(k(i):k(i+1)-1))),'-o','markersize',3)
    else
        person_thetas_o(i,1:size(oculus_theta(k(i):end)))=oculus_theta(k(i):end)';
        person_t_o(i,1:size(t_stamp_o(k(i):end)))=t_stamp_o(k(i):end)';
        plot(t_stamp_o(k(i):end),person_thetas_o(i,1:size(oculus_theta(k(i):end))),'-o','markersize',3)
    end
    legendInfo_o{i} = ['Person ' num2str(i)];
end
mean_thetas_o=mean(person_thetas_o(1:size(k,1),:));
standard_dev_o=std(person_thetas_o(1:size(k,1),:));
plot(person_t_o(1,:),mean_thetas_o,'*','LineWidth',2,'markersize',4)
legendInfo_o{i+1} = 'Mean';

legend(legendInfo_o);

title('Oculus theta');
xlabel('time stamp (sec)');
ylabel('oculus theta (deg)');

robot_data=load('robot.txt','-ascii');
robot_theta=robot_data(:,end);
t_stamp_r=robot_data(:,1);
person_thetas_r=zeros(10,1000);
person_t_r=zeros(10,1000);
subplot(2,1,2);
hold on
grid on
for i=1:size(k,1) 
    if i~=size(k,1)
        person_thetas_r(i,1:size(robot_theta(k(i):k(i+1)-1)))=robot_theta(k(i):k(i+1)-1)';
        person_t_r(i,1:size(t_stamp_r(k(i):k(i+1)-1)))=t_stamp_r(k(i):k(i+1)-1)';
        plot(t_stamp_r(k(i):k(i+1)-1),person_thetas_r(i,1:size(robot_theta(k(i):k(i+1)-1))),'-o','markersize',3)
    else
        person_thetas_r(i,1:size(robot_theta(k(i):end)))=robot_theta(k(i):end)';
        person_t_r(i,1:size(t_stamp_r(k(i):end)))=t_stamp_r(k(i):end)';
        plot(t_stamp_r(k(i):end),person_thetas_r(i,1:size(robot_theta(k(i):end))),'-o','markersize',3)
    end
    legendInfo_r{i} = ['Person ' num2str(i)];
end
mean_thetas_r=mean(person_thetas_r(1:size(k,1),:));
plot(person_t_r(1,:),mean_thetas_r,'*','LineWidth',2,'markersize',4)
legendInfo_r{i+1} = 'Mean';
legend(legendInfo_r);
title('Robot theta');
xlabel('time stamp (sec)');
ylabel('Robot theta (deg)');

%%
%%
%theta dot
figure;
person_thetas_dot_o=zeros(10,1000);
subplot(2,1,1);
hold on
grid on
for i=1:size(k,1)
        if i~=size(k,1)
                oculus_theta_dot=diff(oculus_theta(k(i):k(i+1)-1))./diff(t_stamp_o(k(i):k(i+1)-1));
                person_thetas_dot_o(i,1:size(oculus_theta_dot))=oculus_theta_dot';
                plot(t_stamp_o(k(i)+1:k(i+1)-1),person_thetas_dot_o(i,1:size(oculus_theta_dot)),'-o','markersize',3)
        else
                oculus_theta_dot=diff(oculus_theta(k(i):end))./diff(t_stamp_o(k(i):end));
                person_thetas_dot_o(i,1:size(oculus_theta_dot))=oculus_theta_dot';
                plot(t_stamp_o(k(i)+1:end),person_thetas_dot_o(i,1:size(oculus_theta_dot)),'-o','markersize',3) 
        end
        
 
        legendInfo_o1{i} = ['Person ' num2str(i)];
end

legend(legendInfo_o1);

title('Oculus velocity');
xlabel('time stamp (sec)');
ylabel('oculus theta dot');

person_thetas_dot_r=zeros(10,1000);
subplot(2,1,2);
hold on
grid on
for i=1:size(k,1)
        if i~=size(k,1)
                robot_theta_dot=diff(robot_theta(k(i):k(i+1)-1))./diff(t_stamp_r(k(i):k(i+1)-1));
                person_thetas_dot_r(i,1:size(robot_theta_dot))=robot_theta_dot';
                plot(t_stamp_r(k(i)+1:k(i+1)-1),person_thetas_dot_r(i,1:size(robot_theta_dot)),'-o','markersize',3)
        else
                robot_theta_dot=diff(robot_theta(k(i):end))./diff(t_stamp_r(k(i):end));
                person_thetas_dot_r(i,1:size(robot_theta_dot))=robot_theta_dot';
                plot(t_stamp_r(k(i)+1:end),person_thetas_dot_r(i,1:size(robot_theta_dot)),'-o','markersize',3)
        end
        
 
        legendInfo_r1{i} = ['Person ' num2str(i)];
end

legend(legendInfo_r1);

title('Robot velocity');
xlabel('time stamp (sec)');
ylabel('Robot theta dot');

%%
%theta dot dot
figure;
person_thetas_dot_dot_o=zeros(10,1000);
subplot(2,1,1);
hold on
grid on
for i=1:size(k,1)
        if i~=size(k,1)
                oculus_theta_dot_dot=diff(person_thetas_dot_o(i,1:size(oculus_theta(k(i):k(i+1)-1))-1)')./diff(t_stamp_o(k(i)+1:k(i+1)-1));
                person_thetas_dot_dot_o(i,1:size(oculus_theta_dot_dot))=oculus_theta_dot_dot';
                plot(t_stamp_o(k(i)+2:k(i+1)-1),person_thetas_dot_dot_o(i,1:size(oculus_theta_dot_dot)),'-o','markersize',3)
        else
                oculus_theta_dot_dot=diff(person_thetas_dot_o(i,1:size(oculus_theta(k(i):end))-1)')./diff(t_stamp_o(k(i)+1:end));
                person_thetas_dot_dot_o(i,1:size(oculus_theta_dot_dot))=oculus_theta_dot_dot';
                plot(t_stamp_o(k(i)+2:end),person_thetas_dot_dot_o(i,1:size(oculus_theta_dot_dot)),'-o','markersize',3)
        end
        
 
        legendInfo_o1{i} = ['Person ' num2str(i)];
end

legend(legendInfo_o1);

title('Oculus acceleration');
xlabel('time stamp (sec)');
ylabel('oculus theta dot dot');

person_thetas_dot_dot_r=zeros(10,1000);
subplot(2,1,2);
hold on
grid on
for i=1:size(k,1)
        if i~=size(k,1)
                robot_theta_dot_dot=diff(person_thetas_dot_r(i,1:size(robot_theta(k(i):k(i+1)-1))-1)')./diff(t_stamp_r(k(i)+1:k(i+1)-1));
                person_thetas_dot_dot_r(i,1:size(robot_theta_dot_dot))=robot_theta_dot_dot';
                plot(t_stamp_r(k(i)+2:k(i+1)-1),person_thetas_dot_dot_r(i,1:size(robot_theta_dot_dot)),'-o','markersize',3)
        else
                robot_theta_dot_dot=diff(person_thetas_dot_r(i,1:size(robot_theta(k(i):end))-1)')./diff(t_stamp_r(k(i)+1:end));
                person_thetas_dot_dot_r(i,1:size(robot_theta_dot_dot))=robot_theta_dot_dot';
                plot(t_stamp_r(k(i)+2:end),person_thetas_dot_dot_r(i,1:size(robot_theta_dot_dot)),'-o','markersize',3)
        end
        
 
        legendInfo_r1{i} = ['Person ' num2str(i)];
end

legend(legendInfo_r1);

title('Robot acceleration');
xlabel('time stamp (sec)');
ylabel('Robot theta dot dot');

%%
%theta dot dot dot
figure;
person_thetas_dot_dot_dot_o=zeros(10,1000);
subplot(2,1,1);
hold on
grid on
for i=1:size(k,1)
        if i~=size(k,1)
                oculus_theta_dot_dot_dot=diff(person_thetas_dot_dot_o(i,1:size(oculus_theta(k(i):k(i+1)-1))-2)')./diff(t_stamp_o(k(i)+2:k(i+1)-1));
                person_thetas_dot_dot_dot_o(i,1:size(oculus_theta_dot_dot_dot))=oculus_theta_dot_dot_dot';
                plot(t_stamp_o(k(i)+3:k(i+1)-1),person_thetas_dot_dot_dot_o(i,1:size(oculus_theta_dot_dot_dot)),'-o','markersize',3)
        else
                oculus_theta_dot_dot_dot=diff(person_thetas_dot_dot_o(i,1:size(oculus_theta(k(i):end))-2)')./diff(t_stamp_o(k(i)+2:end));
                person_thetas_dot_dot_dot_o(i,1:size(oculus_theta_dot_dot_dot))=oculus_theta_dot_dot_dot';
                plot(t_stamp_o(k(i)+3:end),person_thetas_dot_dot_dot_o(i,1:size(oculus_theta_dot_dot_dot)),'-o','markersize',3)
        end
        
 
        legendInfo_o11{i} = ['Person ' num2str(i)];
end

legend(legendInfo_o11);

title('Oculus jerk');
xlabel('time stamp (sec)');
ylabel('oculus theta dot dot dot');

person_thetas_dot_dot_dot_r=zeros(10,1000);
subplot(2,1,2);
hold on
grid on
for i=1:size(k,1)
        if i~=size(k,1)
                robot_theta_dot_dot_dot=diff(person_thetas_dot_dot_r(i,1:size(robot_theta(k(i):k(i+1)-1))-2)')./diff(t_stamp_r(k(i)+2:k(i+1)-1));
                person_thetas_dot_dotdot__r(i,1:size(robot_theta_dot_dot_dot))=robot_theta_dot_dot_dot';
                plot(t_stamp_r(k(i)+3:k(i+1)-1),person_thetas_dot_dot_dot_r(i,1:size(robot_theta_dot_dot_dot)),'-o','markersize',3)
        else
                robot_theta_dot_dot_dot=diff(person_thetas_dot_dot_r(i,1:size(robot_theta(k(i):end))-2)')./diff(t_stamp_r(k(i)+2:end));
                person_thetas_dot_dot_dot_r(i,1:size(robot_theta_dot_dot_dot))=robot_theta_dot_dot_dot';
                plot(t_stamp_r(k(i)+3:end),person_thetas_dot_dot_dot_r(i,1:size(robot_theta_dot_dot_dot)),'-o','markersize',3)
        end
        
 
        legendInfo_r11{i} = ['Person ' num2str(i)];
end

legend(legendInfo_r11);

title('Robot jerk');
xlabel('time stamp (sec)');
ylabel('Robot theta dot dot dot');