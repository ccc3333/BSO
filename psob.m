%POSB.m
function [location,fbest]=psob(choose,value,M,D)%choose�����ϲ㻹���²㣬value����ʼֵ��M��������������D:�����ά��
N=40;
% c1=20;c2=50;c3=30;
c1=0.5;c2=2;c3=3;
w=0.9;
% fitness:���Ż���Ŀ�꺯��  
% N:������Ŀ  
% c1,c2:ѧϰ����1��ѧϰ����2  
% w:����Ȩ��  
% M:����������  
% D:�����ά��  
% xm:Ŀ�꺯��ȡ��Сֵʱ���Ա���ֵ  
% fv:Ŀ�꺯����Сֵ  
% choose:Ϊ0ʱ��ʾ��֪y=value���ϲ�x,Ϊ1ʱ��ʾ��֪x=value���²�y,  
 


format long 
fitness = @(x) fmin(x); 
%---------��ʼ����Ⱥ�ĸ���-------------  
for i=1:N  %������Ŀ
    for j=1:D  %����ά��
        x(i,j)=randn;  
        v(i,j)=randn;  
    end  
end
x(N,:)=value';%���Լ��ĳ�ʼֵ�Ž�ȥ


%---------�ȼ���������ӵ���Ӧ�ȣ�����ʼ��Pi��Pg----------  
for i=1:N  
    p(i)=fitness(x(i,:)); %������ 
    y(i,:)=x(i,:);  %ÿ�����ӵĳ�ʼ���Ž�
end  
pg=x(N,:); %pgΪȫ�����ţ�ȡ��N����Ϊ��ʼȫ�����ţ�  

for i=1:(N-1);  
    if fitness(x(i,:))<fitness(pg)  
        pg=x(i,:);
        
    end  
end
fbest_store = fitness(pg);
xbest_store =[0,pg,fitness(pg)];
display(['0:','xbest=[',num2str(pg),'],fbest=',num2str(fbest_store),']'])

%--------------BAS���ֲ�����ʼ��--------------
c=10;%����������֮�����Ĺ�ϵ
step = 10;%ȡ��ţ���һ������Ĳ���������ʽ
d0 = step/c;
dir=[];


%---------������ѭ�������չ�ʽ���ε���----------  
for t=1:M  %����������
    for i=1:N  %������Ŀ
        
%------��ţ�벿�ֵĲ���---------
        dir(i,:)=rands(1,D);%ͷ��kά�ռ�ĳ����������
        dir(i,:)=dir(i,:)/(eps+norm(dir(i,:)));%����������һ��,����
        xleft(i,:)=x(i,:)+dir(i,:)*d0/2;%�ռ�������λ�����
        fleft(i,:)=fitness(xleft(i,:));%����λ�õĺ���ֵ
        xright(i,:)=x(i,:)-dir(i,:)*d0/2;%����λ��
        fright(i,:)=fitness(xright(i,:));%����λ�ú���ֵ
        force_bas(i,:) = -dir(i,:)*sign(fleft(i,:)-fright(i,:));
        
        
        v(i,:)=w*v(i,:)+c1*rand*(y(i,:)-x(i,:))+c2*rand*(pg-x(i,:))+c3*rand*force_bas(i,:); 
        x(i,:)=x(i,:)+v(i,:);
        if fitness(x(i,:))<p(i)%���¸������  
            p(i)=fitness(x(i,:));  
            y(i,:)=x(i,:);  
        end  
        if p(i)<fitness(pg)%����ȫ�����  
            pg=y(i,:);  
        end  
%           v(i,:)=w*v(i,:)+c1*rand*(y(i,:)-x(i,:))+c2*rand*(pg-x(i,:))+c3*rand*force_bas(i,:); 
%           x(i,:)=x(i,:)+v(i,:);
    end  
    pbest(t)=fitness(pg); 
    %����������ʱ��Ĺ���Ȩ�غ����ѧϰ����
    w = 0.9 - 0.5*t/M;%�������ӵĵ�����ʽ
    c1 = 0.5+2*t/M;
    c2 = 2 - 2*t/M;
    c3 = 3+2*t/M;

    
  
    xbest_store = cat(1,xbest_store,[t,pg,fitness(pg)]);
    fbest_store = cat(1,fbest_store,pbest(t));
    display([num2str(t),':xbest=[',num2str(round(pg)),'],fbest=',num2str(pbest(t))])
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ݿ��ӻ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure,
%clf(1),
plot(xbest_store(:,1),xbest_store(:,end),'k-o')
hold on
grid on
plot(xbest_store(:,1),fbest_store,'k-.')
xlabel('iteration')
ylabel('minimum value')
%title(['initstep0=',num2str(step0)]);
hold on
location=pg; 
fbest = pbest(t);