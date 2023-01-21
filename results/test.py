import pickle

info_path = '/data/public/Nuscenes/v1.0-trainval/nuscenes_infos_10sweeps_val.pkl'


nuscenes_infos = []

# for info_path in self.dataset_cfg.INFO_PATH[mode]:
#     info_path = self.root_path / info_path
#     if not info_path.exists():
#         continue
with open(info_path, 'rb') as f:
    infos = pickle.load(f)
    nuscenes_infos.extend(infos)

infos.extend(nuscenes_infos)
print('Total samples for NuScenes dataset: %d' % (len(nuscenes_infos)))