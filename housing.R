setwd("~/Documents/PERSONAL/UNF/MCIS-DS/Modeling/Regression")
library(rstan)

file_path <- 'datasets/USA_Housing.csv'
data <- read.csv(file_path)

# Extract response variable - price

price <- data$Price
predictor_matrix <-model.matrix(~ Avg..Area.Income+ Avg..Area.House.Age + Avg..Area.Number.of.Rooms + Avg..Area.Number.of.Bedrooms+
                                  Area.Population,data = data) 


N=length(price)
K=ncol(predictor_matrix)
stan_data <- list(N=N,K=K,price=price,predictor_matrix=predictor_matrix)
model <- stan(file = 'housing.stan',data = stan_data,cores=4)

# Extract model parameters: 
beta <- extract(model)$beta
sigma <- extract(model)$sigma
price_pred <- extract(model)$price_pred
dim(beta)

#Modal Checking: 

hist(extract(model)$min_price)
abline(v=min(price),col='red')
mean(extract(model)$min_price > min(price))

hist(extract(model)$max_price)
abline(v=max(price), col='red')
mean(extract(model)$max_price > max(price))

hist(extract(model)$range_price)
abline(v=max(price)-min(price),col='red')
mean(extract(model)$range_price > (max(price)-min(price)))

hist(extract(model)$var_price)
abline(v=sd(price)^2,col='red')
mean(extract(model)$var_price > (sd(price))^2)



# Predictions: 
x = head(predictor_matrix,1)
# y = x*beta[1,] + sigma
y = rnorm(1000,x*beta,sigma)

hist(price_pred)
