#!/bin/bash

# This script is not easily parellised and will set off 4 jobs once the _filt file is made by running jobs in background (&)
# first 3 samtools sort steps will use N threads and last will use N-3 (since three other jobs have been launched)

bam_in=$1
threads=$2
genome_fa=$3
picard_path=$4

echo ${bam_in} 
echo ${threads}
echo ${genome_fa}

#mapping using bowtie2 and setting the -p value

echo -n "" > ${bam_in%.bam}_log.txt

if [ ! -f ${bam_in}_filt ]; then
	if [ ! -f ${bam_in}_srt ]; then samtools view -q 30 -S -u ${bam_in} | samtools sort -@ ${threads} -o ${bam_in}_srt -; fi

	if [ ! -f ${bam_in}_srt.bai ]; then samtools index ${bam_in}_srt; fi

	if [ ! -f ${bam_in}_no_dup ]; then java -jar ${picard_path}/picard.jar MarkDuplicates ASSUME_SORTED=true REMOVE_DUPLICATES=true I=${bam_in}_srt O=${bam_in}_no_dup M=${bam_in%.bam}_marked_dup_metrics.txt 2>> ${bam_in%.bam}_log.txt; fi

	samtools sort -@ ${threads} -n ${bam_in}_no_dup | samtools fixmate -r -O bam - - | samtools view -F 1804 -f 2 -@ ${threads} -O BAM -u - | samtools sort -o ${bam_in}_filt - 2>> ${bam_in%.bam}_log.txt; fi
	if [ $? -eq 0 ]; then rm ${bam_in}_srt*; rm ${bam_in}_no_dup*; else echo "Bam processing steps likely failed"; FAIL; fi

if [ ! -f ${bam_in}_filt.bai ]; then samtools index ${bam_in}_filt; fi

if [ ! -f ${bam_in%.bam}_lib_complex_metrics.txt ]; then java -jar ${picard_path}/picard.jar EstimateLibraryComplexity I=${bam_in}_filt O=${bam_in%.bam}_lib_complex_metrics.txt 2>> ${bam_in%.bam}_log.txt; fi &

if [ ! -f ${bam_in%.bam}_gc_bias_metrics.pdf ]; then java -jar ${picard_path}/picard.jar CollectGcBiasMetrics I=${bam_in}_filt O=${bam_in%.bam}_gc_bias_metrics.txt CHART=${bam_in%.bam}_gc_bias_metrics.pdf S=${bam_in%.bam}_summary_metrics.txt R=${genome_fa} 2>> ${bam_in%.bam}_log.txt; fi &

if [ ! -f ${bam_in%.bam}.window500.hist_data ]; then java -jar ${picard_path}/picard.jar CollectInsertSizeMetrics I=${bam_in}_filt O="${bam_in%.bam}.window500.hist_data" H="${bam_in%.bam}.window500.hist_graph.pdf" W=500 2>> ${bam_in%.bam}_log.txt; fi &

threads_n=$(( ${threads} - 3 ))
if [ ! -f ${bam_in%.bam}.tagAlign.gz ]; then samtools sort -@ ${threads_n} -n -O BAM ${bam_in}_filt | bamToBed -i stdin -bedpe | awk 'BEGIN{FS="\t";OFS="\t"}{print $1,$2,$6,"N",$8,$9}' | gzip > ${bam_in%.bam}.tagAlign.gz 2>> ${bam_in%.bam}_log.txt; fi

if [ ! -f ${bam_in%.bam}_mapq_distribution.txt ]; then zcat ${bam_in%.bam}.tagAlign.gz | cut -f5 | sort | uniq -c | sort -k2,2n > ${bam_in%.bam}_mapq_distribution.txt; fi
gnuplot <<- EOF
        set xlabel "MAPQ scores"
        set ylabel "Frequency" 
        set term png
	set boxwidth 0.5
	set style fill solid
        set output "${bam_in%.bam}_mapq_distribution.png"
        plot "${bam_in%.bam}_mapq_distribution.txt" using 2:1 with boxes
EOF

echo "tagAlign file made. Inspect QC outputs to decide on sample quality."

