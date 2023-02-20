#!/bin/bash -l

# Slurm parameters
#SBATCH --job-name=kinus
#SBATCH --output=testnus_pvrcnn_centerhead_car_%j.%N.out
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=168:00:00
#SBATCH --mem=50G
#SBATCH --gpus=rtx_a5000:1
#SBATCH --qos=batch

# Activate everything you need
module load cuda/11.1
pyenv activate rp


CUDA_VISIBLE_DEVICES=0

python test.py \
--cfg_file  cfgs/da-waymo-nus_models/pvrcnn_centerhead/pvrcnn_centerhead_car.yaml \
--ckpt_dir /no_backups/s1435/DA3D/output/da-waymo-kitti_models/pvrcnn_centerhead/pvrcnn_centerhead_car/trainpvrcnncenterhead_waymo/ckpt/ \
--extra_tag  testnus_pvrcnn_centerhead_car \
--eval_all \

#python test.py \
#--cfg_file cfgs/da-waymo-kitti_models/centerpoint/centerpoint_car.yaml \
#--ckpt_dir /no_backups/s1435/DA3D/output/da-waymo-kitti_models/centerpoint/centerpoint_car/train_centerpoint_car_waymo/ckpt/ \
#--extra_tag  testkitti_centerpoint_car \
#--eval_all \
#--set DATA_CONFIG_TAR.FOV_POINTS_ONLY True


#python test.py \
#--cfg_file  cfgs/da-waymo-nus_models/pvrcnn_centerhead/pvrcnn_centerhead_car.yaml \
#--ckpt_dir /no_backups/s1435/DA3D/output/da-waymo-kitti_models/pvrcnn_centerhead/pvrcnn_centerhead_car/trainpvrcnncenterhead_waymo/ckpt/ \
#--extra_tag  testnus_pvrcnn_centerhead_car \
#--eval_all

















# test waymo secondioucargt on nuscenes
#python test.py --cfg_file cfgs/da-waymo-nus_models/second/second_car_gt.yaml \
#--ckpt_dir /no_backups/s1435/DA3D/output/da-waymo-kitti_models/second/second_car_gt/train_second_gt_car_waymo/ckpt/ \
#--extra_tag testnus_secondgt_oldanchor \
#--eval_all
#&
#python test.py --cfg_file cfgs/da-waymo-nus_models/second/second_car_ld.yaml \
#--ckpt_dir /no_backups/s1435/DA3D/output/da-waymo-kitti_models/second/second_car_ld/train_second_ld/ckpt/ \
#--extra_tag testnus_secondld_meananchor \
#--eval_all
#&
#python test.py --cfg_file cfgs/da-waymo-nus_models/second/second_car_sa.yaml \
#--ckpt_dir /no_backups/s1435/DA3D/output/da-waymo-kitti_models/second/second_car_sa/train_second_sa_car_waymo/ckpt/ \
#--extra_tag testnus_secondsa_oldanchor \
#--eval_all
#&
#python test.py --cfg_file cfgs/da-waymo-nus_models/second/second_car_ros.yaml \
#--ckpt_dir /no_backups/s1435/DA3D/output/da-waymo-kitti_models/second/second_car_ros/train_second_ros_car_waymo/ckpt/ \
#--extra_tag testnus_secondros_meananchor \
#--eval_all
#&
#python test.py --cfg_file cfgs/da-waymo-nus_models/second/second_car_sa_gt.yaml \
#--ckpt_dir /no_backups/s1435/DA3D/output/da-waymo-kitti_models/second/second_car_sa_gt/train_second_sa_gt_car_waymo/ckpt/ \
#--extra_tag testnus_secondsagt_meananchor \
#--eval_all






#python resize_label.py --cfg_file=cfgs/waymo_models/pvrcnn.yaml --extra_tag=resize_box

#python test.py --cfg_file cfgs/da-waymo-kitti_models/secondiou/second_car_ros.yaml --ckpt_dir /no_backups/s1435/DA3D/output/da-waymo-kitti_models/secondiou/secondiou_car_ros/train_secondiou_ros_car_waymo/ckpt/ --extra_tag testkitti_secondiouros_oldanchor --eval_all --set DATA_CONFIG_TAR.FOV_POINTS_ONLY True


# generate waymo infos
#python -m pcdet.datasets.waymo.waymo_dataset --func create_waymo_infos --cfg_file cfgs/dataset_configs/waymo_dataset.yaml


# train second_car in waymo
#python train.py \
#--cfg_file cfgs/da-waymo-kitti_models/second/second_car_ld.yaml \
#--batch_size 2 \
#--extra_tag train_second_ld \
#--max_ckpt_save_num 5 \
#--num_epochs_to_eval 5 \
#--eval_src
# test secondiou_sa_gt
#python test.py \
#--cfg_file cfgs/da-waymo-kitti_models/secondiou_aware/secondiou_aware_car_gt.yaml \
#--ckpt /no_backups/s1435/DA3D/output/da-waymo-kitti_models/secondiou_aware_car/secondiou_aware_car_gt/train_secondiou_aware_gt/ckpt/checkpoint_epoch_30.pth \
#--extra_tag  testkitti_secondiou_awaregt_waymo_oldanchor \
#--eval_all \
#--set DATA_CONFIG_TAR.FOV_POINTS_ONLY True
#
#python test.py --cfg_file cfgs/da-waymo-kitti_models/pvrcnn_centerhead/pvrcnn_centerhead_car.yaml \
#--ckpt_dir /no_backups/s1435/DA3D/output/da-waymo-kitti_models/pvrcnn_centerhead/pvrcnn_centerhead_car/trainpvrcnncenterhead_waymo/ckpt/ \
#--extra_tag testkitti_pvrcnncenterhead_waymo \
#--eval_all \
#--batch_size 2 \
#--set DATA_CONFIG_TAR.FOV_POINTS_ONLY True \


#python test.py --cfg_file cfgs/da-waymo-kitti_models/pvrcnn/pvrcnn_car_gt.yaml \
#--ckpt_dir /no_backups/s1435/DA3D/output/da-waymo-kitti_models/pvrcnn/pvrcnn_car_gt/train_pvrcnn_gt_car_waymo/ckpt/ \
#--extra_tag testkitti_pvrcnngtwaymo_newanchor \
#--eval_all \
#--set DATA_CONFIG_TAR.FOV_POINTS_ONLY True


# train  tr
#CUDA_VISIBLE_DEVICES=0 python train.py \
#--cfg_file cfgs/kitti_models/votr_tsd_0.yaml \
#--batch_size 2 \
#--extra_tag only_Downsample \
#--max_ckpt_save_num 15 \
#--num_epochs_to_eval 15

# test votr
#python test.py --cfg_file cfgs/kitti_models/votr_tsd_0.yaml \
#--ckpt /no_backups/s1420/open_output/kitti_models/votr_tsd_0/only_Downsample/ckpt/checkpoint_epoch_76.pth \
#--extra_tag only_Downsample_eval_on_32


# train pvrcnn

# python train.py \
#--cfg_file cfgs/waymo_models/pv_rcnn.yaml \
#--batch_size 2 \
#--extra_tag waymo_train_pvrcnn \
#--max_ckpt_save_num 15 \
#--num_epochs_to_eval 15

# test votr
#python test.py --cfg_file /no_backups/s1435/DAfor3D/tools/cfgs/kitti_models/votr_tsd_a16_l16.yaml \
#--ckpt /no_backups/s1435/DAfor3D/output/kitti_models/votr_tsd/train_votr_a16_gt/ckpt/checkpoint_epoch_68.pth \
#--extra_tag test_votra16gt_kitti_l16_e68

## test waymo on nuscenes pvrcnn
#python test.py --cfg_file cfgs/domain_adaptation/da-waymo-nus_models/pvrcnn/pvrcnn.yaml \
#--ckpt /no_backups/s1435/DAfor3D/output/waymo_models/pv_rcnn/waymo_train_pvrcnn/ckpt/checkpoint_epoch_28.pth \
#--extra_tag testnus_pvrcnnwaymo_e28_2

### test trained pvrcnn(waymo) on kitti
#python test.py --cfg_file cfgs/domain_adaptation/da-waymo-kitti_models/pvrcnn/pvrcnn.yaml \
#--ckpt /no_backups/s1435/DAfor3D/output/waymo_models/pv_rcnn/waymo_train_pvrcnn/ckpt/checkpoint_epoch_28.pth \
#--extra_tag testkitti_fovt_pvrcnnwaymo_e28
# train secondiou_car in waymo

#python train.py --cfg_file cfgs/da-waymo-kitti_models/secondiou/secondiou_car_gt.yaml \
#--batch_size 2 \
#--max_ckpt_save_num 5 \
#--num_epochs_to_eval 5 \
#--eval_src \
#--extra_tag train_secondiou_gt_car_waymo \

# test pvrcnn on waymo
#python test.py --cfg_file cfgs/da-waymo-kitti_models/pvrcnn/pvrcnn_car_gt.yaml \
#--ckpt /no_backups/s1435/DA3D/output/da-waymo-kitti_models/pvrcnn/pvrcnn_car_gt/train_pvrcnn_gt_car_waymo/ckpt/checkpoint_epoch_30.pth \
#--eval_src \
#--extra_tag train_pvrcnn_gt_car_waymo_E30

## test trained secondiou(waymo) on kitti
#python test.py --cfg_file cfgs/da-waymo-kitti_models/secondiou/secondiou_car_gt.yaml \
#--ckpt_dir /no_backups/s1435/DA3D/output/da-waymo-kitti_models/secondiou/secondiou_car/train_secondiou_nogt_car_waymo/ckpt/ \
#--extra_tag testkitti_secondiounogtwaymo \
#--eval_all \
#--set DATA_CONFIG_TAR.FOV_POINTS_ONLY True # for kitti target domain


## test trained secondiou(waymo) on nuscenes
#python test.py --cfg_file cfgs/da-waymo-nus_models/secondiou/secondiou_cyc.yaml \
#--ckpt_dir /no_backups/s1435/DA3D/output/da-waymo-kitti_models/secondiou/secondiou_cyc/train_secondiou_nogt_cyc_waymo/ckpt/ \
#--extra_tag testnus_secondiounogtwaymo \
#--eval_all

# test trained pvrcnn(kitti) on nuscenes
#python test.py --cfg_file cfgs/domain_adaptation/da-kitti-nuscenes_models/pvrcnn/pvrcnn.yaml \
#--ckpt /no_backups/s1435/DAfor3D/output/kitti_models/pv_rcnn/train_kitti/ckpt/checkpoint_epoch_67.pth \
#--extra_tag testnus_pvrcnnkitti_e67


# test votr
#python test.py --cfg_file cfgs/kitti_models/votr_tsd_a32_l32.yaml \
#--ckpt /no_backups/s1435/DAfor3D/output/kitti_models/votr_tsd_a32/train_votr_a32_7/ckpt/checkpoint_epoch_76.pth \
#--extra_tag test_votra327_kitti_l32_e76

#train second
#python train.py \
#--cfg_file cfgs/da-waymo-kitti_models/second/second_car_3anchors.yaml \
#--batch_size 2 \
#--extra_tag train_second_3anchors_waymo \
#--max_ckpt_save_num 5 \
#--num_epochs_to_eval 5 \
#--eval_src

# test second
#python test.py --cfg_file cfgs/kitti_models/second.yaml \
#--ckpt /no_backups/s1420/open_output/kitti_models/second/default_lr_no_gt_H0625_N4/ckpt/checkpoint_epoch_77.pth \
#--extra_tag default_lr_no_gt_H0625_N4_eval_on_16



#train secondiou
#CUDA_VISIBLE_DEVICES=0 python train.py \
#--cfg_file cfgs/kitti_models/second_iou_0.yaml \
#--extra_tag smaller_lr_cia_ssd_only_Downsample \
#--max_ckpt_save_num 15 \
#--num_epochs_to_eval 15

#test secondiou
#python test.py --cfg_file cfgs/kitti_models/second_iou_aware.yaml \
#--ckpt /no_backups/s1420/open_output/kitti_models/second_iou/smaller_lr_cia_ssd_H1_N5_F5_no_GT_yes_Shape_yes_Downsample/ckpt/checkpoint_epoch_78.pth \
#--extra_tag smaller_lr_cia_ssd_H1_N5_F5_no_GT_yes_Shape_yes_Downsample_eval_on_16



#train voxel rcnn
#CUDA_VISIBLE_DEVICES=0 python train.py \
#--cfg_file cfgs/kitti_models/voxel_rcnn_3class_.yaml \
#--extra_tag only_Downsample \
#--max_ckpt_save_num 15 \
#--num_epochs_to_eval 15

#test voxel rcnn
#python test.py --cfg_file cfgs/kitti_models/voxel_rcnn_3class_.yaml \
#--ckpt /no_backups/s1420/open_output/kitti_models/voxel_rcnn_3class_/only_Downsample/ckpt/checkpoint_epoch_77.pth \
#--extra_tag only_Downsample_eval_on_16
