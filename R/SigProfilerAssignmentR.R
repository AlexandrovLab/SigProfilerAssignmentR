#' @title 
#' 
#' @description 
#'
#' @param 
#' 
#' @return
#' 
#' @export cosmic_fit
#'
#' @examples
cosmic_fit <- function(samples,
                       output,
                       signatures=NULL,
                       signature_database=NULL,
                       nnls_add_penalty=0.05,
                       nnls_remove_penalty=0.01,
                       initial_remove_penalty=0.05,
                       genome_build="GRCh37",
                       cosmic_version=3.3,
                       make_plots=T,
                       collapse_to_SBS96=T,
                       connected_sigs=T,
                       verbose=F,
                       devopts=NULL,
                       exclude_signature_subgroups=NULL,
                       exome=F,
                       input_type='matrix',
                       context_type="96",
                       export_probabilities=T,
                       export_probabilities_per_mutation=F,
                       sample_reconstruction_plots=F) {

  sys <- reticulate::import("sys")
  Analyze <- reticulate::import("SigProfilerAssignment.Analyzer")

  nnls_add_penalty=as.numeric(nnls_add_penalty)
  nnls_remove_penalty=as.numeric(nnls_remove_penalty)
  initial_remove_penalty=as.numeric(initial_remove_penalty)
  cosmic_version=as.numeric(cosmic_version)



  Analyze$cosmic_fit(samples=samples,
                     output=output,
                     signatures=signatures,
                     signature_database=signature_database,
                     nnls_add_penalty=nnls_add_penalty,
                     nnls_remove_penalty=nnls_remove_penalty,
                     initial_remove_penalty=initial_remove_penalty,
                     genome_build=genome_build,
                     cosmic_version=cosmic_version,
                     make_plots=make_plots,
                     collapse_to_SBS96=collapse_to_SBS96,
                     connected_sigs=connected_sigs,
                     verbose=verbose,
                     devopts=devopts,
                     exclude_signature_subgroups=exclude_signature_subgroups,
                     exome=exome,
                     input_type=input_type,
                     context_type=context_type,
                     export_probabilities=export_probabilities,
                     export_probabilities_per_mutation=export_probabilities_per_mutation,
                     sample_reconstruction_plots=sample_reconstruction_plots
                     )
  sys$stdout$flush()
}


#' @title 
#' 
#' @description 
#'
#' @param 
#' 
#' @return
#' 
#' @export install
#'
#' @examples
install <- function(genome, custom=F, rsync=F, bash=T, ftp=T){
  os <- reticulate::import("os")
  sys <- reticulate::import("sys")
  genInstall <- reticulate::import("SigProfilerMatrixGenerator.install")
  genInstall$install(genome, custom, rsync,bash,ftp)
  sys$stdout$flush()
}
