data {
  	int<lower=0> N;                    // Número de observaciones
  	int<lower=0> K;                    // Número de filas de beta
  	int<lower=0> L;                    // Número de columnas de beta
  	vector[N] obsx;                    // Observaciones en x
  	vector<lower=0>[N] errx;           // Error en x
  	vector[N] obsy;                    // Observaciones en y
  	vector<lower=0>[N] erry;           // Error en y
  	array[N] int type;                 // Tipo de supernova
}
parameters {
  	matrix[K, L] beta;                 // Coeficientes
  	real<lower=0> sigma;               // Desviación estándar del modelo
  	vector[N] x;                       // Verdaderos valores de x
  	vector[N] y;                       // Verdaderos valores de y
  	real<lower=0> sig0;                // Desviación estándar de los betas
  	real mu0;                          // Media de los betas
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
	// Priors
	mu0 ~ normal(0, 1);
	sig0 ~ normal(0, 5);
	for (i in 1:K)
	for (j in 1:L)
		beta[i, j] ~ normal(mu0, sig0);

	x ~ normal(0, 100);
	sigma ~ gamma(0.5, 0.5);

	// Likelihood
	obsx ~ normal(x, errx);
	y ~ normal(mu, sigma);
	obsy ~ normal(y, erry);
}
