# Database Import Guide

This guide explains how to use `JatsDatabaseImporter` to import articles from a PostgreSQL database (F1000 Research schema) into OJS.

## Overview

The `JatsDatabaseImporter` class queries a PostgreSQL database and transforms the data into a format compatible with `JatsArrayImporter`, which then handles the actual import into OJS.

## Database Schema Mapping

- `f1000r_article` → OJS Submissions
- `f1000r_version` → OJS Publications  
- `f1000r_report` → OJS Reviews (not currently imported)
- `f1000r_collection` → OJS Categories
- `f1000r_upload_info` → OJS Submission Files
- `f1000r_author` + `f1000r_author_version` → OJS Authors
- `f1000r_version_author_affiliation` → Author Affiliations
- `f1000r_version_thesaurus_term` → Keywords

## Setup

1. **Configure Database Connection**

   Add a PostgreSQL connection to your Laravel `config/database.php`:

   ```php
   'postgres' => [
       'driver' => 'pgsql',
       'host' => env('F1000_DB_HOST', 'localhost'),
       'port' => env('F1000_DB_PORT', '5432'),
       'database' => env('F1000_DB_DATABASE', 'f1000'),
       'username' => env('F1000_DB_USERNAME', 'f1000'),
       'password' => env('F1000_DB_PASSWORD', ''),
       'charset' => 'utf8',
       'prefix' => '',
       'schema' => 'public',
   ],
   ```

2. **Configure File Storage Path**

   Set the environment variable for where uploaded files are stored:

   ```bash
   F1000_UPLOAD_PATH=/path/to/f1000/uploads
   ```

   Or modify the `constructFilePath()` method in `JatsDatabaseImporter` to match your file storage structure.

## Usage

### Basic Usage

```php
use APP\plugins\importexport\articleImporter\Configuration;
use APP\plugins\importexport\articleImporter\JatsDatabaseImporter;
use Illuminate\Support\Facades\DB;

// Get database connection
$connection = DB::connection('postgres');

// Create configuration
$configuration = new Configuration(
    [], // No parsers needed
    'my-journal',      // Context path
    'admin',           // Username
    'editor',          // Editor username
    'admin@example.com', // Default email
    '',                // No import path
    'Articles',        // Default section name
    true,              // Generate HTML
    false              // Use category as section
);

// Create importer
$importer = new JatsDatabaseImporter($connection, $configuration);

// Import a single article
$publication = $importer->importArticle(12345);
```

### Import All Articles

```php
// Import all articles
$publications = $importer->importAllArticles();

// Import with filters
$publications = $importer->importAllArticles([
    'status' => 'PUBLISHED'
]);
```

### Command Line Usage

Use the provided `import-from-database.php` script:

```bash
# Import a specific article
php import-from-database.php myjournal admin editor admin@example.com 12345

# Import all articles
php import-from-database.php myjournal admin editor admin@example.com --all

# Import with filters
php import-from-database.php myjournal admin editor admin@example.com --all --filter=status:PUBLISHED
```

## Data Mapping

### Article/Submission Data
- `volume` → Issue volume
- `publication_number` → Issue number
- `id` → Article identifier

### Version/Publication Data
- `title` → Publication title
- `subtitle` → Publication subtitle
- `abstract_text` → Publication abstract
- `lay_summaries` → Plain language summary
- `doi` → DOI identifier
- `published` → Publication date
- `submitted` → Submission date
- `text_license_type` → License URL mapping

### Authors
- Fetched from `f1000r_author_version` joined with `f1000r_author`
- Affiliations from `f1000r_version_author_affiliation` joined with `f1000r_affiliation`
- Credit roles from `f1000r_author_version_contributor_role`

### Keywords
- Fetched from `f1000r_version_thesaurus_term` joined with `thesaurus_term`

### Categories
- Fetched from `f1000r_collection_article` joined with `f1000r_collection`

### Files
- PDF files: `f1000r_upload_info` where `type = 'PDF'`
- HTML files: `f1000r_upload_info` where `type = 'HTML'`
- Supplementary files: `f1000r_upload_info` where `type = 'SUPPLEMENTARY'`

## Customization

### File Path Construction

Modify the `constructFilePath()` method to match your file storage structure:

```php
private function constructFilePath(string $filename, string $type): ?string
{
    // Your custom logic here
    $basePath = '/custom/path/to/files';
    return $basePath . '/' . $filename;
}
```

### Additional Data Fields

To add more fields, modify `fetchArticleData()` to include additional database queries and map them to the data array structure expected by `JatsArrayImporter`.

### License URL Mapping

Update the `getLicenseUrl()` method to add more license type mappings:

```php
private function getLicenseUrl($version): ?string
{
    $licenseMap = [
        'CC_BY' => 'https://creativecommons.org/licenses/by/4.0/',
        'YOUR_LICENSE' => 'https://your-license-url.com',
        // Add more mappings
    ];
    
    $licenseType = $version->text_license_type ?? null;
    return $licenseMap[$licenseType] ?? null;
}
```

## Error Handling

The importer includes error handling:
- Missing articles throw exceptions
- Missing files are logged but don't stop the import
- Failed imports are logged with error messages

## Performance Considerations

- The importer caches article data per request
- For bulk imports, consider processing in batches
- File existence checks are performed, so ensure files are accessible

## Troubleshooting

### Files Not Found

If files aren't being found:
1. Check `F1000_UPLOAD_PATH` environment variable
2. Verify file paths in `f1000r_upload_info.target_filename`
3. Modify `constructFilePath()` to match your storage structure

### Missing Data

If data is missing:
1. Check database relationships (JOINs may need adjustment)
2. Verify field names match your schema
3. Add null checks and default values as needed

### Import Failures

If imports fail:
1. Check OJS logs for detailed error messages
2. Verify all required Configuration parameters
3. Ensure database connection is working
4. Check that all required OJS entities exist (context, users, etc.)

