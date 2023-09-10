import csv
import os
from argparse import ArgumentParser


def is_kraken_report(file_name_path: str) -> bool:
    file_name = file_name_path.split('/')[-1]
    return bool(os.path.isfile(file_name_path) and
                file_name.startswith('report') and
                file_name.endswith('.kreport'))


def write_domain_list_to_file(domain_list: list, output_file_name: str):
    with open(output_file_name, 'a', newline='', encoding='utf-8') as out_file:
        writer = csv.writer(out_file, delimiter='\t')
        writer.writerows(domain_list)


def process_domain(file_path: str, output_file_name: str, sample_name: str):
    domain_list = []
    total_read_num = 0
    # process kraken report file
    with open(file_path, encoding='utf-8') as report:
        lines = list(report)

        # process every line of the kraken report
        for line in lines:
            splitted_line = line.strip(' ').split('\t')

            rank_code = splitted_line[3]

            if rank_code in ('R'):
                num_reads_rooted_clade = int(splitted_line[1])
                total_read_num += int(num_reads_rooted_clade)

            if rank_code in ('U'):
                num_reads_rooted_clade = int(splitted_line[1])
                total_read_num += int(num_reads_rooted_clade)
                taxon = splitted_line[-1].lstrip(' ').strip('\n')
                num_reads_rooted_clade = int(splitted_line[1])
                domain_list.append(
                    [sample_name, taxon, num_reads_rooted_clade])
                print(rank_code, splitted_line)

            if rank_code == 'D':
                taxon = splitted_line[-1].lstrip(' ').strip('\n')
                num_reads_rooted_clade = int(splitted_line[1])
                domain_list.append(
                    [sample_name, taxon, num_reads_rooted_clade])
                print(rank_code, splitted_line)

    for domain in domain_list:
        domain.append((domain[2]*100)/total_read_num)
        domain.append(total_read_num)
        print(domain)
    write_domain_list_to_file(domain_list, output_file_name)


PARSER = ArgumentParser()

PARSER.add_argument('-i', '--input_dir', required=True)
PARSER.add_argument('-l', '--level_taxonomy',
                    default='domain',
                    choices=['domain',
                             'kingdom',
                             'species_chordata',
                             'phylum_non_chordata_eukaryotes',
                             'phylum_bacteria',
                             'species'])
ARGS = PARSER.parse_args()


input_dir_name = ARGS.input_dir
print('input_dir_name: ', input_dir_name)

OUTPUT_FILE_NAME = 'test.txt'

# prepare output file with header
with open(OUTPUT_FILE_NAME, 'w', newline='', encoding='utf-8') as out_file:
    writer = csv.writer(out_file, delimiter='\t')
    writer.writerow(['sample', 'domain', 'num_reads_rooted_clade',
                    'percent_reads_rooted_clade', 'num_total_reads'])

# iterate over report files in input directory
for input_file_name in os.listdir(input_dir_name):

    input_file_path = input_dir_name + input_file_name
    current_sample = input_file_name.split('_')[1]
    print(current_sample)
    if is_kraken_report(input_file_path):
        print(input_file_name)
        process_domain(input_file_path, OUTPUT_FILE_NAME, current_sample)
