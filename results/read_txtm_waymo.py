import argparse
import pandas as pd
import re
from IPython.display import display
import numpy as np
import pygsheets


# gc = pygsheets.authorize(service_file="/no_backups/s1435/DAfor3D/rpresult-9eccea8e7697.json")
# To test the output of this file
# python --path /no_backups/s1435/DAfor3D/output/kitti_models/votr_tsd/train_votr_a16_gt/log_train_20221201-181959.txt

# re.findall("\d+\.\d+", "Current Level: 13.4db.")

def write_df2_gsheet(df: pd.DataFrame, important: dict, service_file_path: str):
    google_client = pygsheets.authorize(service_file=service_file_path)
    spreadsheet = google_client.open('SOURCE_ONLY_WAYMO')
    spreadsheet.add_worksheet(title=important["extra_tag"], index=0)
    wks = spreadsheet.worksheet_by_title(important["extra_tag"])

    wks.set_dataframe(df, (1, 1))

    wks.add_chart(
        ("A2", "A16"),
        [("B2", "B16"), ("C2", "C16")],
        title="Chart:VEHICLE: LEVEL 1&2 AP",
    )
    wks.add_chart(
        ("A2", "A16"),
        [("D2", "D16"), ("E2", "E16")],
        title="Chart:PEDESTRIAN: LEVEL 1&2 AP",
        anchor_cell="E17"
    )
    wks.add_chart(
        ("A2", "A16"),
        [("F2", "F16"), ("G2", "G16")],
        title="Chart:CYCLIST: LEVEL 1&2 AP",
        anchor_cell="A40"
    )


def get_list_epochs(path: str) -> dict:
    important = {}

    list_epochs = {}
    with open(path) as f:
        lines = [line.strip() for line in f.readlines()]
        for idx, content in enumerate(lines):
            if 'extra_tag' in content:
                important["extra_tag"] = content.split(' ')[-1]
            if 'Performance of EPOCH' in content:
                list_epochs[idx + 1] = content.split(' ')[-2]
    return list_epochs, lines, important


def get_epochs_content(list_epochs: dict, lines: list) -> dict:
    epochs_content = {}
    for key, epoch in list_epochs.items():
        epochs_content[epoch] = lines[key + 9:key + 33]
    return epochs_content


def get_metrics(epochs_content: dict) -> dict:
    epochs_metrics = {}
    for epoch, content in epochs_content.items():
        metrics = {"OBJECT_TYPE_TYPE_VEHICLE_LEVEL_1/AP": epochs_content[epoch][0],
                   "OBJECT_TYPE_TYPE_VEHICLE_LEVEL_2/AP": epochs_content[epoch][3],
                   "OBJECT_TYPE_TYPE_PEDESTRIAN_LEVEL_1/AP": epochs_content[epoch][6],
                   "OBJECT_TYPE_TYPE_PEDESTRIAN_LEVEL_2/AP": epochs_content[epoch][9],
                   "OBJECT_TYPE_TYPE_CYCLIST_LEVEL_1/AP": epochs_content[epoch][18],
                   "OBJECT_TYPE_TYPE_CYCLIST_LEVEL_2/AP": epochs_content[epoch][21]}
        epochs_metrics[epoch] = metrics
    return epochs_metrics


def main():
    # Create the parser
    parser = argparse.ArgumentParser(description='returns the epochs metrics as a dictionary')
    # Add the arguments
    parser.add_argument('--path', type=str, help='path of the file')
    # Execute the parse_args() method
    args = parser.parse_args()
    file_path = args.path

    list_epochs, lines, important = get_list_epochs(file_path)

    epochs_content = get_epochs_content(list_epochs, lines)

    epochs_metrics = get_metrics(epochs_content)

    # create a dataframe out of the resultant epochs_metrics
    df_metrics = pd.DataFrame.from_dict(epochs_metrics).T

    # split the car ap 0.70, 0.70,0.70 in easy, medium, hard
    df_metrics["VEHICLE_LEVEL_1/AP"] = [float(value.split(":")[1]) for value in
                                        df_metrics["OBJECT_TYPE_TYPE_VEHICLE_LEVEL_1/AP"]]
    df_metrics["VEHICLE_LEVEL_2/AP"] = [float(value.split(":")[1]) for value in
                                        df_metrics["OBJECT_TYPE_TYPE_VEHICLE_LEVEL_2/AP"]]

    # # split the pedestrian ap 0.50, 0.50, 0.50 in easy, medium, hard
    df_metrics["PEDESTRIAN_LEVEL_1/AP"] = [float(value.split(":")[1]) for value in
                                           df_metrics["OBJECT_TYPE_TYPE_PEDESTRIAN_LEVEL_1/AP"]]
    df_metrics["PEDESTRIAN_LEVEL_2/AP"] = [float(value.split(":")[1]) for value in
                                           df_metrics["OBJECT_TYPE_TYPE_PEDESTRIAN_LEVEL_2/AP"]]
    #
    # # split the cyclist ap 0.50, 0.50, 0.50 in easy, medium, hard
    df_metrics["CYCLIST_LEVEL_1/AP"] = [float(value.split(":")[1]) for value in
                                        df_metrics["OBJECT_TYPE_TYPE_CYCLIST_LEVEL_1/AP"]]
    df_metrics["CYCLIST_LEVEL_2/AP"] = [float(value.split(":")[1]) for value in
                                        df_metrics["OBJECT_TYPE_TYPE_CYCLIST_LEVEL_2/AP"]]

    df_metrics.reset_index(inplace=True)
    df_final = df_metrics.rename(columns={'index': 'EPOCHS'})
    df_final = df_final.drop(['OBJECT_TYPE_TYPE_VEHICLE_LEVEL_1/AP', 'OBJECT_TYPE_TYPE_VEHICLE_LEVEL_2/AP',
                              'OBJECT_TYPE_TYPE_PEDESTRIAN_LEVEL_1/AP', 'OBJECT_TYPE_TYPE_PEDESTRIAN_LEVEL_2/AP',
                              'OBJECT_TYPE_TYPE_CYCLIST_LEVEL_1/AP', 'OBJECT_TYPE_TYPE_CYCLIST_LEVEL_2/AP'], axis=1)
    display("FINAL DATAFRAME:", df_final)
    # WRITE THE FINAL DF TO GOOGLE SHEETS
    write_df2_gsheet(df_final, important, "/no_backups/s1435/Domain_Adaptation/rpresult-9eccea8e7697.json")


if __name__ == "__main__":
    main()
