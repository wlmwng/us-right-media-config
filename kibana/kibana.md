# Kibana Visualizations and Dashboards

Use Kibana's Dev Tools to send HTTP requests to Elasticsearch.

## Add Saved Objects from 'production' version of the project
- "Management" -> "Kibana: Saved Objects" -> "Import"
- Import `export_from_tux02ascor.json`

## Mapping

### Setup mapping if no `inca_alias` index has been created yet (INCA scraping has not started)
1. Copy-paste the HTTP request in `inca_index_and_mapping.txt` into Dev Tools
2. Add the alias
```
POST _aliases
{
    "actions": [
        {
            "add": {
                "index": "inca",
                "alias": "inca_alias"
            }
        }
    ]
}
```
3. When INCA starts adding documents, it should be sending them to `inca_alias`, which then points to the actual index called `inca`.

### Fix mapping if `inca_alias` index already exists (INCA scraping already started)

The project version of INCA connects automatically to `inca_alias`. When scraping has already started, documents are added directly to an *index* called `inca_alias` (rather than to an actual alias). The Kibana dashboard, "US Right Media (URLs)", refers to `inca_alias` as well.

To make `inca_alias` become an actual alias rather than an index:
1. Stop scraping
2. Copy-paste the HTTP request in `inca_index_and_mapping.txt` into Dev Tools
3. Re-index the old `inca_alias` index into the new `inca` index

```
POST _reindex
{
    "source": {
        "index": "inca_alias"
    },
    "dest": {
        "index": "inca"
    }
}
```
4. delete the existing `inca_alias` index
```
DELETE /inca_alias
```
5.  and correctly add the alias as an alternative way to reference the `inca` index
```
POST _aliases
{
    "actions": [
        {
            "add": {
                "index": "inca",
                "alias": "inca_alias"
            }
        }
    ]
}
```

- By having INCA and Kibana outputs refer to the alias, re-mapping is more streamlined moving forward. A re-index can happen 'behind-the-scenes' without disturbing the ongoing scraping process. Once the new index is ready, the alias can be updated to point to the new index.

## Fix dashboard error
- To fix this error,
```
Request to Elasticsearch failed:

{
    "error": {
        "root_cause": [
            {
                "type": "illegal_argument_exception",
                "reason": "Trying to retrieve too many docvalue_fields. Must be less than or equal to: [100] but was [134]. This limit can be set by changing the [index.max_docvalue_fields_search] index level setting."
            }
        ]

        ...
    }
}

```

- enter this PUT request into Dev Tools
```
PUT /inca_alias/_settings
{
    "index.max_docvalue_fields_search": 200
}
```


## Fix timezone display

Kibana defaults to using the browser's timezone. Change it to `UTC`.
- "Management" -> "Advanced Settings" -> "Timezone for date formatting"
- select "UTC"