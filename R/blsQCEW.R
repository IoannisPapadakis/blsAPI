# blsQCEW.R
#
#' @title Request QCEW Data from the U.S. Bureau Of Labor Statistics Open Data Access
#' @description Allows users to request quarterly census of employment and wages (QCEW) data from the U.S. Bureau of Labor Statistics open access.  Users provide parameters and the function returns a data frame.  This function is based off of the sample code developed by the BLS that is found at <\url{https://www.bls.gov/cew/doc/access/data_access_examples.htm}>.
#' @details This function is a wrapper for multiple data request methods.  See code examples for which parameters are required for which methods.  Visit <\url{https://www.bls.gov/cew/opendata.htm}> for an overview of the BLS's open data access.
#' @param method a string describing which type of data you want requested.  Valid options are: Area, Industry and Size.  The method is not case sensitive.
#' @param year a string for the year of data you want
#' @param quarter a string indicating the quarter (1, 2, 3 or 4) or "a" for the annual average.
#' @param area a string indicating which area you want the data for.  See <\url{https://www.bls.gov/cew/doc/titles/area/area_titles.htm}> for all area codes and titles.
#' @param industry a string for the NAICS code.  Some industry codes contain hyphens but the open data access uses underscores instead of hyphens. So 31-33 becomes 31_33. For all industry codes and titles see: <\url{https://www.bls.gov/cew/doc/titles/industry/industry_titles.htm}>
#' @param size a string for the size code. See <\url{https://www.bls.gov/cew/doc/titles/size/size_titles.htm}> for all establishment size classes and titles.  Note: Size data is only available for the first quarter of each year.
#' @keywords bls economics
#' @export blsQCEW
#' @importFrom utils read.csv
#' @examples
#' # These examples are taken from the sample code examples found at: 
#' # <https://www.bls.gov/cew/doc/access/data_access_examples.htm>
#' 
#' # Area Data Request
#' 
#' # Required parameters are:
#' #  * year
#' #  * quarter
#' #  * area
#' 
#' # Example: Request the first quarter of 2017 for the state of Michigan
#' MichiganData <- blsQCEW('Area', year='2017', quarter='1', area='26000')
#' \dontrun{
#' # Industry Data Request
#' 
#' # Required parameters are:
#' #  * industry
#' #  * quarter
#' #  * year
#' 
#' # Example: Request Construction data for the first quarter of 2017
#' Construction <- blsQCEW('Industry', year='2017', quarter='1', industry='1012')
#' 
#' # Size Data Request
#' #  * size
#' #  * year
#' 
#' # Example: Request data for the first quarter of 2017 for establishments with 
#' # 100 to 249 employees
#' SizeData <- blsQCEW('Size', year='2017', size='6')
#' }

blsQCEW <- function(method, year=NA, quarter=NA, area=NA, industry=NA, size=NA){
  # This variable is changed in the case that an error has occured
  request_data <- TRUE
  # These variables are used to check that we have all needed parameters
  have_year <- have_quarter <- have_area <- have_industry <- have_size <- FALSE
  # Fix case sensitivity of the method parameter
  method <- tolower(method)
  # Get the open data url
  if (method == "area"){
    url <- "https://data.bls.gov/cew/data/api/YEAR/QTR/area/AREA.csv"
  } else if (method == "industry"){
    url <- "https://data.bls.gov/cew/data/api/YEAR/QTR/industry/INDUSTRY.csv"
  } else if (method == "size"){
    url <- "https://data.bls.gov/cew/data/api/YEAR/1/size/SIZE.csv"
  } else {
    message('blsQCEW: Method not valid.  Please use "Area", "Industry" or "Size".')
    request_data <- FALSE
  }
  # Update the URL with the parameters
  if (class(year) != "logical"){
    have_year <- TRUE
    url <- sub("YEAR", year, url, ignore.case = FALSE)
  }
  if (class(quarter) != "logical"){
    have_quarter <- TRUE
    url <- sub("QTR", quarter, url, ignore.case = FALSE)
  }
  if (class(area) != "logical"){
    have_area <- TRUE
    url <- sub("AREA", area, url, ignore.case = FALSE)
  }
  if (class(industry) != "logical"){
    have_industry <- TRUE
    url <- sub("INDUSTRY", industry, url, ignore.case = FALSE)
  }
  if (class(size) != "logical"){
    have_size <- TRUE
    url <- sub("SIZE", size, url, ignore.case=FALSE)
  }
  # Check to make sure we have all the parameters we need
  if (method == "area" && (!have_area || !have_year || !have_quarter)){
    request_data <- FALSE
    message('blsQCEW: Missing parameter for area request.  The area, year and quarter parameters are needed.')
  } else if (method == "industry" && (!have_industry || !have_year || !have_quarter)){
    request_data <- FALSE
    message('blsQCEW: Missing parameter for industry request.  The industry, year and quarter parameters are needed.')
  } else if (method == "size" && (!have_size || !have_year)){
    request_data <- FALSE
    message('blsQCEW: Missing parameter for size request.  The size and year parameters are needed.')
  }
  if (request_data){
    #  Return the data frame
    read.csv(url, header <- TRUE, sep <- ",", quote="\"", dec=".",
             na.strings=" ", skip=0)
  }
}