# OJS Article Importer Plugin
Plugin to import A++ and JATS articles up to OJS 3.5.0

## Requirements

### Import Files
To get started you will need to request an export archive of your journal article metadata (metadata.xml) and galley files (fulltext.pdf) for all published articles.
The plugin has a generic format detection, as an example, the following XML document types are supported:
- NLM: `<!DOCTYPE article SYSTEM "-//NLM//DTD Journal Archiving with OASIS Tables v3.0 20080202//EN" "http://dtd.nlm.nih.gov/archiving/3.0/archive-oasis-article3.dtd">`
- JATS: `<!DOCTYPE article PUBLIC "-//EDP//DTD EDP Publishing JATS v1.0 20130606//EN" "JATS-edppublishing1.dtd">`
- A++: `<!DOCTYPE Publisher PUBLIC "-//Springer-Verlag//DTD A++ V2.4//EN" "http://devel.springer.de/A++/V2.4/DTD/A++V2.4.dtd">`

You will need to review your metadata XML files and ensure that all required data is included. If needed, the metadata.xml files can be edited to manually add any missing, required metadata. The following metadata fields are required:

- title
- author name and email
- publication date
- section/type
- volume/issue

Import files will need to be placed in a directory on your OJS server, using the following path convention:
- `xml/volume#/issue#/article#/version#`

Where:
- `xml` is the parent folder for all the exported articles
- `volume#` is the volume number folder that contains all issues for the volume
- `issue#` is the issue number folder that contains all articles for the issue
- `article#` is the article # folder. If the `--no-version` flag is used, then it should contain the article metadata.xml and fulltext.pdf files
- `version#` is the version # folder that contain the article metadata.xml and fulltext.pdf files

#### Optional folder levels

The `volume#`, `issue#` (number) and `version#` levels are each optional and toggled with a CLI flag. The folder structure is `[volume#/][number#/]article#[/version#]`:

- `--no-version` - the `article#` folder holds the `metadata.xml`/`fulltext.pdf` files directly; a single version is assumed. Handy for single-version articles.
- `--no-volume` - there is no `volume#` level.
- `--no-number` - there is no `issue#` (number) level.

When both `--no-volume` and `--no-number` are passed, articles are imported without an issue (continuous publishing); in that case each article's metadata XML must contain a publication date. If only one of volume/number is present, an issue is created from whatever is available.

Use `--no-issue` to force continuous publishing regardless of volume/number in folders or XML — no issues are created or assigned.

All `#` designations will be treated as numeric values; e.g. 'no.01-02' will be interpreted as "1".

The article folder must have only one XML file, with the `.xml` extension, and only one fulltext PDF file, with the `.pdf` extension.

A file named cover.tiff, cover.tif, cover.jpeg, cover.jpg or cover.png may be placed in the `issue#` folder, and will become the issue cover image if present.

When importing JATS, the original metadata XML will be added as a production ready file, and dependent files extracted from the JATS (via `asset` or `graphic` elements) will be appended to the submission if the files exist in the folder. The plugin will also generate a HTML version of the JATS file and create a galley for it, unless you opt-out.

Example structure:
```tree-view
xml/
 ├── volume1/
 │    ├── issue1/
 │    │   ├── cover.tif
 │    │   ├── 1/
 │    │   │   ├── metadata.xml
 │    │   │   ├── fulltext.pdf
 │    │   │   └── table.png
 │    │   ├── 2/
 │    │   │   ├── jats.xml
 │    │   │   └── article.pdf
 │    │   └── 3/
 │    │       ├── metadata.xml
 │    │       ├── fulltext.pdf
 │    │       └── images/
 │    │           ├── graph1.jpg
 │    │           ├── graph2.jpg
 │    │           └── graph3.jpg
 │    ├── issue2/
 │    │   ├── 10/
 │    │   │   ├── 10.meta
 │    │   │   └── 10.pdf
 │    │   └── 15/
 │    │       ├── metadata.xml
 │    │       └── fulltext.pdf
 │    └── ...
 └── volume2/
      ├── issue1/
      │   ├── cover.jpg
      │   ├── 1/
      │   │   ├── metadata.xml
      │   │   └── fulltext.pdf
      │   └── ...
      └── ...
```

### Plugin installation
This plugin will need to be installed in your OJS installation:
- Ensure that the plugin branch/version matches your version of OJS
- The destination folder for the plugin should be `plugins/importexport/articleImporter`

For example, to install this plugin via git:
- `cd /path/to/ojs`
- `git clone https://github.com/pkp/articleImporter plugins/importexport/articleImporter`
- `cd plugins/importexport/articleImporter`
- `git checkout -b stable-3_5_0 origin/stable-3_5_0`
- `cd ../../..`
- `php lib/pkp/tools/installPluginVersion.php plugins/importexport/articleImporter/version.xml`

### OJS setup
Your OJS install will also need to include the following:
- a destination journal in OJS for imported content
- an Author user that should be used as the default account for imported articles
- an Editor user that should be assigned to imported articles

## Usage

Login to your server and execute the following in your OJS source directory.

`php tools/importExport.php ArticleImporterPlugin journal username editorUsername defaultEmail importPath`

Where:

- `journal`: the journal into which the articles should be imported (use the OJS journal path)
- `username`: the user to whom imported articles should be assigned; note: this user must have the Author role
- `editorUsername`: the editor to whom imported articles should be assigned; note: this user must have the Journal Editor role and access to the Production stage
- `defaultEmail`: assigned to article metadata when author email not provided in import XML
- `importPath`: full filepath to import files (e.g. /home/user/articleImporter_xml/journalName)

If you're importing JATS content and you don't want the plugin to generate a HTML galley out of it, include the flag `--no-html`.

## Limitations

Due to limitations with exported XML metadata, the plugin imports published articles in sequential order. Imported articles may need to be further sorted in their respective issue’s table of contents in OJS. In addition, while the plugin attempts to preserve issue sections, some section names and assignments may need correction following the import process.

If no author information is contained in the metadata, the Journal's name will be used as the Author's name.

Please note the import plugin is intended for journal content only and does not support the migration of other formats.

## Bugs and Enhancements

We welcome bug reports and fixes via GitHub issues for this project. Feature enhancements may also be contributed via pull requests for inclusion into the repository.
