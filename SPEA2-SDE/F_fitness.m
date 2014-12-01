function FitnessValue = F_fitness(FunctionValue)

    [N,M] = size(FunctionValue);

    %�������������֧���ϵ
    Dominate = false(N);
    for i = 1 : N-1
        for j = i+1 : N
            k = any(FunctionValue(i,:)<FunctionValue(j,:))-any(FunctionValue(i,:)>FunctionValue(j,:));
            if k == 1
                Dominate(i,j) = true;
            elseif k == -1
                Dominate(j,i) = true;
            end
        end
    end
    
    %����S(i)
    S = sum(Dominate,2);
    
    %����R(i)
    R = zeros(1,N);
    for i = 1 : N
        R(i) = sum(S(Dominate(:,i)));
    end
    
    %������������ľ���
    Distance = zeros(N);
    for i = 1 : N
        ShiftFunctionValue = FunctionValue;
        Temp = repmat(FunctionValue(i,:),N,1);
        Shifted = FunctionValue<Temp;
        ShiftFunctionValue(Shifted) = Temp(Shifted);
        for j = [1:i-1,i+1:N]
            Distance(i,j) = norm(FunctionValue(i,:)-ShiftFunctionValue(j,:));
        end
    end
    
    %����D(i)
    Distance = sort(Distance,2);
    D = 1./(Distance(:,floor(sqrt(N)))+2);
    
    %������Ӧ��ֵ
    FitnessValue = R+D';
end

