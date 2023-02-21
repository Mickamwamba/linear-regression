
data {
  int<lower=0> N;
  int<lower=0> K;
  int<lower=0> N_test;
  vector[N] price;
  matrix[N,K] predictor_matrix;
  matrix[N_test,K] x_test;
  
  
}

parameters {
  vector[K] beta;
  real<lower=0> sigma;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  price ~ normal(predictor_matrix*beta, sigma);
}

generated quantities{
     vector[N] price_pred;
     vector[N_test] test_pred;
     real min_price;
     real max_price;
     real range_price;
     real var_price; 
     
     for(i in 1:N){
       price_pred[i] = normal_rng(predictor_matrix[i]*beta, sigma);
     }
     for(i in 1:N_test){
       test_pred[i] = normal_rng(x_test[i]*beta, sigma);
     }
     
     
     min_price = min(price_pred); 
     max_price = max(price_pred); 
     range_price = max_price - min_price; 
     var_price = sd(price_pred)^2;
     
     
}



