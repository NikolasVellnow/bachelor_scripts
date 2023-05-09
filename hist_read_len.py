# Plot histograms of read length distribution of sample bam files





"""


"""
import subprocess
import matplotlib.pyplot as plt

shell_command = 'ls | grep .bam'

OUTPUT_STREAM = subprocess.run(shell_command, capture_output=True, shell=True, text=True, check=True)

bam_files = OUTPUT_STREAM.stdout.split('\n')[:-1]

# 
fig, axs = plt.subplots(4,5, sharey=True, sharex=True)


positions = {0: (0,0),
	1: (0,1),
	2: (0,2),
	3: (0,3),
	4: (0,4),
	5: (1,0),
	6: (1,1),
	7: (1,2),
	8: (1,3),
	9: (1,4),
	10: (2,0),
	11: (2,1),
	12: (2,2),
	13: (2,3),
	14: (2,4),
	15: (3,0),
	16: (3,1),
	17: (3,2),
	18: (3,3),
	19: (3,4)}


for i,file in enumerate(bam_files):

	sample = file.split('_')[0]
	samtools_command = f'samtools stats {file} | grep ^RL | cut -f 2-'.format(file)

	OUTPUT_STREAM = subprocess.run(samtools_command, capture_output=True, shell=True, text=True, check=True)

	rows = OUTPUT_STREAM.stdout
	split_rows = rows.split('\n')
	split_split_rows = [row.split('\t') for row in split_rows][:-1]
	read_lens = ([int(entry[0]) for entry in split_split_rows])
	read_lens.append(151)
	read_counts = ([int(entry[1]) for entry in split_split_rows])
	axs[positions[i]].stairs(read_counts, read_lens, fill=True)
	axs[positions[i]].set_title(sample, pad=3.0)
	plt.yscale('log')

fig.text(0.5, 0.04, 'Read length', ha='center', va='center', fontsize=18)
fig.text(0.06, 0.5, 'Read counts', ha='center', va='center', rotation='vertical', fontsize=18)
plt.show()

print('done')

