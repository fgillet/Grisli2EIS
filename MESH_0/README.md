# Mesh

## Introduction



## Methods


```bash
export SRC_DIR=..
source ${SRC_DIR}/src/MeshFunctions.sh
```

![](../images//BarentsKara.png "Barents Kara Ice-Sheet mask and Contour")

```bash
GRISLI="${SRC_DIR}/DATA/LGM-IPSL-abs_euras20-pourElmer.nc"
MaskVal=1

ExtractPolygon
```

```bash
Contour2geo=${ELMER_SRC}/elmerice/Meshers/GIS/Contour2geo.py
resolution=500.0
ShpToGeo
```


