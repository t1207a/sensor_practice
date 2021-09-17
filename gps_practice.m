%initailize term
first = [2600.400 -25804.100 5853.200]';
second = [8151.900 -13641.500 21624.200]';
third = [20887.100 -16159.800 3069.000]';
fourth = [22666.000 -2990.000 13842.900]';

x_u = 0;
y_u = 0;
z_u = 0;
b_u = 0;

X_U = [x_u y_u z_u b_u]';
distance_1 = sqrt((first(1)-X_U(1))^2+(first(2)-X_U(2))^2+(first(3)-X_U(3))^2);
distance_2 = sqrt((second(1)-X_U(1))^2+(second(2)-X_U(2))^2+(second(3)-X_U(3))^2);
distance_3 = sqrt((third(1)-X_U(1))^2+(third(2)-X_U(2))^2+(third(3)-X_U(3))^2);
distance_4 = sqrt((fourth(1)-X_U(1))^2+(fourth(2)-X_U(2))^2+(fourth(3)-X_U(3))^2);

delta_raw_1 = 21269.1608 - distance_1;
delta_raw_2 = 21200.9532 - distance_2;
delta_raw_3 = 23681.0417 - distance_3;
delta_raw_4 = 24601.0722 - distance_3;
delta_raw = [delta_raw_1 delta_raw_2 delta_raw_3 delta_raw_4]';

iteration = 0;
del = 100;
del_X_U = [100 100 100];

while del>1
   
    %one
    alpha_matrix = [-(first(1) - X_U(1))/distance_1,-(first(2) - X_U(2))/distance_1,-(first(3) - X_U(3))/distance_1 ,1;
        -(second(1) - X_U(1))/distance_1,-(second(2) - X_U(2))/distance_1,-(second(3) - X_U(3))/distance_1, 1;
        -(third(1) - X_U(1))/distance_1,-(third(2) - X_U(2))/distance_1,-(third(3) - X_U(3))/distance_1, 1;
        -(fourth(1) - X_U(1))/distance_1,-(fourth(2) - X_U(2))/distance_1 ,-(fourth(3) - X_U(3))/distance_1,1];
    
    del_X_U  = inv(alpha_matrix) * delta_raw;
    
    
    %two
    X_U = X_U + del_X_U;
    
    %three
    distance_1 = sqrt((first(1)-X_U(1))^2+(first(2)-X_U(2))^2+(first(3)-X_U(3))^2);
    distance_2 = sqrt((second(1)-X_U(1))^2+(second(2)-X_U(2))^2+(second(3)-X_U(3))^2);
    distance_3 = sqrt((third(1)-X_U(1))^2+(third(2)-X_U(2))^2+(third(3)-X_U(3))^2);
    distance_4 = sqrt((fourth(1)-X_U(1))^2+(fourth(2)-X_U(2))^2+(fourth(3)-X_U(3))^2);
    
    %four
    delta_raw_1 = 21269.1608 - distance_1;
    delta_raw_2 = 21200.9532 - distance_2;
    delta_raw_3 = 23681.0417 - distance_3;
    delta_raw_4 = 24601.0722 - distance_4;
    delta_raw = [delta_raw_1 delta_raw_2 delta_raw_3 delta_raw_4]';
    
    del = sqrt(del_X_U(1)^2 + del_X_U(2)^2 + del_X_U(3)^2);
    iteration  = iteration +1;
%     del = 0
end

%X_U가 최종 ECEF좌표 값입니다!