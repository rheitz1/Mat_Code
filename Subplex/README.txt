This is the MATLAB implementation of the SUBPLEX algorithm, a
generalization of the Nelder-Mead Simplex method which is well suited
for use on noisy functions with large numbers of parameters.  The
following files should be included:

README                  partitionx.m            simplex.m
about_subplex.m         partitionx_rec.m        subplex.m
do_options.m            prodsqr.m               subplex_options.m

For execution, the files README, prodsqr.m, and partitionx_rec.m are
not necessary.

	The prodsqr.m is a simple sum of squares function which is
useful for testing the subplex code.
	The partitionx_rec.m file is a recursive implementation of the
partitionx.m file.  While it is not used, it is included to improve
the clarity of the purpose of partitionx.m  It was not used to
preserve compatibility between the FORTRAN and MATLAB version.

To test this code, simply run matlab and type 

x = subplex('prodsqr',[10 10 10 10])

If all elements of x are close to zero, the routine is working
properly.
