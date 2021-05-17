# !! NOTES !!
# This is a python file that is used to do data preparation
# for the dataset at the following link:
# https://www.kaggle.com/c/competitive-data-science-predict-future-sales/data?select=sales_train.csv
#
# This is phase 1 of data preparation, which will be used to
# determine whether the dataset in the link above will continue at the data preprocessing stage or not
# The dataset used in this file is 'sales_train.csv' which can be accessed via the link provided

import warnings
import pandas as pd
from pandas.core.common import SettingWithCopyWarning
warnings.simplefilter(action="ignore", category=SettingWithCopyWarning)


# !!NOTES !! IF USING GOOGLE COLABORATORY, UNCOMMENT THE CODE BELOW, AND
# DONT FORGET TO UPLOAD YOUR KAGGLE API KEY FIRST!! :
# ! chmod 600 /content/kaggle.json
# !KAGGLE_CONFIG_DIR=/content/ kaggle competitions download -c competitive-data-science-predict-future-sales
# import zipfile
# with zipfile.ZipFile('/content/sales_train.csv.zip','r') as f:
#   f.extractall('/content/')

# Loading dataset into DataFrame Pandas
product_sales_df = pd.read_csv('sales_train.csv')

# Checking missing values in the DataFrame
print("Total Missing Values Every Features: \n{}".format(product_sales_df.isna().sum()))

print("")
print("")

# Showing first 30 row in the DataFrame
print("First 30 rows in DataFrame: \n{}".format(product_sales_df.head(30)))

print("")
print("")

# UNCOMMENT CODE DIBAWAH JIKA INGIN MENGETAHUI VALUE DALAM FEATURE 'item_id' DENGAN JUMLAH -
# ROW TERBANYAK DALAM DATAFRAME.
# CODE DIBAWAH DIBERIKAN COMMENT KARENA MEMBUTUHKAN WAKTU KOMPUTASI -
# YANG LAMA, SEHINGGA MEMBEBANI WORKFLOW
# Looks for a specific value in the 'item_id' feature that has the most rows
# def count_features_row(data_frame):
#     max_value = 0
#     pid_selected = 0
#     count_row = len(data_frame['item_id'])
#     done_pid = []
#     for i in range(0, count_row):
#         if data_frame.loc[i, 'item_id'] not in done_pid:
#             done_pid.append(data_frame.loc[i, 'item_id'])
#             pid = data_frame.loc[i, 'item_id']
#             curr_row_sum = len(data_frame[data_frame['item_id'] == pid])
#             if curr_row_sum > max_value:
#                 max_value = curr_row_sum
#                 pid_selected = pid
#     return "Features dengan row terbanyak :\n1. 'item_id':{}\n 2.Total Row : {}".format(pid_selected, max_value)
#
#
# print(count_features_row(product_sales_df))

print("")
print("")

# Loading '20949' in the 'item_id' features into separate DataFrame
fixed_df = product_sales_df[product_sales_df['item_id'] == 20949]
print("All instances with the feature 'item_id' that has a value of '20949' :\n{}".format(fixed_df.head(30)))
print("Total rows in the above's dataframe : {}".format(fixed_df.shape[0]))

print("")
print("")

# Checking if there is a value of -1 in 'item_cnt_day' at 'fixed_df' variable
print("Checking instances that has a value of -1 at the 'item_cnt_day' feature :")
print(fixed_df[fixed_df['item_cnt_day'] == -1])

print("")
print("")

# Checking candidate 1 product item
print("The number of rows and columns in the Dataframe \
that has a value of 35 at the 'shop_id' feature: {}".format(fixed_df[fixed_df['shop_id'] == 35].shape))

print("")
print("")
print("===== Reconstruct the DataFrame at the Detail Level =====")
print("")
# Separating all rows with value '35' at the 'shop_id' feature to another DataFrame
shop_35_df = fixed_df[fixed_df['shop_id'] == 35]
print("DataFrame that only contains instances with a value of '35' inside the 'shop_id' feature: \n{}".format(shop_35_df))


print("")
print("")
print("<-- Result of Data Preparation on the 'shop_35_df' DataFrame -->")
print("")

# Convert Values  in 'date' feature tobe 'datetime' Pandas format
date_pd = pd.to_datetime((shop_35_df['date']))

# Drop the 'date' feature in the 'shop_35_df' DataFrame
shop_35_df.drop(columns=['date'], axis=1, inplace=True)

# Merging the 'datetime_pd' array into 'shop_35_df' DataFrame
shop_35_df['date'] = date_pd

# Set the 'date' feature tobe index at 'shop_35_df' DataFrame
shop_35_df.set_index('date', inplace=True)

# Changing names on each columns in 'shop_35_df' DataFrame
shop_35_df.columns = ["sequence_of_date", "shop_id", "item_id", "item_price", "item_sold_per_day"]

# Removing unnecessary columns for demand forecasting
shop_35_df.drop(columns=['sequence_of_date'], axis=1, inplace=True)

# Sorting the 'date' index
shop_35_df = shop_35_df.sort_values(by='date')

# Showing preprocessed 'shop_35_df' DataFrame
print(shop_35_df.head(35))

# Exporting Preprocessed DataFrame into CSV file
shop_35_df.to_csv('shop_35_detail_item_sales.csv')

# Exporting Preprocessed DataFrame into Excel File
shop_35_df.to_excel('shop_35_detail_item_sales.xlsx')
