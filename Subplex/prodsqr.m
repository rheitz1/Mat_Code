function answ = prodsqr (parm)

data=[200 300 400 500 600 700 800 900 1000];
prd = model(parm);
answ = sum((prd-data).^2);