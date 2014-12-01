function Del = F_truncation(FunctionValue,K)
%����ѡ��

    [N,M] = size(FunctionValue);
    
    %������������ľ���
    Distance = zeros(N)+inf;
    for i = 1 : N
        ShiftFunctionValue = FunctionValue;
        Temp = repmat(FunctionValue(i,:),N,1);
        Shifted = FunctionValue<Temp;
        ShiftFunctionValue(Shifted) = Temp(Shifted);
        for j = [1:i-1,i+1:N]
            Distance(i,j) = norm(FunctionValue(i,:)-ShiftFunctionValue(j,:));
        end
    end
    
    %�ض�
    Del = false(1,N);
    while sum(Del) < K
        Remain = find(~Del);
        Temp = sort(Distance(Remain,Remain),2);
        [~,Rank] = sortrows(Temp);
        Del(Remain(Rank(1))) = true;
    end
end

