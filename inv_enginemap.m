function [throttle1] = inv_enginemap(rpm,throttle,torque,rpm1,torque1)

% function [throttle1] = inv_enginemap(rpm,throttle,torque,rpm1,torque1)
%
% �� �Լ��� �������� 2D Lookup Table ���·� �־����� ��,������ inverse ������ Ǭ��
%
% known: rpm1, torque1
% unknown: throttle1
%
% �� ������ rpm�� �־����� (=rpm1), ���ϴ� ���� ��� ��ũ�� �־����� �� (= torque1),
% �̷��� ��� ��ũ�� �� �� �ִ� throttle�� (= throttle1)�� �����ִ� �Լ�
%
%%%% �Է� %%%%
% rpm: 2D �������� rpm�� ���� (���� nx)
% throttle: 2D �������� throttle�� ���� (���� ny)
% torque: 2D �������� torque�� ��� (ny-by-nx)
% rpm1: ���� rpm�� (��Į��)
% torque1: ����ϴ� torque�� (��Į��)
%
%%%% ��� %%%%
% throttle1: ������ rpm��(= rpm1)����, ���ϴ� ������ũ(= torque1)�� ���� ����
%            throttle�� (rpm1�̳� torque1�� �������� ������ ����� NaN�� �ش�)
%
%%%% ���� ��� %%%%
% �� �Լ��� ��� throttle1�� �´��� Ȯ���ϱ� ���� �Ʒ��� ���� �ؼ� ���� torque2��
% �� �Լ��� �Է����� ���� torque1�� ������ Ȯ���ϸ� �ȴ�.
%
% torque2 = interp2(rpm,throttle,torque,rpm1,throttle1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% torque1�� 0�̸� throttle1�� 0���� ���� �Լ��� �����Ѵ�.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( torque1 < 1e-10 )
    throttle1 = 0;
    close all
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rpm1�� rpm�� �ּҰ����� �۰ų� �ִ밪���� ũ�� throttle1�� NaN�� �ְ�, �Լ� ����.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( rpm1 < rpm(1) ) | (rpm1 > rpm(end) ) 
    throttle1 = NaN;
    close all
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �־��� rpm ������ ���� �߿��� rpm1�� �����ϴ� ������ ã�´�.
% rpm(iL) <= rpm1 < rpm(iU)
% (�� ������ ������ �ɸ��� ��쿡�� rpm(iL) < rpm1 <= rpm(iU))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if abs(rpm1 - rpm(end)) < 1e-10  % rpm1�� rpm�� ������ ���� ���� ���
    iU = length(rpm);
else
    iU = 1;
    while ( rpm(iU) <= rpm1 ) % equal�� ���� ����.
        iU = iU + 1;
    end
end
iL = iU - 1;

rpmL = rpm(iL);
rpmU = rpm(iU);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rpm1 ������ �־��� throttle ���� �������� torque����(= torqueN)�� ���Ѵ�.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

diffL = rpm1 - rpmL;
diffU = rpmU - rpm1;

torqueL = torque(:,iL);
torqueU = torque(:,iU);
torqueN = torqueL + diffL/(diffL+diffU)*(torqueU - torqueL);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% throttle�� ���� torqueN�� �Լ����踦 �̿�, interpolation�� ���� throttle1�� ���Ѵ�.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

throttleN = throttle;

% interpolation�� �ϱ� ���� torqueN ���� �պκп� 0�� �Ѱ����� ���� ������ �Ѱ���
% ���ܳ��ƾ� �Ѵ�. (���� ������ �ִ� �����ʿ����� �ִ� 3������ ����)
nzero = sum( torqueN == 0 );
if ( nzero > 1 )
    torqueN = torqueN(nzero:end);
    throttleN = throttleN(nzero:end);
end

throttle1 = interp1(torqueN,throttleN,torque1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot. ���ظ� ���� ���� �κ����� ���߿� ���� ����.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
plot(rpm,torque,'.-')
legend(num2str(throttle'))
hold on

xlabel([ 'rpm1 = ' , num2str(rpm1) , ', torque1 = ' , num2str(torque1) ])
plot(rpm1*ones(size(torqueN)),torqueN,'o-')
plot(rpm1,torque1,'*')
title([ 'throttle1 = ' , num2str(throttle1) ])

hold off