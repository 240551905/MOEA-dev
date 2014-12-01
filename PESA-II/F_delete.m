function Del = F_delete(FunctionValue,K,div)
    
    [N,M] = size(FunctionValue);

    %�����������
    fmax = max(FunctionValue);
    fmin = min(FunctionValue);
    d = (fmax-fmin)/div;
    fmin = repmat(fmin,N,1);
    d = repmat(d,N,1);
    GLoc = floor((FunctionValue-fmin)./d);
    GLoc(GLoc>=div) = div-1;

    %ȷ��ÿ���������ڵĸ���
    UniqueGLoc = sortrows(unique(GLoc,'rows'));
    [~,Site] = ismember(GLoc,UniqueGLoc,'rows');

    %����ÿ�����ӵ�ӵ����
    Temp = sortrows(tabulate(Site));
    CrowdG = Temp(:,2);

    %ÿ��ɾȥһ��
    Del = false(1,N);
    while sum(Del) < K
        %ѡ����ĸ���(��ͬʱ�ж��,�����ѡ��һ��)
        maxGrid = find(CrowdG==max(CrowdG));
        Temp = randi([1,length(maxGrid)]);
        Grid = maxGrid(Temp);
        %�������ɾȥһ������
        InGrid = find(Site==Grid);
        Temp = randi([1,length(InGrid)]);
        p = InGrid(Temp);
        Del(p) = true;
        CrowdG(Grid) = CrowdG(Grid)-1;
        Site(p) = NaN;
    end
end

