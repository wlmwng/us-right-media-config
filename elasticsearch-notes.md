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

- Add a new field with `text` and `keyword` types
```
PUT /inca_alias/_mapping/doc
{
  "properties": {
    "standardized_url_2": {
      "type": "text",
      "fields": {
        "exact": {
          "type": "text",
          "analyzer": "whitespace"
        },
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

- Get min date and max date (tweets2)
```
GET /inca_alias/_search?size=0
{  "query": {
    "terms": {
      "doctype": [
       "tweets2"
      ]
    }
  },
    "aggs" : {
       "min_date": {"min": {"field": "created_at", "format": "yyyy-MM-dd"}},
       "max_date": {"max": {"field": "created_at", "format": "yyyy-MM-dd"}}
    }
}
```

- Get min date and max date (outlet documents)
```
GET /inca_alias/_search?size=0
{  "query": {
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
    "aggs" : {
       "min_date": {"min": {"field": "publish_date", "format": "yyyy-MM-dd"}},
       "max_date": {"max": {"field": "publish_date", "format": "yyyy-MM-dd"}}
    }
}
```

- Get documents which match the specified `_id` or which match one value inside a list of `_id`s
```
GET inca_alias/_search
{
  "query": {
      "term": {
        "_id": id_to_match
      }
  }
}

GET inca_alias/_search
{
  "query": {
      "terms": {
        "_id": [id_to_match_1, id_to_match_2]
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
- https://georgebridgeman.com/posts/sum-of-boolean-aggregation/
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

- count and percent of documents per outlet which are labeled as `ap_syndicated` by Media Cloud
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
        "count_ap": {
          "sum": {
            "field": "ap_syndicated"
          }
        },
        "perc_ap": {
          "bucket_script": {
            "buckets_path": {
              "ap_syndicated": "count_ap",
              "total": "_count"
            },
            "script": "(params.ap_syndicated / params.total) * 100"
          }
        }
      }
    }
  }
}
```


- count of outlet documents which were (re-)tweeted 1+ times by outlet (note: this query doesn't count the number of (re-)tweet instances)
- also shows overall min and max match count
```
GET inca_alias/_search?size=0
{
  "aggs": {
    "categories": {
      "terms": {
        "field": "doctype",
        "order": {
          "_key": "asc"
        },
        "size": 13
      }
    },
    "min_match": {
      "min": {
        "field": "tweets2_url_match_count"
      }
    },
    "max_match": {
      "max": {
        "field": "tweets2_url_match_count"
      }
    }
  },
  "query": {
    "bool": {
      "filter": [
        {
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
        {
          "term": {
            "should_include": "true"
          }
        },
        {
          "term": {
            "tweets2_url_match_ind": "true"
          }
        }
      ]
    }
  }
}
```

### search queries with selected fields

- outlet documents
```
GET inca_alias/_search
{
  "_source": [
    "_id",
    "title",
    "should_include",
    "article_maintext_4_missing", 
    "ap_syndicated",
    "fetch_error",
    "is_generic_url", 
    "article_maintext_4", 
    "url",
    "resolved_url",
    "standardized_url",
    "standardized_url_2"
  ],
  "aggs": {
    "categories": {
      "terms": {
        "field": "doctype",
        "order": { "_key": "asc" },
        "size": 13
      }
  }},
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "standardized_url.keyword": "www.washingtonexaminer.com/tag/donald-trump"
          }
        },
        {
          "term": {
            "doctype": "washingtonexaminer"
          }
        },
        {
          "term": {
            "should_include": "false"
          }
        }
      ]
    }
  }
}
```

- `tweets2_url` documents

```
GET inca_alias/_search
{
  "_source": [
    "_id",
    "title",
    "resolved_url",
    "standardized_url",
    "standardized_url_2",
    "tweets2_url_ids"
  ],
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "resolved_url.keyword":  "https://www.washingtonexaminer.com/tag/donald-trump?source=%2Ftrump-to-order-government-wide-review-of-wasteful-spending%2Farticle%2F2617196"
          }
        },
        {
          "term": {
            "doctype": "tweets2_url"
          }
        }
      ]
    }
  }
}
```
