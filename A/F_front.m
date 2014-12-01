function FrontValue = F_front(FunctionValue,FrontValue,DomiRelation,OffFunValue,OffDomi)
%��һ���¸���������������Ⱥ��

    FunctionValue = [FunctionValue;OffFunValue];
    FrontValue = [FrontValue,0];
    DomiRelation = [[DomiRelation;OffDomi'==1],[OffDomi==-1;false]];
    N = size(FunctionValue,1);
    
    %�����¸���������
    Move = false(1,N);
    f = 1;
    while true
        if ~any(DomiRelation(FrontValue==f,end))
            Move(N) = true;
            break;
        end
        f = f+1;
    end
    
    %���κ��Ʊ�֧��ĸ���
    while any(Move)
        NextMove = sum(DomiRelation(Move,:),1)>0 & FrontValue==f;
        FrontValue(Move) = f;
        Move = NextMove;
        f = f+1;
    end
end

