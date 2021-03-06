Debugging Functions
==============================
TODO: split to different headers (debugging/int-function-writing)

There are 3 basic ways to indicate to an end-user that something isn't right inside a function - be it due to an improper calculation or improper input.

* **message**: relay a generic notification produced by `message()`
* **warning**: An indication that something is wrong but not enough to halt execution of the function. Generated with `warning()`
* **error** An indication that a fatal error has occurred - stops execution. Generated with `stop()` function

Given a stoplight analogy - a message is like reading an alert sign over the light, a warning is a "yellow light" and error is a "red light"

TODO: more about warning messages and testing input

R has a couple useful built-in tools for debugging:

* `traceback` - prints out stack of function calls after an error occurs
* `debug` - flags function for "debug" mode to allow function execution to proceed one line at time
* `browser` - suspends execution of function wherever it is called and puts function into debug mode
* `trace` - allows insertion of debugging code into function at specific locations
* `recover` - to modify error behavior to browse function call stack

There is also the `message` and `print/cat` techniques - that are less elegant but work for basic situations

TOCHANGE: change rmse example slightly to make it more 'real'


```r
deviation <- function(x) x - mean(x)
squared <- function(x) x^2
root <- function(x) x^0.5
values <- c(1, "NA", 3, 4, 5)
# would get an error issue with knitting if let error run
# root(mean(squared(deviation(values))))

traceback()
```

```
## No traceback available
```



```r
# what is wrong with this example?  hint think of the type of variables
j <- function(i = 5) {
    if (i == 1) 
        "a" + 1
    j(i - 1)
}
j()
```


## Commands While Debugging 
interactive debugging through `browser()` can be helpful to see what is going on inside your function.

A couple of the important commands to know are:

* **<RET>** Go to the next statement if the function is being debugged. Continue execution if the browser was invoked.
* **c or cont** - Continue execution without single stepping.
* **n** - Execute the next statement in the function. This works from the browser as well.
* **where** - Show the call stack.
* **Q** - Halt execution and jump to the top-level immediately.

`browser()` is helpful to use while building a function if you would like to check what is going on each time the function is called. 


```r
my_fun <- function(x) {
    # do some stuff ...
    browser()
    ## do more stuff
}
```


For the above example, when `my_fun` is run, the browser will be launched at the point where it is called in the function and you can check the current status of the function environment.

TODO: add example use for browser inside function

## debugging example time 

TODO: snap-shot examples for future references

while debugging a couple things you can use to navigate

* `ls()` will list the contents in the environment
    * you can call these objects to see what their current value is
* can quit out of debugging with `Q`
* proceed to next line in debug with 'n'
* continue code execution `c` - similar to `n` but may allow for multiple lines of code to execute before stopping (will run all code inside loop or function before pausing)
While in debug mode you can run code on objects in the environment as you would otherwise

TOCHANGE: to modify as well from metrum-esque example


```r
deviation <- function(x) {
    if (!is.numeric(x)) 
        stop("x must be numeric") else if (any(is.na(x))) 
        warning("removing NA values in x") else message("calculating differences from the reference value\n...")
    return(x - mean(x, na.rm = TRUE))
}
```


`invisible(x)` in place of `return`

Wouldn't it be nice it we could have the results stored but not have them printed!



```r
sim_number <- function(x) {
    cat("You are running:", x, "simulations")
    x + 5  #imagine simulation function here instead
}
```



```r
rep_maker <- function(df, x) {
    cat("You are creating:", x, "copies")
    outputvector <- numeric(length(df) * x)
    lapply(1:x, function(x) {
        # imagine simulation function here instead
    })
}
```

