# D. melanogaster (Linvilla) entropy-trajectories

## Aims

We explore the change of the pseudo-entropy (*H* from now on) over several time points of sampling in a "natural" Drosophila melanogaster population from Linvilla, USA. In particular, we divide the genome into sliding windows and calculate the *H*-trajectories for each window to potentially find interesting genome regions. Our neutral expectation - derived from analytical results and simulations - is a decrease of *H*-values over time. Therefore, we aim to identify interesting genome regions, e.g., by finding areas where *H*-values increase over time.

## Download of DEST data and initial data filtering with bcftools
First I downloaded the bcf-file with firefox from https://dest.bio/data-files/SNP-tables#bcf-files
Then I extracted the data of interest, i.e. of the Linvilla population with the following shell script.

```sh
# download bcf file with firefox from https://dest.bio/data-files/SNP-tables#bcf-files

# create index of bcf-file
bcftools index dest.PoolSeq.PoolSNP.001.50.10Nov2020.header.bcf

# count number of variants
bcftools plugin counts dest.PoolSeq.PoolSNP.001.50.10Nov2020.header.bcf 

# Number of samples: 246
# Number of SNPs:    4042456
# Number of INDELs:  0
# Number of MNPs:    0
# Number of others:  0
# Number of sites:   4042456

# save header for easier understanding of file
bcftools view -h dest.PoolSeq.PoolSNP.001.50.10Nov2020.header.bcf > header_dest.PoolSeq.PoolSNP.001.50.10Nov2020.header.txt

# create list with sample names from Linvilla
bcftools query dest.PoolSeq.PoolSNP.001.50.10Nov2020.header.bcf -l | grep ^PA_li_ > samples_Linvilla.txt

# create new bcf-file with only samples from Linvilla
bcftools view -S samples_Linvilla.txt dest.PoolSeq.PoolSNP.001.50.10Nov2020.header.bcf -Ob -o linvilla.bcf.gz

bcftools index linvilla.bcf.gz

bcftools plugin counts linvilla.bcf.gz

# Number of samples: 15
# Number of SNPs:    4042456
# Number of INDELs:  0
# Number of MNPs:    0
# Number of others:  0
# Number of sites:   4042456

# this is how one could exclude indels (if there were still some indels)
# bcftools view -Ou -I linvilla.bcf.gz -Ob -o linvilla.bcf.gz

# exclude SNPs from "messy" chromosomes and only biallelic SNPs with at least one sample having total depth of "."
bcftools view -Ob -e'CHROM="X" | CHROM="Y" | CHROM="4" | FORMAT/DP="."' -m2 -M2 -v snps linvilla.bcf.gz -Ob -o linvilla_filtered.bcf.gz

bcftools plugin counts linvilla_filtered.bcf.gz

# Number of samples: 15
# Number of SNPs:    1686856
# Number of INDELs:  0
# Number of MNPs:    0
# Number of others:  0
# Number of sites:   1686856


# get chromosome, position, alternative counts (AD), reference counts (RD) and total depths (DP) for all samples
bcftools query -f'%CHROM\t%POS\t[%AD\t]\t[%RD\t]\t[%DP\t]\n' linvilla_filtered.bcf.gz | head -10
```

## Entropy calculation in python
Next, I used a python script to filter out the SNPs that were not polymorphic on the first time point and to calculate allele frequency and allelic entropy for the remaining SNPs.

The script can be used in the terminal as follows:

```sh
python3 entropy_calc_all_samples.py -i linvilla_filtered.bcf.gz
```

It will produce two csv files with the processed SNP data one of which is a subset of the first 40000 SNPs.

The code of the entropy_calc_all_samples.py script:
```python
"""
Script takes bcf-file as input, calculates allel frequencies and allelic entropies,
and filters out SNP positions that are not polymorphic at the first sampling time point.
The script then outputs a csv-file witht the processed data

"""
import math
import subprocess
import time
from argparse import ArgumentParser
from itertools import chain

import pandas as pd

NUM_COL: int = 5


def calculate_entropy_1loc(x_i: float) -> float:
    """ Calculate entropy for allele frequency at one locus """
    y_i = 1-x_i
    entropy_1loc = 0.0
    if 0.0 < x_i < 1.0:
        entropy_1loc = -x_i * math.log(x_i) - y_i * math.log(y_i)
    return entropy_1loc


def calculate_entropy(entropy_list: list) -> float:
    """ Calculate pseudo entropy over number of num_l loci """
    num_l = len(entropy_list)
    entropy = 0.0
    sum_value = sum(entropy_list)
    entropy = sum_value/num_l
    return entropy


def create_snp_dict(count_tuple: tuple, snp_location: list,
                    sample_index: int, sample_list: list) -> dict:
    """ Create dictionary with data for individual snp """
    snp_dict = {}
    snp_dict.setdefault('sample', str(sample_list[sample_index]))
    snp_dict.setdefault('chrom', str(snp_location[0]))
    snp_dict.setdefault('pos', str(snp_location[1]))
    snp_dict.setdefault('alt_counts', int(count_tuple[0]))
    snp_dict.setdefault('ref_counts', int(count_tuple[1]))
    snp_dict.setdefault('tot_counts', int(count_tuple[2]))
    return snp_dict


def create_snp_dict_list(current_line: str, sample_list: list) -> list:
    """ Create list of snp-dictionaries for all samples """
    snp_dict_list = []
    num_samples = len(sample_list)
    splitted_line = current_line.split('\t')
    # remove weird empty space
    splitted_line = [x for x in splitted_line if x != '']
    snp_location = splitted_line[:2]        # chromosome and position of snp
    remaining_line = splitted_line[2:]
    count_tuples = [(alt, ref, tot) for (alt, ref, tot) in zip(
        remaining_line[0:num_samples],
        remaining_line[num_samples:num_samples*2],
        remaining_line[num_samples*2:num_samples*3])]

    snp_dict_list = [create_snp_dict(entry, snp_location, sample_index, sample_list)
                     for sample_index, entry in enumerate(count_tuples)]

    return snp_dict_list


def convert_to_dataframe(all_snp_dicts: list) -> pd.DataFrame:
    """ Convert list of list of dictionaries to pandas dataframe """
    total_snp_dict_list = list(
        chain.from_iterable(all_snp_dicts))
    dataframe = pd.DataFrame.from_records(total_snp_dict_list)
    return dataframe


def convert_samples_to_timepoints(sample: str) -> int:
    """ Convert sample names into time point intergers"""
    switch_dict = {
        'PA_li_09_spring': 0,
        'PA_li_09_fall': 1,
        'PA_li_10_spring': 2,
        'PA_li_10_fall': 3,
        'PA_li_11_spring': 4,
        'PA_li_11_fall': 5,
        'PA_li_11_frost': 6,
        'PA_li_12_spring': 7,
        'PA_li_12_sum': 8,
        'PA_li_12_fall': 9,
        'PA_li_13_spring': 10,
        'PA_li_14_spring': 11,
        'PA_li_14_fall': 12,
        'PA_li_15_spring': 13,
        'PA_li_15_fall': 14
    }
    return switch_dict.get(sample, -1)


PARSER = ArgumentParser()
PARSER.add_argument("-i", "--input_file", required=True)
PARSER.add_argument("-o", "--output_file", required=False)
ARGS = PARSER.parse_args()

BCF_FILE_STR = ARGS.input_file


SAMPLES_COMMAND = "bcftools query -l " + BCF_FILE_STR
# save output stream from bcftools to work with
SAMPLES_OUTPUT_STREAM = subprocess.run(
    SAMPLES_COMMAND, capture_output=True, shell=True, text=True, check=True)
SAMPLES_OUTPUT = SAMPLES_OUTPUT_STREAM.stdout

# save sample names from output
sample_names = [line for line in SAMPLES_OUTPUT.split('\n') if line != '']


# build bcftools command to get SNP data
QUERY = "-f'%CHROM\\t%POS\\t[%AD\\t]\\t[%RD\\t]\t[%DP\\t]\\n' "
SNP_DATA_COMMAND = "bcftools query " + QUERY + BCF_FILE_STR


# save output stream from bcftools to work with
OUTPUT_STREAM = subprocess.run(
    SNP_DATA_COMMAND, capture_output=True, shell=True, text=True, check=True)
OUTPUT = OUTPUT_STREAM.stdout

DATA_COLS = ['chrom', 'pos', 'sample',
             'alt_counts', 'ref_counts', 'tot_counts']


total_snp_dict_list_of_lists = [create_snp_dict_list(line, sample_names)
                                for line in OUTPUT.split('\n') if line != '']


data = convert_to_dataframe(total_snp_dict_list_of_lists)


start_time = time.time()

# add time point column
data['time_point'] = data['sample'].map(convert_samples_to_timepoints)

# add column to uniquely identify each position on each chromosome
data['chrom_pos'] = data['chrom'].map(str) + '_' + data['pos'].map(str)
data['chrom_pos'] = data['chrom_pos'].map(hash)

# Change datatype to save memory
data['sample'] = data['sample'].astype('category')
data['chrom'] = data['chrom'].astype('category')
data['pos'] = data['pos'].astype('int64')

data['time_point'] = data['time_point'].astype('int8')
data['alt_counts'] = data['alt_counts'].astype('int16')
data['ref_counts'] = data['ref_counts'].astype('int16')
data['tot_counts'] = data['tot_counts'].astype('int16')

# check if hashing unique position IDs worked
num_IDs = len(data['chrom_pos'])
num_unique_IDs = len(set(data['chrom_pos']))

if num_unique_IDs != len(set(data['chrom_pos'])):
    print("!!!! Warning: Hashing unique position IDs did not work!!!!")


# Group data by time point
grouped_data = data.groupby('time_point')

# get positions of snps where allele frequency is > 0.0 at first time point
first_sample = grouped_data.get_group(0)
filtered_positions = first_sample.loc[first_sample['alt_counts'] > 0, [
    'chrom_pos']].sort_values('chrom_pos')

filtered_positions_list = list(filtered_positions['chrom_pos'])

filtered_data = data[data['chrom_pos'].isin(filtered_positions_list)].copy()


# Delete original data to save memory (is this the right way?)
del data
del grouped_data
del first_sample
del filtered_positions
del filtered_positions_list

# calculate allele frequencies of alternative allele
filtered_data['freq'] = filtered_data.loc[:, 'alt_counts'] / \
    filtered_data.loc[:, 'tot_counts']
# calculate entropies for individual loci
filtered_data['entropy'] = filtered_data['freq'].map(calculate_entropy_1loc)


print("Filtered data: ")
print(filtered_data.head())
print(filtered_data.describe())

filtered_data.to_csv('linvilla_filtered_data.csv', index=False)

# subset for coding
subset_data = filtered_data.loc[filtered_data['pos'] < 40000]
subset_data.to_csv('linvilla_subset_data.csv', index=False)

end_time = time.time()

print("elapsed time:", end_time-start_time)
```

## Check allele frequency distribution with python

I used the python script entropy_plot_SFSs.py to plot the allele frequency spectra for the different time points

```python
import time
from argparse import ArgumentParser

import matplotlib.pyplot as plt
import pandas as pd

start_time = time.time()

PARSER = ArgumentParser()
PARSER.add_argument("-i", "--input_file", required=True)

PARSER.add_argument("-o", "--output_file", required=False)
ARGS = PARSER.parse_args()

data_file = ARGS.input_file

df = pd.read_csv(data_file)

# increase memory efficiency
df['sample'] = df['sample'].astype('category')
df['chrom'] = df['chrom'].astype('category')
df['pos'] = df['pos'].astype('int64')
df['time_point'] = df['time_point'].astype('int8')
df['alt_counts'] = df['alt_counts'].astype('int16')
df['ref_counts'] = df['ref_counts'].astype('int16')
df['tot_counts'] = df['tot_counts'].astype('int16')

freqs = df.groupby('time_point').freq


fig, axs = plt.subplots(3, 5, sharey=True, sharex=True)
i = 0

for row in range(0, 3):
    for col in range(0, 5):
        axs[row, col].hist(freqs.get_group(i), bins=50)
        time_str = "Time Point " + str(i)
        axs[row, col].set_title(time_str)
        axs[row, col].tick_params(axis='x', rotation=90)
        plt.xlim([0, 1.0])
        plt.ylim([0, 400000])
        i += 1

fig.text(0.5, 0.04, 'Allele Frequency', ha='center', va='center', fontsize=18)
fig.text(0.06, 0.5, 'Number of SNPs', ha='center',
         va='center', rotation='vertical', fontsize=18)
plt.show()

```

## Calculate entropies for sliding windows
Next I calculated entropies for per sliding window along the individual chromosomes. For this I used the script entropy_aggregate_sliding_windows.py, e.g. for windows of 50kb like so:

```sh
entropy_aggregate_sliding_windows.py -i linvilla_filtered_data.csv -ws 50000 -th 100
```
where the code of the script is:
```python
import math
import time
from argparse import ArgumentParser

import matplotlib.pyplot as plt
import pandas as pd


def calculate_entropy(entropy_list) -> float:
    """ Calculate pseudo entropy over number of l loci """
    l = len(entropy_list)
    entropy = 0.0
    sum_value = math.fsum(entropy_list)
    entropy = sum_value/l
    return entropy


def get_win_lim_fix(genome_positions, win_size: int) -> list:
    """
    Takes list or dataframe column of genome positions and fixed window size and
    returns a list of tuples with window start and stop values
    """
    window_limits = range(min(genome_positions), max(
        genome_positions) + win_size, win_size)
    windows = list(zip(window_limits, window_limits[1:]))
    return windows


def get_overlapping_win_lim_fix(genome_positions, win_size: int) -> list:
    """
    Takes list or dataframe column of genome positions and window size and
    returns a list of tuples with window start and stop values. Windows have overlap of 50%
    """
    window_limits = range(min(genome_positions), max(
        genome_positions) + win_size, win_size//2)
    windows = list(zip(window_limits, window_limits[2:]))
    return windows


start_time = time.time()

PARSER = ArgumentParser()
PARSER.add_argument("-i", "--input_file", required=True)
PARSER.add_argument("-ws", "--window_size",
                    required=False, default=5000, type=int)
PARSER.add_argument("-th", "--threshold",
                    required=False, default=0, type=int)
PARSER.add_argument("-o", "--output_file", required=False)
ARGS = PARSER.parse_args()

data_file = ARGS.input_file
window_size = ARGS.window_size
threshold = ARGS.threshold

df = pd.read_csv(data_file)

# increase memory efficiency
df['sample'] = df['sample'].astype('category')
df['chrom'] = df['chrom'].astype('category')
df['pos'] = df['pos'].astype('int64')
df['time_point'] = df['time_point'].astype('int8')
df['alt_counts'] = df['alt_counts'].astype('int16')
df['ref_counts'] = df['ref_counts'].astype('int16')
df['tot_counts'] = df['tot_counts'].astype('int16')


# get chromosome names
chrom_names = list(df['chrom'].unique())

# Group data by time point
grouped_data = df.groupby('chrom')

# loop over chromosomes
for chromosome in chrom_names:
    chrom_data = grouped_data.get_group(chromosome).copy()
    chrom_data['window'] = -1
    chrom_data['window'] = chrom_data['window'].astype('int32')
    chrom_data['window_start'] = -1
    chrom_data['window_start'] = chrom_data['window_start'].astype('int64')
    chrom_data['window_stop'] = -1
    chrom_data['window_stop'] = chrom_data['window_stop'].astype('int64')

    # get positions of SNPs
    positions = chrom_data['pos'].unique()

    # fixed window size
    win_lims = get_win_lim_fix(positions, window_size)

    # loop through windows
    for index, window in enumerate(win_lims):
        print('Chromosome: ', chromosome, window)
        # create mask for only SNPs within window
        win_data = chrom_data[chrom_data['pos'].between(window[0], window[1])]
        win_mask = chrom_data['pos'].between(window[0], window[1])
        # add columns to identify windows
        chrom_data.loc[win_mask, 'window_start'] = window[0]
        chrom_data.loc[win_mask, 'window_stop'] = window[1]
        chrom_data.loc[win_mask, 'window'] = index

    # aggregate data per window and time point
    chrom_data_per_time_point = chrom_data.groupby(
        ['window', 'time_point']).agg(
            entropy=('entropy', calculate_entropy),
            num_snps=('pos', 'count'),
            window_start=('window_start', 'first'),
            window_stop=('window_stop', 'last')
    ).reset_index()

    # increase memory efficiency
    chrom_data_per_time_point['window'] = chrom_data_per_time_point['window'].astype(
        'int32')
    chrom_data_per_time_point['time_point'] = chrom_data_per_time_point['time_point'].astype(
        'int8')
    chrom_data_per_time_point['num_snps'] = chrom_data_per_time_point['num_snps'].astype(
        'int16')
    # add column with entropy at time point 0 for each window
    chrom_data_per_time_point['t0_entropy'] = chrom_data_per_time_point.groupby('window')['entropy'].transform(
        'first')
    chrom_data_per_time_point['window_start'] = chrom_data_per_time_point['window_start'].astype(
        'int32')
    chrom_data_per_time_point['window_stop'] = chrom_data_per_time_point['window_stop'].astype(
        'int32')

    # calculate delta-entropy for each time point
    chrom_data_per_time_point['delta_entropy'] = chrom_data_per_time_point['entropy'] - \
        chrom_data_per_time_point['t0_entropy']

    # exclude windows that have less SNPs htan threshold
    if threshold != 0:
        chrom_data_per_time_point = chrom_data_per_time_point[chrom_data_per_time_point['num_snps'] > threshold]

        file_str = 'Entropy_Linvilla_agg' + \
        f'_chromosome{chromosome}_fixed_win_{window_size}_threshold{threshold}'.format(
            chromosome, window_size, threshold)
        chrom_data_per_time_point.to_csv(file_str + '.csv', index=False)
    
    else:
        file_str = 'Entropy_Linvilla_agg' + \
            f'_chromosome{chromosome}_fixed_win_{window_size}'.format(
                chromosome, window_size)
        chrom_data_per_time_point.to_csv(file_str + '.csv', index=False)


end_time = time.time()

print('Elapsed time: ', (end_time-start_time), 's')

```

This results in four separate csv files for each of the chromosomes (2L, 2R, 3L, 3R), in which the change of entropy over the time points is calcualted for each of the windows.

## Plotting entropy trajectories for sliding windows

Consequently, I plotted the change of entropy over time for each chromosome, e.g. for chromosome 2L, with:
```sh
entropy_plot_agg_sliding_windows.py -i Entropy_Linvilla_agg_chromosome2L_fixed_win_50000_threshold100.csv
```

and the code of entropy_plot_agg_sliding_windows.py:

```python
"""
Plots line plots and violine plots of entropy trajectories
"""
from argparse import ArgumentParser

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

PARSER = ArgumentParser()
PARSER.add_argument("-i", "--input_file", required=True)
ARGS = PARSER.parse_args()

data_file = ARGS.input_file

df = pd.read_csv(data_file)

title_str = data_file[:-4]


windows = df.groupby('window')
for window in windows:
    plt.plot(window[1].time_point, window[1].delta_entropy)

# dummy = [plt.plot(window[1].time_point, window[1].delta_entropy)
    # for window in windows]

plt.figure(1)
plt.ylabel(r'$\Delta$-Pseudo-Entropy')
plt.xlabel('Time points')
plt.axis([-0.6, 14.6, -0.4, 0.31])
plt.yticks(np.arange(-0.4, 0.31, 0.1))
plt.title(title_str)
plt.grid(True, color='grey', linestyle='dotted', axis='y')
plt.savefig(title_str + '_line_plot.png', dpi=300, format='png')

series = df.groupby('time_point')

trajectories = [elem[1].delta_entropy for elem in series]

plt.figure(2)
bla = plt.violinplot(trajectories,
                     df.time_point.unique(),
                     showmedians=True,
                     showextrema=False,
                     widths=0.8)


for pc in bla['bodies']:
    pc.set_facecolor('0.4')
    pc.set_edgecolor('0.2')
    pc.set_alpha(0.7)

plt.ylabel(r'$\Delta$-Pseudo-Entropy')
plt.xlabel('Time points')
plt.axis([-0.6, 14.6, -0.4, 0.31])
plt.yticks(np.arange(-0.4, 0.31, 0.1))
plt.title(title_str)
plt.grid(True, color='grey', linestyle='dotted', axis='y')
plt.savefig(title_str + '_violine_plot.png', dpi=300, format='png')

```

The script produces two plots per chromosome. The first is a "spaghetti-plot" with entropy trajectories as multiple lines (one line per window). The second is a violin plot that summarizes the distribution of entropy values over all windows for each time point.


