function NewPopulation = F_generator(Population,Boundary)
%����,���첢�����µ�����Ⱥ

    [N,D] = size(Population);
    
    %�Ŵ���������
    ProM = 1/D;     %�������
    DisC = 20;     	%�������
    DisM = 20;     	%�������
    
    %ģ������ƽ���
    NewPopulation = zeros(N,D);
    for i = 1 : N
        k = randi([1,N-1]);
        if k >= i
            k = k+1;
        end
        beta = zeros(1,D);
        miu = rand(1,D);
        beta(miu<=0.5) = (2*miu(miu<=0.5)).^(1/(DisC+1));
        beta(miu>0.5) = (2-2*miu(miu>0.5)).^(-1/(DisC+1));
        beta = beta.*(-1).^randi([0,1],1,D);
        NewPopulation(i,:) = (Population(i,:)+Population(k,:))./2+beta.*(Population(i,:)-Population(k,:))./2;
    end
    
    %����ʽ����
    MaxValue = repmat(Boundary(1,:),N,1);
    MinValue = repmat(Boundary(2,:),N,1);
    k = rand(N,D);
    miu = rand(N,D);
    Temp = (k<=ProM & miu<0.5);
    NewPopulation(Temp) = NewPopulation(Temp)+(MaxValue(Temp)-MinValue(Temp)).*((2.*miu(Temp)+(1-2.*miu(Temp)).*(1-(NewPopulation(Temp)-MinValue(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1))-1);
    Temp = (k<=ProM & miu>=0.5);
    NewPopulation(Temp) = NewPopulation(Temp)+(MaxValue(Temp)-MinValue(Temp)).*(1-(2.*(1-miu(Temp))+2.*(miu(Temp)-0.5).*(1-(MaxValue(Temp)-NewPopulation(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1)));        
    
    %Խ�紦��
    NewPopulation(NewPopulation>MaxValue) = MaxValue(NewPopulation>MaxValue);
    NewPopulation(NewPopulation<MinValue) = MinValue(NewPopulation<MinValue);
end