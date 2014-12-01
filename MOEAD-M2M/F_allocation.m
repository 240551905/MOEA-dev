function Choose = F_allocation(FunctionValue,W,S)
%��������䵽����Ⱥ

    [N,M] = size(W);
    NoF = size(FunctionValue,1);

    %����ÿ������������Ȩֵ����
    Cos = zeros(N,NoF);
    for i = 1 : N
        for j = 1 : NoF
            Cos(i,j) = W(i,:)*FunctionValue(j,:)'/norm(W(i,:))/norm(FunctionValue(j,:));
        end
    end
    [~,Belong] = max(Cos,[],1);
    
    %����Ⱥ����
    Choose = zeros(1,N*S);
    Choosed = false(1,NoF);
    for i = 1 : N
        P = find(~Choosed & Belong==i);
        if length(P) < S
            Remain = find(~Choosed & Belong~=i);
            k = randperm(length(Remain));
            P = [P,Remain(k(1:S-length(P)))];
        elseif length(P) > S
            PFrontValue = P_sort(FunctionValue(P,:));
            [~,Rank] = sort(PFrontValue,'descend');
            P(Rank(1:length(P)-S)) = [];
        end
        Choose((i-1)*S+1:(i-1)*S+S) = P;
        Choosed(P) = true;
    end
end

