from google.cloud import storage
import pandas as pd
import datetime
import os
import glob

client = storage.Client(project='spikey-gke')

home = str(os.path.expanduser("~"))
if not os.path.exists(home+'/customer-reviews/'):
    os.makedirs(home+'/customer-reviews/')
    
bucket = client.get_bucket('spikey-customer-reviews')
blobs = bucket.list_blobs(prefix='file-')

for (i,blob) in enumerate(blobs):
	print(blob)
	blob.download_to_filename(home+'/customer-reviews/file'+str(i)+'.csv')

path = home+'/customer-reviews'
filenames = glob.glob(path + "/*.csv")

dataframe = pd.DataFrame()
list_ = []
for file in filenames:
    df = pd.read_csv(file)
    list_.append(df)
dataframe = pd.concat(list_)

customer_ratings = dataframe[["Class Name","Rating"]].groupby('Class Name')\
													 .agg('mean')\
													 .sort_values(
													 	by=['Rating'],
													 	ascending=[True]
													 	)


date = datetime.datetime.now().strftime("%Y-%m-%d|%H:%M:%S")
filename=str('customer_ratings'+'|'+ date+'.csv')

customer_ratings.to_csv(filename)

mybucket = storage.bucket.Bucket(client=client, name='spikey-customer-ratings')

blob = mybucket.blob(filename)
blob.upload_from_filename(filename=filename)






















