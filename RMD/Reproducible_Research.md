Reproducible Research
=============================

This section covers the conceptual framework behind reproducible research.

For software-specific implementations, tips, and tricks, please refer to the 
following sections:

* RMD_Lab_Notebook
* LYX Reports
* Slidify Presentations

TODO: add components for: Rmarkdown, knitr, git/github/bitbucket

## Importance of Reproducible Research


## "Best" Practices in Reproducible Research

Minimal set of guidelines that should be followed to reduce the likelihood of other people being unable to reproduce your results given your document and data.

1. Avoid absolute paths
2. If necessary to set absolute path or read in datasets from other locations, do so in a single, clear location. Minimize the need for people to hunt for locations they need to change paths/pointers.
3. Keep each project in a single directory 
4. For any simulation or number generation `set.seed(<number>)` to maintain reproducibility
5. Use R vanilla to avoid differences with `.Rdata` or `.Rprofile`
6. Include `sessionInfo()` with `cache = FALSE` so other people can check if difficulties are due to environment or version differences
7. Before generating a final report, clear your environment (and `cache()` if the full analysis could be completed in a reasonable amount of time) before knitting to make sure the document compiles from scratch properly. 


## Reproducible Research Tools



## In-line code
One major goal of reproducible research is a final report should not include numbers derived from the data. Instead, numbers should be printed as part of the code evaluation.

For example, I would not write: In the Theophylline dataset there are 12 unique subjects. Instead, I can use in-line code evaluation to write:


```r
There are `r length(unique(Theoph$Subject))` individuals in the dataset
```


Which evaluates to:


There are 12 individuals in the dataset


This can be extended to handle output from models, summary statistics, etc.

TODO: add model fit example

Karl Broman also provides a nice [knitr in a nutshell tutorial](http://kbroman.github.io/knitr_knutshell/)
