# Grisli2EIS

## Table of Contents

<!-- vim-markdown-toc GFM -->

* [Introduction](#introduction)
* [Contents](#contents)

<!-- vim-markdown-toc -->

## Introduction

Contains codes and configuration files to transfer model results from GRISLI
[(the GRenoble Ice Sheet and Land Ice model)](https://gmd.copernicus.org/articles/11/5003/2018/) to [Elmer/Ice](http://elmerice.elmerfem.org/).

## Contents

* [Codes](./src): Usefull source codes
* [MESH_0](./MESH_0): Create initial Elmer mesh from GRISLI ice-sheet mask  
* [AverageViscosity](./AverageViscosity): Compute the depth-averaged viscosity to use with the Elemer/Ice [SSA Solver](http://elmerfem.org/elmerice/wiki/doku.php?id=solvers:ssa)
* [SSA_0](./SSA_0): Control simulation using input parameters from GRISLI  



