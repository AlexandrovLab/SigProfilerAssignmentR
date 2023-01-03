
[![Docs](https://img.shields.io/badge/docs-latest-blue.svg)](https://osf.io/mz79v/wiki/home/) 
[![License](https://img.shields.io/badge/License-BSD\%202--Clause-orange.svg)](https://opensource.org/licenses/BSD-2-Clause)
[![Build Status](https://travis-ci.com/AlexandrovLab/SigProfilerAssignmentR.svg?branch=master)](https://travis-ci.com/AlexandrovLab/SigProfilerAssignmentR)

<img src="figures/SigProfilerAssignment.png" alt="drawing" width="1000"/>

# SigProfilerAssignmentR
An R wrapper for running the SigProfilerAssignment framework.

SigProfilerAssignment allows assigning previously known mutational signatures to individual samples and individual somatic mutations. The tool provides the ability to _refit_ different types of reference mutational signatures, including [COSMIC signatures](https://cancer.sanger.ac.uk/signatures/), as well as custom signature databases. _Refitting of known_ mutational signatures is a numerical optimization approach tat not only identifies the set of operative mutational signatures in a particular sample, but also quantifies the number of mutations attributed to each signature found in that sample. The tool makes use of [SigProfilerMatrixGenerator](https://github.com/AlexandrovLab/SigProfilerMatrixGenerator) and [SigProfilerPlotting](https://github.com/AlexandrovLab/SigProfilerPlotting), seamlessly integrating with other [SigProfiler tools](https://cancer.sanger.ac.uk/signatures/tools/).

For users that prefer working in a Python environment, please check: https://github.com/AlexandrovLab/SigProfilerAssignment. Detailed documentation can be found at: https://osf.io/mz79v/wiki/home/.


## Installation
**PREREQUISITES**

devtools  (R) 
```R
>> install.packages("devtools")
```

reticulate* (R) 
```R
>> install.packages("reticulate")  
```

*Reticulate has a known bug of preventing python print statements from flushing to standard out. As a result, some of the typical progress messages are delayed.

**QUICK START GUIDE**

1. First, install the python package using pip. The R wrapper still requires the python package:

```
$ pip install SigProfilerAssignment
```

2. Open an R session and ensure that your R interpreter recognizes the path to your python installation:

```R
$ R
>> library(reticulate)
>> use_python("path_to_your_python")
>> py_config()
python:         /anaconda3/bin/python
libpython:      /anaconda3/lib/libpython3.6m.dylib
pythonhome:     /anaconda3:/anaconda3
version:        3.6.5 |Anaconda, Inc.| (default, Apr 26 2018, 08:42:37)  [GCC 4.2.1 Compatible Clang 4.0.1 (tags/RELEASE_401/final)]
numpy:          /anaconda3/lib/python3.6/site-packages/numpy
numpy_version:  1.16.1
```
If you do not see your python path listed, restart your R session and rerun the above commands in order.

3. Install SigProfilerAssignmentR using devtools:

```R
>> library(devtools)
>> install_github("AlexandrovLab/SigProfilerAssignmentR")
```

4. If mutation calling files (MAF, VCF, or simple text files) are used as input, please load the package in the same R session and install your desired reference genome as follows:

```R
>> library(SigProfilerAssignmentR)
>> install("GRCh37", rsync=FALSE, bash=TRUE)
```

This will install the human 37 assembly as a reference genome. 

**SUPPORTED GENOMES**

Other available reference genomes are GRCh38, mm9, mm10, and rn6. Information about supported genomes can be found at https://github.com/AlexandrovLab/SigProfilerMatrixGeneratorR

## Running

Assigning of known mutational signatures to individual samples can be performed using the `cosmic_fit` function. Input samples can be provided using mutation calling files (VCFs, MAFs, or simple text files), segmentation files or mutational matrices. COSMIC mutational signatures v3.3 are used as the default reference signatures, although previous COSMIC versions and custom signature databases are also supported using the `cosmic_version` and `signature_database` parameters.

```R
>> library(SigProfilerAssignmentR)
>> cosmic_fit(samples, output, input_type='matrix', context_type="96",
              collapse_to_SBS96=TRUE, cosmic_version=3.3, exome=FALSE,
              genome_build="GRCh37", signature_database=NULL,
              exclude_signature_subgroups=NULL, export_probabilities=TRUE,
              export_probabilities_per_mutation=FALSE, make_plots=TRUE,
              sample_reconstruction_plots=FALSE, verbose=FALSE)
```

### Main Parameters

| Parameter | Variable Type | Parameter Description |
| ------ | ----------- | ----------- |
| samples | String | Path to the input somatic mutations file (segmentation file/mutational matrix) or folder (mutation calling file). |
| output | String | Path to the output folder. |
| input_type | String | Three accepted input types:<ul><li> "vcf": if using mutation calling file/s (VCF, MAF, simple text file) as input</li><li>"seg:TYPE": if using a segmentation file as input. Please check the required format at https://github.com/AlexandrovLab/SigProfilerMatrixGenerator#copy-number-matrix-generation. The accepted callers for TYPE are the following {"ASCAT", "ASCAT_NGS", "SEQUENZA", "ABSOLUTE", "BATTENBERG", "FACETS", "PURPLE", "TCGA"}.For example:"seg:BATTENBERG"</li><li>"matrix": if using a mutational matrix as input</li></ul>The default value is "matrix". |
| context_type | String | Required context type if `input_type` is "vcf". `context_type` takes which context type of the input data is considered for assignment. Valid options include "96", "288", "1536", "DINUC", and "ID". The default value is "96". |
| cosmic_version | Float | Defines the version of the COSMIC reference signatures. Takes a positive float among 1, 2, 3, 3.1, 3.2 and 3.3. The default value is 3.3. |
| exome | Boolean | Defines if the exome renormalized COSMIC signatures will be used. The default value is False. |
| genome_build | String | The reference genome build, used for select the appropriate version of the COSMIC reference signatures, as well as processing the mutation calling file/s. Supported genomes include "GRCh37", "GRCh38", "mm9", "mm10" and "rn6". The default value is "GRCh37". If the selected genome is not in the supported list, the default genome will be used. |
| signature_database | String | Path to the input set of known mutational signatures (only in case that COSMIC reference signatures are not used), a tab delimited file that contains the signature matrix where the rows are mutation types and columns are signature IDs. |
| exclude_signature_subgroups | List | Removes the signatures corresponding to specific subtypes to improve refitting (only available when using default COSMIC reference signatures). The usage is explained below. The default value is None, which corresponds to use all COSMIC signatures. |
| export_probabilities | Boolean | Defines if the probability matrix per mutational context for all samples is created. The default value is True. |
| export_probabilities_per_mutation | Boolean | Defines if the probability matrices per mutation for all samples are created. Only available when `input_type` is "vcf". The default value is False. |
| make_plots | Boolean | Toggle on and off for making and saving plots. The default value is True. |
| sample_reconstruction_plots | Boolean | Toggle on and off for making and saving sample reconstruction plots. The default value is False. |
| verbose | Boolean | Prints detailed statements. The default value is False. |


### Signature Subgroups

When using COSMIC reference signatures, some subgroups of signatures can be removed to improve the refitting analysis. To use this feature, the `exclude_signature_subgroups` parameter should be added, following the sintax below:

```python
exclude_signature_subgroups = ['remove_MMR_deficiency_signatures',
                               'remove_POL_deficiency_signatures',
                               'remove_HR_deficiency_signatures' ,
                               'remove_BER_deficiency_signatures',
                               'remove_Chemotherapy_signatures',
                               'remove_Immunosuppressants_signatures'
                               'remove_Treatment_signatures'
                               'remove_APOBEC_signatures',
                               'remove_Tobacco_signatures',
                               'remove_UV_signatures',
                               'remove_AA_signatures',
                               'remove_Colibactin_signatures',
                               'remove_Artifact_signatures',
                               'remove_Lymphoid_signatures']
```

The full list of signature subgroups is included in the following table:

|Signature subgroup |           SBS signatures excluded | DBS signatures excluded | ID signatures excluded |
| ----------- | ----------- | ----------- | ----------- |
|MMR_deficiency_signatures|     6, 14, 15, 20, 21, 26, 44|      7, 10|  7|
|POL_deficiency_signatures|     10a, 10b, 10c, 10d, 28|         3|      -|
|HR_deficiency_signatures|      3|                              -|      6|
|BER_deficiency_signatures|     30, 36|                         -|      -|
|Chemotherapy_signatures|       11, 25, 31, 35, 86, 87, 90|     5|      -|
|Immunosuppressants_signatures| 32|                             -|      -|
|Treatment_signatures|          11, 25, 31, 32, 35, 86, 87, 90| 5|      -|
|APOBEC_signatures|             2, 13|                          -|      -|
|Tobacco_signatures |           4, 29, 92|                      2|      3|
|UV_signatures|                 7a, 7b, 7c, 7d, 38|             1|      13|
|AA_signatures|                 22|                             -|      -|
|Colibactin_signatures|         88|                             -|      18|
|Artifact_signatures|           27, 43, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 95|-|-|
|Lymphoid_signatures|           9, 84, 85|                      -|      -|


## Examples

### Using mutation calling files (VCFs) as input

```R
library(SigProfilerAssignmentR)

cosmic_fit(samples="test_data/vcf_input", 
           output="example_vcf",
           input_type="vcf",
           context_type="96",
           genome_build="GRCh37",
           cosmic_version=3.3)
```


### Using a multi-sample segmentation file as input

```R
library(SigProfilerAssignmentR)

cosmic_fit(samples="test_data/cnv_input/all.breast.ascat.summary.sample.tsv", 
           output="example_sf",
           input_type="seg:ASCAT_NGS",
           cosmic_version=3.3,
           collapse_to_SBS96=FALSE)
```

### Using a mutational matrix as input

```R
library(SigProfilerAssignmentR)

Analyze.cosmic_fit(samples="test_data/txt_input/sample_matrix_SBS.txt", 
                   output="example_mm",
                   input_type="matrix",
                   genome_build="GRCh37",
                   cosmic_version=3.3)
```

## <a name="copyright"></a> Copyright
This software and its documentation are copyright 2022 as a part of the SigProfiler project. The SigProfilerAssignmentR framework is free software and is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

## <a name="contact"></a> Contact Information
Please address any queries or bug reports to Marcos Díaz-Gay at mdiazgay@health.ucsd.edu.
