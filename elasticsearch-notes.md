# Elasticsearch


## Manage indices
- Check mapping of index
```
GET /inca/_mapping
```

- Check settings of index
```
GET /inca_alias/_settings
```

- Check aliases
```
GET _cat/aliases?v=true
```

- Checking mapping of a specific field
```
GET /inca_alias/_mapping/doc/field/doctype
```

- Add `keyword` type to `text` field
```
GET /inca_alias/_mapping/doc/field/standardized_url_2

PUT /inca_alias/_mapping/doc
{
  "properties": {
    "standardized_url_2": {
      "type": "text",
      "fields": {
        "keyword": {
          "type": "keyword"
        }
      }
    }
  }
}
```

## Delete documents

- delete documents which have a specified doctype
```
POST /inca_alias/_delete_by_query
{
  "query": {
      "term": {
        "doctype": "tweets2_url"
      }
  }
}
```

- delete documents within a time range

```
POST /inca_alias/_delete_by_query
{
  "query": {
    "bool": {
      "filter": [
        {
          "range": {
            "FETCH_AT": {
              "gte": "now-12h",
              "lt": "now"
            }
          }
        },
        {
          "term": {
            "fetch_error": "true"
          }
        }
      ]
    }
  }
}
```

## Search queries

- Get documents which match the specified `_id`
```
GET inca_alias/_search
{
  "query": {
      "term": {
        "_id": id_to_match
      }
  }
}
```

- Get documents of specified doctypes
```
GET inca_alias/_search
{
  "query": {
    "terms": {
      "doctype": [
        "americanrenaissance",
        "breitbart",
        "dailycaller",
        "dailystormer",
        "foxnews",
        "gatewaypundit",
        "infowars",
        "newsmax",
        "oneamericanews",
        "rushlimbaugh",
        "seanhannity",
        "vdare",
        "washingtonexaminer"
      ]
    }
  }
}
```


- Examples of text pre-processing. See 01-text-processing.ipynb in [us-right-media](https://github.com/wlmwng/us-right-media) repo for pre-processing steps.

```
GET inca_alias/_search
{
  "_source": [
    "article_maintext",
    "article_maintext_0",
    "article_maintext_1",
    "article_maintext_2",
    "article_maintext_3",
    "article_maintext_4"
  ],
  "query": {
    "term": {
      "should_include": "true"
    }
  }
}
```

- Count and percent of documents per outlet which should be included for NLP tasks

```
GET inca_alias/_search
{
  "size": 0,
  "query": {
    "terms": {
      "doctype": [
        "americanrenaissance",
        "breitbart",
        "dailycaller",
        "dailystormer",
        "foxnews",
        "gatewaypundit",
        "infowars",
        "newsmax",
        "oneamericanews",
        "rushlimbaugh",
        "seanhannity",
        "vdare",
        "washingtonexaminer"
      ]
    }
  },
  "aggs": {
    "categories": {
      "terms": {
        "field": "doctype",
        "order": { "_key": "asc" },
        "size": 13
      },
      "aggs": {
        "count_should_include": {
          "sum": {
            "field": "should_include"
          }
        },
        "perc_should_include": {
          "bucket_script": {
            "buckets_path": {
              "should_include": "count_should_include",
              "total": "_count"
            },
            "script": "(params.should_include / params.total) * 100"
          }
        }
      }
    }
  }
}
```
