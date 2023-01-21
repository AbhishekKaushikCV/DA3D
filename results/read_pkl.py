"""To read the .pkl files."""

import pandas as pd
import pickle

# df = pd.read_pickle(
#   "/no_backups/s1435/DAfor3D/output/kitti_models/pv_rcnn/train_kitti/eval/eval_with_train/epoch_66/val/result.pkl")
# print("result.pkl", df)

with open('/no_backups/s1435/DAfor3D/output/kitti_models/votr_tsd/train_votr_a16_gt/eval/eval_with_train/epoch_66/val/result.pkl', 'rb') as f:
    data = pickle.load(f)
# data is a list of dictionaries, of size 3769, which is used in train_eval
for i in range(len(data)):
    key_names = []
    for key, value in data[i].items():
        key_names.append(key)
print("the output key names in the resultant dictionary:", list(set(key_names)))
