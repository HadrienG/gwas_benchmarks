process plink2 {
    tag "$prefix"
    label "plink2"
    publishDir "results/plink2/imputed", mode: 'copy'
    input:
        tuple val(prefix), path(genotypes), path(to_include), path(pheno)
    output:
        tuple val(prefix), path("${prefix}.*.glm.linear"), emit:  plink_results
    script:
        """
        plink2 --bpfile "${prefix}" --keep "${to_include}" \
            --out "${prefix}" --threads "${task.cpus}" \
            --ci 0.95 --glm hide-covar cols=+a1freq,+ax --maf 0.01 \
            --hwe 1e-20 --geno 0.05 --pheno ${pheno} \
            --covar ${pheno} --pheno-name standing_height \
            --covar-name genetic_sex PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 \
                PC9 PC10 PC11 PC12 PC13 PC14 PC15 
        """
}


process plink2_hardcalls {
    tag "$prefix"
    label "plink2"
    publishDir "results/plink2/hardcalls", mode: 'copy'
    input:
        tuple val(prefix), path(genotypes), path(to_include), path(pheno)
    output:
        tuple val(prefix), path("${prefix}.*.glm.linear"), emit:  plink_results_hardcalls
    script:
        """
        # --bfile allows to drop imputed
        plink2 --bfile "${prefix}" --keep "${to_include}" \
            --out "${prefix}" --threads "${task.cpus}" \
            --ci 0.95 --glm hide-covar cols=+a1freq,+ax --maf 0.01 \
            --hwe 1e-20 --geno 0.05 --pheno ${pheno} \
            --covar ${pheno} --pheno-name standing_height \
            --covar-name genetic_sex PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 \
                PC9 PC10 PC11 PC12 PC13 PC14 PC15 
        """
}