# Introduction - Fread.jl

## Convert CSVs to feather or parquet
You can use this package to convert CSVs to feather and parquet files
```julia
using Fread

csv_to_feather(path_to_csv, outpath)
csv_to_parquet(path_to_csv, outpath)
```

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

# Deprecated

## Use [CSV.jl](https://github.com/JuliaData/CSV.jl) instead

You should really be using [CSV.jl](https://github.com/JuliaData/CSV.jl) because it performs quite well. I only use Fread.jl for converting data from parquet to feature etc now and not for reading CSVs as CSV.jl is actually really good. 

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
