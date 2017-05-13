Phylogeography Notes:
=====================

There are two major phylogeographic approaches implemented in BEAST2.

1. Discrete Phylogeography 
- reconstructing a set of 'discrete' locations (i.e. did these languages originate at location A or B or C).
- essentially equivalent to ancestral state estimation where the state is a region.
- you will need a location for each of your taxa.
- Tutorial: https://github.com/BEAST2-Dev/beast-classic/releases/download/v1.3.0/ARv2.4.1.pdf

2. Diffusion on a sphere:
- essentially location is a pair of traits (latitude, longitude) that BEAST2 tries to reconstruct.
- implemented in BEAST2 package GEO_SPHERE
- you need a latitude/longitude for each of your taxa.
- Tutorial: https://github.com/BEAST2-Dev/beast-geo/releases/download/v0.0.6/phylogeography_s.v0.1.1.pdf
- Can be extended to sample tip locations -- you will need a [KML](https://en.wikipedia.org/wiki/Keyhole_Markup_Language) file describing your taxa regions.

Note this is a very active field at the moment and there is a lot of work being done on "landscape aware" methods.


Visualising the Results
-----------------------

If you just want to see what your tree looks like on a map, then:

* Rod Page's [GeoJSON-Phylogeny](https://github.com/rdmpage/geojson-phylogeny)
* R/Phytools [phylo.to.map function](http://blog.phytools.org/2013/07/new-phytools-version-with-some.html)

More powerful/complicated phylogeographic visualisation tools:

* Beast2's GEO_SPHERE package comes with `HeatMapMaker` to visualise HPD regions.
* Spread (https://github.com/phylogeography/SPREAD) -- older, more stable.
* SpreaD3 (https://github.com/phylogeography/SpreaD3) -- newer, more features.
* Phylowood (https://mlandis.github.io/phylowood/)
