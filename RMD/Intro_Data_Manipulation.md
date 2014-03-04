Introduction to Data Manipulation
========================================================

You've made it through the theoretical aspects and you're close to being ready to start getting your hands dirty. All of you have most likely used every single element of this module, but now we will reassess these operators and behaviors to get a deeper understanding - thus allowing us to wield them more effectively.

## Subsetting

The three subsetting (or subscripting) operators available in R are `[`, `[[`, and `$`. There are also some functions such as `subset`. Each has different behaviors and caveats attached that are important when deciding which to use for the intended task. 


|  Subscript                  |             Effect               |
|-----------------------------|---------------------------------:|
| Positive Numeric Vector     | selects items in those indices   | 
| Negative Numeric Vector     |selects all but those indices     | 
| Character Vector            |selects items with those names    | 
| Logical Vector              |  selects all TRUE (and NA) items | 
| Missing                     | selects all missing              | 

You can easily see how each of these works given a simple vector


```r
x <- c(1, 5, NA, 8, 10)
names(x) <- c("a", "b", "c", "d", "e")
x[1]
```

```
## a 
## 1
```

```r
x[-1]
```

```
##  b  c  d  e 
##  5 NA  8 10
```

```r
x[c(1:3)]
```

```
##  a  b  c 
##  1  5 NA
```

```r
x[-c(1:3)]
```

```
##  d  e 
##  8 10
```

```r
x[is.na(x)]
```

```
##  c 
## NA
```

```r
x[!is.na(x)]
```

```
##  a  b  d  e 
##  1  5  8 10
```

```r
x["b"]
```

```
## b 
## 5
```

```r
x[c("b", "c")]
```

```
##  b  c 
##  5 NA
```

```r

# Logical subsetting returns values that you give as true
x[c(TRUE, FALSE, TRUE, FALSE, FALSE)]
```

```
##  a  c 
##  1 NA
```

```r
# but don't forget about the recycling rules!
x[c(TRUE, FALSE)]
```

```
##  a  c  e 
##  1 NA 10
```

```r

# if you call a specific index more than once it will be returned more than
# once
x[c(2, 2)]
```

```
## b b 
## 5 5
```



By default, `[` will simplify the results to the lowest possible dimensionality. That is, it will reduce any higher dimensionality object to a list or vector. This is because if you select a subset, R will coerce the result to the appropriate dimensionality. We will give an example of this momentarily. To stop this behavior you can use the `drop = FALSE` option.

For higher dimensionality objects, rows and columns are subset individually and can be combined in a single call


```r
Theoph[c(1:10), c("Time", "conc")]
```

```
##     Time  conc
## 1   0.00  0.74
## 2   0.25  2.84
## 3   0.57  6.57
## 4   1.12 10.50
## 5   2.02  9.66
## 6   3.82  8.58
## 7   5.10  8.36
## 8   7.03  7.47
## 9   9.05  6.89
## 10 12.12  5.94
```


`[[` and `$` allow us to take out components of the list.

Likewise, given data frames are lists of column, `[[` can be used to extract a column from data frames.  

`[[` is similar to `[`, however, it only returns a single value. `$` is  shorthand for `[[` but is only available for character subsetting

There are two additional important distinctions between `$` and `[[`

1. $ can not be used for column names stored as a variable:


```r
id <- "Subject"
Theoph$id
```

```
## NULL
```

```r
Theoph[[id]]
```

```
##   [1] 1  1  1  1  1  1  1  1  1  1  1  2  2  2  2  2  2  2  2  2  2  2  3 
##  [24] 3  3  3  3  3  3  3  3  3  3  4  4  4  4  4  4  4  4  4  4  4  5  5 
##  [47] 5  5  5  5  5  5  5  5  5  6  6  6  6  6  6  6  6  6  6  6  7  7  7 
##  [70] 7  7  7  7  7  7  7  7  8  8  8  8  8  8  8  8  8  8  8  9  9  9  9 
##  [93] 9  9  9  9  9  9  9  10 10 10 10 10 10 10 10 10 10 10 11 11 11 11 11
## [116] 11 11 11 11 11 11 12 12 12 12 12 12 12 12 12 12 12
## Levels: 6 < 7 < 8 < 11 < 3 < 2 < 4 < 9 < 12 < 10 < 1 < 5
```

2. `$` allows for partial matching


```r
names(Theoph)
```

```
## [1] "Subject" "Wt"      "Dose"    "Time"    "conc"
```

```r
# $ allows for partial matching
head(Theoph$Sub)
```

```
## [1] 1 1 1 1 1 1
## Levels: 6 < 7 < 8 < 11 < 3 < 2 < 4 < 9 < 12 < 10 < 1 < 5
```

```r
head(Theoph$Subj)
```

```
## [1] 1 1 1 1 1 1
## Levels: 6 < 7 < 8 < 11 < 3 < 2 < 4 < 9 < 12 < 10 < 1 < 5
```

```r
head(Theoph$Subject)
```

```
## [1] 1 1 1 1 1 1
## Levels: 6 < 7 < 8 < 11 < 3 < 2 < 4 < 9 < 12 < 10 < 1 < 5
```

```r

# '[[' does not
head(Theoph[["Subj"]])
```

```
## NULL
```


Using `$` can lead to unintended consequences if you're looking to grab a column of a certain name that isn't there but a partial match is - especially if this is nested in a function where it isn't clear immediately




`[` and `[[` are both useful for different tasks. In a general sense you use them to accomplish the following:

|             | Simplifying         | Preserving                 |
|-------------|---------------------|----------------------------|
| Vector      | `x[[1]]`           | `x[1]`                     | 
| List        | `x[[1]]`           | `x[1]`                     | 
| Factor      | `x[1:4, drop = T]`  | `x[1:4]`                   | 
| Array       | `x[1, ]`, `x[, 1]`  | `x[1, , drop = F]`, `x[, 1, drop = F]` | 
| Data frame  | `x[, 1]`, `x[[1]]`  | `x[, 1, drop = F]`, `x[1]` | 

There are benefits for each - simplying is often beneficial when you are looking for a result. Preserving is often beneficial in the programming context when you want to keep the results and structure the same.

An easy way to think about it:

>  "If list `x` is a train carrying objects, then `x[[5]]` is 
> the object in car 5; `x[4:6]` is a train of cars 4-6." --- 
> [@RLangTip](http://twitter.com/#!/RLangTip/status/118339256388304896)


One thing to note: S3 and S4 objects can override the standard behavior of `[` and `[[` so they behave differently for different types of objects. This can be useful for controlling simplification vs preservation behavior.

## LETS LOOK AT SOME EXAMPLES

- create a vector, list, and dataframe. 
- Extract elements using [, [[, and $
- What are the type and attributes that remain for the extracted piece of information
- Quickly brainstorm a couple situations that these could be important to remember for more complex tasks

## Logical Subsetting
One of the most common ways to subset rows is to use **logical subsetting**. 

Let's take a look

```r
Theoph[Theoph$Subject == 1, ]
```

```
##    Subject   Wt Dose  Time  conc
## 1        1 79.6 4.02  0.00  0.74
## 2        1 79.6 4.02  0.25  2.84
## 3        1 79.6 4.02  0.57  6.57
## 4        1 79.6 4.02  1.12 10.50
## 5        1 79.6 4.02  2.02  9.66
## 6        1 79.6 4.02  3.82  8.58
## 7        1 79.6 4.02  5.10  8.36
## 8        1 79.6 4.02  7.03  7.47
## 9        1 79.6 4.02  9.05  6.89
## 10       1 79.6 4.02 12.12  5.94
## 11       1 79.6 4.02 24.37  3.28
```


We just subset the Theoph dataframe to only give us back the rows in which Subject equals 1. How does R go about doing this? Logical subsetting!

Notice what we get when we simply ask for `Theoph$Subject == 1`

```r
Theoph$Subject == 1
```

```
##   [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
##  [12] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [23] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [34] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [45] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [56] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [67] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [78] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [89] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [100] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [111] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [122] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
```

It doesn't give us back the values for the rows where subject equals one, rather, it gives us back a vector of `TRUE` or `FALSE` values.

So, in reality, we are using the logical subsetting rules to extract the rows of the dataframe that come back `TRUE` from our logical query.

We can do this 'by hand' to show whats going on 

```r
subj <- ifelse(Theoph[["Subject"]] == 1, TRUE, FALSE)
subj
```

```
##   [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
##  [12] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [23] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [34] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [45] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [56] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [67] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [78] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
##  [89] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [100] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [111] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [122] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
```

```r
Theoph[subj, ]
```

```
##    Subject   Wt Dose  Time  conc
## 1        1 79.6 4.02  0.00  0.74
## 2        1 79.6 4.02  0.25  2.84
## 3        1 79.6 4.02  0.57  6.57
## 4        1 79.6 4.02  1.12 10.50
## 5        1 79.6 4.02  2.02  9.66
## 6        1 79.6 4.02  3.82  8.58
## 7        1 79.6 4.02  5.10  8.36
## 8        1 79.6 4.02  7.03  7.47
## 9        1 79.6 4.02  9.05  6.89
## 10       1 79.6 4.02 12.12  5.94
## 11       1 79.6 4.02 24.37  3.28
```

Logical subsetting is at the core of many of R's operations. Any time you're matching, or checking with `is.*` you are using logical subsetting to test the condition you're looking for then returning the `TRUE` results

## Common Subsetting Situations and Some Useful Functions

Now that you've gotten your feet wet with the basics of subsetting, lets check-in with some of the commonly used operators that give us some enhanced subsetting functionality.

Note: These all take advantage of logical subsetting:

Take a moment to prod through to documentation for the other operations. Note for things operations like `%in%` or `&` to query help you need to add a single quote around it like so `?'%in%'`

This is a good chance for us to take a deeper look @ both how these functions work and how to read the documentation

**pause to look @ %in%, is.na, and which documentation**

* `%in%` 
* `is.na`
* `!`
* `duplicated`
* `unique`
* `&`
* `|`
* `which`
* `any`

It can be useful to make yourself a brief 'cheat sheet' of some of the common operations you use to reference when you're thinking about what you are trying to do what you want your output to be. 

For example:

* `%in% - compares values from the input vector with a table vector and returns T/F. 
    * input/output are coerced to vectors and then type-matched before comparison. Factors, lists converted to character vectors!
    * Never returns NA, making it useful for `if` conditions
    * Can be slow for long lists and best avoided for complex cases

There is an interesting nugget of information in the documentation - that the input is coerced to a vector then type-matched. 

So what is going on in these two situations?


```r
ISM <- c(TRUE, FALSE, TRUE, FALSE)
ISMnums <- c(1, 0, 1, 0)
SUBJ <- c(1, 2, 3, 4)
ISM %in% SUBJ
```

```
## [1]  TRUE FALSE  TRUE FALSE
```

```r
which(ISM %in% SUBJ)
```

```
## [1] 1 3
```

```r
ISMnums %in% SUBJ
```

```
## [1]  TRUE FALSE  TRUE FALSE
```

```r
which(ISMnums %in% SUBJ)
```

```
## [1] 1 3
```

```r

ISM <- c(TRUE, FALSE, TRUE, FALSE)
SUBJ <- factor(c(1, 2, 3, 4))
ISM %in% SUBJ
```

```
## [1] FALSE FALSE FALSE FALSE
```

```r
which(ISM %in% SUBJ)
```

```
## integer(0)
```

```r
ISMnums %in% SUBJ
```

```
## [1]  TRUE FALSE  TRUE FALSE
```

```r
which(ISMnums %in% SUBJ)
```

```
## [1] 1 3
```


hint: look @ ID numbers


The moral of the story, is make sure you know what is going on under the hood - sometimes you can get the 'right' answer for the wrong reasons.

## Some Subsetting Practice Problems

What's wrong with this subsetting command?
` dosingdf <- df[unique(df$ID),]`

TODO: quick and easy give harder ones later


## Data Manipulation
Now that we can slice and dice our data how we want - let's examine how we can actually manipulate the data

Our goal for this section is to be able to:
- rename columns systematically
- reorder and rearrange rows and columns to our needs
- create new columns

### renaming columns

Quick renaming of columns can be easily accomplished using the plyr `rename` command with the structure:

`dataframe <- rename(dataframe, c("oldcolname1" = "newcolname1", ...))`


```r
library(plyr)
names(Theoph)
```

```
## [1] "Subject" "Wt"      "Dose"    "Time"    "conc"
```

```r
Theoph <- rename(Theoph, c(Subject = "ID"))
names(Theoph)
```

```
## [1] "ID"   "Wt"   "Dose" "Time" "conc"
```


This can also be done directly without plyr, however is a bit more verbose


```r
names(Theoph)[names(Theoph) == "Subject"] <- "ID"
```


Pause for a second - given what we've learned about subsetting - what is going on based on the way we've constructed the renaming.

Answer: `names(Theoph)` creates a vector of names - the `names(Theoph) == "Subject"` logically subsets the vector to identify which index matches the query. `<- "ID"` is to assign a new value to that index location(s).

Column names can be directly accessed using the `colnames` function (or for dataframes or lists simply `names`), and you can rename them all directly by giving it a vector of names. 


```r
colnames(Theoph) <- c("hello", "there")
colnames(Theoph)
```

```
## [1] "hello" "there" NA      NA      NA
```

```r
rm(Theoph)
```


As you can see, this can be dangerous due to not giving the proper length vector (remember R's recycling rule!), likewise, if the order of columns changes unexpectedly, your vector could rename columns incorrectly.

There are a couple things directly accessing all the colnames can be useful for though.

For example, capitalization of columns can often be inconsistent and frustrating. This can be quickly fixed by converting all columns to uppercase or lowercase using `toupper()` and `tolower()`


```r
names(Theoph)
```

```
## [1] "Subject" "Wt"      "Dose"    "Time"    "conc"
```

```r
names(Theoph) <- toupper(names(Theoph))
names(Theoph)
```

```
## [1] "SUBJECT" "WT"      "DOSE"    "TIME"    "CONC"
```

```r
rm(Theoph)
```


### reordering rows/columns
When reordering columns in a dataframe you can actually think of it as creating a new dataframe in which the columns get created in the way you order them.


```r
newTheoph <- Theoph[c("Subject", "Time", "conc", "Dose", "Wt")]
head(Theoph)
```

```
##   Subject   Wt Dose Time  conc
## 1       1 79.6 4.02 0.00  0.74
## 2       1 79.6 4.02 0.25  2.84
## 3       1 79.6 4.02 0.57  6.57
## 4       1 79.6 4.02 1.12 10.50
## 5       1 79.6 4.02 2.02  9.66
## 6       1 79.6 4.02 3.82  8.58
```

```r
head(newTheoph)
```

```
##   Subject Time  conc Dose   Wt
## 1       1 0.00  0.74 4.02 79.6
## 2       1 0.25  2.84 4.02 79.6
## 3       1 0.57  6.57 4.02 79.6
## 4       1 1.12 10.50 4.02 79.6
## 5       1 2.02  9.66 4.02 79.6
## 6       1 3.82  8.58 4.02 79.6
```


Most of the time since you don't want to create a new data frame every time you reorder, you can simply overwrite the old data frame. `Theoph <- Theoph[c("Subject", "Time", "conc", "Dose", "Wt")]`

Just like all other subsetting we've gone over, we can also organize by index

`Theoph <- Theoph[c(1, 4, 5, 3, 2)]`

I suggest against it unless you have good reason. (ie you know your code will always be a specific structure) Even then, while faster to type than named indices, it makes legibility more difficult, and modification down the line more tedious trying to keep track.

### Keys
Similar to columns, rows also have names. As you slice and dice and reorder a dataset it can get pretty ugly, so if the need arises, row names can be rest by `rownames(df) <- NULL`

Rows can always be referred by their name. They are also structurally distinguishable by their content. 

A **key** is the set of columns that can uniquely distinguish every row. Different datasets can have keys of varying complexity (number of columns)

A basic dosing dataset key may be as simple as ID, however for a cross-over clinical trial a dataset may be keyed on ID, time, and cohort. 

The general relationship between **key columns** and other columns is:

> Key columns should represent unique objects (persons, events) and the other columns should characterize these objects

R does not explicitly recognize keys - it is up to you to keep track. Keys become increasingly important when delving into advanced data manipulation.

### Ordering and expand.grid()
The concept of keys can help us think about the structure of the dataset when we deal with ordering.

The `order` function in R allows us to easily sort data in ascending or descending order.

If we wanted to sort a dataset by ID and Time we could do so via:

`df <- df[order(df$ID, df$Time),]`

It is a good habit to sort raw data (especially if its eventually going into phoenix or nonmem)

The way `order` works with multiple arguments is it sorts starting with the first argument, each time it runs into a 'tie' it looks for subsequent arguments for how to break the 'tie'

For example, if you have 5 time observations associated with an ID, if you do:
`order(df$ID, df$TIME)` it will start sorting by `ID`, notice it has multiple results for the same ID value, it will then use `TIME` to continue the sort.

`order` is quite powerful with the `expand.grid` function. 



### Additional manipulations 

To quickly note - columns and rows can be removed simply by calling their index and assigning it to NULL

`Theoph$Subject <- NULL` or `Theoph[Theoph$Subject ==1,] <- NULL`

`with` - 'opens up' the input within the function to allow us access columns similar to `attach()` but only in the function's temporary environment. Can be very useful for with modeling.


```r
## get better example
library(MASS)
with(anorexia, {
    anorex.1 <- glm(Postwt ~ Prewt + Treat + offset(Prewt), family = gaussian)
    summary(anorex.1)
})
```



```r
with(Theoph, summary(conc))
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    0.00    2.88    5.28    4.96    7.14   11.40
```

```r
# same as
summary(Theoph$conc)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    0.00    2.88    5.28    4.96    7.14   11.40
```


`within` - allows us access inside a data structure to do things *within* it


```r
id_time <- data.frame(expand.grid(ID = 1:3, TIME = 0:10))
head(id_time)
```

```
##   ID TIME
## 1  1    0
## 2  2    0
## 3  3    0
## 4  1    1
## 5  2    1
## 6  3    1
```

```r
id_time <- id_time[order(id_time$ID, id_time$TIME), ]
head(id_time)
```

```
##    ID TIME
## 1   1    0
## 4   1    1
## 7   1    2
## 10  1    3
## 13  1    4
## 16  1    5
```

```r
df <- within(id_time, {
    DV <- 0
    AMT <- 0
    DOSE <- 150
    MDV <- 0
})
head(df)
```

```
##    ID TIME MDV DOSE AMT DV
## 1   1    0   0  150   0  0
## 4   1    1   0  150   0  0
## 7   1    2   0  150   0  0
## 10  1    3   0  150   0  0
## 13  1    4   0  150   0  0
## 16  1    5   0  150   0  0
```


ie will have column order MDV, DOSE, AMT, DV add by column from bottom up going outward

**notice the structure of a `within` call, there are no `,`s inside the brackets when creating multiple columns

Let's try to create a simulation data frame


```r
df <- data.frame(ID = 1:5)
df <- within(df, {
    UCTX <- 0
    # initialize amount to NA so will be read in as blank to phoenix
    AMT <- NA
    # initialize doses
    DOSE <- numeric()
    ADDL <- NA
    II <- NA
})
str(df)
```

```
## 'data.frame':	5 obs. of  6 variables:
##  $ ID  : int  1 2 3 4 5
##  $ II  : logi  NA NA NA NA NA
##  $ ADDL: logi  NA NA NA NA NA
##  $ DOSE: num  NA NA NA NA NA
##  $ AMT : logi  NA NA NA NA NA
##  $ UCTX: num  0 0 0 0 0
```


Check out the differences between AMT/ADDL/II columns and DOSE

`within` can also be used for logical subsetting in a concisely written format:


```r
Theoph$MDV <- 1
Theoph <- within(Theoph, MDV[Subject == 2 & conc == 0] <- 0)
```


## Assignments
- using `expand.grid` and `order` create an `id_time` dataset (dataframe)
- within the dataset add another column `Measurement` that is a set of noise generated with `rnorm` or `runif`
- use `with` to subset Theoph for ID's 1 and 2 only
- generate a new conc column for Theoph




## Merging Data

Let's create some sample data to merge

TOCHANGE: modify sample merge data off metrum-esque


```r
dose <- data.frame(subject = rep(letters[1:3], each = 2), time = rep(c(1, 3), 
    3), amount = rep(c(40, 60, 80), each = 2))

pk <- data.frame(subject = rep(letters[1:3], each = 4), time = rep(1:4, 3), 
    conc = signif(rnorm(12), 2) + 2)

demo <- data.frame(subject = letters[1:4], race = c("asian", "white", "black", 
    "other"), sex = c("female", "male", "female", "male"), weight = c(75, 70, 
    73, 68))
```


You can merge two data frames with the `merge` command. Merge looks for **keys** to match up which rows and columns can be matched. `merge` can only combine two data frames at once, so in order to merge more than that, nested `merge` calls must be used

What is the order of merging here?
```
merge(merge(x, y), z)
```

Let's look at some of the merge options

`?merge`

Can do more advanced merges - lets merge everything but not include demographic data from subject 3


```r
merge(merge(dose, pk, all = TRUE), demo[-3, ], all.x = TRUE)
```

```
##    subject time amount  conc  race    sex weight
## 1        a    1     40 1.720 asian female     75
## 2        a    2     NA 3.700 asian female     75
## 3        a    3     40 4.000 asian female     75
## 4        a    4     NA 2.370 asian female     75
## 5        b    1     60 3.500 white   male     70
## 6        b    2     NA 2.055 white   male     70
## 7        b    3     60 1.170 white   male     70
## 8        b    4     NA 2.022 white   male     70
## 9        c    1     80 3.100  <NA>   <NA>     NA
## 10       c    2     NA 3.000  <NA>   <NA>     NA
## 11       c    3     80 2.740  <NA>   <NA>     NA
## 12       c    4     NA 1.800  <NA>   <NA>     NA
```

