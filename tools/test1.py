

import numpy as np
import open3d as o3d
xyz = np.load("/data/private/m142_datasets/Waymo/waymo/waymo_format/modes/16^/segment-9985243312780923024_3049_720_3069_720_with_camera_labels/0000.npy")
print(xyz[:, 0:3].shape)
pcd = o3d.geometry.PointCloud()
pcd.points = o3d.utility.Vector3dVector(xyz[:,0:3])
o3d.visualization.draw_geometries([pcd])