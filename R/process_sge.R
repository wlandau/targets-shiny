# To run pipelines as jobs on a Sun Grid Engine (SGE) cluster,
# Deploy the app with the TARGETS_SHINY_BACKEND environment variable
# equal to "sge". Create an app-level .Renviron file for this.
if (identical(tolower(Sys.getenv("TARGETS_SHINY_BACKEND")), "sge")) {

# Run the pipeline in a new Sun Grid Engine (SGE) job
# if no such job is already running in the current project.
process_run <- function() {
  if (!project_exists()) return()
  if (process_running()) return()
  # Block the session while the job is being submitted.
  control_running()
  control_processing()
  on.exit(control_processed())
  # Submit the job.
  process_submit()
  # Give time for the job to post.
  Sys.sleep(1)
}

# Cancel the process if it is running.
process_cancel <- function() {
  if (!project_exists()) return()
  if (!process_running()) return()
  control_processing()
  system2("qdel", process_id())
}

# Submit a pipeline as an SGE job.
process_submit <- function() {
  # The process ID should be short enough that all of it
  # shows up in qstat.
  id <- paste0("t", digest(tempfile(), algo = "xxhash32"))
  # Define other parameters for the job script.
  log_sge <- project_path(project_get(), "sge.txt")
  log_stdout <- project_stdout()
  log_stderr <- project_stderr()
  # Save files for the job shell script and the job ID.
  path_job <- project_path(project_get(), "job.sh")
  path_id <- project_path(project_get(), "id")
  writeLines(glue(process_script), path_job)
  writeLines(id, path_id)
  Sys.chmod(path_job, mode = "0744")
  # Submit the job.
  system2("qsub", path_job)
}

# The app passes this script to qsub when it submits the job.
# The curly braces are glue patterns that the
# process_submit() function populates.
process_script <-  "#!/bin/bash
#$ -N {id}          # Job name. Should be unique, short enough that qstat does not truncate it.
#$ -j y             # Combine SGE stdout and stderr into one log file.
#$ -o {log_sge}     # Log file.
#$ -cwd             # Submit from the current working directory.
#$ -V               # Use environment variables
#$ -l h_rt=04:00:00 # Maximum runtime is 4 hours.
module load R       # Load R as an environment module on the cluster. Pick the right version if applicable.
Rscript -e 'targets::tar_make(callr_arguments = list(stdout = \"{log_stdout}\", stderr = \"{log_stderr}\"))'"

# Get the SGE job ID of the pipeline.
process_id <- function() {
  path <- project_path(project_get(), "id")
  if (any(file.exists(path))) {
    readLines(path)
  } else {
    NA_character_
  }
}

# Read the _targets/meta/process file to get the PID of the pipeline
# and check if it is running.
process_running <- function() {
  id <- process_id()
  !anyNA(id) && any(grepl(id, system2("qstat", stdout = TRUE)))
}

# Status indicator that changes whenever a pipeline starts or stops.
# Useful as a reactive value to update the UI at the proper time.
process_status <- function() {
  list(pid = process_id(), running = process_running())
}

}
