#!/usr/bin/env ruby

excluded = ["../*/OTOLookupActionResponse.swift","../*/OTOActionResponse.swift","../*/OTOReorderResponse.swift","../*/OTOSafetyCheckResponse.swift"]

`jazzy --podspec ../OTOnexus.podspec \
  --output ../docs \
  --clean \
  --config ../OTOnexus/.jazzy.yaml \
  --theme fullwidth`
