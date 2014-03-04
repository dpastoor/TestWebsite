Thinking in R
==================================================
Thinking in R is very important as your R-tasks increase in complexity or magnitude.  Keep in mind that the rest of the workshop will build and call on these concepts heavily. This will also be your first foray into examining your approach to a problem and 'best practices', as there will almost always be a number of ways of getting to the result you want. The goal is to keep you in the 'better' to 'best' range as often as possible. 


## Thinking in R

### Memory Allocation

Before we jump into subsetting, we need to briefly touch upon how R treats data, and more importantly, how it *grows* it as you use it.

Lets look at three possible methods of generating a sequence:


```r
library(microbenchmark)

# c_grow
vec <- numeric(0)
for(i in 1:n) vec <- c(vec, i)

# subscript
vec <- numeric(n)
for(i in 1:n) vec[i] <- i

# colon
vec <- 1:n

microbenchmark {
# do test
# TODO: add microbenchmark test
}
```


Why is the colon operator so much faster?

One reason is that ':' is actually a function just like sum() or mean() or ggplot() - but it is written in `C` and written for *speed*. 

Second, When you grow an object incrementally, it can lead to an issue called **fragmented memory** - when R starts to store the new elements and runs out of the currently allocated space it has to hunt for new space. Do this over and over and it wastes a lot of time.

**suburbanization example***

One stark example is the use of rbind to continuously append to a dataframe.

There are two ways to avoid this trap.

1. Build a list of the pieces and combine in one go (using do.call - will be covered later)
2. preallocate the memory

**Eliminating the growth or re-indexing of objects is an easy way of dramatically increasing the speed of R code.**

### Vectorization
I'm sure you've heard the concept that `for` loops in R are slow. Well slow compared to what?  

Let's consider how we could add together a vector of numbers:

```
lsum <- 0
for (i in 1:length(x)) lsum <- lsum + x[i]
```

or the easy R-way

```
 sum(x) 
```

It may seem like a silly example to you because `sum(x)` is so intuitive to the average user - but someone had to write the function at some point.

Similar to the `:` example previously, these examples provide the same result but with dramatic differences in speed.

The magic that gives these functions is they have been written in C. They are still loops - that is unavoidable, but they've been optimized for speed.

The other benefit that is frequent by-product of vectorization is *legibility* - sum(x) is so easy to understand compared to that loop.

Likewise, `conc <- amt*volume` is both easier to read, and clearly expresses the relationship between variables, whether we are multiplying one amt and volume or a columns of amts and volumes.

### Vectorization Tips
* Put as much outside of loops as possible. Ex: If you have a sequence you are applying over and over, create the sequence first and reuse it inside the loop.
* Make the number of iterations as small as possible. 
* Don't feel the need to over-vectorize

We will come back to more 'optimization'-type issues later, but for now keep these principles in the back of your head as we go forward.

## Indexing

As has been applied in previous examples, R has to have a way of referring to where in your object certain pieces of information are stored. Given that everything in R can be thought of as a vector, indexing allows us to easily query the position in which the vector an element is stored.

For example, to examine the 10th element of an atomic vector one simply can do `v[10]`

For more complex structures keep in mind this concept of an *index* for when you're thinking how to obtain or subset your data.
