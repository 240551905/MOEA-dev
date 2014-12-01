%SPEA2
function MAIN(Problem,M,Run)
clc;format compact;tic;
%-----------------------------------------------------------------------------------------
%�����趨
    [Generations,N] = P_settings('SPEA2',Problem,M);
%-----------------------------------------------------------------------------------------
%�㷨��ʼ
    %��ʼ����Ⱥ
    [Population,Boundary,Coding] = P_objective('init',Problem,M,N);
    FunctionValue = P_objective('value',Problem,M,Population);
    FitnessValue = F_fitness(FunctionValue);
    
    %��ʼ����
    for Gene = 1 : Generations
        %�����Ӵ�
        MatingPool = F_mating(Population,FitnessValue);
        Offspring = P_generator(MatingPool,Boundary,Coding,N);
        Population = [Population;Offspring];
        FunctionValue = P_objective('value',Problem,M,Population);
        FitnessValue = F_fitness(FunctionValue);

        %ѡ��
        Next = FitnessValue<1;
        if sum(Next) < N
            [~,Rank] = sort(FitnessValue);
            Next(Rank(1:N)) = true;
        elseif sum(Next) > N
            Del = F_truncation(FunctionValue(Next,:),sum(Next)-N);
            Temp = find(Next);
            Next(Temp(Del)) = false;
        end
        
        %��һ����Ⱥ
        Population = Population(Next,:);
        FitnessValue = FitnessValue(Next);
        
        clc;fprintf('SPEA2,��%2s��,%5s����,��%2sά,�����%4s%%,��ʱ%5s��\n',num2str(Run),Problem,num2str(M),num2str(round2(Gene/Generations*100,-1)),num2str(round2(toc,-2)));
    end
%-----------------------------------------------------------------------------------------     
%���ɽ��
    P_output(Population,toc,'SPEA2',Problem,M,Run);
end
