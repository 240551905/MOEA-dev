%I-DBEA
function MAIN(Problem,M,Run)
clc;format compact;tic;
%-----------------------------------------------------------------------------------------
%�����趨
    [Generations,N,p1,p2] = P_settings('I-DBEA',Problem,M);
%-----------------------------------------------------------------------------------------
%�㷨��ʼ
    %��ʼ������
    Evaluations = Generations*N;
    [N,W] = F_weight(p1,p2,M);
    W(W==0) = 0.000001;
    for i = 1 : N
        W(i,:) = W(i,:)./norm(W(i,:));
    end
    Generations = floor(Evaluations/N);
    
    %��ʼ����Ⱥ
    [Population,Boundary,Coding] = P_objective('init',Problem,M,N);
    FunctionValue = P_objective('value',Problem,M,Population);
    z = min(FunctionValue);
    a = F_intercept(FunctionValue);
    
    %��ʼ����
    for Gene = 1 : Generations
        %��ÿ������ִ�в���
        for i = 1 : N
            %�����Ӵ�
            Offspring = P_generator([Population(i,:);Population(randi([1,N]),:)],Boundary,Coding,1);
            OffFunValue = P_objective('value',Problem,M,Offspring);
            
            %�ж��Ӵ��Ƿ�֧��
            if any(sum(FunctionValue<=repmat(OffFunValue,N,1),2)==M)
                continue;
            end
            
            %���¸���
            for j = randperm(N)
                ScaledFun = (FunctionValue(j,:)-z)./(a-z);
                ScaledOffFun = (OffFunValue-z)./(a-z);
                d1_old = sum(W(j,:).*ScaledFun);
                d2_old = norm(ScaledFun-d1_old*W(j,:));
                d1_new = sum(W(j,:).*ScaledOffFun);
                d2_new = norm(ScaledOffFun-d1_new*W(j,:));
                if d2_new < d2_old || d2_new == d2_old && d1_new < d1_old
                    %���µ�ǰ����
                    Population(j,:) = Offspring;
                    FunctionValue(j,:) = OffFunValue;
                    a = F_intercept(FunctionValue);
                    break;
                end
            end
            
            %�������������
            z = min(z,OffFunValue);
        end

        clc;fprintf('I-DBEA,��%2s��,%5s����,��%2sά,�����%4s%%,��ʱ%5s��\n',num2str(Run),Problem,num2str(M),num2str(round2(Gene/Generations*100,-1)),num2str(round2(toc,-2)));
    end
%----------------------------------------------------------------------------------------- 
%���ɽ��
    P_output(Population,toc,'I-DBEA',Problem,M,Run);
end