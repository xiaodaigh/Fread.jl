module Fread

using RCall, Feather

export fread

const PKG_NOT_INSTALLED_ERR_MSG = "{data.table} and/or {arrow} package(s) not installed\n run 'Fread.install_pkgs()' or install {data.table} and {arrow} manually in R using 'install.packages(c('data.table', 'arrow'))'"

"""
    Fread.install_pkgs()

Install the R packages needed namely data.table and arrow
"""
function install_pkgs(repos = "https://cran.rstudio.com")
    run(`R -e "install.packages(c('data.table', 'arrow'),repos='$repos')"`)
    pkgs_installed()
end

"""
    Fread.pkgs_installed()

Checks if all required R packages are installed
"""
function pkgs_installed()
    R"""
        ml = memory.limit()
        # TODO better
        memory.limit(max(ml, ml*2, 2e14))
        datatable_installed <- require(data.table)
        arrow_installed <- require(arrow)
    """
    @rget datatable_installed
    @rget arrow_installed
    (datatable_installed = datatable_installed, arrow_installed = arrow_installed)
end

"""
    fread(path, feather_out_path = path*".feather"; params...)

Reads a CSV from `path` and create a DataFrame. An intermediate feather file
is created at `feather_out_path`

* `path` input CSV path
* `feather_out_path` intermediate feather file path
* `params` parameters passed to data.table
"""
fread(path,  feather_out_path = path*".feather"; params...) = begin
    csv_to_feather(path, feather_out_path; params...)

    Feather.read(feather_out_path)
end

"""
    csv_to_feather(path, outpath; params...)

Converts a CSV file to feather format
"""
csv_to_feather(path, outpath; params...) = begin
    if !all(pkgs_installed())
        throw(ErrorException(PKG_NOT_INSTALLED_ERR_MSG))
    end

    @rput params
    R"""
        ml = memory.limit()
        # TODO better
        memory.limit(max(ml, ml*2, 2e14))
        if(!require(data.table)) {
            stop("data.table not installed")
        }
        if(!require(arrow)) {
            stop("arrow R package not installed")
        }
        #res = data.table::fread($path)
        res = do.call(data.table::fread, c(list($path), params))
        arrow::write_feather(res, $outpath)
    """
end

"""
    csv_to_parquet(path, outpath; params...)

Converts a CSV file to parquet format
"""
csv_to_parquet(path, outpath; params...) = begin
    if !all(pkgs_installed())
        throw(ErrorException(PKG_NOT_INSTALLED_ERR_MSG))
    end

    @rput params
    R"""
        ml = memory.limit()
        # TODO better
        memory.limit(max(ml, ml*2, 2e14))
        if(!require(data.table)) {
            stop("data.table not installed")
        }
        if(!require(arrow)) {
            stop("arrow R package not installed")
        }
        #res = data.table::fread($path)
        res = do.call(data.table::fread, c(list($path), params))
        arrow::write_parquet(res, $outpath)
    """
end

end # module
