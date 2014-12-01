function Choose = F_choose(FunctionValue,K,RefPoint,NoSample)
%����ѡ��,����HV���׶�ѡ��������Ѹ���

    [N,M] = size(FunctionValue);
    Choose = ones(1,N);
    
    %ÿ�ε���ȥ�����׶���С��һ������
    while sum(Choose) > K
        Remain = find(Choose==1);
        %3ά������ʱ���ù����㷨
        if M > 2           
            Points = FunctionValue(Remain,:);
            NoP = size(Points,1);
            k = NoP-K;
            F = zeros(1,NoP);
            alpha = zeros(1,NoP); 
            for i = 1 : k 
                alpha(i) = prod((k-[1:i-1])./(NoP-[1:i-1]))./i; 
            end
            MinValue = min(Points,[],1);
            S = rand(NoSample,M).*repmat(RefPoint-MinValue,NoSample,1)+repmat(MinValue,NoSample,1);
            PdS = false(NoP,NoSample);
            dS = zeros(1,NoSample);
            for i = 1 : NoP
                x = sum(repmat(Points(i,:),NoSample,1)-S<=0,2)==M;
                PdS(i,x) = true;
                dS(x) = dS(x)+1;
            end
            for i = 1 : NoP
                F(i) = sum(alpha(dS(PdS(i,:))));
            end     
        %2άʱ���þ�ȷ�㷨
        else
            F = F_HyperExact(FunctionValue(Remain,:),RefPoint,3);
        end
        [~,del] = min(F);
        Choose(Remain(del)) = 0;
    end
    Choose = find(Choose==1);
end

