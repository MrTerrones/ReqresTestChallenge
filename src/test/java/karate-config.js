function fn() {
  var env = karate.env;
  karate.configure('ssl',true);
  karate.log('El ambiente donde se ejecutó es :', env);

  if (!env) {
    env = 'cert';
  }

  if (env == 'dev') {
   baseUrl = 'https://reqres.in/api';

  } else if (env == 'cert') {
    baseUrl = 'https://reqres.in/api';
  }

  var config = {
      env:env,
      baseUrl:baseUrl
    };

  // don't waste time waiting for a connection or if servers don't respond within 5 seconds
  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);

  return config;
}