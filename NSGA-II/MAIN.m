%NSGA-II
function MAIN(Problem,M,Run)
clc;format compact;tic;
%-----------------------------------------------------------------------------------------
%�����趨
    [Generations,N] = P_settings('NSGA-II',Problem,M);
	FrontColor = ['ro';'bo';'go';'ko';'r^';'g^';'b^';'k^';'r*';'g*';'b*';'k*';'r>';'g>';'b>';'k>';'r<';'g<';'b<';'k<';'rv';'gv';'bv';'kv'];
%-----------------------------------------------------------------------------------------
%�㷨��ʼ
    %��ʼ����Ⱥ
    [Population,Boundary,Coding] = P_objective('init',Problem,M,N);
    FunctionValue = P_objective('value',Problem,M,Population);
    %This is for test -----Start
    Seq = zeros(size(FunctionValue));
    for i = 1 : M
        [~,tmp] = sort(FunctionValue(:,i));
        [~,Seq(:,i)] = sort(tmp);
    end
    %this is for test -----Start
    FrontValue = P_sort(FunctionValue);
    CrowdDistance = F_distance(FunctionValue,FrontValue);
    
    %��ʼ����
    for Gene = 1 : Generations    
        %�����Ӵ�
        MatingPool = F_mating(Population,FrontValue,CrowdDistance);
        Offspring = P_generator(MatingPool,Boundary,Coding,N);
        Population = [Population;Offspring];
        FunctionValue = P_objective('value',Problem,M,Population);
        [FrontValue,MaxFront] = P_sort(FunctionValue,'half');
        CrowdDistance = F_distance(FunctionValue,FrontValue);

        
        %ѡ����֧��ĸ���        
        Next = zeros(1,N);
        NoN = numel(FrontValue,FrontValue<MaxFront);
        Next(1:NoN) = find(FrontValue<MaxFront);
        
        %ѡ�����һ����ĸ���
        Last = find(FrontValue==MaxFront);
        [~,Rank] = sort(CrowdDistance(Last),'descend');
        Next(NoN+1:N) = Last(Rank(1:N-NoN));
        
        %��һ����Ⱥ
        Population = Population(Next,:);
        FrontValue = FrontValue(Next);
        CrowdDistance = CrowdDistance(Next);
        
		FunctionValue = P_objective('value',Problem,M,Population);
		cla;
		for i = 1 : MaxFront
			FrontCurrent = find(FrontValue==i);
			P_draw(FunctionValue(FrontCurrent,:),FrontColor(i,:));
			pause();
		end
	%	pause();
        %This is for test
%        if Gene == floor(Generations / 2)
%            %This is for test -----Start
%            Seq2 = zeros(size(FunctionValue));
%            for i = 1 : M
%                [~,tmp] = sort(FunctionValue(:,i));
%                [~,Seq2(:,i) ]= sort(tmp);
%            end
%            %this is for test -----Start
%        end
        %End Test
        clc;fprintf('NSGA-II,��%2s��,%5s����,��%2sά,�����%4s%%,��ʱ%5s��\n',num2str(Run),Problem,num2str(M),num2str(round2(Gene/Generations*100,-1)),num2str(round2(toc,-2)));
    end
	%-----------------------------------------------------------------------------------------     
    %Seq3 = zeros(size(FunctionValue));
    %for i = 1 : M
    %    [~,tmp] = sort(FunctionValue(:,i));
    %    [~,Seq3(:,i)] = sort(tmp);
    %end
%���ɽ��
    P_output(Population,toc,'NSGA-II',Problem,M,Run);
end
