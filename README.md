![aji](https://raw.githubusercontent.com/aco/aji/master/demo.png)

A pet project app which parsed out recipes from a given page, written over lockdown and published on the App Store in 2020. It relied on the Open Graph protocol and, where unavailable, would look to a list of supported sites with parsing instructions for each part of a recipe. The key feature of aji was its ability to tag an ingredient (e.g., 1 tbsp of syrup) and scale it to the recipe as the user adjusts portion/serving size.

It accomplishes this by injecting JS into a UIWebView, hidden from the user, which can better interpret, traverse, and parse the DOM better than any native Swift equivalent. The ingredients of the recipe are passed to an on-edge NLTagger, from MLKit, trained on the [NYT ingredient phase tagger](https://github.com/nytimes/ingredient-phrase-tagger) dataset. To scale, we take what quantified ingredients we have and adjust accordingly.

Otherwise, it's a standard app using messaging/pub/sub to communicate data, De/codable for serialization, designed with UIKit and pure layout constraints.

## Installation

Clone the project and ```pod install```. As part of the theming, we must make the ```rootContentStack```, within the Tabman pod, public as opposed to internal. Xcode will identify this line when you attempt to build. Simply unlock the file and make the change.

## License

GNU GPL v3
