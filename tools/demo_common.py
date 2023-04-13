import glob
from pathlib import Path

import argparse

try:
    import open3d
    from visual_utils import open3d_vis_utils as V

    OPEN3D_FLAG = True
except:
    import mayavi.mlab as mlab
    from visual_utils import visualize_utils as V

    OPEN3D_FLAG = False

import numpy as np
import torch

from pcdet.config import cfg, cfg_from_yaml_file
from pcdet.datasets import DatasetTemplate, build_dataloader
from pcdet.models import build_network, load_data_to_gpu
from pcdet.utils import common_utils

import os

vis_folder = 'detection_visualizations'
if not os.path.exists(vis_folder):
    os.makedirs(vis_folder)


def parse_config():
    parser = argparse.ArgumentParser(description='arg parser')
    parser.add_argument('--cfg_file', type=str, default='cfgs/nuscenes_models/cbgs_pp_multihead.yaml',
                        help='specify the config for demo')
    parser.add_argument('--ckpt', type=str, default="ckpt/pp_multihead_nds5823_updated.pth",
                        help='specify the pretrained model')
    parser.add_argument('--vis_src', action='store_true', default=False, help='')
    parser.add_argument('--save', action='store_true', default=False, help='save the detection results')

    args = parser.parse_args()
    cfg_from_yaml_file(args.cfg_file, cfg)

    return args, cfg


def main():
    args, cfg = parse_config()
    logger = common_utils.create_logger()
    logger.info('-----------------Quick Demo of OpenPCDet-------------------------')

    if cfg.get('DATA_CONFIG_TAR', None) and not args.vis_src:
        vis_set, vis_loader, sampler = build_dataloader(
            dataset_cfg=cfg.DATA_CONFIG_TAR,
            class_names=cfg.DATA_CONFIG_TAR.CLASS_NAMES,
            batch_size=1,
            dist=None, workers=4, logger=logger, training=False,
            merge_all_iters_to_one_epoch=False,
            total_epochs=None
        )
    else:
        vis_set, vis_loader, sampler = build_dataloader(
            dataset_cfg=cfg.DATA_CONFIG,
            class_names=cfg.CLASS_NAMES,
            batch_size=1,
            dist=None, workers=4,
            logger=logger,
            training=False,
            merge_all_iters_to_one_epoch=False,
            total_epochs=None
        )

    logger.info(f'Total number of samples: \t{len(vis_set)}')

    model = build_network(model_cfg=cfg.MODEL, num_class=len(cfg.CLASS_NAMES), dataset=vis_set)
    model.load_params_from_file(filename=args.ckpt, logger=logger, to_cpu=True)
    model.cuda()
    model.eval()
    with torch.no_grad():
        for idx, data_dict in enumerate(vis_set):
            logger.info(f'Visualized sample index: \t{idx + 1}')
            data_dict = vis_set.collate_batch([data_dict])
            load_data_to_gpu(data_dict)
            pred_dicts, _ = model.forward(data_dict)
            # print("predictions:", pred_dicts[0]['pred_boxes'])
            # print(pred_dicts[0]['pred_boxes'].size())
            gt_boxes = data_dict['gt_boxes']
            gt_boxes = gt_boxes.squeeze(dim=0)

            V.draw_scenes(
                points=data_dict['points'][:, 1:], gt_boxes=gt_boxes, ref_boxes=pred_dicts[0]['pred_boxes'],
                ref_scores=pred_dicts[0]['pred_scores'], ref_labels=pred_dicts[0]['pred_labels']
            )

            if not OPEN3D_FLAG:
                mlab.show(stop=True)

    logger.info('Demo done.')


if __name__ == '__main__':
    main()
