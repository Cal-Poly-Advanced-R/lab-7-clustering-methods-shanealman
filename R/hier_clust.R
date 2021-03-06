#' @title Hierarchical Clustering
#'
#' @description Preform hierarchical clustering on a dataset.
#'
#' @usage hier_clust(x)
#'
#'
#' @param x numeric matrix of data, or an object that can be coerced to such a matrix
#' (such as a numeric vector or a data frame with all numeric columns).
#' @param method the distance measure to be used. This must be one of euclidean or manhattan.
#'
#' @return A vector with what was merged and in what order.
#'
#' @import tidyverse
#' @improt sna
#'
#' @export

hier_clust = function(x, method = 'euclidean'){

  dists = diag.remove(as.matrix(
    dist(x, method = ifelse(method == 'euclidean', 'euclidean', 'manhattan'))))

  merges = NULL
  i = 1

  while(length(merges) < nrow(x)){

    index = which(dists == min(dists, na.rm = T), arr.ind = T)
    index = as.matrix(sample_n(data.frame(index),1))
    merges = c(merges, paste(row.names(dists[index,]), sep = '', collapse = ','))
    new_dists = dists[-index,-index]
    comparison = dists[-as.numeric(index),as.numeric(index)]

    if(length(new_dists) > 1){

      comparison = apply(comparison, 1, max)
      dists = cbind(comparison, new_dists)
      dists = rbind(c(NA, comparison), dists)
      row.names(dists)[1] = merges[i]

    } else {

      merges = c(merges, paste(row.names(dists), sep = '', collapse = ','))
      break

    }

    i = i + 1

  }

  return(merges)

}

