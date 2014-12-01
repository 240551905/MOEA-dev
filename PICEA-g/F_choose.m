function [Choose,GChoose] = F_choose(FunctionValue,Goal,FrontValue)
%����ѡ��,�ȼ�����Ӧ��ֵ��ѡ��һ��ĸ�����Ŀ���
   
    [N,M] = size(FunctionValue);
    NGoal = size(Goal,1);

    %����ng
    FdG = false(N,NGoal);
    dG = zeros(1,NGoal);
    for i = 1 : N
        x = sum(repmat(FunctionValue(i,:),NGoal,1)-Goal<=0,2)==M;
        FdG(i,x) = true;
        dG(x) = dG(x)+1;
    end
    
    %����Fs
    Fs = zeros(1,N);
    for i = 1 : N
        Fs(i) = sum(1./dG(FdG(i,:)));
    end
    
    %����Fg
    Fg = zeros(1,NGoal);
    for i = 1 : NGoal
        if dG(i) == 0
            Fg(i) = 0.5;
        else
            Fg(i) = 1/(1+(dG(i)-1)/(N-1));
        end
    end   
    
    %ѡ��һ�����
    NF = find(FrontValue==1);
    if length(NF) < N/2
        Fs(NF) = inf;
        [~,Rank] = sort(Fs,'descend');
        Choose = Rank(1:N/2);
    else
        [~,Rank] = sort(Fs(NF),'descend');
        Choose = NF(Rank(1:N/2));
    end
    
    %ѡ��һ��Ŀ���
    [~,Rank] = sort(Fg,'descend');
    GChoose = Rank(1:NGoal/2);
end

