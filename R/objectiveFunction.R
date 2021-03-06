laplacian.objectiveFunction <- function(Lw, U, lambda, K, beta) {
  return(laplacian.negloglikelihood(Lw, lambda, K) +
         laplacian.prior(beta, Lw, lambda, U))
}


laplacian.negloglikelihood <- function(Lw, lambda, K) {
  return(sum(-log(lambda)) + sum(diag(K %*% Lw)))
}


laplacian.prior <- function(beta, Lw, lambda, U) {
  return(.5 * beta * norm(Lw - crossprod(sqrt(lambda) * t(U)), type="F")^2)
}


bipartite.obj_fun <- function(Aw, Lw, V, psi, K, J, nu) {
  return(bipartite.negloglikelihood(Lw = Lw, K = K, J = J) +
         bipartite.prior(nu = nu, Aw = Aw, psi = psi, V = V))
}


bipartite.negloglikelihood <- function(Lw, K, J) {
  return(sum(-log(eigval_sym(Lw + J)) + c(diag(K %*% Lw))))
}


bipartite.prior <- function(nu, Aw, psi, V) {
  return(.5 * nu * norm(Aw - V %*% diag(psi) %*% t(V), type="F")^2)
}


joint.obj_fun <- function(Lw, Aw, U, V, lambda, psi, beta, nu, K) {
  return(joint.negloglikelihood(Lw = Lw, lambda = lambda, K = K) +
         joint.prior(beta = beta, nu = nu, Lw = Lw, Aw = Aw, U = U, V = V,
                     lambda = lambda, psi = psi))
}


joint.negloglikelihood <- function(...) {
  return(laplacian.negloglikelihood(...))
}


joint.prior <- function(beta, nu, Lw, Aw, U, V, lambda, psi) {
  return(laplacian.prior(beta = beta, Lw = Lw, lambda = lambda, U = U) +
         bipartite.prior(nu = nu, Aw = Aw, psi = psi, V = V))
}

vanilla.objective <- function(Theta, K) {
  p <- nrow(Theta)
  return(sum(diag(Theta %*% K)) - sum(log(eigval_sym(Theta)[2:p])))
}
