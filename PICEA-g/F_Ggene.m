function NewGoal = F_Ggene(FunctionValue,NGoal)
%������Ⱥ����ֵ����ָ������Ŀ��㼯

    Gmax = max(FunctionValue,[],1)*1.2;
    Gmin = min(FunctionValue,[],1);
    NewGoal = rand(NGoal,size(FunctionValue,2)).*(repmat(Gmax-Gmin,NGoal,1))+repmat(Gmin,NGoal,1);
end

