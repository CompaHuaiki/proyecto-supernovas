data {
	int<lower=0> N;
	int<lower=0> K;
	int<lower=0> L;
	vector[N] obsx;
	vector<lower=0>[N] errx;
	vector[N] obsy;
	vector<lower=0>[N] erry;
	array[N] int type;
}
parameters {
	matrix[K, L] beta;
	real<lower=0> sigma;
	vector[N] x;
	vector[N] y;
	real<lower=0> sig0;	
	real mu0;
}
transformed parameters {
	vector[N] mu;
	for (i in 1:N) {
	if (type[i] == 0)
		mu[i] = beta[1,1] + beta[2,1] * x[i];
	else
		mu[i] = beta[1,2] + beta[2,2] * x[i];
	}
}
model {
	mu0 ~ normal(0, 1);
	sig0 ~ normal(0, 5);
	for (i in 1:K)
	for (j in 1:L)
	  beta[i,j] ~ normal(mu0, sig0);
	obsx ~ normal(x, errx);
	x ~ normal(0, 100);
	y ~ normal(mu, sigma);
	sigma ~ gamma(0.5, 0.5);
	obsy ~ normal(y, erry);
}
