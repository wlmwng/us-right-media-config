## Kibana: transfer from dev to prod version
- backup the data volume after Media Cloud URLs are done scraping
- transfer ES mapping from dev to prod

1) Stop the Elasticsearch container before backup

```
docker stop elasticsearch-wailam
```

2) Backup the data before re-index

```
docker run --rm --volumes-from elasticsearch-wailam -v /home/wailam/volumes_backup:/backup ubuntu tar cvzf /backup/esdata-wailam-20211210-finished-mc-scrape.tar.gz /usr/share/elasticsearch/data
```

3) Start up the container again

```
docker start elasticsearch-wailam
```

4) use Kibana's Dev Tools to add new index (inca2) with mapping from dev version

  ```
  PUT /inca2
  {
    "settings": {
      "index.mapping.total_fields.limit": 20000
    },
    "mappings": {
      "doc": {
        "dynamic_templates": [
          {
            "id": {
              "match": "id",
              "match_mapping_type": "string",
              "mapping": {
                "type": "keyword"
              }
            }
          },
          {
            "es": {
              "match": "*_es",
              "match_mapping_type": "string",
              "mapping": {
                "analyzer": "spanish",
                "type": "text"
              }
            }
          },
          {
            "nl": {
              "match": "*_nl",
              "match_mapping_type": "string",
              "mapping": {
                "analyzer": "dutch",
                "type": "text"
              }
            }
          },
          {
            "raw": {
              "match": "*_raw",
              "match_mapping_type": "string",
              "mapping": {
                "type": "text"
              }
            }
          },
          {
            "en": {
              "match": "*_en",
              "match_mapping_type": "string",
              "mapping": {
                "analyzer": "english",
                "type": "text"
              }
            }
          },
          {
            "default": {
              "match": "*",
              "match_mapping_type": "string",
              "mapping": {
                "fields": {
                  "exact": {
                    "analyzer": "whitespace",
                    "type": "text"
                  }
                },
                "filter": [
                  "stop"
                ],
                "type": "text"
              }
            }
          }
        ],
        "properties": {
          "FETCH_AT": {
            "type": "date"
          },
          "FETCH_FUNCTION": {
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
          },
          "META": {
            "properties": {
              "ADDED": {
                "type": "date"
              },
              "FETCH_AT": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "FETCH_FUNCTION": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "PROJECT": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "RETRIEVAL_MSG": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "TIME_TAKEN": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "__twarc": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "_id": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "alt_url": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "ap_syndicated": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "article_maintext": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "article_maintext_is_empty": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "attachments": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "author": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "author_id": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "byline": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "context_annotations": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "conversation_id": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "created_at": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "display_url": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "float"
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "doctype": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "entities": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "expanded_url": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "float"
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "feedurl": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "fetch_error": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "geo": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "htmlsource": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "id": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "image": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "in_reply_to_user": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "in_reply_to_user_id": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "is_generic_url": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "lang": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "most_unrolled_field": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "float"
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "most_unrolled_url": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "float"
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "original_url": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "outlet": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "possibly_sensitive": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "public_metrics": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "publish_date": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "referenced_tweets": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "reply_settings": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "resolved_domain": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "resolved_netloc": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "resolved_text": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "resolved_url": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "response_code": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "response_reason": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "retrieval_error_msg": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "selected_url": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "float"
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "source": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "standardized_domain": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "float"
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "standardized_netloc": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "float"
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "standardized_url": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "standardized_url_is_generic": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "float"
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "teaser_rss": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "text": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "themes": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "title": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "title_rss": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "tweet_id": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "float"
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "tweet_url": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "float"
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "unwound_url": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "float"
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "url": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "url_id": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "urlexpander_error": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "float"
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "username": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "float"
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              },
              "withheld": {
                "properties": {
                  "ADDED_AT": {
                    "type": "date"
                  },
                  "ADDED_METHOD": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "ADDED_USING": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_ARGUMENTS": {
                    "type": "object"
                  },
                  "FUNCTION_TYPE": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "FUNCTION_VERSION_DATE": {
                    "type": "date"
                  }
                }
              }
            }
          },
          "PROJECT": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "RETRIEVAL_MSG": {
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
          },
          "TIME_TAKEN": {
            "type": "float"
          },
          "__twarc": {
            "properties": {
              "retrieved_at": {
                "type": "date"
              },
              "url": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "version": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              }
            }
          },
          "alt_url": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "ap_syndicated": {
            "type": "boolean"
          },
          "article_maintext": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "article_maintext_0": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "article_maintext_1": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "article_maintext_2": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "article_maintext_3": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "article_maintext_4": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "article_maintext_4_is_empty": {
            "type": "boolean"
          },
          "article_maintext_4_is_generic_dupe": {
            "type": "boolean"
          },
          "article_maintext_4_is_misc_dupe": {
            "type": "boolean"
          },
          "article_maintext_4_is_valid_dupe": {
            "type": "boolean"
          },
          "article_maintext_4_missing": {
            "type": "boolean"
          },
          "article_maintext_is_empty": {
            "type": "boolean"
          },
          "attachments": {
            "properties": {
              "media": {
                "properties": {
                  "alt_text": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "duration_ms": {
                    "type": "long"
                  },
                  "height": {
                    "type": "long"
                  },
                  "media_key": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "preview_image_url": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "public_metrics": {
                    "properties": {
                      "view_count": {
                        "type": "long"
                      }
                    }
                  },
                  "type": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "url": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "width": {
                    "type": "long"
                  }
                }
              },
              "media_keys": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "poll": {
                "properties": {
                  "duration_minutes": {
                    "type": "long"
                  },
                  "end_datetime": {
                    "type": "date"
                  },
                  "id": {
                    "type": "keyword"
                  },
                  "options": {
                    "properties": {
                      "label": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "position": {
                        "type": "long"
                      },
                      "votes": {
                        "type": "long"
                      }
                    }
                  },
                  "voting_status": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  }
                }
              },
              "poll_ids": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              }
            }
          },
          "author": {
            "properties": {
              "created_at": {
                "type": "date"
              },
              "description": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "entities": {
                "properties": {
                  "description": {
                    "properties": {
                      "hashtags": {
                        "properties": {
                          "end": {
                            "type": "long"
                          },
                          "start": {
                            "type": "long"
                          },
                          "tag": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      },
                      "mentions": {
                        "properties": {
                          "end": {
                            "type": "long"
                          },
                          "start": {
                            "type": "long"
                          },
                          "username": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      },
                      "urls": {
                        "properties": {
                          "display_url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "end": {
                            "type": "long"
                          },
                          "expanded_url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "start": {
                            "type": "long"
                          },
                          "url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      }
                    }
                  },
                  "url": {
                    "properties": {
                      "urls": {
                        "properties": {
                          "display_url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "end": {
                            "type": "long"
                          },
                          "expanded_url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "start": {
                            "type": "long"
                          },
                          "url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              },
              "id": {
                "type": "keyword"
              },
              "location": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "name": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "pinned_tweet_id": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "profile_image_url": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "protected": {
                "type": "boolean"
              },
              "public_metrics": {
                "properties": {
                  "followers_count": {
                    "type": "long"
                  },
                  "following_count": {
                    "type": "long"
                  },
                  "listed_count": {
                    "type": "long"
                  },
                  "tweet_count": {
                    "type": "long"
                  }
                }
              },
              "url": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "username": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "verified": {
                "type": "boolean"
              }
            }
          },
          "author_id": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "byline": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "context_annotations": {
            "properties": {
              "domain": {
                "properties": {
                  "description": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "id": {
                    "type": "keyword"
                  },
                  "name": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  }
                }
              },
              "entity": {
                "properties": {
                  "description": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "id": {
                    "type": "keyword"
                  },
                  "name": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  }
                }
              }
            }
          },
          "conversation_id": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "created_at": {
            "type": "date"
          },
          "display_url": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "doctype": {
            "type": "keyword"
          },
          "entities": {
            "properties": {
              "annotations": {
                "properties": {
                  "end": {
                    "type": "long"
                  },
                  "normalized_text": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "probability": {
                    "type": "float"
                  },
                  "start": {
                    "type": "long"
                  },
                  "type": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  }
                }
              },
              "cashtags": {
                "properties": {
                  "end": {
                    "type": "long"
                  },
                  "start": {
                    "type": "long"
                  },
                  "tag": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  }
                }
              },
              "hashtags": {
                "properties": {
                  "end": {
                    "type": "long"
                  },
                  "start": {
                    "type": "long"
                  },
                  "tag": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  }
                }
              },
              "mentions": {
                "properties": {
                  "created_at": {
                    "type": "date"
                  },
                  "description": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "end": {
                    "type": "long"
                  },
                  "entities": {
                    "properties": {
                      "description": {
                        "properties": {
                          "cashtags": {
                            "properties": {
                              "end": {
                                "type": "long"
                              },
                              "start": {
                                "type": "long"
                              },
                              "tag": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          },
                          "hashtags": {
                            "properties": {
                              "end": {
                                "type": "long"
                              },
                              "start": {
                                "type": "long"
                              },
                              "tag": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          },
                          "mentions": {
                            "properties": {
                              "end": {
                                "type": "long"
                              },
                              "start": {
                                "type": "long"
                              },
                              "username": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          },
                          "urls": {
                            "properties": {
                              "display_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "end": {
                                "type": "long"
                              },
                              "expanded_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "start": {
                                "type": "long"
                              },
                              "url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          }
                        }
                      },
                      "url": {
                        "properties": {
                          "urls": {
                            "properties": {
                              "display_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "end": {
                                "type": "long"
                              },
                              "expanded_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "start": {
                                "type": "long"
                              },
                              "url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  },
                  "id": {
                    "type": "keyword"
                  },
                  "location": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "name": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "pinned_tweet_id": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "profile_image_url": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "protected": {
                    "type": "boolean"
                  },
                  "public_metrics": {
                    "properties": {
                      "followers_count": {
                        "type": "long"
                      },
                      "following_count": {
                        "type": "long"
                      },
                      "listed_count": {
                        "type": "long"
                      },
                      "tweet_count": {
                        "type": "long"
                      }
                    }
                  },
                  "start": {
                    "type": "long"
                  },
                  "url": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "username": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "verified": {
                    "type": "boolean"
                  },
                  "withheld": {
                    "properties": {
                      "country_codes": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      }
                    }
                  }
                }
              },
              "urls": {
                "properties": {
                  "description": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "display_url": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "end": {
                    "type": "long"
                  },
                  "expanded_url": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "images": {
                    "properties": {
                      "height": {
                        "type": "long"
                      },
                      "url": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "width": {
                        "type": "long"
                      }
                    }
                  },
                  "start": {
                    "type": "long"
                  },
                  "status": {
                    "type": "long"
                  },
                  "title": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "unwound_url": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "url": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  }
                }
              }
            }
          },
          "expanded_url": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "feedurl": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "fetch_error": {
            "type": "boolean"
          },
          "functiontype": {
            "type": "keyword"
          },
          "geo": {
            "properties": {
              "coordinates": {
                "properties": {
                  "coordinates": {
                    "type": "float"
                  },
                  "type": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  }
                }
              },
              "country": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "country_code": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "full_name": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "geo": {
                "properties": {
                  "bbox": {
                    "type": "float"
                  },
                  "properties": {
                    "type": "object"
                  },
                  "type": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  }
                }
              },
              "id": {
                "type": "keyword"
              },
              "name": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "place_id": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "place_type": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              }
            }
          },
          "htmlsource": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "id": {
            "type": "keyword"
          },
          "image": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "in_reply_to_user": {
            "properties": {
              "created_at": {
                "type": "date"
              },
              "description": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "entities": {
                "properties": {
                  "description": {
                    "properties": {
                      "cashtags": {
                        "properties": {
                          "end": {
                            "type": "long"
                          },
                          "start": {
                            "type": "long"
                          },
                          "tag": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      },
                      "hashtags": {
                        "properties": {
                          "end": {
                            "type": "long"
                          },
                          "start": {
                            "type": "long"
                          },
                          "tag": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      },
                      "mentions": {
                        "properties": {
                          "end": {
                            "type": "long"
                          },
                          "start": {
                            "type": "long"
                          },
                          "username": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      },
                      "urls": {
                        "properties": {
                          "display_url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "end": {
                            "type": "long"
                          },
                          "expanded_url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "start": {
                            "type": "long"
                          },
                          "url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      }
                    }
                  },
                  "url": {
                    "properties": {
                      "urls": {
                        "properties": {
                          "display_url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "end": {
                            "type": "long"
                          },
                          "expanded_url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "start": {
                            "type": "long"
                          },
                          "url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              },
              "id": {
                "type": "keyword"
              },
              "location": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "name": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "pinned_tweet_id": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "profile_image_url": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "protected": {
                "type": "boolean"
              },
              "public_metrics": {
                "properties": {
                  "followers_count": {
                    "type": "long"
                  },
                  "following_count": {
                    "type": "long"
                  },
                  "listed_count": {
                    "type": "long"
                  },
                  "tweet_count": {
                    "type": "long"
                  }
                }
              },
              "url": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "username": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "verified": {
                "type": "boolean"
              },
              "withheld": {
                "properties": {
                  "country_codes": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  }
                }
              }
            }
          },
          "in_reply_to_user_id": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "is_generic_url": {
            "type": "boolean"
          },
          "lang": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "most_unrolled_field": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "most_unrolled_url": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "original_url": {
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
          },
          "outlet": {
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
          },
          "possibly_sensitive": {
            "type": "boolean"
          },
          "public_metrics": {
            "properties": {
              "like_count": {
                "type": "long"
              },
              "quote_count": {
                "type": "long"
              },
              "reply_count": {
                "type": "long"
              },
              "retweet_count": {
                "type": "long"
              }
            }
          },
          "publish_date": {
            "type": "date"
          },
          "referenced_tweets": {
            "properties": {
              "attachments": {
                "properties": {
                  "media": {
                    "properties": {
                      "alt_text": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "duration_ms": {
                        "type": "long"
                      },
                      "height": {
                        "type": "long"
                      },
                      "media_key": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "preview_image_url": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "public_metrics": {
                        "properties": {
                          "view_count": {
                            "type": "long"
                          }
                        }
                      },
                      "type": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "url": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "width": {
                        "type": "long"
                      }
                    }
                  },
                  "media_keys": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "poll": {
                    "properties": {
                      "duration_minutes": {
                        "type": "long"
                      },
                      "end_datetime": {
                        "type": "date"
                      },
                      "id": {
                        "type": "keyword"
                      },
                      "options": {
                        "properties": {
                          "label": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "position": {
                            "type": "long"
                          },
                          "votes": {
                            "type": "long"
                          }
                        }
                      },
                      "voting_status": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      }
                    }
                  },
                  "poll_ids": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  }
                }
              },
              "author": {
                "properties": {
                  "created_at": {
                    "type": "date"
                  },
                  "description": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "entities": {
                    "properties": {
                      "description": {
                        "properties": {
                          "cashtags": {
                            "properties": {
                              "end": {
                                "type": "long"
                              },
                              "start": {
                                "type": "long"
                              },
                              "tag": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          },
                          "hashtags": {
                            "properties": {
                              "end": {
                                "type": "long"
                              },
                              "start": {
                                "type": "long"
                              },
                              "tag": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          },
                          "mentions": {
                            "properties": {
                              "end": {
                                "type": "long"
                              },
                              "start": {
                                "type": "long"
                              },
                              "username": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          },
                          "urls": {
                            "properties": {
                              "display_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "end": {
                                "type": "long"
                              },
                              "expanded_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "start": {
                                "type": "long"
                              },
                              "url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          }
                        }
                      },
                      "url": {
                        "properties": {
                          "urls": {
                            "properties": {
                              "display_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "end": {
                                "type": "long"
                              },
                              "expanded_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "start": {
                                "type": "long"
                              },
                              "url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  },
                  "id": {
                    "type": "keyword"
                  },
                  "location": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "name": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "pinned_tweet_id": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "profile_image_url": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "protected": {
                    "type": "boolean"
                  },
                  "public_metrics": {
                    "properties": {
                      "followers_count": {
                        "type": "long"
                      },
                      "following_count": {
                        "type": "long"
                      },
                      "listed_count": {
                        "type": "long"
                      },
                      "tweet_count": {
                        "type": "long"
                      }
                    }
                  },
                  "url": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "username": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "verified": {
                    "type": "boolean"
                  },
                  "withheld": {
                    "properties": {
                      "country_codes": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      }
                    }
                  }
                }
              },
              "author_id": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "context_annotations": {
                "properties": {
                  "domain": {
                    "properties": {
                      "description": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "id": {
                        "type": "keyword"
                      },
                      "name": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      }
                    }
                  },
                  "entity": {
                    "properties": {
                      "description": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "id": {
                        "type": "keyword"
                      },
                      "name": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      }
                    }
                  }
                }
              },
              "conversation_id": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "created_at": {
                "type": "date"
              },
              "entities": {
                "properties": {
                  "annotations": {
                    "properties": {
                      "end": {
                        "type": "long"
                      },
                      "normalized_text": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "probability": {
                        "type": "float"
                      },
                      "start": {
                        "type": "long"
                      },
                      "type": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      }
                    }
                  },
                  "cashtags": {
                    "properties": {
                      "end": {
                        "type": "long"
                      },
                      "start": {
                        "type": "long"
                      },
                      "tag": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      }
                    }
                  },
                  "hashtags": {
                    "properties": {
                      "end": {
                        "type": "long"
                      },
                      "start": {
                        "type": "long"
                      },
                      "tag": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      }
                    }
                  },
                  "mentions": {
                    "properties": {
                      "created_at": {
                        "type": "date"
                      },
                      "description": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "end": {
                        "type": "long"
                      },
                      "entities": {
                        "properties": {
                          "description": {
                            "properties": {
                              "cashtags": {
                                "properties": {
                                  "end": {
                                    "type": "long"
                                  },
                                  "start": {
                                    "type": "long"
                                  },
                                  "tag": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              },
                              "hashtags": {
                                "properties": {
                                  "end": {
                                    "type": "long"
                                  },
                                  "start": {
                                    "type": "long"
                                  },
                                  "tag": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              },
                              "mentions": {
                                "properties": {
                                  "end": {
                                    "type": "long"
                                  },
                                  "start": {
                                    "type": "long"
                                  },
                                  "username": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              },
                              "urls": {
                                "properties": {
                                  "display_url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "end": {
                                    "type": "long"
                                  },
                                  "expanded_url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "start": {
                                    "type": "long"
                                  },
                                  "url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          },
                          "url": {
                            "properties": {
                              "urls": {
                                "properties": {
                                  "display_url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "end": {
                                    "type": "long"
                                  },
                                  "expanded_url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "start": {
                                    "type": "long"
                                  },
                                  "url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      },
                      "id": {
                        "type": "keyword"
                      },
                      "location": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "name": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "pinned_tweet_id": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "profile_image_url": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "protected": {
                        "type": "boolean"
                      },
                      "public_metrics": {
                        "properties": {
                          "followers_count": {
                            "type": "long"
                          },
                          "following_count": {
                            "type": "long"
                          },
                          "listed_count": {
                            "type": "long"
                          },
                          "tweet_count": {
                            "type": "long"
                          }
                        }
                      },
                      "start": {
                        "type": "long"
                      },
                      "url": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "username": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "verified": {
                        "type": "boolean"
                      },
                      "withheld": {
                        "properties": {
                          "country_codes": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      }
                    }
                  },
                  "urls": {
                    "properties": {
                      "description": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "display_url": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "end": {
                        "type": "long"
                      },
                      "expanded_url": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "images": {
                        "properties": {
                          "height": {
                            "type": "long"
                          },
                          "url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "width": {
                            "type": "long"
                          }
                        }
                      },
                      "start": {
                        "type": "long"
                      },
                      "status": {
                        "type": "long"
                      },
                      "title": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "unwound_url": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "url": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      }
                    }
                  }
                }
              },
              "geo": {
                "properties": {
                  "coordinates": {
                    "properties": {
                      "coordinates": {
                        "type": "float"
                      },
                      "type": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      }
                    }
                  },
                  "country": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "country_code": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "full_name": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "geo": {
                    "properties": {
                      "bbox": {
                        "type": "float"
                      },
                      "properties": {
                        "type": "object"
                      },
                      "type": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      }
                    }
                  },
                  "id": {
                    "type": "keyword"
                  },
                  "name": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "place_id": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "place_type": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  }
                }
              },
              "id": {
                "type": "keyword"
              },
              "in_reply_to_user": {
                "properties": {
                  "created_at": {
                    "type": "date"
                  },
                  "description": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "entities": {
                    "properties": {
                      "description": {
                        "properties": {
                          "cashtags": {
                            "properties": {
                              "end": {
                                "type": "long"
                              },
                              "start": {
                                "type": "long"
                              },
                              "tag": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          },
                          "hashtags": {
                            "properties": {
                              "end": {
                                "type": "long"
                              },
                              "start": {
                                "type": "long"
                              },
                              "tag": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          },
                          "mentions": {
                            "properties": {
                              "end": {
                                "type": "long"
                              },
                              "start": {
                                "type": "long"
                              },
                              "username": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          },
                          "urls": {
                            "properties": {
                              "display_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "end": {
                                "type": "long"
                              },
                              "expanded_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "start": {
                                "type": "long"
                              },
                              "url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          }
                        }
                      },
                      "url": {
                        "properties": {
                          "urls": {
                            "properties": {
                              "display_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "end": {
                                "type": "long"
                              },
                              "expanded_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "start": {
                                "type": "long"
                              },
                              "url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  },
                  "id": {
                    "type": "keyword"
                  },
                  "location": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "name": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "pinned_tweet_id": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "profile_image_url": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "protected": {
                    "type": "boolean"
                  },
                  "public_metrics": {
                    "properties": {
                      "followers_count": {
                        "type": "long"
                      },
                      "following_count": {
                        "type": "long"
                      },
                      "listed_count": {
                        "type": "long"
                      },
                      "tweet_count": {
                        "type": "long"
                      }
                    }
                  },
                  "url": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "username": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "verified": {
                    "type": "boolean"
                  },
                  "withheld": {
                    "properties": {
                      "country_codes": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      }
                    }
                  }
                }
              },
              "in_reply_to_user_id": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "lang": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "possibly_sensitive": {
                "type": "boolean"
              },
              "public_metrics": {
                "properties": {
                  "like_count": {
                    "type": "long"
                  },
                  "quote_count": {
                    "type": "long"
                  },
                  "reply_count": {
                    "type": "long"
                  },
                  "retweet_count": {
                    "type": "long"
                  }
                }
              },
              "referenced_tweets": {
                "properties": {
                  "attachments": {
                    "properties": {
                      "media": {
                        "properties": {
                          "alt_text": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "duration_ms": {
                            "type": "long"
                          },
                          "height": {
                            "type": "long"
                          },
                          "media_key": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "preview_image_url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "public_metrics": {
                            "properties": {
                              "view_count": {
                                "type": "long"
                              }
                            }
                          },
                          "type": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "width": {
                            "type": "long"
                          }
                        }
                      },
                      "media_keys": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "poll": {
                        "properties": {
                          "duration_minutes": {
                            "type": "long"
                          },
                          "end_datetime": {
                            "type": "date"
                          },
                          "id": {
                            "type": "keyword"
                          },
                          "options": {
                            "properties": {
                              "label": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "position": {
                                "type": "long"
                              },
                              "votes": {
                                "type": "long"
                              }
                            }
                          },
                          "voting_status": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      },
                      "poll_ids": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      }
                    }
                  },
                  "author": {
                    "properties": {
                      "created_at": {
                        "type": "date"
                      },
                      "description": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "entities": {
                        "properties": {
                          "description": {
                            "properties": {
                              "hashtags": {
                                "properties": {
                                  "end": {
                                    "type": "long"
                                  },
                                  "start": {
                                    "type": "long"
                                  },
                                  "tag": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              },
                              "mentions": {
                                "properties": {
                                  "end": {
                                    "type": "long"
                                  },
                                  "start": {
                                    "type": "long"
                                  },
                                  "username": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              },
                              "urls": {
                                "properties": {
                                  "display_url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "end": {
                                    "type": "long"
                                  },
                                  "expanded_url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "start": {
                                    "type": "long"
                                  },
                                  "url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          },
                          "url": {
                            "properties": {
                              "urls": {
                                "properties": {
                                  "display_url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "end": {
                                    "type": "long"
                                  },
                                  "expanded_url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "start": {
                                    "type": "long"
                                  },
                                  "url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      },
                      "id": {
                        "type": "keyword"
                      },
                      "location": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "name": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "pinned_tweet_id": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "profile_image_url": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "protected": {
                        "type": "boolean"
                      },
                      "public_metrics": {
                        "properties": {
                          "followers_count": {
                            "type": "long"
                          },
                          "following_count": {
                            "type": "long"
                          },
                          "listed_count": {
                            "type": "long"
                          },
                          "tweet_count": {
                            "type": "long"
                          }
                        }
                      },
                      "url": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "username": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "verified": {
                        "type": "boolean"
                      }
                    }
                  },
                  "author_id": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "context_annotations": {
                    "properties": {
                      "domain": {
                        "properties": {
                          "description": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "id": {
                            "type": "keyword"
                          },
                          "name": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      },
                      "entity": {
                        "properties": {
                          "description": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "id": {
                            "type": "keyword"
                          },
                          "name": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      }
                    }
                  },
                  "conversation_id": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "created_at": {
                    "type": "date"
                  },
                  "entities": {
                    "properties": {
                      "annotations": {
                        "properties": {
                          "end": {
                            "type": "long"
                          },
                          "normalized_text": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "probability": {
                            "type": "float"
                          },
                          "start": {
                            "type": "long"
                          },
                          "type": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      },
                      "cashtags": {
                        "properties": {
                          "end": {
                            "type": "long"
                          },
                          "start": {
                            "type": "long"
                          },
                          "tag": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      },
                      "hashtags": {
                        "properties": {
                          "end": {
                            "type": "long"
                          },
                          "start": {
                            "type": "long"
                          },
                          "tag": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      },
                      "mentions": {
                        "properties": {
                          "created_at": {
                            "type": "date"
                          },
                          "description": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "end": {
                            "type": "long"
                          },
                          "entities": {
                            "properties": {
                              "description": {
                                "properties": {
                                  "cashtags": {
                                    "properties": {
                                      "end": {
                                        "type": "long"
                                      },
                                      "start": {
                                        "type": "long"
                                      },
                                      "tag": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      }
                                    }
                                  },
                                  "hashtags": {
                                    "properties": {
                                      "end": {
                                        "type": "long"
                                      },
                                      "start": {
                                        "type": "long"
                                      },
                                      "tag": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      }
                                    }
                                  },
                                  "mentions": {
                                    "properties": {
                                      "end": {
                                        "type": "long"
                                      },
                                      "start": {
                                        "type": "long"
                                      },
                                      "username": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      }
                                    }
                                  },
                                  "urls": {
                                    "properties": {
                                      "display_url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      },
                                      "end": {
                                        "type": "long"
                                      },
                                      "expanded_url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      },
                                      "start": {
                                        "type": "long"
                                      },
                                      "url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              },
                              "url": {
                                "properties": {
                                  "urls": {
                                    "properties": {
                                      "display_url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      },
                                      "end": {
                                        "type": "long"
                                      },
                                      "expanded_url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      },
                                      "start": {
                                        "type": "long"
                                      },
                                      "url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          },
                          "id": {
                            "type": "keyword"
                          },
                          "location": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "name": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "pinned_tweet_id": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "profile_image_url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "protected": {
                            "type": "boolean"
                          },
                          "public_metrics": {
                            "properties": {
                              "followers_count": {
                                "type": "long"
                              },
                              "following_count": {
                                "type": "long"
                              },
                              "listed_count": {
                                "type": "long"
                              },
                              "tweet_count": {
                                "type": "long"
                              }
                            }
                          },
                          "start": {
                            "type": "long"
                          },
                          "url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "username": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "verified": {
                            "type": "boolean"
                          }
                        }
                      },
                      "urls": {
                        "properties": {
                          "description": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "display_url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "end": {
                            "type": "long"
                          },
                          "expanded_url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "images": {
                            "properties": {
                              "height": {
                                "type": "long"
                              },
                              "url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "width": {
                                "type": "long"
                              }
                            }
                          },
                          "start": {
                            "type": "long"
                          },
                          "status": {
                            "type": "long"
                          },
                          "title": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "unwound_url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      }
                    }
                  },
                  "geo": {
                    "properties": {
                      "coordinates": {
                        "properties": {
                          "coordinates": {
                            "type": "float"
                          },
                          "type": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      },
                      "country": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "country_code": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "full_name": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "geo": {
                        "properties": {
                          "bbox": {
                            "type": "float"
                          },
                          "properties": {
                            "type": "object"
                          },
                          "type": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      },
                      "id": {
                        "type": "keyword"
                      },
                      "name": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "place_id": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "place_type": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      }
                    }
                  },
                  "id": {
                    "type": "keyword"
                  },
                  "in_reply_to_user": {
                    "properties": {
                      "created_at": {
                        "type": "date"
                      },
                      "description": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "entities": {
                        "properties": {
                          "description": {
                            "properties": {
                              "hashtags": {
                                "properties": {
                                  "end": {
                                    "type": "long"
                                  },
                                  "start": {
                                    "type": "long"
                                  },
                                  "tag": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              },
                              "mentions": {
                                "properties": {
                                  "end": {
                                    "type": "long"
                                  },
                                  "start": {
                                    "type": "long"
                                  },
                                  "username": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              },
                              "urls": {
                                "properties": {
                                  "display_url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "end": {
                                    "type": "long"
                                  },
                                  "expanded_url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "start": {
                                    "type": "long"
                                  },
                                  "url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          },
                          "url": {
                            "properties": {
                              "urls": {
                                "properties": {
                                  "display_url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "end": {
                                    "type": "long"
                                  },
                                  "expanded_url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "start": {
                                    "type": "long"
                                  },
                                  "url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      },
                      "id": {
                        "type": "keyword"
                      },
                      "location": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "name": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "pinned_tweet_id": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "profile_image_url": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "protected": {
                        "type": "boolean"
                      },
                      "public_metrics": {
                        "properties": {
                          "followers_count": {
                            "type": "long"
                          },
                          "following_count": {
                            "type": "long"
                          },
                          "listed_count": {
                            "type": "long"
                          },
                          "tweet_count": {
                            "type": "long"
                          }
                        }
                      },
                      "url": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "username": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "verified": {
                        "type": "boolean"
                      }
                    }
                  },
                  "in_reply_to_user_id": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "lang": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "possibly_sensitive": {
                    "type": "boolean"
                  },
                  "public_metrics": {
                    "properties": {
                      "like_count": {
                        "type": "long"
                      },
                      "quote_count": {
                        "type": "long"
                      },
                      "reply_count": {
                        "type": "long"
                      },
                      "retweet_count": {
                        "type": "long"
                      }
                    }
                  },
                  "referenced_tweets": {
                    "properties": {
                      "attachments": {
                        "properties": {
                          "media": {
                            "properties": {
                              "duration_ms": {
                                "type": "long"
                              },
                              "height": {
                                "type": "long"
                              },
                              "media_key": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "preview_image_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "public_metrics": {
                                "properties": {
                                  "view_count": {
                                    "type": "long"
                                  }
                                }
                              },
                              "type": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "width": {
                                "type": "long"
                              }
                            }
                          },
                          "media_keys": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      },
                      "author": {
                        "properties": {
                          "created_at": {
                            "type": "date"
                          },
                          "description": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "entities": {
                            "properties": {
                              "description": {
                                "properties": {
                                  "hashtags": {
                                    "properties": {
                                      "end": {
                                        "type": "long"
                                      },
                                      "start": {
                                        "type": "long"
                                      },
                                      "tag": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      }
                                    }
                                  },
                                  "mentions": {
                                    "properties": {
                                      "end": {
                                        "type": "long"
                                      },
                                      "start": {
                                        "type": "long"
                                      },
                                      "username": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      }
                                    }
                                  },
                                  "urls": {
                                    "properties": {
                                      "display_url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      },
                                      "end": {
                                        "type": "long"
                                      },
                                      "expanded_url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      },
                                      "start": {
                                        "type": "long"
                                      },
                                      "url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              },
                              "url": {
                                "properties": {
                                  "urls": {
                                    "properties": {
                                      "display_url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      },
                                      "end": {
                                        "type": "long"
                                      },
                                      "expanded_url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      },
                                      "start": {
                                        "type": "long"
                                      },
                                      "url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          },
                          "id": {
                            "type": "keyword"
                          },
                          "location": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "name": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "pinned_tweet_id": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "profile_image_url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "protected": {
                            "type": "boolean"
                          },
                          "public_metrics": {
                            "properties": {
                              "followers_count": {
                                "type": "long"
                              },
                              "following_count": {
                                "type": "long"
                              },
                              "listed_count": {
                                "type": "long"
                              },
                              "tweet_count": {
                                "type": "long"
                              }
                            }
                          },
                          "url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "username": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "verified": {
                            "type": "boolean"
                          }
                        }
                      },
                      "author_id": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "context_annotations": {
                        "properties": {
                          "domain": {
                            "properties": {
                              "description": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "id": {
                                "type": "keyword"
                              },
                              "name": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          },
                          "entity": {
                            "properties": {
                              "description": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "id": {
                                "type": "keyword"
                              },
                              "name": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          }
                        }
                      },
                      "conversation_id": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "created_at": {
                        "type": "date"
                      },
                      "entities": {
                        "properties": {
                          "annotations": {
                            "properties": {
                              "end": {
                                "type": "long"
                              },
                              "normalized_text": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "probability": {
                                "type": "float"
                              },
                              "start": {
                                "type": "long"
                              },
                              "type": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          },
                          "hashtags": {
                            "properties": {
                              "end": {
                                "type": "long"
                              },
                              "start": {
                                "type": "long"
                              },
                              "tag": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          },
                          "mentions": {
                            "properties": {
                              "created_at": {
                                "type": "date"
                              },
                              "description": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "end": {
                                "type": "long"
                              },
                              "entities": {
                                "properties": {
                                  "description": {
                                    "properties": {
                                      "hashtags": {
                                        "properties": {
                                          "end": {
                                            "type": "long"
                                          },
                                          "start": {
                                            "type": "long"
                                          },
                                          "tag": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          }
                                        }
                                      },
                                      "mentions": {
                                        "properties": {
                                          "end": {
                                            "type": "long"
                                          },
                                          "start": {
                                            "type": "long"
                                          },
                                          "username": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          }
                                        }
                                      },
                                      "urls": {
                                        "properties": {
                                          "display_url": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          },
                                          "end": {
                                            "type": "long"
                                          },
                                          "expanded_url": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          },
                                          "start": {
                                            "type": "long"
                                          },
                                          "url": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  },
                                  "url": {
                                    "properties": {
                                      "urls": {
                                        "properties": {
                                          "display_url": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          },
                                          "end": {
                                            "type": "long"
                                          },
                                          "expanded_url": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          },
                                          "start": {
                                            "type": "long"
                                          },
                                          "url": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              },
                              "id": {
                                "type": "keyword"
                              },
                              "location": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "name": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "pinned_tweet_id": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "profile_image_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "protected": {
                                "type": "boolean"
                              },
                              "public_metrics": {
                                "properties": {
                                  "followers_count": {
                                    "type": "long"
                                  },
                                  "following_count": {
                                    "type": "long"
                                  },
                                  "listed_count": {
                                    "type": "long"
                                  },
                                  "tweet_count": {
                                    "type": "long"
                                  }
                                }
                              },
                              "start": {
                                "type": "long"
                              },
                              "url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "username": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "verified": {
                                "type": "boolean"
                              }
                            }
                          },
                          "urls": {
                            "properties": {
                              "display_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "end": {
                                "type": "long"
                              },
                              "expanded_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "start": {
                                "type": "long"
                              },
                              "status": {
                                "type": "long"
                              },
                              "unwound_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          }
                        }
                      },
                      "geo": {
                        "properties": {
                          "coordinates": {
                            "properties": {
                              "coordinates": {
                                "type": "float"
                              },
                              "type": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          },
                          "country": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "country_code": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "full_name": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "geo": {
                            "properties": {
                              "bbox": {
                                "type": "float"
                              },
                              "properties": {
                                "type": "object"
                              },
                              "type": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          },
                          "id": {
                            "type": "keyword"
                          },
                          "name": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "place_id": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "place_type": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      },
                      "id": {
                        "type": "keyword"
                      },
                      "in_reply_to_user": {
                        "properties": {
                          "created_at": {
                            "type": "date"
                          },
                          "description": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "entities": {
                            "properties": {
                              "description": {
                                "properties": {
                                  "hashtags": {
                                    "properties": {
                                      "end": {
                                        "type": "long"
                                      },
                                      "start": {
                                        "type": "long"
                                      },
                                      "tag": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      }
                                    }
                                  },
                                  "mentions": {
                                    "properties": {
                                      "end": {
                                        "type": "long"
                                      },
                                      "start": {
                                        "type": "long"
                                      },
                                      "username": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      }
                                    }
                                  },
                                  "urls": {
                                    "properties": {
                                      "display_url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      },
                                      "end": {
                                        "type": "long"
                                      },
                                      "expanded_url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      },
                                      "start": {
                                        "type": "long"
                                      },
                                      "url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              },
                              "url": {
                                "properties": {
                                  "urls": {
                                    "properties": {
                                      "display_url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      },
                                      "end": {
                                        "type": "long"
                                      },
                                      "expanded_url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      },
                                      "start": {
                                        "type": "long"
                                      },
                                      "url": {
                                        "type": "text",
                                        "fields": {
                                          "exact": {
                                            "type": "text",
                                            "analyzer": "whitespace"
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          },
                          "id": {
                            "type": "keyword"
                          },
                          "location": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "name": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "pinned_tweet_id": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "profile_image_url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "protected": {
                            "type": "boolean"
                          },
                          "public_metrics": {
                            "properties": {
                              "followers_count": {
                                "type": "long"
                              },
                              "following_count": {
                                "type": "long"
                              },
                              "listed_count": {
                                "type": "long"
                              },
                              "tweet_count": {
                                "type": "long"
                              }
                            }
                          },
                          "url": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "username": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "verified": {
                            "type": "boolean"
                          }
                        }
                      },
                      "in_reply_to_user_id": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "lang": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "possibly_sensitive": {
                        "type": "boolean"
                      },
                      "public_metrics": {
                        "properties": {
                          "like_count": {
                            "type": "long"
                          },
                          "quote_count": {
                            "type": "long"
                          },
                          "reply_count": {
                            "type": "long"
                          },
                          "retweet_count": {
                            "type": "long"
                          }
                        }
                      },
                      "referenced_tweets": {
                        "properties": {
                          "attachments": {
                            "properties": {
                              "media": {
                                "properties": {
                                  "height": {
                                    "type": "long"
                                  },
                                  "media_key": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "type": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "width": {
                                    "type": "long"
                                  }
                                }
                              },
                              "media_keys": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          },
                          "author": {
                            "properties": {
                              "created_at": {
                                "type": "date"
                              },
                              "description": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "entities": {
                                "properties": {
                                  "description": {
                                    "properties": {
                                      "mentions": {
                                        "properties": {
                                          "end": {
                                            "type": "long"
                                          },
                                          "start": {
                                            "type": "long"
                                          },
                                          "username": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  },
                                  "url": {
                                    "properties": {
                                      "urls": {
                                        "properties": {
                                          "display_url": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          },
                                          "end": {
                                            "type": "long"
                                          },
                                          "expanded_url": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          },
                                          "start": {
                                            "type": "long"
                                          },
                                          "url": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              },
                              "id": {
                                "type": "keyword"
                              },
                              "location": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "name": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "pinned_tweet_id": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "profile_image_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "protected": {
                                "type": "boolean"
                              },
                              "public_metrics": {
                                "properties": {
                                  "followers_count": {
                                    "type": "long"
                                  },
                                  "following_count": {
                                    "type": "long"
                                  },
                                  "listed_count": {
                                    "type": "long"
                                  },
                                  "tweet_count": {
                                    "type": "long"
                                  }
                                }
                              },
                              "url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "username": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "verified": {
                                "type": "boolean"
                              }
                            }
                          },
                          "author_id": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "context_annotations": {
                            "properties": {
                              "domain": {
                                "properties": {
                                  "description": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "id": {
                                    "type": "keyword"
                                  },
                                  "name": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              },
                              "entity": {
                                "properties": {
                                  "description": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "id": {
                                    "type": "keyword"
                                  },
                                  "name": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          },
                          "conversation_id": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "created_at": {
                            "type": "date"
                          },
                          "entities": {
                            "properties": {
                              "annotations": {
                                "properties": {
                                  "end": {
                                    "type": "long"
                                  },
                                  "normalized_text": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "probability": {
                                    "type": "float"
                                  },
                                  "start": {
                                    "type": "long"
                                  },
                                  "type": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              },
                              "hashtags": {
                                "properties": {
                                  "end": {
                                    "type": "long"
                                  },
                                  "start": {
                                    "type": "long"
                                  },
                                  "tag": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              },
                              "mentions": {
                                "properties": {
                                  "created_at": {
                                    "type": "date"
                                  },
                                  "description": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "end": {
                                    "type": "long"
                                  },
                                  "entities": {
                                    "properties": {
                                      "description": {
                                        "properties": {
                                          "hashtags": {
                                            "properties": {
                                              "end": {
                                                "type": "long"
                                              },
                                              "start": {
                                                "type": "long"
                                              },
                                              "tag": {
                                                "type": "text",
                                                "fields": {
                                                  "exact": {
                                                    "type": "text",
                                                    "analyzer": "whitespace"
                                                  }
                                                }
                                              }
                                            }
                                          },
                                          "urls": {
                                            "properties": {
                                              "display_url": {
                                                "type": "text",
                                                "fields": {
                                                  "exact": {
                                                    "type": "text",
                                                    "analyzer": "whitespace"
                                                  }
                                                }
                                              },
                                              "end": {
                                                "type": "long"
                                              },
                                              "expanded_url": {
                                                "type": "text",
                                                "fields": {
                                                  "exact": {
                                                    "type": "text",
                                                    "analyzer": "whitespace"
                                                  }
                                                }
                                              },
                                              "start": {
                                                "type": "long"
                                              },
                                              "url": {
                                                "type": "text",
                                                "fields": {
                                                  "exact": {
                                                    "type": "text",
                                                    "analyzer": "whitespace"
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        }
                                      },
                                      "url": {
                                        "properties": {
                                          "urls": {
                                            "properties": {
                                              "display_url": {
                                                "type": "text",
                                                "fields": {
                                                  "exact": {
                                                    "type": "text",
                                                    "analyzer": "whitespace"
                                                  }
                                                }
                                              },
                                              "end": {
                                                "type": "long"
                                              },
                                              "expanded_url": {
                                                "type": "text",
                                                "fields": {
                                                  "exact": {
                                                    "type": "text",
                                                    "analyzer": "whitespace"
                                                  }
                                                }
                                              },
                                              "start": {
                                                "type": "long"
                                              },
                                              "url": {
                                                "type": "text",
                                                "fields": {
                                                  "exact": {
                                                    "type": "text",
                                                    "analyzer": "whitespace"
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  },
                                  "id": {
                                    "type": "keyword"
                                  },
                                  "location": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "name": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "pinned_tweet_id": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "profile_image_url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "protected": {
                                    "type": "boolean"
                                  },
                                  "public_metrics": {
                                    "properties": {
                                      "followers_count": {
                                        "type": "long"
                                      },
                                      "following_count": {
                                        "type": "long"
                                      },
                                      "listed_count": {
                                        "type": "long"
                                      },
                                      "tweet_count": {
                                        "type": "long"
                                      }
                                    }
                                  },
                                  "start": {
                                    "type": "long"
                                  },
                                  "url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "username": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "verified": {
                                    "type": "boolean"
                                  }
                                }
                              },
                              "urls": {
                                "properties": {
                                  "display_url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "end": {
                                    "type": "long"
                                  },
                                  "expanded_url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  },
                                  "start": {
                                    "type": "long"
                                  },
                                  "url": {
                                    "type": "text",
                                    "fields": {
                                      "exact": {
                                        "type": "text",
                                        "analyzer": "whitespace"
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          },
                          "id": {
                            "type": "keyword"
                          },
                          "in_reply_to_user": {
                            "properties": {
                              "created_at": {
                                "type": "date"
                              },
                              "description": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "entities": {
                                "properties": {
                                  "description": {
                                    "properties": {
                                      "hashtags": {
                                        "properties": {
                                          "end": {
                                            "type": "long"
                                          },
                                          "start": {
                                            "type": "long"
                                          },
                                          "tag": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          }
                                        }
                                      },
                                      "urls": {
                                        "properties": {
                                          "display_url": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          },
                                          "end": {
                                            "type": "long"
                                          },
                                          "expanded_url": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          },
                                          "start": {
                                            "type": "long"
                                          },
                                          "url": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  },
                                  "url": {
                                    "properties": {
                                      "urls": {
                                        "properties": {
                                          "display_url": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          },
                                          "end": {
                                            "type": "long"
                                          },
                                          "expanded_url": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          },
                                          "start": {
                                            "type": "long"
                                          },
                                          "url": {
                                            "type": "text",
                                            "fields": {
                                              "exact": {
                                                "type": "text",
                                                "analyzer": "whitespace"
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              },
                              "id": {
                                "type": "keyword"
                              },
                              "location": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "name": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "pinned_tweet_id": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "profile_image_url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "protected": {
                                "type": "boolean"
                              },
                              "public_metrics": {
                                "properties": {
                                  "followers_count": {
                                    "type": "long"
                                  },
                                  "following_count": {
                                    "type": "long"
                                  },
                                  "listed_count": {
                                    "type": "long"
                                  },
                                  "tweet_count": {
                                    "type": "long"
                                  }
                                }
                              },
                              "url": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "username": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              },
                              "verified": {
                                "type": "boolean"
                              }
                            }
                          },
                          "in_reply_to_user_id": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "lang": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "possibly_sensitive": {
                            "type": "boolean"
                          },
                          "public_metrics": {
                            "properties": {
                              "like_count": {
                                "type": "long"
                              },
                              "quote_count": {
                                "type": "long"
                              },
                              "reply_count": {
                                "type": "long"
                              },
                              "retweet_count": {
                                "type": "long"
                              }
                            }
                          },
                          "referenced_tweets": {
                            "properties": {
                              "id": {
                                "type": "keyword"
                              },
                              "type": {
                                "type": "text",
                                "fields": {
                                  "exact": {
                                    "type": "text",
                                    "analyzer": "whitespace"
                                  }
                                }
                              }
                            }
                          },
                          "reply_settings": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "source": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "text": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          },
                          "type": {
                            "type": "text",
                            "fields": {
                              "exact": {
                                "type": "text",
                                "analyzer": "whitespace"
                              }
                            }
                          }
                        }
                      },
                      "reply_settings": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "source": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "text": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      },
                      "type": {
                        "type": "text",
                        "fields": {
                          "exact": {
                            "type": "text",
                            "analyzer": "whitespace"
                          }
                        }
                      }
                    }
                  },
                  "reply_settings": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "source": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "text": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "type": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  }
                }
              },
              "reply_settings": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "source": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "text": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "type": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "withheld": {
                "properties": {
                  "copyright": {
                    "type": "boolean"
                  },
                  "country_codes": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  },
                  "scope": {
                    "type": "text",
                    "fields": {
                      "exact": {
                        "type": "text",
                        "analyzer": "whitespace"
                      }
                    }
                  }
                }
              }
            }
          },
          "reply_settings": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "resolved_domain": {
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
          },
          "resolved_netloc": {
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
          },
          "resolved_text": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "resolved_url": {
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
          },
          "response_code": {
            "type": "long"
          },
          "response_reason": {
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
          },
          "retrieval_error_msg": {
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
          },
          "selected_url": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "should_include": {
            "type": "boolean"
          },
          "softcos02_id": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "softcos03_id": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "softcos04_id": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "softcos05_id": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "softcos06_id": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "softcos07_id": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "softcos08_id": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "softcos09_id": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "source": {
            "type": "keyword"
          },
          "standardized_domain": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "standardized_netloc": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "standardized_url": {
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
          },
          "standardized_url_is_generic": {
            "type": "boolean"
          },
          "teaser_rss": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "text": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "themes": {
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
          },
          "title": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "title_rss": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "tweet_id": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "tweet_url": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "tweets2_url_ids": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "tweets2_url_match_count": {
            "type": "long"
          },
          "tweets2_url_match_ind": {
            "type": "boolean"
          },
          "unwound_url": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "url": {
            "type": "keyword"
          },
          "url_id": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "urlexpander_error": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "username": {
            "type": "text",
            "fields": {
              "exact": {
                "type": "text",
                "analyzer": "whitespace"
              }
            }
          },
          "withheld": {
            "properties": {
              "copyright": {
                "type": "boolean"
              },
              "country_codes": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              },
              "scope": {
                "type": "text",
                "fields": {
                  "exact": {
                    "type": "text",
                    "analyzer": "whitespace"
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  ```

5) Check new index and its mapping

  ```
  GET inca2/_mapping
  ```

6) reindex from inca to inca2

  ```
    POST _reindex
    {
      "source": {
          "index": "inca"
      },
      "dest": {
          "index": "inca2"
      }
    }
  ```

  - HTTP connection from Kibana to ES times out but still runs in the background:
    ```
    {
      "statusCode": 504,
      "error": "Gateway Time-out",
      "message": "Client request timeout"
    }
    ```

    - Check status
    
    ```
    GET _tasks?actions=*reindex&detailed
    GET /_cat/indices?v=true
    ```

7) switch `inca_alias` from `inca` to `inca2`

  ```
  POST _aliases
  {
      "actions": [
          {
              "remove": {
                  "index": "inca",
                  "alias": "inca_alias"
              }
          },
          {
              "add": {
                  "index": "inca2",
                  "alias": "inca_alias"
              }
          }
      ]
  }
  ```

  - Confirm that alias switch succeeded
  
  ```
  GET _cat/aliases?v=true
  ```

8) Stop the Elasticsearch container before backup (after re-index)

```
docker stop elasticsearch-wailam
```

9) Backup the data after re-index

```
docker run --rm --volumes-from elasticsearch-wailam -v /home/wailam/volumes_backup:/backup ubuntu tar cvzf /backup/esdata-wailam-20211210.tar.gz /usr/share/elasticsearch/data
```

10) Start up the container again

```
docker start elasticsearch-wailam
```
