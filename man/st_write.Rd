% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read.R, R/db.R
\name{st_write}
\alias{st_write}
\alias{st_write}
\alias{st_write.sfc}
\alias{st_write}
\alias{st_write.sf}
\alias{st_write}
\alias{write_sf}
\alias{st_write}
\alias{st_write_db}
\title{Write simple features object to file or database}
\usage{
st_write(obj, dsn, layer, ...)

\method{st_write}{sfc}(obj, dsn, layer, ...)

\method{st_write}{sf}(obj, dsn, layer = file_path_sans_ext(basename(dsn)),
  ..., driver = guess_driver_can_write(dsn), dataset_options = NULL,
  layer_options = NULL, quiet = FALSE, factorsAsCharacter = TRUE,
  update = driver \%in\% db_drivers, delete_dsn = FALSE,
  delete_layer = FALSE)

write_sf(..., quiet = TRUE, delete_layer = TRUE)

st_write_db(conn = NULL, obj, table = deparse(substitute(obj)),
  geom_name = "wkb_geometry", ..., drop = FALSE, debug = FALSE,
  binary = TRUE, append = FALSE)
}
\arguments{
\item{obj}{object of class \code{sf} or \code{sfc}}

\item{dsn}{data source name (interpretation varies by driver - for some drivers, dsn is a file name, but may also be a
folder or contain a database name)}

\item{layer}{layer name (varies by driver, may be a file name without extension); if layer is missing, the
\link{basename} of \code{dsn} is taken.}

\item{...}{ignored for \code{st_write}, for \code{st_write_db} arguments passed on to \code{dbWriteTable}}

\item{driver}{character; driver name to be used, if missing, a driver name is guessed from \code{dsn};
\code{st_drivers()} returns the drivers that are available with their properties; links to full driver documentation
are found at \url{http://www.gdal.org/ogr_formats.html}.}

\item{dataset_options}{character; driver dependent dataset creation options; multiple options supported.}

\item{layer_options}{character; driver dependent layer creation options; multiple options supported.}

\item{quiet}{logical; suppress info on name, driver, size and spatial reference}

\item{factorsAsCharacter}{logical; convert \code{factor} objects into character strings (default), else into numbers by
\code{as.numeric}.}

\item{update}{logical; \code{FALSE} by default for single-layer drivers but \code{TRUE} by default for database drivers
as defined by \code{db_drivers}.
For database-type drivers (e.g. GPKG) \code{TRUE} values will make \code{GDAL} try
to update (append to) the existing data source, e.g. adding a table to an existing database.}

\item{delete_dsn}{logical; delete data source \code{dsn} before attempting to write?}

\item{delete_layer}{logical; delete layer \code{layer} before attempting to write? (not yet implemented)}

\item{conn}{open database connection}

\item{table}{character; name for the table in the database, possibly of length 2, \code{c("schema", "name")}; default schema is \code{public}}

\item{geom_name}{name of the geometry column in the database}

\item{drop}{logical; should \code{table} be dropped first?}

\item{debug}{logical; print SQL statements to screen before executing them.}

\item{binary}{logical; use well-known-binary for transfer?}

\item{append}{logical; append to table? (NOTE: experimental, might not work)}
}
\description{
Write simple features object to file or database

Write simple feature table to a spatial database
}
\details{
columns (variables) of a class not supported are dropped with a warning. When deleting layers or
data sources is not successful, no error is emitted. \code{delete_dsn} and \code{delete_layers} should be
handled with care; the former may erase complete directories or databases.

st_write_db was written with help of Josh London, see \url{https://github.com/r-spatial/sf/issues/285}
}
\examples{
nc = st_read(system.file("shape/nc.shp", package="sf"))
st_write(nc, "nc.shp")
st_write(nc, "nc.shp", delete_layer = TRUE) # overwrites
data(meuse, package = "sp") # loads data.frame from sp
meuse_sf = st_as_sf(meuse, coords = c("x", "y"), crs = 28992)
st_write(meuse_sf, "meuse.csv", layer_options = "GEOMETRY=AS_XY") # writes X and Y as columns
st_write(meuse_sf, "meuse.csv", layer_options = "GEOMETRY=AS_WKT", delete_dsn=TRUE) # overwrites
\dontrun{
 library(sp)
 example(meuse, ask = FALSE, echo = FALSE)
 try(st_write(st_as_sf(meuse), "PG:dbname=postgis", "meuse_sf",
     layer_options = c("OVERWRITE=yes", "LAUNDER=true")))
 demo(nc, ask = FALSE)
 try(st_write(nc, "PG:dbname=postgis", "sids", layer_options = "OVERWRITE=true"))
}
\dontrun{
  library(sp)
  data(meuse)
  sf = st_as_sf(meuse, coords = c("x", "y"), crs = 28992)
  library(RPostgreSQL)
  try(conn <- dbConnect(PostgreSQL(), dbname = "postgis"))
  if (exists("conn") && !inherits(conn, "try-error"))
    st_write_db(conn, sf, "meuse_tbl", drop = FALSE)
}
}
\seealso{
\link{st_drivers}
}
