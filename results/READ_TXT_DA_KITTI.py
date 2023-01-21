import argparse
import pandas as pd
import re
from IPython.display import display
import pygsheets


def write_df2_gsheet(df: pd.DataFrame, important: dict, service_file_path: str):
    google_client = pygsheets.authorize(service_file=service_file_path)
    spreadsheet = google_client.open('DA')
    spreadsheet.add_worksheet(title=important["extra_tag"], index=0)
    wks = spreadsheet.worksheet_by_title(important["extra_tag"])

    wks.set_dataframe(df, (1, 1))



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
        epochs_content[epoch] = lines[key:key + 69]
    return epochs_content


def get_metrics(epochs_content: dict) -> dict:
    epochs_metrics = {}
    for epoch, content in epochs_content.items():
        metrics = {"Car AP@0.70, 0.70, 0.70 (3D)": epochs_content[epoch][11],
                   "Car AP@0.70, 0.70, 0.70 (BEV)": epochs_content[epoch][10],
                   "Car AP_R40@0.70, 0.70, 0.70 (3D)": epochs_content[epoch][16],
                   "Car AP_R40@0.70, 0.70, 0.70 (BEV)": epochs_content[epoch][15],

                   "Pedestrian AP@0.50, 0.50, 0.50 (3D)": epochs_content[epoch][31],
                   "Pedestrian AP@0.50, 0.50, 0.50 (BEV)": epochs_content[epoch][30],
                   "Pedestrian AP_R40@0.50, 0.50, 0.50 (3D)": epochs_content[epoch][36],
                   "Pedestrian AP_R40@0.50, 0.50, 0.50 (BEV)": epochs_content[epoch][35],

                   "Cyclist AP@0.50, 0.50, 0.50 (3D)": epochs_content[epoch][51],
                   "Cyclist AP@0.50, 0.50, 0.50 (BEV)": epochs_content[epoch][50],
                   "Cyclist AP_R40@0.50, 0.50, 0.50 (3D)": epochs_content[epoch][56],
                   "Cyclist AP_R40@0.50, 0.50, 0.50 (BEV)": epochs_content[epoch][55]}
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
    df_metrics = pd.DataFrame.from_dict(epochs_metrics)

    # # split the car ap 0.70, 0.70,0.70 in easy, medium, hard
    # df_metrics["car_easy"] = [float(re.split("[,:]", value)[1]) for value in df_metrics["Car AP@0.70, 0.70, 0.70"]]
    # df_metrics["car_medium"] = [float(value.split(",")[1]) for value in df_metrics["Car AP@0.70, 0.70, 0.70"]]
    # df_metrics["car_hard"] = [float(value.split(",")[2]) for value in df_metrics["Car AP@0.70, 0.70, 0.70"]]
    #
    # # split the pedestrian ap 0.50, 0.50, 0.50 in easy, medium, hard
    # df_metrics["pedestrian_easy"] = [float(re.split("[,:]", value)[1]) for value in
    #                                  df_metrics["Pedestrian AP@0.50, 0.50, 0.50"]]
    # df_metrics["pedestrian_medium"] = [float(value.split(",")[1]) for value in
    #                                    df_metrics["Pedestrian AP@0.50, 0.50, 0.50"]]
    # df_metrics["pedestrian_hard"] = [float(value.split(",")[2]) for value in
    #                                  df_metrics["Pedestrian AP@0.50, 0.50, 0.50"]]
    #
    # # split the cyclist ap 0.50, 0.50, 0.50 in easy, medium, hard
    # df_metrics["cyclist_easy"] = [float(re.split("[,:]", value)[1]) for value in
    #                               df_metrics["Cyclist AP@0.50, 0.50, 0.50"]]
    # df_metrics["cyclist_medium"] = [float(value.split(",")[1]) for value in
    #                                 df_metrics["Cyclist AP@0.50, 0.50, 0.50"]]
    # df_metrics["cyclist_hard"] = [float(value.split(",")[2]) for value in
    #                               df_metrics["Cyclist AP@0.50, 0.50, 0.50"]]

    df_metrics.reset_index(inplace=True)
    df_final = df_metrics.rename(columns={'index': 'EPOCHS'})
    #df_styled = df_metrics.style.highlight_max(subset=numeric_columns, color='yellow', axis=0)
    # WRITE THE FINAL DF TO GOOGLE SHEETS
    write_df2_gsheet(df_final, important, "/no_backups/s1435/Domain_Adaptation/rpresult-9eccea8e7697.json")
    display(df_final)


if __name__ == "__main__":
    main()
