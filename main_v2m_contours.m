% main_v2m_contours.m

% ���� ���Ϸκ��� ����Ʈ�� �о���δ�.
disp('Reading data from main_v2m_contours_data.xlsx ... ')
tot = xlsread('main_v2m_contours_data.xlsx','Sheet2','A3:F57');
rpms = tot(:,1);
rpm_unique = unique(rpms);
disp('Reading completed.')

% Ŭ���� ������ ������ ������ �ʱ�ȭ�Ѵ�
rpm_all  = [];
icam_all = [];
ecam_all = [];
torque_all = [];
apc_all = [];
cov_all = [];

format short g % fixed point�� �����͸� �����ֱ� ���� ����

while 1 % ���� ���� (outer loop)
    
    % ���ϴ� rpm ���� �����Ѵ�
    rpm_now = input(['\n Type rpm among: ', num2str(rpm_unique') , ...
    '\n Or just type enter to finish \n --> ']);

    if isempty( rpm_now ) % �׳� enter�� ģ ���
        break % outer loop�� ������
    end
    
    i = ( rpm_now == rpms ); % i�� �������� �̷���� ����. 
    if sum(i) == 0
        disp(' ')
        disp(' You typed Invalid rpm! Type valid rpm again.')
        continue % rpms�� ���� ���� ����ڰ� �Է��� ��� ���� iteration���� �ǳʶڴ�
    end

    % ����ڰ� ������ rpm ���� �ش��ϴ� ������ �κи��� �����Ѵ�.
    torque = tot(i,2);
    apc    = tot(i,3);
    ecam   = tot(i,4);
    icam   = tot(i,5);
    cov    = tot(i,6);

    % column vector ������ x,y,z �����͸� 2D ���̺� ���¸� ���� X,Y,Z ������� ��ȯ��
    % �� �� Z ����� NaN�� ������ �� �ִ�. �� x,y�� ���տ� �ش��ϴ� �����ε�
    % �� ���ǿ� �ش��ϴ� z ���� ���� ���, �� ��ġ�� ���� NaN�� �Ҵ�ȴ�.
    [ ICAM1 , ECAM1 , TORQUE ] = v2m( icam , ecam , torque );
    [ ICAM2 , ECAM2 , APC ]    = v2m( icam , ecam , apc );
    [ ICAM3 , ECAM3 , COV ]    = v2m( icam , ecam , cov );

    close all

    subplot(2,2,1)
    [a,b] = contourf( ICAM1 , ECAM1 , TORQUE );
    clabel(a,b)
    xlabel('ICAM'); ylabel('ECAM')
    title(['TORQUE (RPM = ' , num2str(rpm_now) , ')'  ])
    hold on % subplot�� ��� hold on�� ������ subplot�� ���� ����� ��

    subplot(2,2,2)
    [a,b] = contourf( ICAM2 , ECAM2 , APC );
    clabel(a,b)
    xlabel('ICAM'); ylabel('ECAM')
    title(['APC (RPM = ' , num2str(rpm_now) , ')' ])
    hold on % subplot�� ��� hold on�� ������ subplot�� ���� ����� ��

    subplot(2,2,3)
    [a,b] = contourf( ICAM3 , ECAM3 , COV );
    clabel(a,b)
    xlabel('ICAM'); ylabel('ECAM')
    title(['COV (RPM = ' , num2str(rpm_now) , ')' ])
    hold on % subplot�� ��� hold on�� ������ subplot�� ���� ����� ��

    while 1 % ���� ���� (inner loop)

        % �� �׸� ��, �ƹ� �׸� ������ Ŭ���ϵ��� �ȳ��Ѵ�
        disp('Click on any plot or just type enter to go to different rpm -->')
        [ icam_now , ecam_now ] = ginput(1);

        if isempty(icam_now) % �׸� ���� Ŭ���� ���� �ʰ�, �׳� Enter�� ���� ��
            break
        end
        
        % ��� ������ ���콺�� Ŭ���� �������� torque, apc, cov ���� ���������� ���Ѵ�.
        torque_now = interp2( ICAM1 , ECAM1 , TORQUE , icam_now , ecam_now );
        apc_now    = interp2( ICAM2 , ECAM2 , APC , icam_now , ecam_now );
        cov_now    = interp2( ICAM3 , ECAM3 , COV , icam_now , ecam_now );

        % Ŭ���� ������ ��Ƽ� *_all �̶�� ������ �ִ´�.
        rpm_all    = [rpm_all; rpm_now];
        icam_all   = [icam_all; icam_now];
        ecam_all   = [ecam_all; ecam_now];
        torque_all = [torque_all; torque_now];
        apc_all    = [apc_all; apc_now];
        cov_all    = [cov_all; cov_now];

        % ���� Ŭ���� ������ ���������� ����� �����͸� �����ش� (���ݱ��� ������ �����Ϳ� �Բ�)
        disp('[        rpm_all    icam_all     ecam_all     torque_all   apc_all     cov_all ]')
        disp('--------------------------------------------------------------------------------')
        disp([ rpm_all , icam_all , ecam_all , torque_all , apc_all , cov_all ])
    
        % ������ �׸��� ������ ���콺�� Ŭ���� ���� marker�� ǥ���Ѵ�.
        subplot(2,2,1)
        plot( icam_now , ecam_now , 'wo' ); % ��� ���׶�� ��Ŀ
        subplot(2,2,2)
        plot( icam_now , ecam_now , 'wo' ); % ��� ���׶�� ��Ŀ
        subplot(2,2,3)
        plot( icam_now , ecam_now , 'wo' ); % ��� ���׶�� ��Ŀ

    end
    
end

format % format short g ���� �ٽ� format���� ���� ����
hold off