function MAIN()
% This is for testing the distribution
N=200; %������
a=rand(N,1)*pi/2;%�������������ȷֲ���������һ����ʼ״̬
b=asin(rand(N,1));
r0=[cos(a).*cos(b),sin(a).*cos(b),sin(b)];
v0=zeros(size(r0));
G=1e-5;%�����������������ֵ�Ƚϲ���

h=plot3(r0(:,1),r0(:,2),r0(:,3),'o');hold on;%�����
axis equal;
axis([0 1 0 1 0 1]);

for ii=1:1000%ģ��200����һ���Ѿ��������ӵ��ж�������ʵ������֮ǰ�˳�
    [rn,vn]=countnext(r0,v0,G);%����״̬
    r0=rn;v0=vn;
    set(h,'xdata',rn(:,1),'ydata',rn(:,2),'zdata',rn(:,3));
    pause();
    drawnow;
end
% dt = DelaunayTri(rn);  %����Delaunay���㻮��Ϊ�ռ�4����
% [ch] = convexHull(dt); %����convexHull��͹�������͹�����
% trisurf(ch,rn(:,1),rn(:,2),rn(:,3),'FaceColor','c');%��͹����������
hold off;
end

function [rn vn]=countnext(r,v,G) %����״̬�ĺ���
%r���ÿ���x��y��z���ݣ�v���ÿ����ٶ�����
num=size(r,1);
dd=zeros(3,num,num); %������ʸ����
for m=1:num-1
    for n=m+1:num
        dd(:,m,n)=(r(m,:)-r(n,:))';
        dd(:,n,m)=-dd(:,m,n);
    end
end
L=sqrt(sum(dd.^2,1));%�����ľ���
L(L<1e-2)=1e-2; %�����С�޶�
F=sum(dd./repmat(L.^3,[3 1 1]),3)';%�������

Fr=r.*repmat(dot(F,r,2),[1 3]); %��������������
Fv=F-Fr; %�������

rn=r+v;  %��������
rn(rn<0) = 0;
rn(rn>1) = 1;
rn=rn./repmat(sqrt(sum(rn.^2,2)),[1 3]);
vn=v+G*Fv;%�����ٶ�
end