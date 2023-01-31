#!/bin/bash

NAME=$1
genome_fa=$2
threads=$3
TSS_bed=$4  #this is a bed file containing the position of TSS for each gene model

mkdir ${NAME}_peaks

##the 3 replicates are in a file each with the format being 0hr_1, 0hr_2 and 0hr_3 for example.
ls ./${NAME}_[1-9]/${NAME}_*.tagAlign.gz
if [ ! -f ./${NAME}_peaks/${NAME}_pooled.tagAlign.gz ]; then zcat ./${NAME}_[1-9]/${NAME}_*.tagAlign.gz | awk '($3>$2) {print}' | gzip > ./${NAME}_peaks/${NAME}_pooled.tagAlign.gz; fi

##extract median fragment size from picard CollectInsertSizeMetrics output
extsize=`head -8 ./${NAME}_1/${NAME}_1_merged.window500.hist_data | tail -1 | cut -f1`
shift=$(( $extsize / 2 ))
if [ -z ${genome_size+x} ]; then 
genome_size=`faSize ${genome_fa} | head -1 | cut -d " " -f 5`; 
else echo "Genome is set to ${genome_size}"; fi
export genome_size

##run macs2 on pooled tagAlign file
if [ ! -f ./${NAME}_peaks/${NAME}.MACS_peaks.narrowPeak ]; then macs2 callpeak -t ./${NAME}_peaks/${NAME}_pooled.tagAlign.gz -f BED -n ./${NAME}_peaks/${NAME}.MACS -g ${genome_size} -p 1e-2 --nomodel --shift=-${shift} --extsize=${extsize} --SPMR; fi
if [ $? -eq 0 ]; then rm ./${NAME}_peaks/${NAME}.MACS_summits.bed; rm ./${NAME}_peaks/${NAME}.MACS_peaks.xls; else echo "Peak calling failed - inspect tagAlign file"; FAIL; fi

##make the DHS bed file
cat ./${NAME}_peaks/${NAME}.MACS_peaks.narrowPeak | parallel -j ${threads} --pipe cut -f1,2,3 - | sort -k1,1 -k2,2n > ./${NAME}_peaks/${NAME}.MACS_peaks.bed

##get DHS distances to nearest TSS
if [ ! -f ./${NAME}_peaks/${NAME}_DHS_TSS_distance.txt ]; then awk '{OFS="\t"; mid=int($2+(($3-$2)/2)); print $1, mid, mid+1}' ./${NAME}_peaks/${NAME}.MACS_peaks.bed | sort -k1,1 -k2,2n | bedtools closest -D a -b stdin -a ${TSS_bed} | uniq | cut -f7 > ./${NAME}_peaks/${NAME}_DHS_TSS_distance.txt; fi

##get SPOT scores
if [ ! -f ./${NAME}_peaks/${NAME}_SPOT ]; then
awk 'BEGIN{OFS="\t"};{print $1, $2, $3'} ./${NAME}_peaks/${NAME}.MACS_peaks.narrowPeak > ./${NAME}_peaks/${NAME}_OUTBED;
zcat ./${NAME}_peaks/${NAME}_pooled.tagAlign.gz | shuf | head -n 5000000 - > ./${NAME}_peaks/${NAME}_T_BEDFILE;
SPT=`bedtools intersect -f 1E-9 -wa -u -a ./${NAME}_peaks/*_T_BEDFILE -b ./${NAME}_peaks/*_OUTBED -bed | wc -l`;
if [ $? -eq 0 ]; then rm ./${NAME}_peaks/*_T_BEDFILE; rm ./${NAME}_peaks/*_OUTBED; else echo "SPOT score failed - moving on but look to repeat this step"; fi;
echo "scale=2; ${SPT}/5000000" | bc > ./${NAME}_peaks/${NAME}_SPOT;
fi

##create merged bam file
if [ ! -f ./${NAME}_peaks/${NAME}.bam ]; then samtools merge - ./${NAME}_*/${NAME}_*_merged.bam_filt | samtools sort -@ ${threads} -o ./${NAME}_peaks/${NAME}.bam -; fi
if [ ! -f ./${NAME}_peaks/${NAME}.bam.stats ]; then samtools flagstat ./${NAME}_peaks/${NAME}.bam; fi &
if [ ! -f ./${NAME}_peaks/${NAME}.bam.bai ]; then samtools index ./${NAME}_peaks/${NAME}.bam; fi

##plot DHS profile
if [ ! -f ./${NAME}_peaks/${NAME}_DHS_profile.png ]; then
bamCoverage -p ${threads} -b ./${NAME}_peaks/${NAME}.bam -o ./${NAME}_peaks/${NAME}.bw -bs 50 -p 2 --ignoreDuplicates --centerReads;
computeMatrix scale-regions -p ${threads} -S ./${NAME}_peaks/${NAME}.bw -R ./${NAME}_peaks/${NAME}.MACS_peaks.narrowPeak -o ./${NAME}_peaks/${NAME}_matrix -bs 50 -a 1000 -b 1000;
plotProfile --startLabel "DHS start" --endLabel "DHS end" --plotTitle "" --samplesLabel "DNaseI profile" --yAxisLabel "DNaseI cut frequency" -m ./${NAME}_peaks/${NAME}_matrix -o ./${NAME}_peaks/${NAME}_DHS_profile.png;
if [ $? -eq 0 ]; then rm ./${NAME}_peaks/${NAME}_matrix; rm ./${NAME}_peaks/${NAME}.bw; else echo "DNase activity plot failed - moving on but repeat this step"; fi;
fi

##Get DGF
mkdir ./${NAME}_peaks/${NAME}_footprints
if [ ! -f ./${NAME}_peaks/${NAME}_footprints/*bed ]; then wellington_footprints.py -fdrlimit -10 -p ${threads} ./${NAME}_peaks/${NAME}.MACS_peaks.bed ./${NAME}_peaks/${NAME}.bam ./${NAME}_peaks/${NAME}_footprints; if [ ! $? -eq 0 ]; then rm ./${NAME}_peaks/${NAME}.MACS_peaks.bed; fi; fi
