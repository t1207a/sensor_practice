data = load('ransac_data.mat');
final_model_X = zeros(3,1);
maximum_count = 0;
%iteration
for w=1:length(data.x)
    %random select
    random_index = randi([1 100],1,3);
    %make matrix
    B = [data.y(random_index(1)),data.y(random_index(2)),data.y(random_index(3))]';
    x_1 = data.x(random_index(1)); x_2 = data.x(random_index(2)); x_3 = data.x(random_index(3)); 
    A = [x_1^2 x_1 1;
        x_2^2 x_2 1;
        x_3^2 x_3 1;];
    X = inv(A) * B;
    %calculate residual
    y = zeros(100,1);
    B_real = data.y;
    for k = 1:length(data.x)
        y(k) = X(1)*(data.x(k))^2+  X(2)*(data.x(k)) + X(3);
    end
    residual = B_real - y;
    count_num = 0;
    for i=1:length(data.x)
       if (abs(residual(i)))<1*10^3*0.1  %count number of points that are entered in range
           count_num = count_num +1;
       end
    end
    
    %find optimal model
    if maximum_count < count_num
        final_model_X = X;
        maximum_count = count_num;
    end
end

for k = 1:length(data.x)
        y(k) = final_model_X(1)*(data.x(k))^2+  final_model_X(2)*(data.x(k)) + final_model_X(3);
end
plot(data.x,data.y,'r*',data.x,y,'b-')
