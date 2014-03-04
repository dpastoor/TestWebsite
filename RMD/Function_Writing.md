Function Writing
========================================================

This section will be our bread and butter as functions provide the means for us to start to harness R's power to reduce duplication of code and increase our efficiency.

Functions in R are known as "first class objects" - they can be treated like other R objects.

 They can be:
*  created without a name
*  assigned to variables
*  stored in lists
*  returned from functions
*  passed as arguments to other functions
*  Essentially, you can do anything with a function that you can with a vector.

In R, a function is defined with the following syntax:

`function(arguments) body`

* `function` is a reserved word to initialize creation.
* **Arguments** are sets of formal argument names that will be defined in the function body.
    * **Formal arguments** are arguments included in the function definition
* The **body** is simply the code that the function will execute

A function can be written in one line as shown above, however, to encapsulate multiple lines brackets `{}` must be used.

A multi-line function could look as such:

```
function(arguments) {
    some code
    some more code
    even more code
}
```

We can a simple addition function to examine some features


```r
add_fun <- function(x, y) {
    x + y
}
```


This is a function function declaration. We have created a function and given it a name. We can use it by calling it by name and passing some arguments that it requires.


```r
add_fun(1, 5)
```

```
## [1] 6
```


There are numer of important behaviors going on 'behind-the-scenes' in even this simple function call.

### Default Behaviors
**Formal arguments** can be soley user defined, they can also have a default value/behavior.

Defaults can be assigned to an argument with `=` 

Let's update our function to default to `y = 5`


```r
add_fun2 <- function(x, y = 5) x + y
```


When a default behavior defined, if no object or value is passed to that argument, the default value is used.


```r
add_fun2(6)
```

```
## [1] 11
```


But you can override the default behavior by simply passing in some value


```r
add_fun2(6, 3)
```

```
## [1] 9
```


If no default is defined, the function will halt and give you an error requesting what to do with the missing argument value


```r
add_fun2(y = 3)
```

```
## Error: 'x' is missing
```


When you have multiple arguments - how does a function know which one to use for the various arguments?

### Argument Matching
Like all things programming - R has specific rules for how it handles argument matching for functions.

Here is a basic overview:
* arguments can be matched positionally or by name
* you can mix positional and named matching
    * when an argument is matched by name it is "removed" from the argument list - the remaining arguments are matched by order
* arguments can be partially matched

The overall order of operations for argument matching:
1) Check exact match for named argument
2) Check for partial match for named argument
3) Check for positional match
4) Any remaining unmatched formal arguments are "taken up" by `...`

**Caveat(s)** 
* Any arguments *after* `...` are only matched exactly
* Tags partially matching multiple arguments will result in an error

### Lazy Evaluation
Lazy evaluation states that arguments to functions are only evaluated as need.


```r
plus_one <- function(x, y) x + 1
plus_one(5)
```

```
## [1] 6
```


This does not give an error saying `y` the `y` argument is missing as 5 gets positionally matched to `x` and no other evaluation occurs.


An interesting example of this lazy evaluation is through the following example


```r
a <- 1
b <- 2
c <- 3
d <- quote(c(a, b, c))
eval(d)
```

```
## [1] 1 2 3
```

```r
a <- 10
eval(d)
```

```
## [1] 10  2  3
```

 The quote function simply returns its argument, eval is it's "opposite", it evaluates what it is passed. 

### Passing on Arguments

`...` argument indicates that arguments may be passed on to other (internally called) functions

`...` can be used when extending another function where you don't want to copy all the arguments from the original function. 



```r
f <- function(x, ...) {
    print(x)
    summary(...)
}

f("It worked! The summary is:", runif(1000, 0, 100), digits = 2)
```

```
## [1] "It worked! The summary is:"
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    0.05   26.00   53.00   51.00   75.00  100.00
```


As you can see, all arguments after the first - which was given to `x` - where passed to `summary`.


### Return Values
In R after a function completes its code it will return a resulting value. 


```r
f <- function(x) x + 1
f(2)
```

```
## [1] 3
```


`f(2)` returns the result of `x + 1`, which in this case is 3.

By default, **R returns the last evaluated expression**. You can also formally declare what you'd like R to return using `return()`


```r
f <- function(x) return(x + 1)
```


This can be helpful for legibility when dealing with more complex functions where multiple outcomes are possible. It can also help you "escape" a function early by returning a result as soon as one is relevant


```r
num_sign <- function(x) {
    if (!is.numeric(x)) 
        return("NaN")
    if (x > 0) 
        return("positive")
    if (x < 0) 
        return("negative")
    return("Don't know - is it zero?")
}

num_sign(1)
```

```
## [1] "positive"
```

```r
num_sign(-1)
```

```
## [1] "negative"
```

```r
num_sign("hello")
```

```
## [1] "NaN"
```

```r
num_sign(0)
```

```
## [1] "Don't know - is it zero?"
```

```r

num_sign2 <- function(x) {
    if (!is.numeric(x)) 
        "NaN"
    if (x > 0) 
        "positive"
    if (x < 0) 
        "negative"
    "Don't know - is it zero?"
}

num_sign2(1)
```

```
## [1] "Don't know - is it zero?"
```

```r
num_sign2(-1)
```

```
## [1] "Don't know - is it zero?"
```

```r
num_sign2("hello")
```

```
## [1] "Don't know - is it zero?"
```

```r
num_sign2(0)
```

```
## [1] "Don't know - is it zero?"
```


**R can only return a single result from a function**

To return multiple objects you can combine them into a list or other structure


```r
PK_info <- function() {
    id <- 1:10
    id
    doses <- c(1, 5, 10)
    doses
    time <- seq(0, 10, 1)
    time
}

PK_info2 <- function() {
    id <- 1:10
    doses <- c(1, 5, 10)
    time <- seq(0, 10, 1)
    list(id = id, doses = doses, time = time)
}

PK_info()
```

```
##  [1]  0  1  2  3  4  5  6  7  8  9 10
```

```r
PK_info2()
```

```
## $id
##  [1]  1  2  3  4  5  6  7  8  9 10
## 
## $doses
## [1]  1  5 10
## 
## $time
##  [1]  0  1  2  3  4  5  6  7  8  9 10
```


## Basic Function Creation Assignments
#TODO

# pause to go read the Environments and R section #


## Types of Functions
3 specific types of functions that you may frequently run-into and/or utilize yourself are:
* Anonymous functions - functions that don't have a name
* Closures - functions written by other functions
* Lists of Functions - storing multiple functions in a list

### Anonymous Functions
In R, there is no special syntax for creating functions. Functions, like most things in R, are objects themselves. When you create a function, you are simply assigning a name to the object you are creating. By this behavior you can even create a function and assign it many names.

Sometimes, however, we don't want or need to spend the time assigning a name. You've most likely run across this when reading code that uses commands such as the `apply` family, `do.call`, or with `plyr`. 

Something along the lines of: 

`lapply(df, function(x) length(unique(x)))`

This lapply command could be rewritten with a named function

```
len_unique <- function(x) length(unique(x))
lapply(df, len_unique)
```

However, that is unnecessarily verbose for a one-time function, and can also introduce unnecessary clutter into your environment(s)

Just like other functions, anonymous function have **formals** (arguments), a **body** and are tied to a **parent environment**

### Closures
Closures were touched upon in the ![Environments and Scoping](Environments-and-Scoping.md) section.

Closures are functions written within other functions, and therefore have access to the environment of the parent function (they *enclose* it).

This is a powerful tool to creating **function factories**


#### Assignment
Create a function factory `dosing_time` that can create functions for various dosing schemes. Use it to create a QD, BID, and TID regimen out to 168 hours. 

Hint: maybe something involving seq()

### Lists of Functions
One way to store sets of functions is to put them in lists. Instead of a single function returning a list of results, you can actually store the functions themselves in a list for later re-use. 


```r
means <- list(normal = function(x) mean(x), geometric = function(x) ..., harmonic = function(x) ..., 
    )
```


To then call a function you can simply extract it from the list

`means$harmonic(data)` or `means[["geometric"]](data)`

While it might seem awkward there are some situations where lists of functions provide convenience. It also offers a degree of modularity that reduces dependencies.

#### Assignment
- Using a dataset of your choosing write 2-3 functions to create exploratory plots 
- Add those functions to an `exploratory_plots` list. 
- Using `lapply` quickly call all the functions on:
    - the whole dataset
    - a subset


## Functional Programming

Functions provide a host of benefits to the user. The allow for efficient automation of repetitive tasks, bundling or common operations and a host of other possibilities.

One additional, and equally important, opporunity they offer is to **reduce errors**.

As touched upon in *Pragmatic Programming*, the **DRY** (DON'T REPEAT YOURSELF) is well suited to functions.

A Motivating Example

When dealing with a new dataset there are two frequent issues that arise with concentration data - BQL values, and how to handle them.

Given the hypothetical situation where you are given 3 similarly-structured datasets how you could handle replacing the phrase `LLOQ < 10` simply with NA?

The copy-paste process may be something along the lines of:

```
df1$conc[df1$CONC == 'LLOQ < 10'] <- NA
df2$conc[df2$CONC == 'LLOQ < 10'] <- NA
df3$conc[df3$CONC == 'LLOQ < 10'] <- NA
df4$conc[df4$CONC == 'LLOQ < 10'] <- NA
df5$conc[df4$CONC == 'LLOQ < 10'] <- NA
```

Quick - did anyone spot any issue with the code?

Let's write a function to help automate this, as well as reduce potential for mistakes such as the above



```r
BQL_NA <- function(x) {
    x[x[["CONC"]] == "LLOQ < 10"] <- NA
    x
}

BQL_NA(df1)
BQL_NA(df2)
BQL_NA(df3)
BQL_NA(df4)
BQL_MA(df5)
```


Closer, but again, we're repeating ourselves.

We touched on `lapply`, lets combine our dataframes into a list a 

**SIDE TRICK** `df[] <- lapply(df, our_fun)` - using `df[]` will give us back a dataframe instead of a list from `df <- lapply(df, our_fun)`


```r
df_list <- list(df1, df2, df3, df4, df5)
df_NOBQL <- lapply(df_list, BQL_NA)
```


### Assignment
- extend BQL_NA to allow us to pass different character strings for what how the LLOQ was defined
- BONUS: likewise, extend it to:   
    - handle any column 'conc' regardless of capitalization
    - handle any concentration column name (conc, concentration, DV, ...)
