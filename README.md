# OJS Article Importer Plugin
Plugin to import A++ and JATS articles into OJS 3.2.1 or newer

## Requirements

### Import Files
To get started you will need to request an export archive of your journal article metadata (metadata.xml) and galley files (fulltext.pdf) for all published articles.
The plugin supports the following XML document types:
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
- `xml/vol#/iss#/#`

where:
- `xml` is the parent folder for all the exported articles,
- `vol#` is the volume number folder that contains all issues for the volume
- `iss#` is the issue number folder that contains all articles for the issue
- `#` is the article # folder that contains the article metadata.xml and fulltext.pdf files

All `#` designations will be treated as numeric values; e.g. 'no.01-02' will be interpreted as "1".

The article folder must have only one XML file, with the extension of `.xml` or `.meta`, and only one fulltext PDF file, with the extension of `.pdf`.

If importing JATS, the original metadata XML will be added as a production ready file.  Dependent files as named in the XML (via `asset` or `graphic` elements) will be appended, if the files are found in the article folder.

Example structure:
```tree-view
xml/
 ├── vol1/
 │    ├── i1/
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
 │    ├── i2/
 │    │   ├── 10/
 │    │   │   ├── 10.meta
 │    │   │   └── 10.pdf
 │    │   └── 15/
 │    │       ├── metadata.xml
 │    │       └── fulltext.pdf
 │    └── ...
 └── vol2/
      ├── i1/
      │   ├── cover.jpg
      │   ├── 1/
      │   │   ├── metadata.xml
      │   │   └── fulltext.pdf
      │   └── ...
      └── ...
```

### Plugin installation
This plugin will need to be installed in your **OJS 3.2.1 or newer** installation:
- Ensure that the plugin branch/version matches your version of OJS
- The destination folder for the plugin should be `plugins/importexport/articleImporter`

For example, to install this plugin via git for OJS 3.2.1:
- `cd /path/to/ojs`
- `git clone https://github.com/jonasraoni/article-importer-plugin.git plugins/importexport/articleImporter`
- `cd plugins/importexport/articleImporter`
- `git checkout -b stable-3_2_1 origin/stable-3_2_1`
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

where:

- `journal`: the journal into which the articles should be imported (use the OJS journal path)
- `username`: the user to whom imported articles should be assigned; note: this user must have the Author role
- `editorUsername`: the editor to whom imported articles should be assigned; note: this user must have the Journal Editor role and access to the Production stage
- `defaultEmail`: assigned to article metadata when author email not provided in import XML
- `importPath`: full filepath to import files (e.g. /home/user/articleImporter_xml/journalName)

## Limitations

Due to limitations with exported XML metadata, the plugin imports published articles in sequential order. Imported articles may need to be further sorted in their respective issue’s table of contents in OJS. In addition, while the plugin attempts to preserve issue sections, some section names and assignments may need correction following the import process.

The plugin does not import the following journal content, which can be uploaded following the import:
- Article supplementary files
- Issue cover images

Please note the import plugin is intended for journal content only and does not support the migration of other formats.

## Bugs and Enhancements

We welcome bug reports and fixes via github Issues for this project. Feature enhancements may also be contributed via pull requests for inclusion into the repository.
