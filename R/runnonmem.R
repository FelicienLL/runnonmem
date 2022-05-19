runnonmem <- function(name, dir = getwd(), file = NULL, nonmem_location = "C:/nm74g64/util/nmfe74.bat"){
  if(!file.exists(nonmem_location)) stop(paste("Cannot find", nonmem_location))
  mod_ <- mod(name = name, dir = dir, file = file)
  cmd_ <- cmd(modelfile = mod_, nonmem = nonmem_location)
  bat_ <- bat()
  write_bat(command = cmd_, batfile = bat_)
  shell.exec(bat_)
}

mod <- function(name, dir = getwd(), file = NULL){
  if(is.null(file)){
    if(missing(name)) stop("'name' argument is missing.")
    file <- file.path(dir, name)
  }
  if(!file.exists(file)) stop(paste("Cannot find", file))
  file <- normalizePath(file)
  file
}

cmd <- function(modelfile, nonmem){
  disk_ <- getdisk(modelfile)
  dir_ <- dirname(modelfile)
  mod_ <- basename(modelfile)
  lst_ <- lst(mod_)

  paste(disk_, "& cd", tick(dir_), "& CALL", tick(nonmem), mod_, lst_, "& pause")
}
# testthat::expect_equal(
#   cmd(modelfile = "Y:/PK-LE-LOUEDEC-FELICIEN/nm001/run001.mod", nonmem = "C:/nm74g64/util/nmfe74.bat"),
#   'Y: & cd "Y:/PK-LE-LOUEDEC-FELICIEN/nm001" & CALL "C:/nm74g64/util/nmfe74.bat" run001.mod run001.lst & pause'
# )


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
  paste0(d,":")
}

getdisk("C:/blabla")


lst <- function(x, extention = "mod$|ctl$|txt$"){
  gsub(extention, "lst", x)
}

gsub("mod", "lst", "run001.mod")
gsub("mod$", "lst", "mod001.mod")
gsub("mod$|ctl$", "lst", "mod001.mod")
gsub("mod$|ctl$|txt$", "lst", "ctl001.ctl")



tick <- function(x){
  paste0("\"", x, "\"")
}
tick("C:/hello")
