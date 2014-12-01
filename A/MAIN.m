%A New MOEA Based on Individual Replacement
function MAIN(Problem,M,Run)
clc;format compact;tic;
%-----------------------------------------------------------------------------------------
%�����趨
    [Generations,N] = P_settings('A',Problem,M);
%-----------------------------------------------------------------------------------------
%�㷨��ʼ
    %��ʼ����Ⱥ
    [Population,Boundary,Coding] = P_objective('init',Problem,M,N);
    FunctionValue = P_objective('value',Problem,M,Population);
    FrontValue = P_sort(FunctionValue);
    [DistanceDirect,DistanceMaped] = F_distance(FunctionValue,FunctionValue);
    DistanceDirect(logical(eye(N))) = inf;
    DistanceMaped(logical(eye(N))) = inf;

    %��¼֧���ϵ
    DomiRelation = false(N);
    for i = 1 : N-1
        for j = i+1 : N
            k = any(FunctionValue(i,:)<FunctionValue(j,:)) - any(FunctionValue(i,:)>FunctionValue(j,:));
            if k == 1
                DomiRelation(i,j) = true;
            elseif k == -1
                DomiRelation(j,i) = true;
            end
        end
    end

    %��ʼ����
    for Gene = 1 : Generations
        %ÿ�ξֲ�������һ������
        for i = 1 : N
            %��һ��
            Fmax = max(FunctionValue);
            Fmin = min(FunctionValue);
            FunctionValue = (FunctionValue-repmat(Fmin,N,1))./repmat(Fmax-Fmin,N,1);

            %�����Ӵ�
            k = randperm(N);
            if FrontValue(k(1)) < FrontValue(k(2))
                p = k(1);
            elseif FrontValue(k(1)) > FrontValue(k(2))
                p = k(2);
            elseif mean(FunctionValue(k(1),:)) < mean(FunctionValue(k(2),:))
                p = k(1);
            else
                p = k(2);
            end
            if min(DistanceMaped(k(3),:)) > min(DistanceMaped(k(4),:))
                q = k(3);
            else
                q = k(4);
            end
            Offspring = P_generator([Population(p,:);Population(q,:)],Boundary,Coding,1);
            OffFunValue = P_objective('value',Problem,M,Offspring);
            OffFunValue = (OffFunValue-Fmin)./(Fmax-Fmin);

            %�ж�֧���ϵ
            OffDomi = any(repmat(OffFunValue,N,1)<FunctionValue,2) - any(repmat(OffFunValue,N,1)>FunctionValue,2);
            NewFront = F_front(FunctionValue,FrontValue,DomiRelation,OffFunValue,OffDomi);

            %�������
            [OffDisDirect,OffDisMaped] = F_distance(OffFunValue,FunctionValue);            
            
            %�ж��Ƿ����
            instead = false;
            if NewFront(end) < max(NewFront)
                Temp = find(NewFront>NewFront(end));
                [~,q] = min(min(DistanceMaped(Temp,:),[],2));
                q = Temp(q);
                OffDisMaped(q) = inf;
                OffDisDirect(q) = inf;
                FrontValue = NewFront(1:end-1);
                FrontValue(q) = NewFront(end);
                OffDomi(q) = 0;
                DomiRelation(q,:) = OffDomi'==1;
                DomiRelation(:,q) = OffDomi==-1;
                instead = true;
            elseif NewFront(end) > 1 && NewFront(end) == max(NewFront)
            else
                rank = sort(min(DistanceDirect,[],2),'descend');
                if min(min(DistanceDirect,[],2)) < mean(rank(1:M))/2
                    [~,q] = min(min(DistanceDirect,[],2));
                    OffDisMaped(q) = inf;
                    OffDisDirect(q) = inf;
                    if min(OffDisDirect) > min(DistanceDirect(q,:))
                        instead = true;
                    end
                else
                    [~,q] = min(OffDisDirect);
                    OffDisMaped(q) = inf;
                    OffDisDirect(q) = inf;
                    if mean(OffFunValue) < mean(FunctionValue(q,:)) && min(OffDisDirect) > min(DistanceDirect(q,:))
                        instead = true;
                    end
                end
            end

            %���
            if instead
                Population(q,:) = Offspring;
                FunctionValue(q,:) = OffFunValue;
                DistanceMaped(q,:) = OffDisMaped;
                DistanceMaped(:,q) = OffDisMaped';
                DistanceDirect(q,:) = OffDisDirect;
                DistanceDirect(:,q) = OffDisDirect';
            end

            %����һ��
            FunctionValue = FunctionValue.*repmat(Fmax-Fmin,N,1)+repmat(Fmin,N,1);
        end
        
        clc;fprintf('A,��%2s��,%5s����,��%2sά,�����%4s%%,��ʱ%5s��\n',num2str(Run),Problem,num2str(M),num2str(round2(Gene/Generations*100,-1)),num2str(round2(toc,-2)));
    end
%-----------------------------------------------------------------------------------------     
%���ɽ��
    P_output(Population,toc,'A2',Problem,M,Run);
end