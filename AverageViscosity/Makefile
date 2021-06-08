## Adapt this to your installation
## fortran compiler
F90=gfortran
## netcdf fortran include and lib files
NETCDF_INC=-I/usr/local/include
NETCDF_LIB=-L/usr/local/lib -lnetcdf -lnetcdff

PROG=ComputeMeanViscosity

all: $(PROG)

ComputeMeanViscosity: ComputeMeanViscosity.F90
	$(F90) $(NETCDF_INC) $< -o $@ $(NETCDF_LIB)

clean :
	rm -f $(PROG)
	
