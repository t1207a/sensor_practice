%store data and variables
data = load('LidarRangeData.mat');
phi = 95:-0.5:-95;
theta = 0.36:0.36:360;
phi_length = length(phi);
theta_length = length(theta);
lidar_data = zeros(length(data.R),3);

%data를 n*3으로 변경
for k=1:theta_length
    for i = 1:phi_length
        lidar_data(length(phi)*(k-1)+i,1) = data.R(length(phi)*(k-1)+i)*cos(phi(i)*pi/180)*cos(theta(k)*pi/180);
        lidar_data(length(phi)*(k-1)+i,2) = data.R(length(phi)*(k-1)+i)*cos(phi(i)*pi/180)*sin(theta(k)*pi/180);
        lidar_data(length(phi)*(k-1)+i,3) = data.R(length(phi)*(k-1)+i)*sin(phi(i)*pi/180);
    end
end

%for data view
point_cloud_data = pointCloud(lidar_data);
pcshow(point_cloud_data);