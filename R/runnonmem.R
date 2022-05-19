#' Run NONMEM
#'
#' @description Run NONMEM from R. Creates a `.bat` file in a temporary directory and executes it from R.
#'
#' @param name name of the model to run located in `dir`. Accepted extension are: ".mod", ".ctl" and ".txt"
#' @param dir project directory where the file in `name` is and where `NONMEM` will be executed
#' @param file full name file with directory, alternative to `name` and `dir` arguments.
#' @param nmfe_location location of the `nmfeXX.bat` script, usually available in the NONMEM installation directory
#'
#' @return call for side effects. Open a shell where NONMEM runs
#' @export
#'
#' @examples
#' \dontrun{
#' # First, define where is NONMEM is installed
#' options(runnonmem_nmfe_location = "C:/nmXXXXX/util/nmfeXX.bat")
#'
#' # Then launch a run
#' # If the control stream is in the working directory, just execute
#' runnonmem("mod001.mod")
#'
#' # Or specify the project directory apart
#' runnonmem("mod001.mod", "/my/working/directory")
#'
#' # Or full path to model object
#' runnonmem(file = "C:/my/working/directory.mod001.mod")
#' }
#'
#'
runnonmem <- function(name,
                      dir = getwd(),
                      file = NULL,
                      nmfe_location = getOption("runnonmem_nmfe_location")){
  if(is.null(nmfe_location)){
    stop("Please set the location of the `nmfeXX.bat` script.")
  }
  if(!file.exists(nmfe_location)) stop(paste("Cannot find", nmfe_location))
  mod_ <- mod(name = name, dir = dir, file = file)
  if(!file.exists(mod_)) stop(paste("Cannot find", mod_))
  mod_ <- normalizePath(mod_)
  cmd_ <- cmd(modelfile = mod_, nonmem = nmfe_location)
  bat_ <- bat()
  write_bat(command = cmd_, batfile = bat_)
  shell.exec(bat_)
}

mod <- function(name, dir = getwd(), file = NULL){
  mod_ <- file
  if(is.null(mod_)){
    if(missing(name)) stop("'name' argument is missing.")
    mod_ <- file.path(dir, name)
  }
  mod_
}

cmd <- function(modelfile, nonmem){
  disk_ <- getdisk(modelfile)
  dir_ <- dirname(modelfile)
  mod_ <- basename(modelfile)
  lst_ <- lst(mod_)
  paste(disk_, "& cd", tick(dir_), "& CALL", tick(nonmem), mod_, lst_, "& pause")
}

bat <- function(){
  random <- paste0(sample(c(letters,0:9), 10, T), collapse = "")
  filenam_ <- paste0(random, ".bat")
  path_ <- paste(tempdir(), "runnonmem", sep = "\\")
  paste(path_, filenam_, sep = "\\")
}

write_bat <- function(command, batfile){
  dir.create(dirname(batfile), showWarnings = FALSE)
  fileConn <- file(batfile)
  writeLines(command, fileConn)
  close(fileConn)
}

getdisk <- function(x){
  d <- strsplit(x, split = ":")[[1]][1]
  if(x==d) return(NA_character_)
  paste0(d,":")
}

lst <- function(x, extension = "mod$|ctl$|txt$"){
  lst <- gsub(extension, "lst", x)
  if(x==lst) stop("Cannot create .lst file name. Supported extensions are: .mod, .ctl, .txt.")
  lst
}

tick <- function(x){
  paste0("\"", x, "\"")
}
