%GrEA
function MAIN(Problem,M,Run)
clc;format compact;tic;
 %-----------------------------------------------------------------------------------------
 %�����趨
    [Generations,N,div] = P_settings('GrEA',Problem,M);
 %-----------------------------------------------------------------------------------------
 %�㷨��ʼ
    %��ʼ����Ⱥ
    [Population,Boundary,Coding] = P_objective('init',Problem,M,N);
    FunctionValue = P_objective('value',Problem,M,Population);

    %��ʼ����
    for Gene = 1 : Generations
        %�����Ӵ�
        MatingPool = F_mating(Population,FunctionValue,div);
        Offspring = P_generator(MatingPool,Boundary,Coding,N);
        Population = [Population;Offspring];
        FunctionValue = P_objective('value',Problem,M,Population);
        [FrontValue,MaxFront] = P_sort(FunctionValue,'half');
        
        %ѡ��ǰ������ĸ���     
        Next = zeros(1,N);
        NoN = numel(FrontValue,FrontValue<MaxFront);
        Next(1:NoN) = find(FrontValue<MaxFront);
        
        %ѡ�����һ����ĸ���
        Last = find(FrontValue==MaxFront);
        Choose = F_choose(FunctionValue(Last,:),N-NoN,div);
        Next(NoN+1:N) = Last(Choose);
        
        %��һ����Ⱥ
        Population = Population(Next,:);
        FunctionValue = FunctionValue(Next,:);
        
        cla;
        P_draw(FunctionValue);
        pause();
        
        clc;fprintf('GrEA,��%2s��,%5s����,��%2sά,�����%4s%%,��ʱ%5s��\n',num2str(Run),Problem,num2str(M),num2str(round2(Gene/Generations*100,-1)),num2str(round2(toc,-2)));
    end
%-----------------------------------------------------------------------------------------     
%���ɽ��
    P_output(Population,toc,'GrEA',Problem,M,Run);
end