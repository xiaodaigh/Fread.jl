# Introduction - Fread.jl

This packages allows you to use [R' {data.table}](https://github.com/Rdatatable/data.table)'s excellent `fread` function to read CSVs

## Installation

```julia
using Pkg
Pkg.add("https://github.com/xiaodaigh/Fread.jl")
```

### Install R packages
You need to make sure you have `{data.table}` and `{feather}` installed in  your R. E.g. in your R session

```r
install.packages(c("data.table", "feather"))
```

## Usage
To use the default parameters of `fread`
```julia
using Fread

a = fread(path_to_csv)
```

To use customised parameters/arguments, you *must set them by name* using `arg = ` e.g. 
```julia
using Fread

a = fread(path_to_csv, sep="|", nrows = 50)
```


## How does it work internally?

The function `fread` does a few of things

1. Reads the CSV using `data.table::fread`
2. Saves the `data.frame` in feather format
3. Loads the feather file into Julia as a `DataFrame`

Step 2 creates a feather file which you can set the location of by using a 2nd unnamed argument .e.g.

```julia
fread(path_to_csv, "path/to/out.feather")
```

by default the `feather` output path is `path_to_csv*".feather` i.e. with the feather extension attached to the input file.

## Why?
Because `data.table::fread` is fast! And is often much faster than native pure-Julia solutions at the moment

