## Utility functions for data preparation.


#' Convert data type
#' 
#' Change the type of a vector.
#' 
#' @template function_not_exported
#' 
#' @param x Vector to typecast.
#' @param type Type to which to convert `x`.
#' @param date Date format if `x` has to be converted from `character` to
#'  `Date`.
#' @return Vector corresponding to `x` whose type is `type`.
#' 
#' @author Gauthier Magnin
#' @keywords internal
#' 
typecast = function(x, type, date = "%Y%m%d") {
  switch(type,
         factor  = as.factor(x),
         Date    = as.Date(x, format = date),
         numeric = {
           if (class(x) == "factor") as.numeric(as.character(x))
           else as.numeric(x)
         },
         as(x, type))
}


#' Extend character values
#' 
#' Extend character values to the left by adding a repeated character until
#'  they get a given number of characters.
#' 
#' @details
#' `NA` values always remain unchanged.
#' 
#' @template function_not_exported
#' 
#' @param x Character values to extend.
#' @param char Character to use to extend values from `x`.
#' @param nb Number of characters each value must have at the end of the
#'  process.
#' @return Vector corresponding to `x` in which all values have the same number
#'  of characters.
#' 
#' @author Gauthier Magnin
#' @keywords internal
#' 
extend_left = function(x, char, nb = max(nchar(x))) {
  x[!is.na(x)] = gsub(" ", char, sprintf(paste0("%", nb, "s"), x[!is.na(x)]))
  return(x)
}


#' Split the elements of a character vector
#' 
#' Split the lemenets of a charcter vector `x` into substrings according to the
#'  matches to a substring `split` within them.
#' For each character value from to be splitted, only the last match is
#'  considered.
#' 
#' @details
#' This function combines the functions `gregexpr` and `sapply` rather than
#'  using `strsplit`.
#' 
#' @template function_not_exported
#' 
#' @param x Character values to split.
#' @param split Character value to use for splitting.
#' @param simplify Logical value indicating whether the result should be
#'  simplified. See [`base::sapply`].
#' @param ... Further arguments to the function [`base::gregexpr`].
#' @return Matrix or list (according to the argument `simplify`) in which each
#'  column or element contains the vector of splits of an element of `x`.
#' 
#' @author Gauthier Magnin
#' @seealso [`base::strsplit`].
#' @keywords internal
#' 
strsplit_last = function(x, split, simplify = TRUE, ...) {
  
  split_pos = sapply(gregexpr(split, x, ...), tail, n = 1)
  
  return(sapply(seq_along(x),
                function(i) {
                  to_split = x[i]
                  if (is.na(split_pos[i]) || split_pos[i] == -1) return(to_split)
                  
                  return(c(
                    substr(to_split, 1, split_pos[i] - 1),
                    substring(to_split, split_pos[i] + 1)
                  ))
                },
                simplify = simplify))
}


#' Check the validity of keys identifying each row
#' 
#' Check the existence of a key for each row and the uniqueness of each key.
#'  Print diagnostic messages if keys are not valid.
#' 
#' @details
#' Keys are considered as invalid if any of the following conditions is met.
#'  * A key appears more than once.
#'  * There is data associated with no key (i.e., the key or one of its part is
#'    `NA`).
#' 
#' @template function_not_exported
#' 
#' @param table Data frame containing data to verify.
#' @param keys Numbers of the columns containing the identifiers (i.e., forming
#'  the unique keys).
#' @param name Optional. Name to give to the data frame to use in the diagnostic
#'  message.
#' 
#' @author Gauthier Magnin
#' @keywords internal
#' 
validate_keys = function(table, keys = 1, name = NULL) {
  
  name = if (!is.null(name)) paste0(name, " ") else character(0)
  
  if (any(duplicated(table[keys]))) {
    message("Invalid ", name, "table. ",
            "Certain keys appear more than once.")
  }
  
  if (any(apply(table, 1, function(row) any(is.na(row[keys])) & any(!is.na(row[-keys]))))) {
    message("Invalid ", name, "table. ",
            "There is data associated with no key (i.e., the key or one of its part is NA).")
  }
}


#' Turn a two-column structure into a named vector
#' 
#' Turn a two-column data frame or matrix into a named vector using one column
#'  as names and the other one as values.
#' 
#' @template function_not_exported
#' 
#' @param x Data frame to turn into a vector.
#' @param names Number of the column of `x` to use as names.
#' @param values Number of the column of `x` to use as values.
#' @return Named vector.
#' 
#' @author Gauthier Magnin
#' @keywords internal
#' 
turn_2c_into_vec = function(x, names = 1, values = 2) {
  return(stats::setNames(x[, values], x[, names]))
}


#' Resave data with the best compression method
#' 
#' Search for the best compression method to save existing '.RData' or '.rda'
#'  files and resave them with this method.
#' 
#' @details
#' Use of the maximum compression level (9).
#' 
#' @template function_not_exported
#' 
#' @param paths A character vector of paths to found data and save files.
#' 
#' @author Gauthier Magnin
#' @seealso [`tools::resaveRdaFiles`], [`tools::checkRdaFiles`].
#' @keywords internal
#' 
resave_with_best_compression = function(paths){
  
  # Checking the existence of the package tools
  # (included in "Suggests" field of the DESCRIPTION file)
  if (!requireNamespace("tools", quietly = TRUE)) {
    stop("Package \"tools\" needed for this function to work. Please install it.",
         call. = FALSE)
  }
  
  # Compression methods
  methods = c("gzip", "bzip2", "xz")
  
  # For each file
  for (p in paths) {
    
    # For each compression method, compress the data and get the file size
    sizes = sapply(methods, function(m) {
      tools::resaveRdaFiles(p, compress = m, compression_level = 9)
      return(tools::checkRdaFiles(p)$size)
    })
    names(sizes) = methods
    
    # Selecting the best compression method
    best = methods[which.min(sizes)]
    
    # Display of results and optimal choice
    if (length(paths) != 1) cat("File:", p,"\n")
    cat("File sizes according to compression method:\n")
    print(sizes)
    cat("Use of '", best, "' compression method.\n", sep = "")
    if (p != paths[length(paths)]) cat("\n")
    
    # Compress again using the best method
    if (best != methods[3]) {
      tools::resaveRdaFiles(p, compress = best, compression_level = 9)
    }
  }
}
