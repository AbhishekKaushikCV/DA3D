#!/bin/bash -l

# Slurm parameters
#SBATCH --job-name=trce
#SBATCH --output=train_secondiougt_car_intensity_waymo_%j.%N.out
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=4
#SBATCH --time=168:00:00
#SBATCH --mem=120G
# SBATCH --gpus=geforce_gtx_1080_ti:2
#SBATCH --gpus=rtx_a5000:2
#SBATCH --qos=batch

while true
do
    PORT=$(( ((RANDOM<<15)|RANDOM) % 49152 + 10000 ))
    status="$(nc -z 127.0.0.1 $PORT < /dev/null &>/dev/null; echo $?)"
    if [ "${status}" != "0" ]; then
        break;
    fi
done
echo $PORT

# Activate everything you need
module load cuda/11.1
pyenv activate venv

CUDA_VISIBLE_DEVICES=0,1


# to see the name of the gpus and infos
#sinfo -o "%20N  %10c  %10m  %25f  %25G "

# KITTI Oracles dataset

#srun python train.py \
#--launcher slurm \
#--tcp_port $PORT \
#--cfg_file cfgs/kitti_models/second/second.yaml \
#--batch_size 2 \
#--extra_tag train_secondnogt_kitti_e80 \
#--max_ckpt_save_num 5 \
#--num_epochs_to_eval 5 \
#--eval_src
#
#
#srun python train.py \
#--launcher slurm \
#--tcp_port $PORT \
#--cfg_file cfgs/kitti_models/secondiou/secondiou.yaml \
#--batch_size 2 \
#--extra_tag train_secondiou_kitti_e80 \
#--max_ckpt_save_num 5 \
#--num_epochs_to_eval 5 \
#--eval_src

#srun python train.py \
#--launcher slurm \
#--tcp_port $PORT \
#--cfg_file cfgs/da-nuscenes-kitti_models/centerpoint/centerpoint_car_gt.yaml \
#--batch_size 2 \
#--extra_tag train_centerpoint_cargt_nuscenes \
#--max_ckpt_save_num 5 \
#--num_epochs_to_eval 5 \
#--eval_src








## train secondiou_car in nuscenes
#srun python train.py \
#--launcher slurm \
#--tcp_port $PORT \
#--cfg_file cfgs/da-nuscenes-kitti_models/pvrcnn/pvrcnn_car_gt.yaml \
#--batch_size 2 \
#--extra_tag train_pvrcnngt_car_nuscenes \
#--max_ckpt_save_num 5 \
#--num_epochs_to_eval 5 \
#--eval_src

# train secondiou_car in waymo
srun python train.py \
--launcher slurm \
--tcp_port $PORT \
--cfg_file cfgs/da-waymo-kitti_models/secondiou/secondiou_car_gt_intensity.yaml \
--batch_size 2 \
--extra_tag train_secondiougt_car_intensity_waymo \
--max_ckpt_save_num 5 \
--num_epochs_to_eval 5 \
--eval_src

#srun python train.py \
#--launcher slurm \
#--tcp_port $PORT \
#--cfg_file cfgs/da-waymo-kitti_models/second/second_gt_intensity.yaml \
#--batch_size 2 \
#--extra_tag train_secondgt_intensity_waymo \
#--max_ckpt_save_num 5 \
#--num_epochs_to_eval 5 \
#--eval_src









# test pvrcnn on waymo (kitti metric)
#srun python test.py \
#--launcher slurm \
#--tcp_port $PORT \
#--cfg_file cfgs/da-waymo-kitti_models/pvrcnn/pvrcnn_car_gt.yaml \
#--batch_size 2 \
#--ckpt /no_backups/s1435/DA3D/output/da-waymo-kitti_models/pvrcnn/pvrcnn_car_gt/train_pvrcnn_gt_car_waymo/ckpt/checkpoint_epoch_30.pth \
#--eval_src \
#--extra_tag train_pvrcnn_gt_car_waymo_E30


# train votr on kitti
#srun python train.py \
#--launcher slurm \
#--tcp_port $PORT \
#--cfg_file cfgs/kitti_models_models/votr_tsd_a16gtlt.yaml \
#--batch_size 3 \
#--extra_tag train_votra16gtlt_kitti \
#--max_ckpt_save_num 15 \
#--num_epochs_to_eval 15

# train in waymo
#srun python train.py \
#--launcher slurm \
#--tcp_port $PORT \
#--cfg_file cfgs/waymo_models/votr_tsd_gt.yaml \
#--batch_size 2 \
#--extra_tag train_votrgt_waymo \
#--max_ckpt_save_num 5



## train secondiou_cyc in waymo
#srun python train.py \
#--launcher slurm \
#--tcp_port $PORT \
#--cfg_file cfgs/da-waymo-kitti_models/secondiou/secondiou_gt.yaml \
#--batch_size 2 \
#--extra_tag train_secondiou_gtintensity255_waymo \
#--max_ckpt_save_num 5 \
#--num_epochs_to_eval 5 \
#--eval_src

## train secondiou car on waymo
#srun python train.py \
#--launcher slurm \
#--tcp_port $PORT \
#--cfg_file cfgs/da-waymo-kitti_models/secondiou/secondiou_car_sa_gt.yaml \
#--batch_size 2 \
#--max_ckpt_save_num 5 \
#--num_epochs_to_eval 5 \
#--eval_src \
#--extra_tag train_secondiou_sa_gt_car_waymo

# train pvrcnn_car in waymo
#srun python train.py \
#--launcher slurm \
#--tcp_port $PORT \
#--cfg_file cfgs/da-waymo-kitti_models/pvrcnn_centerhead/pvrcnn_centerhead.yaml \
#--batch_size 2 \
#--extra_tag trainpvrcnncenterhead_waymo \
#--max_ckpt_save_num 5 \
#--num_epochs_to_eval 5 \
#--eval_src

# train second_car in waymo
#srun python train.py \
#--launcher slurm \
#--tcp_port $PORT \
#--cfg_file cfgs/da-waymo-kitti_models/second/second_car_vh025_bev128.yaml \
#--batch_size 2 \
#--extra_tag train_second_car_va_h025_bev128 \
#--max_ckpt_save_num 5 \
#--num_epochs_to_eval 5 \
#--eval_src

## secondiou aware in waymo
#srun python train.py \
#--launcher slurm \
#--tcp_port $PORT \
#--cfg_file cfgs/da-waymo-kitti_models/secondiou_aware/secondiou_aware_car_ld.yaml \
#--batch_size 2 \
#--extra_tag train_secondiou_awareld \
#--max_ckpt_save_num 5 \
#--num_epochs_to_eval 5 \
#--eval_src

# train in waymo# srun python train.py \
#--launcher slurm \
#--tcp_port $PORT \
#--cfg_file cfgs/waymo_models/pv_rcnn.yaml \
#--batch_size 2 \
#--extra_tag train_pvrcnnnogt_waymo \
#--max_ckpt_save_num 5

# test waymo model in multi gpu
#srun python test.py \
#--launcher slurm \
#--tcp_port $PORT \
#--cfg_file cfgs/waymo_models/pvrcnn.yaml \
#--ckpt /no_backups/s1420/open_output/waymo_models/pv_rcnn/pvrcnn_resized_gt/ckpt/checkpoint_epoch_30.pth \
#--extra_tag pvrcnn_resized_gt_eval_on_resized_kirk

# train in kitti
#srun python train.py \
#--launcher slurm \
#--tcp_port $PORT \
#--cfg_file cfgs/kitti_models/pv_rcnn_2.yaml \
#--extra_tag H125_N5_F1_no_GT_yes_Shape \
#--max_ckpt_save_num 15 \
#--num_epochs_to_eval 15

# test kitti model in multi gpu
#srun python test.py \
#--launcher slurm \
#--tcp_port $PORT \
#--cfg_file cfgs/kitti_models/pvrcnn.yaml \
#--ckpt /no_backups/s1420/open_output/kitti_models/pv_rcnn/pvrcnn_filter_by_1/ckpt/checkpoint_epoch_72.pth \
#--extra_tag pvrcnn_filter_by_1_eval_on_16
