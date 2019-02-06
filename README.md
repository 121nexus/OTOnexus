# OTOnexus
> A Barcode Scanning SDK by [121nexus.com](https://121nexus.com)

OTOnexus is a Barcode Scanning SDK for capturing, looking up, presenting data associated with barcodes. The SDK is supported by the 121nexus Platform which allows clients to add products to the system to enable interactive experiences when end-users scan the physical product.

You will need to obtain an api-key from [121nexus.com](https://121nexus.com/next) in order to interact with the 121nexus Platform.

## Features

- [x] Scans the most widely used barcode types (including "stacked" 128Code)
- [x] Extract raw barcode data from barcodes
- [x] Autocapture scanned barcode images
- [x] GS1 UDI barcode validation 
- [x] Access FDA GUDID data directly

## Requirements

- iOS 9.0+
- Xcode 9.0+

## Installation with CocoaPods
<!---->

#### CocoaPods
OTOnexus is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'OTOnexus'
```

#### Initialization

Import OTOnexus and configure with API key and, optionally, API URL and location delegate. The API URL should be passes as the raw host string, without protocol or slashes. The API key should passed as provided by Soom (please [contact us](https://www.soom.com/contact) for a Soom Platform account and API access).
```
import OTOnexus
...
OTOnexus.configure(withApiKey: '6e9d87f2-a1f0-4b86-8bd1-01f0d4173ddf', withApiUrl: 'api.soom.com', locationDelegate: nil)
...
```

## Usage Example
To see a complete example of using the gallery, take a look at the [Example](https://github.com/121nexus/OTOnexus/tree/master/Example).

To configure the SDK in the sample project, modify ApiConfiguration.swift
```
...
struct ApiConfiguration {
static let apiKey = "<YOUR API KEY HERE>"
/// Set the sampleExperienceId to the provided value
static let sampleExperienceId = -1
}
...
```

## License
See the LICENSE file for more details.
