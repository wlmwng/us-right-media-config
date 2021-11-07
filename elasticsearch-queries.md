# Elasticsearch queries

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
