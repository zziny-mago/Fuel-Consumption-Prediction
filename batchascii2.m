% batchascii2.m
%
% �Է������� ������ �� ��Ģ
%
%  - ���Ͽ��� ���ںκа� �Բ� 2���� ������ �κ��� �ִ�.
%  - ù��° �����ͺκ��� [Data1]�̶�� ���� �Ʒ��� �ִ�.
%  - �ι�° �����ͺκ��� [Data2]�̶�� ���� �Ʒ��� �ִ�.

% �Է������� �̸��� ����ڷκ��� �޾Ƽ�, �� ������ �б�� ����.
filename = input('Type ascii file name (ex. output3.txt) --> ','s');
fid = fopen(filename,'r'); % open file

% [Data1]�̶�� ���ڰ� ��� �ִ� �κ��� ã�´�.
% �ֳ��ϸ�, file position indicator�� �� �������� �Ű� ���� ���ؼ�
while 1 % infinite loop
    s = fgetl(fid);
    if   isequal(s,'[Data1]')
        break
    end
end
A = fscanf(fid,'%e')

% [Data2]�̶�� ���ڰ� ��� �ִ� �κ��� ã�´�.
% �ֳ��ϸ�, file position indicator�� �� �������� �Ű� ���� ���ؼ�
while 1 % infinite loop
    s = fgetl(fid);
    if   isequal(s,'[Data2]')
        break
    end
end
B = fscanf(fid,'%e')