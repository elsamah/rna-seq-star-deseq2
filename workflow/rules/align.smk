rule align_pe:
  input:
    fq1=get_fq1,
    fq2=get_fq2
  output:
    alignedcoord="results/star/pe/{sample}/Aligned.sortedByCoord.out.bam",
    alignedtranscriptome="results/star/pe/{sample}/Aligned.toTranscriptome.out.bam",
  threads: 16
  params:
    stargtf=config['star']['gtf'],
    starparams=config['star']['params'],
    stargenome=config["star"]["star-genome"],
    outprefix="results/star/pe/{sample}/",
  shell:
    """
    module load STAR/2.7.3a
    
    STAR \
    --quantMode GeneCounts TranscriptomeSAM \
    --outSAMtype BAM SortedByCoordinate \
    --outFilterIntronMotifs RemoveNoncanonical \
    --chimSegmentMin 10 \
    --chimOutType SeparateSAMold \
    --outSAMunmapped Within \
    --sjdbGTFfile {params.stargtf} {params.starparams} \
    --runThreadN {threads} \
    --genomeDir {params.stargenome} \
    --readFilesIn {input.fq1} {input.fq2} \
    --readFilesCommand zcat \
    --outFileNamePrefix {params.outprefix} \
    --outStd Log
    """
    
    
rule align_se:
    input:
      fq1=get_fq1,
      fq2=get_fq2
    output:
      alignedcoord="results/star/se/{sample}/Aligned.sortedByCoord.out.bam",
      alignedtranscriptome="results/star/se/{sample}/Aligned.toTranscriptome.out.bam",
      counts="results/star/se/{sample}/ReadsPerGene.out.tab",
    threads: 16
    params:
      stargtf=config['star']['gtf'],
      starparams=config['star']['params'],
      stargenome=config["star"]["star-genome"],
      outprefix="results/star/se/{sample}/",
    threads: 16
    shell:
      """
      module load STAR/2.7.3a
      
      STAR \
      --quantMode GeneCounts TranscriptomeSAM \
      --outSAMtype BAM SortedByCoordinate \
      --outFilterIntronMotifs RemoveNoncanonical \
      --chimSegmentMin 10 \
      --chimOutType SeparateSAMold \
      --outSAMunmapped Within \
      --sjdbGTFfile {params.stargtf} {params.starparams} \
      --runThreadN {threads} \
      --genomeDir {params.stargenome} \
      --readFilesIn {input.fq1} \
      --readFilesCommand zcat \
      --outFileNamePrefix {params.outprefix} \
      --outStd Log
      """

rule index_coord_pe:
  input:
    "results/star/pe/{sample}/Aligned.sortedByCoord.out.bam",
  output:
    "results/star/pe/{sample}/Aligned.sortedByCoord.out.bam.bai",
  params:
  shell:
    """
    module load samtools/1.17
    
    samtools index {input} {output}
    """

rule index_coord_se:
  input:
    "results/star/se/{sample}/Aligned.sortedByCoord.out.bam",
  output:
    "results/star/se/{sample}/Aligned.sortedByCoord.out.bam.bai",
  params:
  shell:
    """
    module load samtools/1.17
    
    samtools index {input} {output}
    """
