# Importing CSV

Now we insert the data into a relational database for further analysis.

Note: An sqlite database file pre-loaded with the datasets is available as `qmss.sqlite`
in [this repository](data/).


## Using the `sqlite` cli

```
sqlite> create table languoids (
	glottocode VARCHAR(8) NOT NULL, 
	name VARCHAR(58), 
	isocodes VARCHAR(4), 
	level VARCHAR(8) NOT NULL, 
	macroarea VARCHAR(13), 
	latitude FLOAT, 
	longitude FLOAT
);
sqlite> .mode csv
sqlite> .import data/languages-and-dialects-geo.csv languoids
```

## Using csvkit

Importing CSV data into a relational database using csvkit's `csvsql` command is easy.

We can take a peek at the table csvkit is going to create, running

```bash
$ csvsql --tables languoids -q '"' data/languages-and-dialects-geo.csv
CREATE TABLE languoids (
	glottocode VARCHAR(8) NOT NULL, 
	name VARCHAR(58), 
	isocodes VARCHAR(4), 
	level VARCHAR(8) NOT NULL, 
	macroarea VARCHAR(13), 
	latitude FLOAT, 
	longitude FLOAT
);
```

and then insert the data running

```bash
$ csvsql --tables languoids --insert -q '"' --db=sqlite:///qmss.sqlite data/languages-and-dialects-geo.csv
$ csvsql --tables phonemes --insert -t --db=sqlite:///qmss.sqlite data/phoible-by-phoneme.tsv 
$ csvsql --tables precipitation --insert --db=sqlite:///qmss.sqlite data/dplace-societies-2016-4-19-clean.csv
```


## Summary

We now have an sqlite database containing three tables `languoids`, `phonemes` and `precipitation` defined as

```sql
CREATE TABLE languoids (
	glottocode VARCHAR(8) NOT NULL, 
	name VARCHAR(58), 
	isocodes VARCHAR(4), 
	level VARCHAR(8) NOT NULL, 
	macroarea VARCHAR(13), 
	latitude FLOAT, 
	longitude FLOAT
);
```

and 

```sql
CREATE TABLE phonemes (
	"LanguageCode" VARCHAR(3) NOT NULL, 
	"LanguageName" VARCHAR(79) NOT NULL, 
	"SpecificDialect" VARCHAR(51), 
	"Phoneme" VARCHAR(11) NOT NULL, 
	"Allophones" VARCHAR(34), 
	"Source" VARCHAR(6) NOT NULL, 
	"GlyphID" VARCHAR(54) NOT NULL, 
	"InventoryID" INTEGER NOT NULL, 
	tone VARCHAR(4), 
	stress VARCHAR(4), 
	syllabic VARCHAR(4), 
	short VARCHAR(4), 
	long VARCHAR(4), 
	consonantal VARCHAR(4), 
	sonorant VARCHAR(7), 
	continuant VARCHAR(5), 
	"delayedRelease" VARCHAR(4), 
	approximant VARCHAR(4), 
	tap VARCHAR(4), 
	trill VARCHAR(4), 
	nasal VARCHAR(7), 
	lateral VARCHAR(4), 
	labial VARCHAR(5), 
	round VARCHAR(4), 
	labiodental VARCHAR(4), 
	coronal VARCHAR(5), 
	anterior VARCHAR(4), 
	distributed VARCHAR(4), 
	strident VARCHAR(5), 
	dorsal VARCHAR(5), 
	high VARCHAR(5), 
	low VARCHAR(5), 
	front VARCHAR(5), 
	back VARCHAR(5), 
	tense VARCHAR(4), 
	"retractedTongueRoot" VARCHAR(4), 
	"advancedTongueRoot" VARCHAR(4), 
	"periodicGlottalSource" VARCHAR(5), 
	"epilaryngealSource" VARCHAR(4), 
	"spreadGlottis" VARCHAR(4), 
	"constrictedGlottis" VARCHAR(4), 
	fortis VARCHAR(4), 
	"raisedLarynxEjective" VARCHAR(4), 
	"loweredLarynxImplosive" VARCHAR(4), 
	click VARCHAR(4)
);
```

and 

```sql
CREATE TABLE precipitation (
	"Source" VARCHAR(23) NOT NULL, 
	"Preferred_society_name" VARCHAR(38) NOT NULL, 
	"Society_id" VARCHAR(5) NOT NULL, 
	"Cross_dataset_id" VARCHAR(6) NOT NULL, 
	"Original_society_name" VARCHAR(42) NOT NULL, 
	"Revised_latitude" FLOAT NOT NULL, 
	"Revised_longitude" FLOAT NOT NULL, 
	"Original_latitude" FLOAT NOT NULL, 
	"Original_longitude" FLOAT NOT NULL, 
	glottocode VARCHAR(8), 
	"Glottolog_name" VARCHAR(43), 
	"ISO_code" VARCHAR(4), 
	"Language_family" VARCHAR(24), 
	"Precipitation" FLOAT NOT NULL, 
	"Comment_Monthly_Mean_Precipitation" VARCHAR(127)
);
```

Notes:
- Each row in the `languoids` table contains information about a different language or dialect.
- Each row in the `phonemes` table contains information about one phoneme encountered in a phoneme
  inventory associated with a language.
- Database fields are explicitly typed (as opposed to columns in CSV files).


## Next section

[Querying the database](04-querying.md)
