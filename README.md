# Fread

This packages allows you to use [R' {data.table}](https://github.com/Rdatatable/data.table)'s excellent `fread` function to read CSVs

## Installation

```julia
using Pkg
Pkg.add("https://github.com/xiaodaigh/Fread.jl")
```

## Usage
To use the default parameters of `fread`
```julia
using Fread

a = fread(path_to_csv)
```

To use the parameters, you *must set them by name* using `arg = ` e.g. 
```julia
using Fread

a = fread(path_to_csv, sep="|", nrows = 50)
```

