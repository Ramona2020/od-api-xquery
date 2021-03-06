xquery version "3.1" encoding "UTF-8";

module namespace od-api = "od-api-basex";

(: https://github.com/AdamSteffanick/od-api-xquery :)

(:
MIT License

Copyright (c) 2017 Adam Steffanick

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
:)

(: # API 1.5.0 :)

(: # General functions :)
(: ## Create elements for optional fragment arrays :)
declare function od-api:option($fragment as item()*, $function as xs:string) as item()* {
  (: ### General arrays :)
  if ($fragment and $function = "arrayofstrings") then
    od-api:arrayofstrings($fragment)
  (: ### Dictionary arrays :)
  else if ($fragment and $function = "headwordEntry") then
    element {"results"} {
      for $result in $fragment/_
      return od-api:headwordEntry($result)
    }
  else if ($fragment and $function = "entry") then
    element {"entries"} {
      for $entry in $fragment/_
      return od-api:entry($entry)
    }
  else if ($fragment/fn:name() = "senses" or "subsenses" and $function = "sense") then
    if ($fragment/fn:name() = "senses") then
      element {"senses"} {
        for $sense in $fragment/_
        return od-api:sense($sense, "sense")
      }
    else if ($fragment/fn:name() = "subsenses") then
      element {"subsenses"} {
        for $subsense in $fragment/_
        order by $subsense/domains, $subsense/regions, $subsense/registers
        return od-api:sense($subsense, "subsense")
      }
    else ()
  else if ($fragment/fn:name() = "pronunciations" and $function = "dictionaryInlineModel1") then
    element {"pronunciations"} {
      for $pronunciation in $fragment/_
      return od-api:dictionaryInlineModel1($pronunciation, "pronunciation")
    }
  else if ($fragment/fn:name() = "pronunciations" and $function = "dictionaryInlineModel1") then
    element {"pronunciations"} {
      for $pronunciation in $fragment/_
      return od-api:dictionaryInlineModel1($pronunciation, "pronunciation")
    }
  else if ($fragment/fn:name() = "grammaticalFeatures" and $function = "dictionaryInlineModel2") then
    element {"grammaticalFeatures"} {
      for $grammaticalFeature in $fragment/_
      return od-api:dictionaryInlineModel2($grammaticalFeature, "grammaticalFeature")
    }
  else if ($fragment/fn:name() = "variantForms" and $function = "dictionaryInlineModel3") then
    element {"variantForms"} {
      for $variantForm in $fragment/_
      order by $variantForm/text
      return od-api:dictionaryInlineModel3($variantForm, "variantForm")
    }
  else if ($fragment/fn:name() = "crossReferences" and $function = "dictionaryInlineModel4") then
    element {"crossReferences"} {
      for $crossReference in $fragment/_
      return od-api:dictionaryInlineModel4($crossReference, "crossReference")
    }
  else if ($fragment/fn:name() = "examples" and $function = "dictionaryInlineModel5") then
    element {"examples"} {
      for $example in $fragment/_
      return od-api:dictionaryInlineModel5($example, "example")
    }
  else if ($fragment/fn:name() = "translations" and $function = "dictionaryInlineModel6") then
    element {"translations"} {
      for $translation in $fragment/_
      return od-api:dictionaryInlineModel6($translation, "translation")
    }
  (: ### Lemmatron arrays :)
  else if ($fragment and $function = "headwordLemmatron") then
    element {"results"} {
      for $result in $fragment/_
      return od-api:headwordLemmatron($result)
    }
  else if ($fragment/fn:name() = "grammaticalFeatures" and $function = "lemmatronInlineModel1") then
    element {"grammaticalFeatures"} {
      for $grammaticalFeature in $fragment/_
      return od-api:lemmatronInlineModel1($grammaticalFeature, "grammaticalFeature")
    }
  else if ($fragment/fn:name() = "inflectionOf" and $function = "lemmatronInlineModel2") then
    element {"inflectionOf"} {
      for $wordform in $fragment/_
      order by $wordform/text
      return od-api:lemmatronInlineModel2($wordform, "wordform")
    }
  (: ### Thesaurus arrays :)
  else if ($fragment and $function = "headwordThesaurus") then
    element {"results"} {
      for $result in $fragment/_
      return od-api:headwordThesaurus($result)
    }
  else if ($fragment and $function = "thesaurusEntry") then
    element {"entries"} {
      for $entry in $fragment/_
      return od-api:thesaurusEntry($entry)
    }
  else if ($fragment/fn:name() = "senses" or "subsenses" and $function = "thesaurusSense") then
    if ($fragment/fn:name() = "senses") then
      element {"senses"} {
        for $sense in $fragment/_
        return od-api:thesaurusSense($sense, "sense")
      }
    else if ($fragment/fn:name() = "subsenses") then
      element {"subsenses"} {
        for $subsense in $fragment/_
        order by $subsense/domains, $subsense/regions, $subsense/registers
        return od-api:thesaurusSense($subsense, "subsense")
      }
    else ()
  else if ($fragment/fn:name() = "variantForms" and $function = "thesaurusInlineModel1") then
    element {"variantForms"} {
      for $variantForm in $fragment/_
      order by $variantForm/text
      return od-api:thesaurusInlineModel1($variantForm, "variantForm")
    }
  else if ($fragment/fn:name() = "synonyms" or "antonyms" and $function = "thesaurusInlineModel2") then
      if ($fragment/fn:name() = "synonyms") then
        element {"synonyms"} {
          for $synonym in $fragment/_
          order by $synonym/text
          return od-api:thesaurusInlineModel2($synonym, "synonym")
        }
      else if ($fragment/fn:name() = "antonyms") then
        element {"antonyms"} {
          for $antonym in $fragment/_
          return od-api:thesaurusInlineModel2($antonym, "antonym")
        }
      else ()
  else if ($fragment and $function = "thesaurusInlineModel3") then
    element {"examples"} {
      for $example in $fragment/_
      return od-api:thesaurusInlineModel3($example, "example")
    }
  else if ($fragment and $function = "thesaurusInlineModel4") then
    element {"translations"} {
      for $translation in $fragment/_
      return od-api:thesaurusInlineModel4($translation, "translation")
    }
  else if ($fragment and $function = "thesaurusInlineModel5") then
    element {"grammaticalFeatures"} {
      for $grammaticalFeature in $fragment/_
      return od-api:thesaurusInlineModel5($grammaticalFeature, "grammaticalFeature")
    }
  else ()
};
(: ## Add metadata :)
declare function od-api:metadata($response as item()*) as item()* {
  let $metadata := $response/json/metadata
  let $date := $response[1]/*[fn:name()="http:header"][@name="Date"]/@value/fn:string()
  return element {"metadata"} {
    $metadata/node(),
    element {"date"} {$date}
  }
};
(: ## Create elements for string arrays :)
declare function od-api:arrayofstrings($nodes as node()*) as item()* {
  for $node in $nodes
  return typeswitch($node)
  case text() return $node
  case element(crossReferenceMarkers) return element {fn:name($node)} {
    for $n in $node/_
    return element {"crossReferenceMarker"} {od-api:arrayofstrings($n/node())}
  }
  case element(definitions) return element {fn:name($node)} {
    for $n in $node/_
    return element {"definition"} {od-api:arrayofstrings($n/node())}
  }
  case element(dialects) return element {fn:name($node)} {
    for $n in $node/_
    return element {"dialect"} {od-api:arrayofstrings($n/node())}
  }
  case element(domains) return element {fn:name($node)} {
    for $n in $node/_
    return element {"domain"} {od-api:arrayofstrings($n/node())}
  }
  case element(etymologies) return element {fn:name($node)} {
    for $n in $node/_
    return element {"etymology"} {od-api:arrayofstrings($n/node())}
  }
  case element(regions) return element {fn:name($node)} {
    for $n in $node/_
    return element {"region"} {od-api:arrayofstrings($n/node())}
  }
  case element(registers) return element {fn:name($node)} {
    for $n in $node/_
    return element {"register"} {od-api:arrayofstrings($n/node())}
  }
  case element(senseIds) return element {fn:name($node)} {
    for $n in $node/_
    return element {"senseId"} {od-api:arrayofstrings($n/node())}
  }
  default return $node
};

(: # Dictionary functions :)
(: ## Dictionary :)
declare function od-api:dictionary($source_lang as xs:string, $word-id as xs:string, $filter as xs:string, $id as xs:string, $key as xs:string) {
  let $word_id := fn:encode-for-uri(fn:lower-case(fn:translate($word-id, " ", "_")))
  let $filters :=
    if ($filter) then
      fn:concat("/", $filter)
    else ()
  let $request :=
    <http:request href="https://od-api.oxforddictionaries.com/api/v1/entries/{$source_lang}/{$word_id}{$filters}" method="get">
      <http:header name="app_key" value="{$key}"/>
      <http:header name="app_id" value="{$id}"/>
    </http:request>
  let $response := http:send-request($request)
  return
  element {"dictionary"} {
    attribute {"input"} {$word_id},
    attribute {"language"} {$source_lang},
    od-api:metadata($response),
    od-api:option($response/json/results, "headwordEntry")
  }
};
(: ## HeadwordEntry :)
declare function od-api:headwordEntry($result as node()*) as item()* {
  element {"result"} {
    $result/id,
    $result/language,
    $result/type,
    $result/word,
    od-api:option($result/pronunciations, "dictionaryInlineModel1"),
    element {"lexicalEntries"} {
      for $lexicalEntry in $result/lexicalEntries/_
      return od-api:lexicalEntry($lexicalEntry)
    }
  }
};
(: ## lexicalEntry :)
declare function od-api:lexicalEntry($lexicalEntry as node()*) as item()* {
  element {"lexicalEntry"} {
    $lexicalEntry/language,
    $lexicalEntry/lexicalCategory,
    $lexicalEntry/text,
    od-api:option($lexicalEntry/pronunciations, "dictionaryInlineModel1"),
    od-api:option($lexicalEntry/grammaticalFeatures, "dictionaryInlineModel2"),
    od-api:option($lexicalEntry/variantForms, "dictionaryInlineModel3"),
    od-api:option($lexicalEntry/entries, "entry")
  }
};
(: ## PronunciationsList :)
declare function od-api:dictionaryInlineModel1($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    $fragment/audioFile,
    od-api:option($fragment/dialects, "arrayofstrings"),
    $fragment/phoneticNotation,
    $fragment/phoneticSpelling,
    od-api:option($fragment/regions, "arrayofstrings")
  }
};
(: ## Entry :)
declare function od-api:entry($entry as node()*) as item()* {
  element {"entry"} {
    od-api:option($entry/etymologies, "arrayofstrings"),
    od-api:option($entry/grammaticalFeatures, "dictionaryInlineModel2"),
    $entry/homographNumber,
    od-api:option($entry/pronunciations, "dictionaryInlineModel1"),
    od-api:option($entry/variantForms, "dictionaryInlineModel3"),
    od-api:option($entry/senses, "sense")
  }
};
(: ## GrammaticalFeaturesList :)
declare function od-api:dictionaryInlineModel2($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    $fragment/text,
    $fragment/type
  }
};
(: ## VariantFormsList :)
declare function od-api:dictionaryInlineModel3($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/regions, "arrayofstrings"),
    $fragment/text
  }
};
(: ## Sense :)
declare function od-api:sense($sense as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($sense/crossReferenceMarkers, "arrayofstrings"),
    od-api:option($sense/crossReferences, "arrayofstrings"),
    od-api:option($sense/definitions, "arrayofstrings"),
    od-api:option($sense/domains, "arrayofstrings"),
    od-api:option($sense/examples, "dictionaryInlineModel5"),
    $sense/id,
    od-api:option($sense/pronunciations, "dictionaryInlineModel1"),
    od-api:option($sense/regions, "arrayofstrings"),
    od-api:option($sense/registers, "arrayofstrings"),
    od-api:option($sense/variantForms, "dictionaryInlineModel3"),
    od-api:option($sense/translations, "dictionaryInlineModel6"),
    od-api:option($sense/subsenses, "sense")
  }
};
(: ## CrossReferencesList :)
declare function od-api:dictionaryInlineModel4($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    $fragment/id,
    $fragment/text,
    $fragment/type
  }
};
(: ## ExamplesList :)
declare function od-api:dictionaryInlineModel5($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/definitions, "arrayofstrings"),
    od-api:option($fragment/domains, "arrayofstrings"),
    od-api:option($fragment/regions, "arrayofstrings"),
    od-api:option($fragment/registers, "arrayofstrings"),
    od-api:option($fragment/senseIds, "arrayofstrings"),
    $fragment/text,
    od-api:option($fragment/translations, "dictionaryInlineModel6")
  }
};
(: ## TranslationsList :)
declare function od-api:dictionaryInlineModel6($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/domains, "arrayofstrings"),
    od-api:option($fragment/grammaticalFeatures, "dictionaryInlineModel2"),
    $fragment/language,
    od-api:option($fragment/regions, "arrayofstrings"),
    od-api:option($fragment/registers, "arrayofstrings"),
    $fragment/text
  }
};

(: # Lemmatron functions :)
(: ## Lemmatron :)
declare function od-api:lemmatron($source_lang as xs:string, $word-id as xs:string, $filter as xs:string, $id as xs:string, $key as xs:string) {
  let $word_id := fn:encode-for-uri(fn:lower-case(fn:translate($word-id, " ", "_")))
  let $filters :=
    if ($filter) then
      fn:concat("/", $filter)
    else ()
  let $request :=
    <http:request href="https://od-api.oxforddictionaries.com/api/v1/inflections/{$source_lang}/{$word_id}{$filters}" method="get">
      <http:header name="app_key" value="{$key}"/>
      <http:header name="app_id" value="{$id}"/>
    </http:request>
  let $response := http:send-request($request)
  return
  element {"lemmatron"} {
    attribute {"input"} {$word_id},
    attribute {"language"} {$source_lang},
    od-api:metadata($response),
    od-api:option($response/json/results, "headwordLemmatron")
  }
};
(: ## HeadwordLemmatron :)
declare function od-api:headwordLemmatron($result as node()*) as item()* {
  element {"result"} {
    $result/id,
    $result/language,
    $result/type,
    $result/word,
    element {"lexicalEntries"} {
      for $lexicalEntry in $result/lexicalEntries/_
      return od-api:lemmatronLexicalEntry($lexicalEntry)
    }
  }
};
(: ## LemmatronLexicalEntry :)
declare function od-api:lemmatronLexicalEntry($lexicalEntry as node()*) as item()* {
  element {"lexicalEntry"} {
    $lexicalEntry/language,
    $lexicalEntry/lexicalCategory,
    $lexicalEntry/text,
    od-api:option($lexicalEntry/grammaticalFeatures, "lemmatronInlineModel1"),
    od-api:option($lexicalEntry/inflectionOf, "lemmatronInlineModel2")
  }
};
(: ## GrammaticalFeaturesList :)
declare function od-api:lemmatronInlineModel1($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    $fragment/text,
    $fragment/type
  }
};
(: ## InflectionsList :)
declare function od-api:lemmatronInlineModel2($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    $fragment/id,
    $fragment/text
  }
};

(: # Translation functions :)
(: ## Translation :)
declare function od-api:translation($source_lang as xs:string, $word-id as xs:string, $target_lang as xs:string, $id as xs:string, $key as xs:string) {
  let $word_id := fn:encode-for-uri(fn:lower-case(fn:translate($word-id, " ", "_")))
  let $request :=
    <http:request href="https://od-api.oxforddictionaries.com/api/v1/entries/{$source_lang}/{$word_id}/translations={$target_lang}" method="get">
      <http:header name="app_key" value="{$key}"/>
      <http:header name="app_id" value="{$id}"/>
    </http:request>
  let $response := http:send-request($request)
  return
  element {"translation"} {
    attribute {"input"} {$word_id},
    attribute {"language"} {$source_lang},
    attribute {"target-language"} {$target_lang},
    od-api:metadata($response),
    od-api:option($response/json/results, "headwordEntry")
  }
};

(: # Thesaurus functions :)
(: ## Thesaurus :)
declare function od-api:thesaurus($source_lang as xs:string, $word-id as xs:string, $operation as xs:string, $id as xs:string, $key as xs:string) {
  let $word_id := fn:encode-for-uri(fn:lower-case(fn:translate($word-id, " ", "_")))
  let $request :=
    <http:request href="https://od-api.oxforddictionaries.com/api/v1/entries/{$source_lang}/{$word_id}/{$operation}" method="get">
      <http:header name="app_key" value="{$key}"/>
      <http:header name="app_id" value="{$id}"/>
    </http:request>
  let $response := http:send-request($request)
  return
  element {"thesaurus"} {
    attribute {"input"} {$word_id},
    attribute {"language"} {$source_lang},
    od-api:metadata($response),
    od-api:option($response/json/results, "headwordThesaurus")
  }
};
(: ## HeadwordThesaurus :)
declare function od-api:headwordThesaurus($result as node()*) as item()* {
  element {"result"} {
    $result/id,
    $result/language,
    $result/type,
    $result/word,
    element {"lexicalEntries"} {
      for $lexicalEntry in $result/lexicalEntries/_
      return od-api:thesaurusLexicalEntry($lexicalEntry)
    }
  }
};
(: ## ThesaurusLexicalEntry :)
declare function od-api:thesaurusLexicalEntry($lexicalEntry as node()*) as item()* {
  element {"lexicalEntry"} {
    $lexicalEntry/language,
    $lexicalEntry/lexicalCategory,
    $lexicalEntry/text,
    od-api:option($lexicalEntry/variantForms, "thesaurusInlineModel1"),
    od-api:option($lexicalEntry/entries, "thesaurusEntry")
  }
};
(: ## ThesaurusEntry :)
declare function od-api:thesaurusEntry($entry as node()*) as item()* {
  element {"entry"} {
    $entry/homographNumber,
    od-api:option($entry/variantForms, "thesaurusInlineModel1"),
    od-api:option($entry/senses, "thesaurusSense")
  }
};
(: ## ThesaurusSense :)
declare function od-api:thesaurusSense($sense as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($sense/domains, "arrayofstrings"),
    od-api:option($sense/examples, "thesaurusInlineModel3"),
    $sense/id,
    od-api:option($sense/regions, "arrayofstrings"),
    od-api:option($sense/registers, "arrayofstrings"),
    od-api:option($sense/synonyms, "thesaurusInlineModel2"),
    od-api:option($sense/antonyms, "thesaurusInlineModel2"),
    od-api:option($sense/subsenses, "thesaurusSense")
  }
};
(: ## VariantFormsList :)
declare function od-api:thesaurusInlineModel1($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/regions, "arrayofstrings"),
    $fragment/text
  }
};
(: ## SynonymsAntonyms :)
declare function od-api:thesaurusInlineModel2($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/domains, "arrayofstrings"),
    $fragment/id,
    $fragment/language,
    od-api:option($fragment/regions, "arrayofstrings"),
    od-api:option($fragment/registers, "arrayofstrings"),
    $fragment/text
  }
};
(: ## ExamplesList :)
declare function od-api:thesaurusInlineModel3($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/definitions, "arrayofstrings"),
    od-api:option($fragment/domains, "arrayofstrings"),
    od-api:option($fragment/regions, "arrayofstrings"),
    od-api:option($fragment/registers, "arrayofstrings"),
    od-api:option($fragment/senseIds, "arrayofstrings"),
    $fragment/text,
    od-api:option($fragment/translations, "thesaurusInlineModel4")
  }
};
(: ## TranslationsList :)
declare function od-api:thesaurusInlineModel4($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    od-api:option($fragment/domains, "arrayofstrings"),
    od-api:option($fragment/grammaticalFeatures, "thesaurusInlineModel5"),
    $fragment/language,
    od-api:option($fragment/regions, "arrayofstrings"),
    od-api:option($fragment/registers, "arrayofstrings"),
    $fragment/text
  }
};
(: ## GrammaticalFeaturesList :)
declare function od-api:thesaurusInlineModel5($fragment as node()*, $element as xs:string) as item()* {
  element {$element} {
    $fragment/text,
    $fragment/type
  }
};