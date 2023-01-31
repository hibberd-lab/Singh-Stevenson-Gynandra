# Singh-Stevenson-Gynandra deetiolation

This repository contains data processing scripts, data analysis and plotting scripts and commands.

The naming of files largely reflects the figures in which the data is used and presented.

### Fig 1: 
- No associated files

### Fig 2
#### Analysis and plots relating to RNaseSEQ
- All_read_counts.txt is the raw read counts produced after salmon quant (see command_line_steps)
- DEseq2.R contains the R script for the DEseq2 processing of the RNAseq using the All_read_counts.txt file. It also contains the PCA plot used in Fig 2A
- edgeR.R contains the R script for the edgeR processing of the RNAseq using the All_read_counts.txt file.
- NOTE: an inner join was used between the outputs from edgeR and DEseq2 to identify the final sets of significant differentially regulated genes. 
- Fig2B.R contains heatmap plotting script for Fig2B
- Fig2B_heatmap_data.txt is data used as input for Fig2B.R
- Fig2C.R contains heatmap plotting script for Fig2C
- Fig2C_heatmap_data.txt is data used as input for Fig2C.R

### Fig 3:
#### Processing, analysis and plotting of DNaseI-SEQ data relating to DHS
- DnaseSEQ_tagAlign.sh is the bash script to create the tagAlign files needed for DNase Hypersentive Sites (DHS) and Digital Genomic Footprints (DGF). This uses the raw bam files available from the NCBI PRJNA640984 project.
- DHS_DGF_identification.sh is the bash pipeline used to call DHS and then the DGF. This uses the tagAlign files created by DnaseSEQ_tagAlign.sh.
- Ggynandra_DNaseSEQ_multiqc_report.html is the QC report for all the DNaseI-SEQ libraries.
- Fig3C.R contains the plotting script for the line plots showing the difference in read depth in the 4kbp surrounding the Transcriptional Start Sites (TSS) between the 4 light samples and the dark.
- Fig3D.R contains the script for plotting the boxplots of the G-box motifs within the DHS of light-responsive genes.
- Fig3D_data.txt contains the data used in Fig3D.R
- Fig3E.R contains the script to plot the motif clusters that were  most enriched or deleted in light specific DHS
- Fig3E_data.txt contains the data used in Fig3E.R

### Fig 4:
#### Analysis and plotting related to DGF found from DNaseI-SEQ
- Fig4A.R contains the plotting script to make the pie charts showing the frequencies of DGF found to overlap with each gene feature (exon, promoter etc)
- Fig4A_data.txt contains the data used in Fig4A.R
- Fig4B.R contains the code for calculating and plotting the relative motif abundances in DGF between all light samples and the 0H/dark sample.
- Fig4C.R contains the script to plot all motif clusters and thier abundances across all time points, from which a select few were chosen for main figure 4C.
- Fig4BC_data.txt contains the data used in Fig4B.R and Fig4C.R.

### Fig 5:
#### Comparative multiomics with RNase-SEQ and DNaseI-SEQ with Arabisopsis and Gynandra
- Fig5D.R is the boxplot plotting script showing the expression patterns of Gynandra TFs that are orthologous to two distinct groups of TFs found to be light responsive in a de-etiolation Arabidopsis time-course.
- Fig5D_right_panel_data and Fig5D_left_panel_data.txt are data used in the Fig5D.R script.
- Fig5E.R contains the script to plot the motif enrichments for 3 motif clusters in both Arabidopsis and Gynandra for the C3 and C4 gene DHS
- Fig5E_data.txt is the data used in Fig5E.R
- Fig5F.R contains the script to plot the boxplots of enrichment of each motif cluster within the DGF associated with genes most strongly induced by light.
- Fig5F_data.txt contains the data for Fig5F.R.

### Fig 6:
- No associated files
