# Compute Mean Viscosity

## Introduction

From depth-averaged viscosity to use with the Elmer/Ice SSA solver from the 3D GRISLI temperature field.   
The depth-averaged viscosity is defined as $$\bar{\eta}=\dfrac{1}{H} \int_{z_b}^{z_s} (2EA)^{-1/n} dz = \int_{0}^{1} (2EA)^{-1/n} d\xsi $$ 
where:  
- $H=z_s - z_b$ is the ice thickness computed as the difference from the top and bottom surface elevations.  
- $\xsi$ is the reduced vertical coordinate $\xsi=(z - z_b) / (z_s - z_b)$
- $A(T)$ is the Glen rate factor function of the ice temperature.  
- $E$ is the Glen enhencement factor.  
- $n$ is the Glen exponent. 


## Content

- ComputeMeanViscosity.F90: fortran code required a fortran compiler with the fortran netcdf libraries.   
- Makefile : Makefile to compile ComputeMeanViscosity.F90; adapt this to your installation.  
- input.txt: typical input file.  

## Usage

1. Extract the Temperature field in the ice from GRISLI input file:

Here it corresponds to the  variable *T* in the vertical levels 1 to 21:
```bash
ncks -F -v x,y,nzzm,T -d nzzm,1,21 LGM-IPSL-abs_euras20-pourElmer.nc IceTemperature.nc
```

2. Compile the fortran code:  
 * Update the makefile with your forrtan compiler and netcdf libraries
 * do **make**

3. If required adapt the input file **input.txt**

 * Run the fortran code
 * It will produce a netcdf file with the mean viscosity $\bar{\eta}$ and the depth averaged temperature.
