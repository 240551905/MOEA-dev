%��-MOEA
function MAIN(Problem,M,Run)
clc;format compact;tic;
 %-----------------------------------------------------------------------------------------
 %�����趨
    [Generations,N,epsilon] = P_settings('e-MOEA',Problem,M);
 %-----------------------------------------------------------------------------------------
 %�㷨��ʼ
    %��ʼ����Ⱥ
    [Population,Boundary,Coding] = P_objective('init',Problem,M,N);
    FunctionValue = P_objective('value',Problem,M,Population);
    eFrontValue = P_sort(floor((FunctionValue-repmat(min(FunctionValue,[],1),N,1))/epsilon),'first');
    Archive = Population(eFrontValue==1,:);
    ArchiveFunValue = FunctionValue(eFrontValue==1,:);
    
    %��ʼ����
    for Gene = 1 : Generations
        for i = 1 : N
         	%����һ���Ӵ�
            k = randperm(N);
            Domi = any(FunctionValue(k(1),:)<FunctionValue(k(2),:))-any(FunctionValue(k(1),:)>FunctionValue(k(2),:));
            if Domi == 1
                p = k(1);
            elseif Domi == -1
                p = k(2);
            elseif rand < 0.5
                p = k(1);
            else
                p = k(2);
            end
            q = randi([1,size(Archive,1)]);
            Offspring = P_generator([Population(p,:);Archive(q,:)],Boundary,Coding,1);
            OffFunValue = P_objective('value',Problem,M,Offspring);
            
            %�ж��Ӵ��Ƿ��ܼ�����Ⱥ
            Dominated = find(sum(FunctionValue-repmat(OffFunValue,N,1)<=0,2)==M,1);
            if isempty(Dominated)
                Dominate = find(sum(repmat(OffFunValue,N,1)-FunctionValue<=0,2)==M);
                if ~isempty(Dominate)
                    k = randi([1,length(Dominate)]);
                    Population(Dominate(k),:) = Offspring;
                    FunctionValue(Dominate(k),:) = OffFunValue;
                else
                    k = randi([1,N]);
                    Population(k,:) = Offspring;
                    FunctionValue(k,:) = OffFunValue;
                end
            end
            
            %�ж��Ӵ��Ƿ��ܼ����ⲿ��Ⱥ
            [Archive,ArchiveFunValue] = F_archive(Offspring,OffFunValue,Archive,ArchiveFunValue,epsilon);
        end
        
        clc;fprintf('��-MOEA,��%2s��,%5s����,��%2sά,�����%4s%%,��ʱ%5s��\n',num2str(Run),Problem,num2str(M),num2str(round2(Gene/Generations*100,-1)),num2str(round2(toc,-2)));
    end
%-----------------------------------------------------------------------------------------     
%���ɽ��
    P_output(Archive,toc,'e-MOEA',Problem,M,Run);
end