#' @title K-Means Clustering
#'
#' @description Preform k-means clustering on a dataset.
#'
#' @usage k_means(x, centers, PCA = F, plus.plus = F)
#'
#'
#' @param x numeric matrix of data, or an object that can be coerced to such a matrix
#' (such as a numeric vector or a data frame with all numeric columns).
#' @param centers the number of clusters k.
#' @param PCA logical indicating if you want to preform a PCA transformation on the data.
#' @param plus.plus logical indicating if you want to use the k-means++ algorithm for
#' improved choosing of initial values.
#'
#' @return A list containing cluster means, clustering vector, and total SSE.
#'
#' @import tidyverse
#'
#' @export

k_means = function(x, centers, PCA = F, plus.plus = F){

  if(PCA == T){

    x = princomp(x)
    x = x$scores %>% as_tibble() %>% select(Comp.1, Comp.2)

  }

  k.means = sample_n(x, centers)
  ik.means = 0


  if(plus.plus == T){

    k.means = sample_n(x, 1)

    for(i in 2:centers){

      tempdf = as.matrix(x)
      dists = rep(NA, nrow(tempdf))

      for(i in 1:nrow(tempdf)){

        tempdist = as.matrix(dist(rbind(k.means, tempdf[i,])))
        tempdist = tempdist[nrow(tempdist), 1:nrow(tempdist)-1]
        dists[i] = min(tempdist)

        }

      tempdf = data.frame(tempdf)
      weights = dists^2/sum(dists^2)
      k.means = rbind(k.means, sample_n(tempdf, 1, weight = weights))

      }
    }

  while(sum((k.means - ik.means)^2) != 0){

    ik.means = k.means
    tempdf = as.matrix(x)
    clust = rep(NA, nrow(tempdf))
    dists = rep(NA, nrow(tempdf))

    for(i in 1:nrow(tempdf)){

      tempdist = as.matrix(dist(rbind(k.means, tempdf[i,])))
      tempdist = tempdist[nrow(tempdist), 1:nrow(tempdist)-1]
      clust[i] = which.min(tempdist)
      dists[i] = min(tempdist)

    }

    tempdf = cbind(tempdf, clust, dists)
    SSE = sum(dists^2)
    k.means = cbind(tapply(tempdf[,1], tempdf[,3], mean),
                    tapply(tempdf[,2], tempdf[,3], mean))

  }

  return(list('Clustering vector' = tempdf[,3], 'Cluster Means' = k.means, 'Total SSE' = SSE))

}
