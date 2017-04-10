#' @title Evenness Index
#' @description Various community evenness indices.
#' @param index Evenness index. See details for options.
#' @param zeroes Include zero counts in the evenness estimation.
#' @inheritParams global
#' @return A vector of evenness indices
#' @export
#' @examples
#'   data(dietswap)
#'   # phyloseq object
#'   d <- evenness(dietswap, "pielou")
#'   # matrix
#'   d <- evenness(abundances(dietswap), "pielou")
#'   # vector
#'   d <- evenness(abundances(dietswap)[,1], "pielou")
#'
#' @details
#' By default, Pielou's evenness is returned.
#'
#' The available evenness indices include the following:
#'   1) "camargo": Camargo's evenness (Camargo 1992)
#'   2) "simpson": Simpson’s evenness (inverse Simpson diversity / S)
#'   3) "pielou": Pielou's evenness (Pielou, 1966), also known as Shannon or Shannon-Weaver/Wiener/Weiner evenness; H/ln(S). The Shannon-Weaver is the correct one, please stick to that.
#'   4) "evar": Smith and Wilson’s Evar index (Smith & Wilson 1996)
#'   5) "bulla": Bulla’s index (O) (Bulla 1994)
#'   
#'   Desirable statistical evenness metrics avoid strong bias towards very large or very small abundances; are independent of richness; and range within [0,1] with increasing evenness (Smith & Wilson 1996). Evenness metrics that fulfill these criteria include at least camargo, simpson, smith-wilson, and bulla. Also see Magurran & McGill (2011) and Beisel et al. (2003) for further details.
#'
#' @references
#'
#'  Beisel J-N. et al. A Comparative Analysis of Evenness Index Sensitivity. Internal Rev. Hydrobiol. 88(1):3-15, 2003. URL: \url{https://portais.ufg.br/up/202/o/2003-comparative_evennes_index.pdf}
#' 
#'  Bulla L. An  index  of  evenness  and  its  associated  diversity  measure.  Oikos 70:167--171, 1994
#'
#'  Camargo, JA. New diversity index for assessing structural alterations in aquatic communities. Bull. Environ. Contam. Toxicol. 48:428--434, 1992.
#'
#'  Locey KJ and Lennon JT. Scaling laws predict global microbial diversity. PNAS 113(21):5970-5975, 2016; doi:10.1073/pnas.1521291113.
#'
#'  Magurran AE, McGill BJ, eds (2011) Biological Diversity: Frontiers in Measurement and Assessment (Oxford Univ Press, Oxford), Vol 12.
#'
#'  Pielou, EC. The measurement of diversity in different types of biological collections. Journal of Theoretical Biology 13:131--144, 1966.
#'
#'  Smith B and Wilson JB. A Consumer's Guide to Evenness Indices. Oikos 76(1):70-82, 1996.
#'
#' @author Contact: Leo Lahti \email{microbiome-admin@@googlegroups.com}
#' @seealso coverage, core_abundance, rarity, global
#' @keywords utilities
evenness <- function(x, index = "all", zeroes = TRUE) {

  # Only include accepted indices	 
  accepted <- c("camargo", "pielou", "simpson", "evar", "bulla")

  # Return all indices
  if (index == "all") {
    index <- accepted
  }

  index <- intersect(index, accepted)
  if (length(index) == 0) {
    return(NULL)
  }

  if (length(index) > 1) {
    ev <- NULL
    for (idx in index) {
      ev <- cbind(ev, evenness(x, index = idx, zeroes = TRUE))
    }
    colnames(ev) <- index
    return(as.data.frame(ev))
  }

  # Pick data
  otu <- pick_data(x, compositional = FALSE)

  if (index == "camargo") {
    ev <- apply(otu, 2, function (x) {camargo(x, zeroes = zeroes)})
  } else if (index == "simpson") {
    ev <- apply(otu, 2, function (x) {simpson_evenness(x, zeroes = zeroes)})
  } else if (index == "pielou") {
    ev <- apply(otu, 2, function (x) {pielou(x, zeroes = zeroes)})
  } else if (index == "evar") {
    ev <- apply(otu, 2, function (x) {evar(x, zeroes = zeroes)})
  } else if (index == "bulla") {
    ev <- apply(otu, 2, function (x) {bulla(x, zeroes = zeroes)})
  }

  names(ev) <- colnames(otu)

  ev

}



bulla <- function (x, zeroes = TRUE) {

  if (!zeroes) {
    x[x > 0]
  }

  # Species richness (number of species)
  S <- length(x)

  # Relative abundances
  p <- x/sum(x)

  O <- sum(pmin(p, 1/S))

  # Bulla's Evenness
  (O - 1/S) / (1 - 1/S)


}


# Camargo's eveness
# x: species counts
# zeroes: include zeros
# Inspired by code from Pepijn de Vries and Zhou Xiang
# at https://www.researchgate.net/post/How_can_we_calculate_the_Camargo_evenness_index_in_R but rewritten here
camargo <- function(x, zeroes = TRUE)
{

  if (!zeroes) {
    x[x > 0]
  }

  N <- length(x)

  xx <- 0
  for (i in 1:(N - 1)) {
    xx <- xx + sum(abs(x[(i+1):N]-x[i]))
  }

  # Return
  1 - xx/(sum(x)*N)
  
}



# x: Species count vector
simpson_evenness <- function (x, zeroes = TRUE) {

  if (!zeroes) {
    x[x > 0]
  }

  # Species richness (number of species)
  S <- length(x)

  # Relative abundances
  p <- x/sum(x)

  # Simpson index
  lambda <- sum(p^2)

  # Simpson evenness (Simpson diversity per richness)
  (1/lambda)/S
  
}





# x: Species count vector
pielou <- function (x, zeroes = TRUE) {

  if (!zeroes) {
    x[x > 0]
  }

  # Species richness (number of species)
  S <- length(x)

  # Relative abundances
  p <- x/sum(x)

  # Shannon index
  H <- (-sum(p * log(p)))

  # Simpson evenness
  H/log(S)
  
}

# Smith and Wilson’s Evar index
evar <- function(x, zeroes = TRUE){

  if (!zeroes) {
    x[x > 0]
  }

  n <- length(x)
  d <- rep(NA, n)

  # Log abundance  
  a <- ifelse(x != 0, log(x), 0)

  # Richness
  S <- sum(x > 0)

  b <- a/S  
  c <- sum(b)
  d <- ifelse(x != 0, (a-c)^2/S, 0)
  f <- sum(d)
    
  (1-2/pi*atan(f))

}
