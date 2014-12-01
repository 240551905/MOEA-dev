%HypE
function MAIN(Problem,M,Run)
clc;format compact;tic;
%-----------------------------------------------------------------------------------------
%�����趨
    [Generations,N,NoSample] = P_settings('HypE',Problem,M);
%-----------------------------------------------------------------------------------------    
    %��ʼ����Ⱥ
    [Population,Boundary,Coding] = P_objective('init',Problem,M,N);
    FunctionValue = P_objective('value',Problem,M,Population);
    RefPoint = zeros(1,M)+max(FunctionValue)*1.2;
    
    %��ʼ����
    for Gene = 1 : Generations
        %�����Ӵ�
        MatingPool = F_mating(Population,FunctionValue,RefPoint,NoSample);
        Offspring = P_generator(MatingPool,Boundary,Coding,N);
        Population = [Population;Offspring];
        FunctionValue = P_objective('value',Problem,M,Population);
        [FrontValue,MaxFront] = P_sort(FunctionValue,'half');
        
        %ѡ����֧��ĸ���        
        Next = zeros(1,N);
        NoN = numel(FrontValue,FrontValue<MaxFront);
        Next(1:NoN) = find(FrontValue<MaxFront);
        
        %ѡ�����һ����ĸ���
        Last = find(FrontValue==MaxFront);
        Choose = F_choose(FunctionValue(Last,:),N-NoN,RefPoint,NoSample);
        Next(NoN+1:N) = Last(Choose);
        
        %��һ����Ⱥ
        Population = Population(Next,:);
        FunctionValue = FunctionValue(Next,:);

        clc;fprintf('HypE,��%2s��,%5s����,��%2sά,�����%4s%%,��ʱ%5s��\n',num2str(Run),Problem,num2str(M),num2str(round2(Gene/Generations*100,-1)),num2str(round2(toc,-2)));
    end
%-----------------------------------------------------------------------------------------
%���ɽ��
    P_output(Population,toc,'HypE',Problem,M,Run);
end

