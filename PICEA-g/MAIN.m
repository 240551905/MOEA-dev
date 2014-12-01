%PICEA-g
function MAIN(Problem,M,Run)
clc;format compact;tic;
%-----------------------------------------------------------------------------------------
%�����趨
    [Generations,N,NGoal] = P_settings('PICEA-g',Problem,M);
%-----------------------------------------------------------------------------------------
%�㷨��ʼ
    %��ʼ����Ⱥ
    [Population,Boundary,Coding] = P_objective('init',Problem,M,N);
    FunctionValue = P_objective('value',Problem,M,Population);
    Goal = F_Ggene(FunctionValue,NGoal);
    
    %��ʼ����
    for Gene = 1 : Generations
        %�����Ӵ�
        MatingPool = F_mating(Population);
        Offspring = P_generator(MatingPool,Boundary,Coding,N);
        Population = [Population;Offspring];
        FunctionValue = P_objective('value',Problem,M,Population);
        Goal = [Goal;F_Ggene(FunctionValue,NGoal)];
        FrontValue = P_sort(FunctionValue,'first');
        
        %����ѡ��
        [Next,GChoose] = F_choose(FunctionValue,Goal,FrontValue);
        
        %��һ����Ⱥ
        Population = Population(Next,:);
        Goal = Goal(GChoose,:);

        clc;fprintf('PICEA-g,��%2s��,%5s����,��%2sά,�����%4s%%,��ʱ%5s��\n',num2str(Run),Problem,num2str(M),num2str(round2(Gene/Generations*100,-1)),num2str(round2(toc,-2)));
    end
%-----------------------------------------------------------------------------------------     
%���ɽ��
    P_output(Population,toc,'PICEA-g',Problem,M,Run);
end