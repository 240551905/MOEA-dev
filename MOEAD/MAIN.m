%MOEA/D
function MAIN(Problem,M,Run)
clc;format compact;tic;
%-----------------------------------------------------------------------------------------
%�����趨
    [Generations,N,p1,p2] = P_settings('MOEAD',Problem,M);
    A = 1;	%1.�����б�ѩ�򷽷� 2.����PBI����
%-----------------------------------------------------------------------------------------
%�㷨��ʼ
    %��ʼ������
    Evaluations = Generations*N;
    [N,W] = F_weight(p1,p2,M);
    W(W==0) = 0.000001;
    T = floor(N/10);
    Generations = floor(Evaluations/N);

    %�ھ��ж�
    B = zeros(N);
    for i = 1 : N
        for j = i : N
            B(i,j) = norm(W(i,:)-W(j,:));
            B(j,i) = B(i,j);
        end
    end
    [~,B] = sort(B,2);
    B = B(:,1:T);
    
    %��ʼ����Ⱥ
    [Population,Boundary,Coding] = P_objective('init',Problem,M,N);
    FunctionValue = P_objective('value',Problem,M,Population);
    Z = min(FunctionValue);

    %��ʼ����
    for Gene = 1 : Generations
        %��ÿ������ִ�в���
        for i = 1 : N
            %��һ��
            Fmax = max(FunctionValue);
            Fmin = Z;
            FunctionValue = (FunctionValue-repmat(Fmin,N,1))./repmat(Fmax-Fmin,N,1);
            
            %ѡ����ĸ
            k = randperm(T);
            k = B(i,k(1:2));

            %�����Ӵ�
            Offspring = P_generator([Population(k(1),:);Population(k(2),:)],Boundary,Coding,1);
            OffFunValue = P_objective('value',Problem,M,Offspring);
            OffFunValue = (OffFunValue-Fmin)./(Fmax-Fmin);
            
            %�������������
            Z = min(Z,OffFunValue);

            %�����ھӸ���
            for j = 1 : T
                if A == 1
                    g_old = max(abs(FunctionValue(B(i,j),:)-Z).*W(B(i,j),:));
                    g_new = max(abs(OffFunValue-Z).*W(B(i,j),:));
                elseif A == 2
                    d1 = abs(sum((FunctionValue(B(i,j),:)-Z).*W(B(i,j),:)))/norm(W(B(i,j),:));
                    g_old = d1+5*norm(FunctionValue(B(i,j),:)-(Z+d1*W(B(i,j),:)/norm(W(B(i,j),:))));               
                    d1 = abs(sum((OffFunValue-Z).*W(B(i,j),:)))/norm(W(B(i,j),:));
                    g_new = d1+5*norm(OffFunValue-(Z+d1*W(B(i,j),:)/norm(W(B(i,j),:))));
                end
                if g_new < g_old
                    %���µ�ǰ�����ĸ���
                    Population(B(i,j),:) = Offspring;
                    FunctionValue(B(i,j),:) = OffFunValue;
                end
            end

            %����һ��
            FunctionValue = FunctionValue.*repmat(Fmax-Fmin,N,1)+repmat(Fmin,N,1);

        end
        
        cla;
        P_draw(FunctionValue);
        pause();
        clc;fprintf('MOEA/D,��%2s��,%5s����,��%2sά,�����%4s%%,��ʱ%5s��\n',num2str(Run),Problem,num2str(M),num2str(round2(Gene/Generations*100,-1)),num2str(round2(toc,-2)));
    end
%----------------------------------------------------------------------------------------- 
%���ɽ��
    
    P_output(Population,toc,'MOEAD',Problem,M,Run);
end