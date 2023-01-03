library(devtools)
install_github("AlexandrovLab/SigProfilerAssignmentR")

library(SigProfilerAssignmentR)

cosmic_fit(samples="test_data/vcf_input", 
           output="example_vcf",
           input_type="vcf",
           context_type="96",
           genome_build="GRCh37",
           cosmic_version=3.3)