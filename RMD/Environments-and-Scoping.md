Environments and Scoping Rules
==============================
Continued from Basic Function Writing

Until this point, we have not addressed how R stores and references objects. This underlying behavior is incredibly important to the end-users. In addition, there are some important behaviors that play a role in more complex R-based projects.

For example, what is going on in the following situation


```r
dose <- 100
dosing_col <- function(df, dose) {
    df[, "dose"] <- dose
}
# TOCHANGE: add real ourDF and change to eval = T

dosing_col(ourDF, dose = 500)
```

How does R know to to use the value of 500 for dose, rather than 100.

Another situation:


```r
y <- 3
add_fun <- function(x, ...) x + y

# what happens in these situations?
add_fun(2)
add_fun(2, 10)
add_fun(2, y = 10)
```


To understand this behavior better we need to understand **environments**

**Environments** are R objects that contain the sets of symbols available in a given context, the objects associated with these symbols, and a *pointer* to the parent environment. The overall purpose of an environment is to bind a set of names to values. Every environment has a parent environment (expect for one env - the *empty environment*), and can also have multiple "child" environments. 

All symbols and objects in an environment are called a **frame**.

When R tries to bind a value to a symbol, it recursively looks through the parent environments to find the appropriate value.

The *global environment* is always the first element of the search list, and the *base* package is always the last. The order of packages in the search list defines the order in which the environments are searched.

When a new library is loaded, the namespace of the package is assigned to the 2nd position in the search list and everything else is shifted down.

Hence, if two packages each have a function `doStuff()`, if `doStuff()` is called, R will search and find the `doStuff()` function in the last loaded package and use it. To force the use of a symbol associated with a specific package you can use `::`

For example: `our_package::doStuff()` will immediately look to `our_package` without searching if `doStuff()` was available in other environments.

To better understand the interaction between environments there are **scoping rules** that help define behavior

## What is Scoping

Scoping is a ruleset used to lookup symbol (variable) values when they are called. Each language handles this differently (though most OO-lanuages handle them very similarly)

## Scoping Rules
Scoping rules determine how a value is associated with free variables. R primarily uses **lexical scoping**. Lexical scoping defines how variable names are resolved in nested function. 

### Lexical Scoping
At it's heart lexical scoping can be explained as inner functions (child functions) contain the scope of the parent functions. This is possible due to the *first class* nature of functions in R. 

TODO: add more layman definition (perhaps with example)

This is particularly useful for simplifying computations (especially statistical ones!)

Given a function such as `function(x) x + y` how does R search for y?

Side reminder: In the above function `x` is a **formal argument** whereas `y` is known as a **free variable**

Scoping rules (particularly lexical scoping) determine how a value is assigned to the free variable (remember - with R's lazy evaluation - a free variable is only assigned when it is called)

Two consequences of lexical scoping in R is all objects must be stored in memory, and all functions must have a pointer to their parent (defining) environment.


## Function Environments

A function + environment combination is called a **closure**

Each function is associated with four distinct environments 
* environment where function exists
* environment where function was created
* environment from which function is called 
* environment that's created when a function is run


### Where Function Exists
When a function is created, a reference is added to point to the environment where it was made. This is 

TOCHANGE: re-do example to make more easily understandable

```r
dose <- 100
t <- function(x = 10) {
    print(dose)
    x
}
t()
```

```
## [1] 100
```

```
## [1] 10
```

```r
dose <- 5
t()
```

```
## [1] 5
```

```
## [1] 10
```


When `t()` is called, it looks to the environment in which the function was created (in this case the global environment) for a symbol `dose`. If the value of `dose` changes in the parent, so will the results inside t().

This behavior is expected when a function is defined in the global environment, thereby any free variables are those found in the user's workspace.

### Environment Where Function Created
But what happens if you define a function inside another function?


```r
library(pryr)
```

```
## 
## Attaching package: 'pryr'
## 
## The following object is masked _by_ '.GlobalEnv':
## 
##     f
## 
## The following object is masked from 'package:metrumrg':
## 
##     f
```

```r
power <- function(pow) {
    exp <- function(x) {
        x^pow
    }
    exp
}
square <- power(2)
square(5)
```

```
## [1] 25
```

```r
cube <- power(3)
cube(5)
```

```
## [1] 125
```

```r
square(5)
```

```
## [1] 25
```

```r

# where is function cube
where("cube")
```

```
## <environment: R_GlobalEnv>
```

```r

# what is cube's environment
environment(power)
```

```
## <environment: R_GlobalEnv>
```

```r
environment(cube)
```

```
## <environment: 0x000000000f2e8210>
```

```r
parent.env(environment(cube))
```

```
## <environment: R_GlobalEnv>
```

```r

# what is the value of the symbol 'pow' in the various environments
get("pow", environment(cube))
```

```
## [1] 3
```

```r
get("pow", environment(square))
```

```
## [1] 2
```

```r
get("pow", environment(power))
```

```
## Error: object 'pow' not found
```

```r


pow <- 10
get("pow", environment(cube))
```

```
## [1] 3
```

```r
get("pow", environment(square))
```

```
## [1] 2
```

```r
get("pow", environment(power))
```

```
## [1] 10
```


What will this return?

```
pow <- 5
whatpow <- power()
whatpow(2)
```

We can take advantage of R's ability to return a function in combination with remembering what the environment looked like when a function was created allows us to create **function factories** like the power function above.

### Environment Where Function Called

Another example:

TOCHANGE: update significantly to make more easily understandable

```r
greeting_fun <- function() {
    introduction <- "hello"
    return(function() introduction)
}
greeting <- greeting_fun()
greeting()
```

```
## [1] "hello"
```

```r

introduction <- "hi"
greeting <- greeting_fun()
greeting()
```

```
## [1] "hello"
```


### Environment Created When Function Runs


```r
a <- 5
f <- function() {
    a <- a + 1
    print(a)
}
f()
```

```
## [1] 6
```

```r
f()
```

```
## [1] 6
```

```r

a <- 10
f()
```

```
## [1] 11
```

```r
f()
```

```
## [1] 11
```


It returns the same value as every time a function is called a new environment is created to host execution.

### A Pharmacometrics Example

Predict what will the results will be: 

Situation 1: Define `f` and `g` separately from one another


```r
dose <- 100
f <- function() print(dose)
g <- function() {
    f()
    dose <- 10
    f()
}
g()
dose <- 50
g()
```


Situation 2: Define `f` inside of `g`


```r
dose <- 100

g <- function() {
    f <- function() print(dose)
    f()
    dose <- 10
    f()
}
g()
dose <- 50
g()
```


## Modifiying Binding (dangerously!)

`<<-`

This does not assign the variable in the current environment, instead steps up the parent environment(s) until it finds an existing variable it can modifiy



```r
dose <- 100
t <- function(x = 10) {
    dose <<- x
}
t()
dose
```

```
## [1] 10
```

```r

t(15)
dose
```

```
## [1] 15
```


This is especially dangerous as it can introduce dependencies between functions that aren't immediately apparent! This should only be used in extremely specific circumstances. Frankly, in virtually all situations you are better off attacking the problem from a different angle if the only way to get the behavior you want is to use `<<-`. 

TODO: give example of when <<- used
