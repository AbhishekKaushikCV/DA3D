import pandas as pd


data = pd.read_pickle(
    "/data/private/m142_datasets/object/kitti_infos_test.pkl")
df = pd.DataFrame(data)
print(df)
