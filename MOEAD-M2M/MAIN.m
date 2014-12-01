%MOEA/D-M2M
function MAIN(Problem,M,Run)
clc;format compact;tic;
%-----------------------------------------------------------------------------------------
%�����趨
    [Generations,N,H,S] = P_settings('MOEAD-M2M',Problem,M);
%-----------------------------------------------------------------------------------------
%�㷨��ʼ
    %��ʼ������
    Evaluations = Generations*N;
    [N,W] = F_weight(H,M);
    W(W==0) = 0.000001;
    Generations = floor(Evaluations/N/S);
    
    %��ʼ����Ⱥ
    [Population,Boundary] = P_objective('init',Problem,M,N*S);
    FunctionValue = P_objective('value',Problem,M,Population);
    Choose = F_allocation(FunctionValue,W,S);
    Population = Population(Choose,:);

    %��ʼ����
    for Gene = 1 : Generations
        %�����Ӵ�
        R = zeros(N*S,size(Population,2));
        for n = 1 : N
            R((n-1)*S+1:(n-1)*S+S,:) = F_generator(Population((n-1)*S+1:(n-1)*S+S,:),Boundary);
        end
        
        %���¸�����Ⱥ
        Q = [R;Population];
        QFunValue = P_objective('value',Problem,M,Q);
        Choose = F_allocation(QFunValue,W,S);
        Population = Q(Choose,:);
        
        clc;fprintf('MOEA/D-M2M,��%2s��,%5s����,��%2sά,�����%4s%%,��ʱ%5s��\n',num2str(Run),Problem,num2str(M),num2str(round2(Gene/Generations*100,-1)),num2str(round2(toc,-2)));
    end
%----------------------------------------------------------------------------------------- 
%���ɽ��
    P_output(Population,toc,'MOEAD-M2M',Problem,M,Run);
end