conda create -y -n aln -c conda-forge -c bioconda locarna
conda activate aln
cd coverage100
nohup mlocarna --threads=10 --stockholm --write-structure --iterate --tgtdir coverage100_locarna --keep-sequence-order --consensus-structure=alifold fasta/coverage100.fa > coverage100.locarna&
conda create -y -n extractfasta -c bioconda -c conda-forge biopython
conda activate extractfasta
./multifastaselect.py --in_fasta_filepath fasta/coverage100.fa --out_filepath fasta --selected_ids NT_033777.3:23983503-23984565,NC_052523.1:20206768-20207826,NC_046670.1:20931002-20932054,NC_045952.1:22528594-22529611,NC_050609.1:7493273-7494336
conda activate aln
nohup mlocarna --threads=10 --stockholm --write-structure --iterate --tgtdir selected_locarna --keep-sequence-order --consensus-structure=alifold fasta/selected.fa > selected.locarna&
conda create -y -n vis -c conda-forge -c bioconda viennarna
conda activate vis
RNAalifold --aln-stk=RNAalifold selected_locarna/results/result.stk
#use guide structure
export guide_structure=$(cat selected.locarna | grep alifold -A 9 | tr -d '[:space:]' | cut -c 8-1095)
sed -E "s/([ +])([().]+)/\1$guide_structure/g" RNAalifold.stk > RNAalifold_mlocarna.stk
RNAplot --covar -o ps -t 4 -a RNAalifold_mlocarna.stk
RNAalifold --SS_cons --color --aln RNAalifold_mlocarna.stk
conda create -y -n conversion -c conda-forge -c bioconda ghostscript pdf2svg
conda activate conversion
ps2pdf -dEPSCrop alignment_0001_ss.ps alignment_0001_ss.pdf
pdf2svg alignment_0001_ss.pdf alignment_0001_ss.svg
conda create -n msaquality -c conda-forge -c bioconda rnaz rnacode selectsequencesfrommsa
conda activate msaquality
echo "" >> selected_locarna/results/result.aln
SelectSequencesFromMSA --inputclustalpath=selected_locarna/results/result.aln
RNAz -l results.selected > RNAz_structure.out
RNAcode results.selected > RNAcode.out

