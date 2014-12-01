%PESA-II
function MAIN(Problem,M,Run)
clc;format compact;tic;
%-----------------------------------------------------------------------------------------
%�����趨
    [Generations,N,div] = P_settings('PESA-II',Problem,M);
%-----------------------------------------------------------------------------------------
%�㷨��ʼ
    %��ʼ����Ⱥ
    [Population,Boundary,Coding] = P_objective('init',Problem,M,N);
    FunctionValue = P_objective('value',Problem,M,Population);
    
    %��ʼ����
    for Gene = 1 : Generations
        %�����Ӵ�
        MatingPool = F_mating(Population,FunctionValue,N,div);
        Offspring = P_generator(MatingPool,Boundary,Coding,N);
        Population = [Population;Offspring];
        FunctionValue = P_objective('value',Problem,M,Population);
        FrontValue = P_sort(FunctionValue,'first');
        
        %ѡ����֧�����
        Next = FrontValue==1;
        
        %�ü�
        if sum(Next) > N
            Del = F_delete(FunctionValue(Next,:),sum(Next)-N,div);
            Temp = find(Next);
            Next(Temp(Del)) = false;
        end
        
        %��һ����Ⱥ
        Population = Population(Next,:);
        FunctionValue = FunctionValue(Next,:);
        
        clc;fprintf('PESA-II,��%2s��,%5s����,��%2sά,�����%4s%%,��ʱ%5s��\n',num2str(Run),Problem,num2str(M),num2str(round2(Gene/Generations*100,-1)),num2str(round2(toc,-2)));
    end
%-----------------------------------------------------------------------------------------     
%���ɽ��
    P_output(Population,toc,'PESA-II',Problem,M,Run);
end
