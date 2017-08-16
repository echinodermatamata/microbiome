<!--
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteIndexEntry{microbiome tutorial - Installation}
  %\usepackage[utf8]{inputenc}
  %\VignetteEncoding{UTF-8}  
-->
### Installing R

**If you do not already have R/RStudio installed**, do as follows.

1.  Install [R](http://www.r-project.org/)
2.  Install [RStudio](http://rstudio.org)
3.  With Windows, install also
    [RTools](http://cran.r-project.org/bin/windows/Rtools/) (version
    corresponding to your R version)

### Install dependencies

Open R and install dependencies from the Tools panel, or run the
following commands (see
[DESCRIPTION](https://github.com/microbiome/microbiome/blob/master/DESCRIPTION)
file for a full list of dependencies):

    source("http://www.bioconductor.org/biocLite.R")
    biocLite("devtools")
    biocLite("phyloseq")
    biocLite("ggplot2")
    biocLite("dplyr")
    biocLite("reshape2")
    biocLite("tidyr")
    biocLite("vegan")
    biocLite("knitr")
    biocLite("knitcitations")
    biocLite("compositions")
    biocLite("qvalue")
    biocLite("rmarkdown")

If some of these installations fail, ensure from the RStudio tools panel
that you have access to CRAN and Bioconductor repositories. If you
cannot install some packages, some functionality in microbiome may not
work.

### Install/update the microbiome package

To install microbiome package and recommended dependencies, run in R:

    library(devtools) # Load the devtools package
    install_github("microbiome/microbiome") # Install the package

### Loading the package

Once the package has been installed, load it in R (also to test
successful installation):

    library(microbiome)  

See further usage examples in [microbiome
tutorial](https://github.com/microbiome/microbiome/blob/master/index./index.html)

### Installing R packages from CRAN/Bioconductor/Github

R packages are maintained in three distinct repositories: CRAN,
Bioconductor and Github. You need to somehow find out which repository
your desired package is in, or just try out the three alternatives:

    # Installing from Bioconductor
    source("http://www.bioconductor.org/biocLite.R")
    biocLite("MASS")

    # Installing from CRAN
    install.packages("sorvi")

    # Installing from Github
    library(devtools)
    install_github("antagomir/netresponse")