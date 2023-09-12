import csv
import os
from argparse import ArgumentParser


def is_kraken_report(file_name_path: str) -> bool:
    """Function checks if file is aproper kraken report"""
    file_name = file_name_path.split('/')[-1]
    return bool(os.path.isfile(file_name_path) and
                file_name.startswith('report') and
                file_name.endswith('.kreport'))


def write_clade_list_to_file(clade_list: list, output_file_name: str) -> None:
    """Recieves domain list as input and writes data into tab-delimited text file"""
    with open(output_file_name, 'a', newline='', encoding='utf-8') as out_file_1:
        data_writer = csv.writer(out_file_1, delimiter='\t')
        data_writer.writerows(clade_list)


def process_domain(file_path: str, output_file_name: str, sample_name: str):
    """Processes data from singel report file and writes it to output file \
        when the taxonomy level is 'domain'."""
    domain_list = []
    total_read_num = 0
    # process kraken report file
    with open(file_path, encoding='utf-8') as report:
        lines = list(report)

        # process every line of the kraken report
        for line in lines:
            splitted_line = line.strip(' ').split('\t')

            rank_code = splitted_line[3]

            if rank_code == 'R':
                num_reads_rooted_clade = int(splitted_line[1])
                total_read_num += num_reads_rooted_clade

            if rank_code == 'U':
                num_reads_rooted_clade = int(splitted_line[1])
                total_read_num += num_reads_rooted_clade
                taxon = splitted_line[-1].lstrip(' ').strip('\n')
                domain_list.append(
                    [sample_name, taxon, num_reads_rooted_clade])

            if rank_code == 'D':
                taxon = splitted_line[-1].lstrip(' ').strip('\n')
                num_reads_rooted_clade = int(splitted_line[1])
                domain_list.append(
                    [sample_name, taxon, num_reads_rooted_clade])

    # collect data for each domain and write it to output file
    for domain in domain_list:
        domain.append((domain[2]*100)/total_read_num)
        domain.append(total_read_num)
    write_clade_list_to_file(domain_list, output_file_name)


def process_species_in_chordata(file_path: str, output_file_name: str, sample_name: str):
    """Processes data from singel report file and writes it to output file \
        when the taxonomy level is 'species_in_chordata'. Percentages for each species\
            of all species in chordata clade will be calculated."""
    species_list = []
    total_read_num = 0
    # process kraken report file
    with open(file_path, 'r', encoding='utf-8') as report:
        lines = list(report)
        read_num_species_level = 0

        # process every line of the kraken report
        for line in lines:
            splitted_line = line.strip(' ').split('\t')
            scientific_name = splitted_line[-1].lstrip(' ').strip('\n')

            rank_code = splitted_line[3]

            # Find entry for Chordata clade
            if rank_code == 'P' and scientific_name == 'Chordata':
                total_read_num = int(splitted_line[1])

            # Collect data from all species in Chordata clade
            if rank_code == 'S':
                num_reads_rooted_clade = int(splitted_line[1])
                read_num_species_level += num_reads_rooted_clade
                species_list.append(
                    [sample_name, scientific_name, num_reads_rooted_clade])

            # Stop when all species of Chordata clade have been processed
            if rank_code == 'P' and scientific_name != 'Chordata':
                break

    # collect data for each domain and write it to output file
    for species in species_list:
        species.append((species[2]*100)/total_read_num)
        species.append(total_read_num)

    # Calculate percentage of reads in 'Chordata' not classified to species level
    read_num_not_species_level = total_read_num - read_num_species_level

    unclassified_at_species_level = [sample_name, 'unclassified_at_species_level',
                                     read_num_not_species_level,
                                     (100*read_num_not_species_level) /
                                     total_read_num,
                                     total_read_num]
    species_list.append(unclassified_at_species_level)
    write_clade_list_to_file(species_list, output_file_name)


def process_phylum_non_metazoa_eukaryotes(file_path: str, output_file_name: str, sample_name: str):
    """Processes data from single report file and writes it to output file \
        when the taxonomy level is 'phylum_non_metazoa_eukaryotes'. Percentages for each phylum\
            of all phyla in non-chordata eukaryotes will be calculated. This excludes reads that \
                that were not classified to phylum level."""
    phyla_list = []
    read_num_eukaryotes = 0
    read_num_opisthokonta_general = 0
    read_num_metazoa = 0
    read_num_non_metazoa = 0
    read_num_non_metazoa_phylum_level = 0
    read_num_non_metazoa_not_phylum_level = 0

    print(sample_name)

    # process kraken report file
    with open(file_path, 'r', encoding='utf-8') as report:
        lines = list(report)

        # process every line of the kraken report
        for line in lines:
            splitted_line = line.strip(' ').split('\t')
            scientific_name = splitted_line[-1].lstrip(' ').strip('\n')

            rank_code = splitted_line[3]

            # Find entry for all eukaryotes
            if rank_code == 'D' and scientific_name == 'Eukaryota':
                read_num_eukaryotes = int(splitted_line[1])
                print('eukaryotes reads: ', read_num_eukaryotes)

            if rank_code == 'D1' and scientific_name == 'Opisthokonta':
                read_num_opisthokonta_general = int(splitted_line[2])
                print('general opisthokonta reads: ',
                      read_num_opisthokonta_general)

            # Find entry for Metazoa clade
            if rank_code == 'K' and scientific_name == 'Metazoa':
                read_num_metazoa = int(splitted_line[1])
                print('metazoa reads: ', read_num_metazoa)

            # Collect data from remaining phyla of non-metazoa eukaryotes
            if rank_code == 'P' and scientific_name != 'Chordata':
                num_reads_rooted_clade = int(splitted_line[1])
                read_num_non_metazoa_phylum_level += num_reads_rooted_clade
                phyla_list.append(
                    [sample_name, scientific_name, num_reads_rooted_clade])

            # Stop when all species of Eukaryota clade have been processed
            if rank_code == 'D' and scientific_name != 'Eukaryota':
                break

    read_num_non_metazoa = read_num_eukaryotes - \
        read_num_metazoa - read_num_opisthokonta_general
    print('non-metazoa reads: ', read_num_non_metazoa)

    read_num_non_metazoa_not_phylum_level = read_num_non_metazoa - \
        read_num_non_metazoa_phylum_level

    print('non-metazoa reads on phylum level: ',
          read_num_non_metazoa_phylum_level)

    # Why are these values so high? Because of "general Eukaryota reads"
    print('non-metazoa reads not on phylum level: ',
          read_num_non_metazoa_not_phylum_level)

    # collect data for each phylum and write it to output file
    for phylum in phyla_list:
        phylum.append((phylum[2]*100)/(read_num_non_metazoa -
                      read_num_non_metazoa_not_phylum_level))
        phylum.append(read_num_non_metazoa -
                      read_num_non_metazoa_not_phylum_level)
    write_clade_list_to_file(phyla_list, output_file_name)


def process_phylum_in_bacteria(file_path: str, output_file_name: str, sample_name: str):
    """Processes data from single report file and writes it to output file \
        when the taxonomy level is 'phylum_in_bacteria'. Percentages for each phylum\
            of all phyla in clade bacteria will be calculated."""

    phylum_list = []
    start_processing_lines = False
    total_read_num = 0
    # process kraken report file
    with open(file_path, 'r', encoding='utf-8') as report:
        lines = list(report)
        read_num_phylum_level = 0

        # process every line of the kraken report
        for line in lines:
            splitted_line = line.strip(' ').split('\t')
            scientific_name = splitted_line[-1].lstrip(' ').strip('\n')

            rank_code = splitted_line[3]

            # Find entry for Bacteria clade
            if rank_code == 'D' and scientific_name == 'Bacteria':
                total_read_num = int(splitted_line[1])
                print('total reads: ', total_read_num)
                start_processing_lines = True

            # Collect data from all phyla in Bacteria clade
            if rank_code == 'P' and start_processing_lines is True:
                num_reads_rooted_clade = int(splitted_line[1])
                read_num_phylum_level += num_reads_rooted_clade
                phylum_list.append(
                    [sample_name, scientific_name, num_reads_rooted_clade])

            # Stop when all species of Bacteria clade have been processed
            if rank_code == 'D' and scientific_name not in ('Bacteria', 'Eukaryota'):
                print('stopped at: ', scientific_name)
                break

    # collect data for each domain and write it to output file
    for phylum in phylum_list:
        phylum.append((phylum[2]*100)/total_read_num)
        phylum.append(total_read_num)
        print(phylum)

    # Calculate percentage of reads in 'Chordata' not classified to species level
    read_num_not_phylum_level = total_read_num - read_num_phylum_level

    unclassified_at_phylum_level = [sample_name, 'unclassified_at_phylum_level',
                                    read_num_not_phylum_level,
                                    (100*read_num_not_phylum_level) /
                                    total_read_num,
                                    total_read_num]
    phylum_list.append(unclassified_at_phylum_level)
    print(unclassified_at_phylum_level)
    write_clade_list_to_file(phylum_list, output_file_name)


def process_top_5_phyla_in_bacteria(file_path: str, output_file_name: str, sample_name: str):
    """Processes data from single report file and writes it to output file \
        when the taxonomy level is 'top_5_phyla_bacteria'. Percentages for each phylum\
            of Pseudomonadota, Actinomycetota, Cyanobacteriota, Bacillota and Bacteriodota \
                (the most abundant ones) in clade bacteria will be calculated."""

    top_5_phyla = ['Pseudomonadota',  'Actinomycetota',
                   'Bacillota', 'Cyanobacteriota', 'Bacteroidota']
    phylum_list = []
    start_processing_lines = False
    total_read_num = 0

    # process kraken report file
    with open(file_path, 'r', encoding='utf-8') as report:
        lines = list(report)

        # process every line of the kraken report
        for line in lines:
            splitted_line = line.strip(' ').split('\t')
            scientific_name = splitted_line[-1].lstrip(' ').strip('\n')

            rank_code = splitted_line[3]

            # Collect data from top 5 phyla in Bacteria clade
            if rank_code == 'P' and scientific_name in top_5_phyla:
                num_reads_rooted_clade = int(splitted_line[1])
                total_read_num += num_reads_rooted_clade
                phylum_list.append(
                    [sample_name, scientific_name, num_reads_rooted_clade])

            # Stop when all species of Bacteria clade have been processed
            if rank_code == 'D' and scientific_name not in ('Bacteria', 'Eukaryota'):
                print('stopped at: ', scientific_name)
                break

    # collect data for each domain and write it to output file
    for phylum in phylum_list:
        phylum.append((phylum[2]*100)/total_read_num)
        phylum.append(total_read_num)
        print(phylum)

    write_clade_list_to_file(phylum_list, output_file_name)


PARSER = ArgumentParser()

PARSER.add_argument('-i', '--input_dir', required=True)
PARSER.add_argument('-l', '--level_taxonomy',
                    default='domain',
                    choices=['domain',
                             # 'kingdom',
                             'species_in_chordata',
                             'phylum_non_metazoa_eukaryotes',
                             'phylum_bacteria',
                             'top_5_phyla_bacteria'])
ARGS = PARSER.parse_args()


input_dir_name = ARGS.input_dir
level_taxonomy = ARGS.level_taxonomy

print(level_taxonomy)

OUTPUT_FILE_NAME = 'percentages_taxa_' + level_taxonomy + '.txt'


# prepare output file with header
with open(OUTPUT_FILE_NAME, 'w', newline='', encoding='utf-8') as out_file_2:
    header_writer = csv.writer(out_file_2, delimiter='\t')
    header_writer.writerow(['sample', level_taxonomy, 'num_reads_rooted_clade',
                            'percent_reads_rooted_clade', 'num_total_reads'])

# iterate over report files in input directory
for input_file_name in os.listdir(input_dir_name):

    input_file_path = input_dir_name + input_file_name
    current_sample = input_file_name.split('_')[1]
    if is_kraken_report(input_file_path):
        if level_taxonomy == 'domain':
            process_domain(input_file_path, OUTPUT_FILE_NAME, current_sample)
        if level_taxonomy == 'species_in_chordata':
            process_species_in_chordata(
                input_file_path, OUTPUT_FILE_NAME, current_sample)
        if level_taxonomy == 'phylum_non_metazoa_eukaryotes':
            process_phylum_non_metazoa_eukaryotes(
                input_file_path, OUTPUT_FILE_NAME, current_sample)
        if level_taxonomy == 'phylum_bacteria':
            process_phylum_in_bacteria(
                input_file_path, OUTPUT_FILE_NAME, current_sample)
        if level_taxonomy == 'top_5_phyla_bacteria':
            process_top_5_phyla_in_bacteria(
                input_file_path, OUTPUT_FILE_NAME, current_sample)
        else:
            print('Please provide usable taxonomy level')
