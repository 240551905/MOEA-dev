function MatingPool = F_mating(Population,FunctionValue,N,div)
%�����ѡ��

    [NoP,D] = size(Population);
    
    %�����������
    fmax = max(FunctionValue);
    fmin = min(FunctionValue);
    d = (fmax-fmin)/div;
    fmin = repmat(fmin,NoP,1);
    d = repmat(d,NoP,1);
    GLoc = floor((FunctionValue-fmin)./d);
    GLoc(GLoc>=div) = div-1;
    
    %ȷ��ÿ���������ڵĸ���
    UniqueGLoc = sortrows(unique(GLoc,'rows'));
    [~,Site] = ismember(GLoc,UniqueGLoc,'rows');
    
    %����ÿ�����ӵ�ӵ����
    Temp = sortrows(tabulate(Site));
    CrowdG = Temp(:,2);
    
    %��Ԫ����ѡ��
    MatingPool = zeros(N,D);
    for i = 1 : 2 : N
        %ѡ��ĸ
        k = zeros(1,2);
        for j = 1 : 2
            Temp = randi([1,size(UniqueGLoc,1)],1,2);
            if CrowdG(Temp(1)) < CrowdG(Temp(2))
                Grid = Temp(1);
            else
                Grid = Temp(2);
            end
            InGrid = find(Site==Grid);
            Temp = randi([1,length(InGrid)]);
            k(j) = InGrid(Temp);
        end
        MatingPool(i,:) = Population(k(1),:);
        MatingPool(i+1,:) = Population(k(2),:);
    end
end

