ruby extconf.rb
make
mv bayesian_learn.bundle ../../lib/bayesian_learn
mv bayesian_learn.o ../../lib/bayesian_learn
rm Makefile
cd ../.. && autotest
