from argparse import ArgumentParser

import matplotlib.pyplot as plt
import pandas as pd

PARSER = ArgumentParser()
PARSER.add_argument('-i', '--input_file', required=True)
PARSER.add_argument('-sc', '--scaffold', required=False)
ARGS = PARSER.parse_args()

input_file_name = ARGS.input_file
scaffold = ARGS.scaffold

df = pd.read_csv(input_file_name)

df['scaffold'] = df['scaffold'].astype('category')
df['window_start'] = df['window_start'].astype('int64')
df['S1'] = df['S1'].astype('float16')
df['s4'] = df['s4'].astype('float16')
df['s20'] = df['s20'].astype('float16')

window_size = df.window_start[1]-df.window_start[0]

if scaffold is not None:

    df_grouped = df.groupby('scaffold')
    df_scaffold = df_grouped.get_group(scaffold)
    print(df_scaffold)
    plt.plot(df_scaffold.window_start, df_scaffold.S1,
             linewidth=1.0, label='S1 (PGC)')
    plt.plot(df_scaffold.window_start, df_scaffold.s4,
             linewidth=1.0, label='s4 (PGC-)')
    plt.plot(df_scaffold.window_start, df_scaffold.s20,
             linewidth=1.0, label='s20 (PGC+)')
    plt.legend()
    # plt.title(scaff)
    plt.ylabel(f'mean depth per {round(window_size/1000)}kb window')
    plt.xlabel('position on scaffold')
    plt.semilogy()
    plt.show()
else:
    scaffolds = pd.unique(df.scaffold)
    for scaffold in scaffolds:
        df_grouped = df.groupby('scaffold')
        df_scaffold = df_grouped.get_group(scaffold)
        plt.plot(df_scaffold.window_start, df_scaffold.S1,
                 linewidth=1.0, label='S1 (PGC)')
        plt.plot(df_scaffold.window_start, df_scaffold.s4,
                 linewidth=1.0, label='s4 (PGC-)')
        plt.plot(df_scaffold.window_start, df_scaffold.s20,
                 linewidth=1.0, label='s20 (PGC+)')
        plt.legend()
        plt.title(scaffold)
        plt.ylabel(f'mean depth per {round(window_size/1000)}kb window')
        plt.xlabel('position on scaffold')
        plt.semilogy()
        plt.savefig(
            f'mean_depth_per_{round(window_size/1000)}kb_window_scaff_{scaffold}.png', dpi=300, format='png', bbox_inches='tight')
        plt.close()
