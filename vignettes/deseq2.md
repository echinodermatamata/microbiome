---
title: "DESeq2"
bibliography: 
- bibliography.bib
- references.bib
output: 
  prettydoc::html_pretty:
    theme: cayman
    highlight: github
---
<!--
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteIndexEntry{microbiome tutorial - comparisons}
  %\usepackage[utf8]{inputenc}
  %\VignetteEncoding{UTF-8}  
-->


## Normalization and group-wise comparisons with DESeq2

Examples adapted from [Callahan et al. F1000 (2017)](https://f1000research.com/articles/5-1492/v2).

Load example data:


```r
# Load libraries
library(microbiome)
library(ggplot2)

# Probiotics intervention example data 
data(dietswap) 
pseq <- dietswap
# Set baseline to 0 (in this data set it appears to be 1)
pseq <- transform(pseq, "shift", shift = -1)
```


Toy example, to be polished:


```r
library(phyloseq)
library(structSSI)
library(plyr)
library(dplyr)
library(reshape2)
library(DESeq2)

# Running the DESeq2 analysis
ds2 <- phyloseq_to_deseq2(pseq, ~ nationality)
dds <- DESeq(ds2)
res <- results(dds)
df <- as.data.frame(res)
df$taxon <- rownames(df)
df <- df %>% arrange(log2FoldChange, padj)
print(head(kable((df)))

# Just applying the variance stabilizing transformation
varianceStabilizingTransformation(ds2, blind = TRUE, fitType = "parametric")
ds2 <- estimateSizeFactors(ds2)
ds2 <- estimateDispersions(ds2)
abund <- getVarianceStabilizedData(ds2)
```

```
## Error: <text>:18:1: unexpected symbol
## 17: # Just applying the variance stabilizing transformation
## 18: varianceStabilizingTransformation
##     ^
```