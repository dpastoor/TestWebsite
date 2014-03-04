##list files
library(stringr)
library(knitr)
setwd(paste0(getwd(), "/TestWebsite/RMD"))
files <- list.files()
isRmd <- grep("*.Rmd", files)
Rmd_files <- files[isRmd]
Rmd_files <- Rmd_files[c(8, 9, 2, 10, 6, 1, 5,4,  7, 3)]

# test str_split
str_split(Rmd_files[[1]], pattern='.Rmd')[[1]][[1]]
#lapply(Rmd_files, function(x) knit(x,output=paste0(str_split(x, pattern='.Rmd')[[1]][[1]]), ".md"))
#figure out why lapply not working by for loop does


# parse to markdown
for(i in seq_along(Rmd_files)) {
knit(Rmd_files[[i]], output=paste0(str_split(Rmd_files[[i]], pattern = '.Rmd')[[1]][[1]], ".md"))
}


# markdown to html vs pandoc w/ TOC
for(i in seq_along(Rmd_files)) {
  system(command=paste("pandoc -s -S --toc -c custom.css", paste0(str_split(Rmd_files[[i]], pattern = '.Rmd')[[1]][[1]], ".md"),
                       "-o", paste0("..\\", str_split(Rmd_files[[i]], pattern = '.md')[[1]][[1]], "html")))
}
# for some reason Rmd_Lab_Notebook.Rmd is not compiling properly in the loop
#- but works fine from the command line via
# pandoc -s -S --toc -c custom.css .\Rmd_Lab_Notebook.md -o ..\\Rmd_Lab_Notebook.html


setwd("C:/Users/Devin/Documents/TestWebsite")

get_TOC <- function (filename) 
{
  filename <- filename
  listfile <- scan(filename, sep = "\n", what = character(), 
                   quiet = TRUE)
  div_TOC <- grep("<div id=\"TOC\"", listfile)
  TOCs <- grep("href=\"#", listfile)
  end_div <- grep("</div>", listfile)
  desc <- listfile[(div_TOC-1):(end_div)]
  r <-regexpr(">\\w.+?</a>", listfile)
  o1 <- str_split(regmatches(listfile, r), ">")
  o2 <- str_split(o1[[1]][2], "<")
  desc[1] <- paste("<h2>", o2[[1]][1], "</h2>")
  desc <- gsub(x = desc, pattern="href=\"#",replacement=paste0("href=\"", filename, "#" ))
  
  return(desc)
}

#extract all ToC
html_files <- lapply(str_split(Rmd_files, pattern = '.Rmd'), function(x) out <- paste0(x[1], ".html"))
for(i in seq_along(html_files)){
  write(get_TOC(html_files[[i]]), file="test.html", append = TRUE)
}

## replace ToC w/ css floating implementation in each subpage
rep_TOC <- function (filename) 
{
  filename <- filename
  listfile <- scan(filename, sep = "\n", what = character(), 
                   quiet = TRUE)
  listfile <- gsub("<div id=\"TOC\">", "<div class=\"toc\">", listfile)
  return(listfile)
}
for(i in seq_along(html_files)){
  output <- rep_TOC(html_files[[i]])
write(output, file=html_files[[i]])
}




