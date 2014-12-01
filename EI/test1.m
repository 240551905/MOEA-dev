function test1()
%�ֲ�����Ѱ�Ҷ�ά�ķ�֮һԲƽ��̬
    N=100; %������
    generation = 200;
    x=rand(N,1)*pi/2;%�������������ȷֲ���������һ����ʼ״̬
    r0=[cos(x),sin(x)];
    v0=zeros(size(r0));
    G=1e-5;%�����������������ֵ�Ƚϲ���
    
    h=plot(r0(:,1),r0(:,2),'o');hold on;%�����
    axis equal;
    axis([0 1 0 1]);

    for gen = 1 : generation
        [rn,vn]=countnext(r0,v0,G);%����״̬
        r0=rn;v0=vn;
        set(h,'xdata',rn(:,1),'ydata',rn(:,2));
        pause();
        drawnow;
    end
end

function [rn vn]=countnext(r,v,G) %����״̬�ĺ���
%r���ÿ���x��y��z���ݣ�v���ÿ����ٶ�����
num=size(r,1);
dd=zeros(2,num,num); %������ʸ����
for m=1:num-1
    for n=m+1:num
        dd(:,m,n)=(r(m,:)-r(n,:))';
        dd(:,n,m)=-dd(:,m,n);
    end
end
L=sqrt(sum(dd.^2,1));%�����ľ���
L(L<1e-2)=1e-2; %�����С�޶�
F=sum(dd./repmat(L.^3,[2 1 1]),3)';%�������

Fr=r.*repmat(dot(F,r,2),[1 2]); %��������������
Fv=F-Fr; %�������

rn=r+v;  %��������
rn(rn<0) = 0;
rn(rn>1) = 1;
rn=rn./repmat(sqrt(sum(rn.^2,2)),[1 2]);
vn=v+G*Fv;%�����ٶ�
end