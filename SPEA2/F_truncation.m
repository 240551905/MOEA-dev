function Del = F_truncation(FunctionValue,K)
%����ѡ��

    [N,M] = size(FunctionValue);
    
    %������������ľ���
    Distance = zeros(N)+inf;
    for i = 1 : N-1
        for j = i+1 : N
            Distance(i,j) = norm(FunctionValue(i,:)-FunctionValue(j,:));
            Distance(j,i) = Distance(i,j);
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

