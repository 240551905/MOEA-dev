function [Offspring,t] = F_generator(p1,p2,MaxValue,MinValue,t)
%����,�������һ���Ӵ�

    D = length(p1);
    
    %�Ŵ���������
    ProM = 1/D;     %�������
    DisC = 20;     	%�������
    DisM = 20;     	%�������
    tic
    %ģ������ƽ���
    beta = zeros(1,D);
    miu = rand(1,D);
    beta(miu<=0.5) = (2*miu(miu<=0.5)).^(1/(DisC+1));
    beta(miu>0.5) = (2-2*miu(miu>0.5)).^(-1/(DisC+1));
    beta = beta.*(-1).^randi([0,1],1,D);
    Offspring = (p1+p2)./2+beta.*(p1-p2)./2;
    t(1)=t(1)+toc;
    tic
    %����ʽ����
    k = rand(1,D);
    miu = rand(1,D);
    Temp = (k<=ProM & miu<0.5);
    Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*((2.*miu(Temp)+(1-2.*miu(Temp)).*(1-(Offspring(Temp)-MinValue(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1))-1);
    Temp = (k<=ProM & miu>=0.5);
    Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*(1-(2.*(1-miu(Temp))+2.*(miu(Temp)-0.5).*(1-(MaxValue(Temp)-Offspring(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1)));        
    t(2)=t(2)+toc;
    %Խ�紦��
    Offspring(Offspring>MaxValue) = MaxValue(Offspring>MaxValue);
    Offspring(Offspring<MinValue) = MinValue(Offspring<MinValue);
end