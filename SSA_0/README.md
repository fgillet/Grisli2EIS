# Basic Elmer/Ice set-up

## Introduction

Basic set-up for Elmer/Ice adapted from the [Greenland Elmer/Ice-Sheet set-up](http://elmerfem.org/elmerice/wiki/doku.php?id=eis:greenland)
and from the Elmer/Ice tutorial of [Petermann Glacier](https://github.com/ElmerCSC/ElmerIceCourses/tree/main/north-greenland)

## Description

See **PreProcess.sh** to initial the .sif files from the provided templates.

* INIT.sif: initialise the required variables from the GRISLI input files.  
* CTRL.sif: run a control simulation (constant forcing) for 10 years, solving the SSA for the force balance and the continuity equation for teh oce thickness.

