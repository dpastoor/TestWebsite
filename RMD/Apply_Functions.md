Apply Functions
========================================================

TODO: flesh out and add more concrete PMTRX examples

There are a number of `apply` commands in the R family. Each has different way of handling data

Additional information can be found in threads on [stackoverflow](http://stackoverflow.com/questions/3505701/r-grouping-functions-sapply-vs-lapply-vs-apply-vs-tapply-vs-by-vs-aggrega)

Note - the apply-style commands are *not* particularly faster than a *well-written* loop. The benefit is their one-line nature. [Read some more here](http://stackoverflow.com/questions/2275896/is-rs-apply-family-more-than-syntactic-sugar?rq=1)

Here is a brief overview:

TODO: test tag here

## apply

Used to evaluate a function over the margins of a matrix/array. It can apply a function by dimension (row/col).  

`apply` takes the following arguments: 
* `X` - input
* `MARGIN` - to distinguish by row or column. `1` - row, `2` - column
* `FUN` - function to be applied
* `...` is for other arguments to be passed into fun

For example to apply the function `range` across all columns in `Theoph`:


```r
apply(Theoph, 2, range)
```

```
##      Subject Wt     Dose   Time    conc    MDV
## [1,] "1"     "54.6" "3.10" " 0.00" " 0.00" "0"
## [2,] "9"     "86.4" "5.86" "24.65" "11.40" "1"
```

```r
str(apply(Theoph, 2, range))
```

```
##  chr [1:2, 1:6] "1" "9" "54.6" "86.4" "3.10" "5.86" ...
##  - attr(*, "dimnames")=List of 2
##   ..$ : NULL
##   ..$ : chr [1:6] "Subject" "Wt" "Dose" "Time" ...
```


Notice:
- the 'range' function does not have '()' around it.
- The results are all characters - since `apply` goes over by dimension and needs a matrix/array, the whole data structure is coerced to the highest level. Since Subject is an ordered factor for `Theoph` the whole data-frame is coerced to a matrix of type `char` before the function is applied!

*tidbit* - apply is a good opportunity to use colMeans/colSums and rowMeans/rowSums - they are significantly faster, especially for large data structures.


## lapply

Works to apply a function to each element in the list and *returns a list back*

`lapply` takes the following arguments:
* `X` - input
* `FUN` - function to be applied
* `...` is for other arguments to be passed into fun


```r
lapply(Theoph, range)
```

```
## $Subject
## [1] 6 5
## Levels: 6 < 7 < 8 < 11 < 3 < 2 < 4 < 9 < 12 < 10 < 1 < 5
## 
## $Wt
## [1] 54.6 86.4
## 
## $Dose
## [1] 3.10 5.86
## 
## $Time
## [1]  0.00 24.65
## 
## $conc
## [1]  0.0 11.4
## 
## $MDV
## [1] 0 1
```


Given that a dataframe is a list with dimensions - lapply can easily step throuh the columns and apply your function and returns a list.

## sapply

sapply is similar to lapply, the biggest difference is it attempts to simplify the result.


```r
lapply(Theoph, range)
```

```
## $Subject
## [1] 6 5
## Levels: 6 < 7 < 8 < 11 < 3 < 2 < 4 < 9 < 12 < 10 < 1 < 5
## 
## $Wt
## [1] 54.6 86.4
## 
## $Dose
## [1] 3.10 5.86
## 
## $Time
## [1]  0.00 24.65
## 
## $conc
## [1]  0.0 11.4
## 
## $MDV
## [1] 0 1
```

```r
sapply(Theoph, range)
```

```
##      Subject   Wt Dose  Time conc MDV
## [1,]       1 54.6 3.10  0.00  0.0   0
## [2,]      12 86.4 5.86 24.65 11.4   1
```

```r
str(lapply(Theoph, range))
```

```
## List of 6
##  $ Subject: Ord.factor w/ 12 levels "6"<"7"<"8"<"11"<..: 1 12
##  $ Wt     : num [1:2] 54.6 86.4
##  $ Dose   : num [1:2] 3.1 5.86
##  $ Time   : num [1:2] 0 24.6
##  $ conc   : num [1:2] 0 11.4
##  $ MDV    : num [1:2] 0 1
```

```r
str(sapply(Theoph, range))
```

```
##  num [1:2, 1:6] 1 12 54.6 86.4 3.1 ...
##  - attr(*, "dimnames")=List of 2
##   ..$ : NULL
##   ..$ : chr [1:6] "Subject" "Wt" "Dose" "Time" ...
```

```r
class(lapply(Theoph, range))
```

```
## [1] "list"
```

```r
class(sapply(Theoph, range))
```

```
## [1] "matrix"
```

```r
typeof(lapply(Theoph, range))
```

```
## [1] "list"
```

```r
typeof(sapply(Theoph, range))
```

```
## [1] "double"
```


Generally, the "rules" for `sapply` can be thought-of as:
* Result is a list where every element is length 1 - returns a vector
* Result list where every elemtn is same length - returns a matrix
* Neither of above - returns list

## vapply

 preferred over sapply due to minor speed improvement and better consistency with return types. Can read more about it on [stack overflow here](http://stackoverflow.com/questions/12339650/why-is-vapply-safer-than-sapply)

## tapply

Used to apply functions to subsets of a vector. I will briefly give some detail, though my person preference is to use `plyr` commands or `split` when I'm dealing with subsets.

`tapply` takes the following arguments: 
* `X` - input
* `INDEX` is a factor or list of factors
* `FUN` - function to be applied
* `...` is for other arguments to be passed into fun
* `simplify` - logical for whether to simplify result or not

**note**: INDEX must be a factor or list of factors - if not any value passed in will be coerced to factor.


```r
with(Theoph, tapply(conc, Subject, mean))
```

```
##     6     7     8    11     3     2     4     9    12    10     1     5 
## 3.525 3.911 4.272 4.511 5.086 4.824 4.940 4.894 5.410 5.931 6.439 5.783
```


Without using with:


```r
tapply(Theoph$conc, Theoph$Subject, mean)
```

```
##     6     7     8    11     3     2     4     9    12    10     1     5 
## 3.525 3.911 4.272 4.511 5.086 4.824 4.940 4.894 5.410 5.931 6.439 5.783
```


If speed is of the essence - `tapply` does perform well - for some minor benchmarks it proved to be ~ 7x faster than plyr - though take that with a grain of salt as it was the difference between 0.19 and 1.3 seconds. Hadley Wickham is also coming out with his new `dplyr` package that should increase the speed of `plyr`-style commands substantially.

## reapply

 metrumrg function - similar to `tapply` but adds some additional functionality, including a `where` option to restrict calculations in domain of `x`.


```r
library(metrumrg)
with(Theoph, reapply(conc, Subject, mean, where = Time != 0, na.rm = TRUE))
```

```
##   [1] 7.009 7.009 7.009 7.009 7.009 7.009 7.009 7.009 7.009 7.009 7.009
##  [12] 5.306 5.306 5.306 5.306 5.306 5.306 5.306 5.306 5.306 5.306 5.306
##  [23] 5.595 5.595 5.595 5.595 5.595 5.595 5.595 5.595 5.595 5.595 5.595
##  [34] 5.434 5.434 5.434 5.434 5.434 5.434 5.434 5.434 5.434 5.434 5.434
##  [45] 6.361 6.361 6.361 6.361 6.361 6.361 6.361 6.361 6.361 6.361 6.361
##  [56] 3.878 3.878 3.878 3.878 3.878 3.878 3.878 3.878 3.878 3.878 3.878
##  [67] 4.287 4.287 4.287 4.287 4.287 4.287 4.287 4.287 4.287 4.287 4.287
##  [78] 4.699 4.699 4.699 4.699 4.699 4.699 4.699 4.699 4.699 4.699 4.699
##  [89] 5.383 5.383 5.383 5.383 5.383 5.383 5.383 5.383 5.383 5.383 5.383
## [100] 6.500 6.500 6.500 6.500 6.500 6.500 6.500 6.500 6.500 6.500 6.500
## [111] 4.962 4.962 4.962 4.962 4.962 4.962 4.962 4.962 4.962 4.962 4.962
## [122] 5.951 5.951 5.951 5.951 5.951 5.951 5.951 5.951 5.951 5.951 5.951
```


