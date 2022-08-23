# 保存为TUM和KITTI格式的位姿
```cpp
void SaveKittiFormat(const string& map_path)
{
    FILE *fp = NULL;
    char end1 = 0x0d; // "/n"
    char end2 = 0x0a;
 
    // lidar odometry
    string lidar_tum_file = map_path + "imu_data_res_kitti.txt";
    fp = fopen(lidar_tum_file.c_str(), "w+");
 
    if (fp == NULL)
    {
        printf("fail to open file %s ! \n", lidar_tum_file.c_str());
        exit(1);
    }
    else
        printf("KITTI : write lidar data to %s \n", lidar_tum_file.c_str());
 
    for (int i = 0; i < imu_data_.size(); ++i)
    {
        auto q = imu_data_[i].continous_quat;
        Eigen::Matrix3d R;
        R = q;
 
        Eigen::Vector3d t = imu_data_[i].pos;
        double time = imu_data_[i].stamp;
        fprintf(fp, "%.5lf %.5lf %.5lf %.5lf %.5lf %.5lf %.5lf %.5lf %.5lf %.5lf %.5lf %.5lf%c",
                R(0,0),R(0,1),R(0,2),t.x(),
                R(1,0),R(1,1),R(1,2),t.y(),
                R(2,0),R(2,1),R(2,2),t.z(),
                end2);
    }
    fclose(fp);
}
 
void SaveTumFormat(const string& map_path)
{
    FILE *fp = NULL;
    char end1 = 0x0d; // "/n"
    char end2 = 0x0a;
 
    // lidar odometry
    string lidar_tum_file = map_path + "imu_data_res.txt";
    fp = fopen(lidar_tum_file.c_str(), "w+");
 
    if (fp == NULL)
    {
        printf("fail to open file %s ! \n", lidar_tum_file.c_str());
        exit(1);
    }
    else
        printf("TUM : write lidar data to %s \n", lidar_tum_file.c_str());
 
    for (size_t i = 0; i < imu_data_.size(); ++i)
    {
        Eigen::Quaterniond q = imu_data_[i].continous_quat;
        Eigen::Vector3d t = imu_data_[i].pos;
        double time = imu_data_[i].stamp;
        fprintf(fp, "%.3lf %.3lf %.3lf %.3lf %.5lf %.5lf %.5lf %.5lf%c",
                time, t.x(), t.y(), t.z(),
                q.x(), q.y(), q.z(), q.w(), end2);
    }
    fclose(fp);
}

```
