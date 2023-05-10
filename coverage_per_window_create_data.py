import subprocess
from argparse import ArgumentParser
from itertools import pairwise

import pandas as pd

PARSER = ArgumentParser()

# input files can be a list of bam files
PARSER.add_argument('-i', '--input_files', required=True)
# file with the part of the .bai file that contains the scaffold of interest
PARSER.add_argument("-sc", "--scaffold_table", required=True)
PARSER.add_argument("-mq", "--mapping_quality", default=20)

PARSER.add_argument("-ws", "--window_size", required=True)

ARGS = PARSER.parse_args()

input_file_list_name = ARGS.input_files

scaffold_table_name = ARGS.scaffold_table

window_size = int(ARGS.window_size)

mapping_quality = int(ARGS.mapping_quality)

scaff_dict = {}

with open(scaffold_table_name, encoding='utf-8') as scaffold_table:

    lines = [line for line in scaffold_table]
    for line in lines:
        scaff_dict[line.split('\t')[0]] = int(line.split('\t')[1])

# get header
COMMAND = f"samtools depth -H -f {input_file_list_name} | head -1"
OUTPUT_STREAM = subprocess.run(
    COMMAND, capture_output=True, shell=True, check=True)
OUTPUT = OUTPUT_STREAM.stdout
samples = OUTPUT.decode('utf-8').strip('\n').split('\t')[2:]
samples = [sample.split('_')[0] for sample in samples]


windows_data = []
for scaff, scaff_len in scaff_dict.items():
    print(f'Processing windows for scaffold {scaff} ...')
    window_lims = list(range(0, scaff_len, window_size))
    windows = list(pairwise(window_lims))
    windows.append((window_lims[-1], scaff_len))

    for window in windows:
        window_data = {}
        start = window[0]
        end = window[1]

        AWK_COMMAND = "| awk '{n++; for(i=3;i<=5;i++) sum[i]+=$i;}END{for(i=3;i<=5;i++) print sum[i]/n}'"

        DEPTH_COMMAND = f"samtools depth -q {mapping_quality} -r {scaff}:{start}-{end} -f {input_file_list_name}" + AWK_COMMAND
        # try-except, e.g. when no reads mapped in current window
        try:
            DEPTH_OUTPUT_STREAM = subprocess.run(
                DEPTH_COMMAND, capture_output=True, shell=True, check=True)
        except ValueError:
            continue
        DEPTH_OUTPUT = DEPTH_OUTPUT_STREAM.stdout
        mean_depth = DEPTH_OUTPUT.decode('utf-8').strip('\n').split('\n')
        window_data['scaffold'] = scaff
        window_data['window_start'] = start
        for i, sample in enumerate(samples):
            window_data[sample] = mean_depth[i]
        windows_data.append(window_data)

scaff_df = pd.DataFrame(windows_data)
scaff_df['scaffold'] = scaff_df['scaffold'].astype('category')
scaff_df['window_start'] = scaff_df['window_start'].astype('int64')
scaff_df['S1'] = scaff_df['S1'].astype('float16')
scaff_df['s4'] = scaff_df['s4'].astype('float16')
scaff_df['s20'] = scaff_df['s20'].astype('float16')
print(scaff_df.head())
print(scaff_df.info())
scaff_df.to_csv(
    f'coverage_per_{round(window_size/1000)}_kb_window.csv.gz', index=False, compression='gzip')
