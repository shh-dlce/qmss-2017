
# Data curation with git and GitHub

We already learned about the advantages of using git and GitHub to collaborate on research projects.
A special kind of research project is the curation of a dataset. For research data to be amenable for
curation via git means:

- it should consist of a collection of text files
- individual text files should not be too big, and have a line-based format

It turns out that quite a few datasets important to us can be modelled in this way, and CSV - everyone's 
favorite format for tabular data - is gaining popularity every day:

- Glottolog:
  - Bibliographic information is stored as set of BibTeX files
  - Language information is stored as one INI file per language
  - directory tree models the language classification

- D-PLACE
- Concepticon
- Gelato

For relational data, though, this approach sacrifices a built-in mechanism to enforce referential integrity
(which relational databases provide - see https://github.com/shh-dlce/qmss-2016/blob/master/masterclass/data-curation-sql.pdf). But this can be alleviated using scripts to check data consistency
(and using the GitHub platform these checks could be run automatically).

See also https://github.com/clld/lanclid2/blob/master/presentations/forkel.pdf

## Example: D-PLACE

- fork the repository
- clone your fork on your machine
- navigate the data in your file-system


## Collaboration

- edit data in fork
- commit and push
- create pull request

## Example: Glottolog

- changing a language name


## Adding an API to the data

If we already have scripts to check consistency of the data, it is only one more step to turn these
scripts into a full-fledged API to the data, i.e. provide programmatic access to the data.

### Example: Glottolog

Mapping ISO 639-3 codes to Glottocodes


## Using the API to build a CLI

...


## Using the API to feed a web application

...


## Using the API as stable interface when moving the backend

Caveat: While the API is certainly the right thing to keep stable, losing direct access to the data files
may be a problem.



## Summary

It's still early days for this model of data curation, but given its potential for collaborative enhancement
of both data and API, we want to make it known to the people who could make use of the data as well as contribute
to the curation.
