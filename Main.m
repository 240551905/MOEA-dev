%������
function Main()
clc;format short;addpath public;
    
    %�㷨����
    Algorithm = {'NSGA-II'};
    %��������
    Problem = {'DTLZ2'};
    %����ά��
    Objectives = 2;

    %��������
    Start(Algorithm,Problem,Objectives);
end
