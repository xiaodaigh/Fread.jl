module Fread

using RCall, Feather

export fread

const PKG_NOT_INSTALLED_ERR_MSG = "{data.table} and/or {feather} package(s) not installed\n run 'Fread.install_pkgs()' or install {data.table} and {feather} manually in R using 'install.packages(c('data.table', 'feather'))'"

function install_pkgs()
    R"""
        if(!require(data.table)) {
          install.packages(c("data.table"))
        }
        if(!require(data.table)) {
          install.packages(c("data.table"))
        }
    """
end

function pkgs_installed()
    R"""
        memory.limit(1e10)
        datatable_installed <- require(data.table)
        feather_installed <- require(feather)
    """
    @rget datatable_installed
    @rget feather_installed
    (datatable_installed = datatable_installed, feather_installed = feather_installed)
end

fread(path,  feather_out_path = path*".feather"; params...) = begin
    if !pkgs_installed()
        throw(ErrorException(PKG_NOT_INSTALLED_ERR_MSG))
    end

    @rput params
    R"""
        if(!require(data.table)) {
            stop("data.table not installed")
        }
        if(!require(feather)) {
            stop("feather R package not installed")
        }
        #res = data.table::fread($path)
        res = do.call(data.table::fread, c(list($path), params))
        feather::write_feather(res, $feather_out_path)
    """

    Feather.read(feather_out_path)
end

end # module
