%matplotlib inline
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import os

Data = ('/Users/ararun/ACU/projects/braincann/MIDT/CorrelationAnalysisAll.csv')

Corr_df = pd.read_csv(Data)

Corr_df.head()

Corr_df.isna().sum()

print(f'The shape of Corr_df is {Corr_df.shape}')
print()
print(f'{Corr_df.isna().sum()}')

# Split to Users & Controls
users_df = Corr_df[Corr_df['group']==1]

controls_df = Corr_df[Corr_df['group']==2]

#Check dataframe
print(f'The shape of users_df is {users_df.shape}')
print()
users_df.head()

users_acohol_df = users_df[[ 'Precentral, left', 'Temporal Mid, left', 'Precentral, left', 'Frontal Sup Medial, right', 'Frontal Sup Medial, left', 'Frontal Sup, left', 'Precuneus, right', 'Precuneus, left', 'Cuneus, left', 'Temporal Mid, left', 'Occipital Mid, left', 'AlcoholExp', 'SCID score', 'AgeUse', 'Cones/past mo', 'CannabisFreq', 'RT, reward trials', 'RT, neural trials']]

users_acohol_df.head()
# Run Corr
correlation = users_acohol_df.corr()

#correlation
fig = plt.figure()
mask = np.triu(np.ones_like(correlation, dtype=bool))
cmap = sns.diverging_palette(230, 20, as_cmap=True)  
sns.heatmap(correlation, vmin=-0.8, vmax=1, annot=False, cmap=cmap, mask=mask)
sns.set(rc={'figure.figsize':(15,10)})

plt.savefig('/Users/ararun/ACU/projects/braincann/MIDT/Corr.png', bbox_inches='tight')
