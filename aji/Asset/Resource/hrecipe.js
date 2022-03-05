selectRecipe = (hrecipe) => {
	if (!Array.isArray(hrecipe)) {
		return selectRecipe([hrecipe]);
	}
	
	for (let hrec of hrecipe) {
		if (hrec['@type'] == 'Recipe') {
			return hrec;
		} else if (hrec['@context'] != undefined && (hrec['@context']).endsWith('schema.org') &&
				hrec['@graph'] != undefined) {
			for (let subhrec of hrec['@graph']) {
				if (subhrec['@type'] == 'Recipe') {
					return subhrec;
				}
			}
		}
	}

	return null;
}

var currencyRegex = /\(?[$£€]\d+[.,]?\d{0,2}\)?/g;
var alternativeUnit = /\/\d+\s?.*?\s/ig;
let gUnitRegex = /.*?\d+\s?([A-Za-z]*g)(?:rams)?/ig;

const repeatingFractions = {
	[333]: '1/3',
	[666]: '2/3',
	[111]: '1/9',
	[166]: '1/6',
	[833]: '5/6'
}

function convertFromFraction(value) {
	// number comes in, for example: 1 1/3
	if (value && value.split(' ').length > 1) {
		const [whole, fraction] = value.split(' ');
		const [a, b] = fraction.split('/');
		
		const remainder = parseFloat(a) / parseFloat(b);
		const wholeAndFraction = parseInt(whole) ? parseInt(whole) + remainder : remainder;

		return keepThreeDecimals(wholeAndFraction);
	} else if (!value || value.split('-').length > 1) {
		return value;
	} else {
		const [a, b] = value.split('/');

		return b ? keepThreeDecimals(parseFloat(a) / parseFloat(b)) : a;
	}
}

function getFirstMatch(line, regex) {
	const match = line.match(regex);
	return (match && match[0]) || '';
}

const unicodeObj = {
	'½': '1/2',
	'⅓': '1/3',
	'⅔': '2/3',
	'¼': '1/4',
	'¾': '3/4',
	'⅕': '1/5',
	'⅖': '2/5',
	'⅗': '3/5',
	'⅘': '4/5',
	'⅙': '1/6',
	'⅚': '5/6',
	'⅐': '1/7',
	'⅛': '1/8',
	'⅜': '3/8',
	'⅝': '5/8',
	'⅞': '7/8',
	'⅑': '1/9',
	'⅒': '1/10'
};

function findQuantityAndConvertIfUnicode(ingredientLine) {
	const numericAndFractionRegex = /^(\d+\/\d+)|(\d+\s\d+\/\d+)|(\d+.\d+)|\d+/g;
	const numericRangeWithSpaceRegex = /^(\d+\-\d+)|^(\d+\s\-\s\d+)|^(\d+\sto\s\d+)/g; // for ex: "1 to 2" or "1 - 2"
	const unicodeFractionRegex = /\d*[^\u0000-\u007F]+/g;
	const onlyUnicodeFraction = /[^\u0000-\u007F]+/g;

	// found a unicode quantity inside our regex, for ex: '⅝'
	if (ingredientLine.match(unicodeFractionRegex)) {
		const numericPart = getFirstMatch(ingredientLine, numericAndFractionRegex);
		const unicodePart = getFirstMatch(ingredientLine, numericPart ? onlyUnicodeFraction : unicodeFractionRegex);

		// If there's a match for the unicodePart in our dictionary above
		if (unicodeObj[unicodePart]) {
			return [`${numericPart} ${unicodeObj[unicodePart]}`, ingredientLine.replace(getFirstMatch(ingredientLine, unicodeFractionRegex), '').trim()];
		}
	}

	// found a quantity range, for ex: "2 to 3"
	if (ingredientLine.match(numericRangeWithSpaceRegex)) {
		const quantity = getFirstMatch(ingredientLine, numericRangeWithSpaceRegex).replace('to', '-').split(' ').join('');
		const restOfIngredient = ingredientLine.replace(getFirstMatch(ingredientLine, numericRangeWithSpaceRegex), '').trim();
		return [ingredientLine.match(numericRangeWithSpaceRegex) && quantity, restOfIngredient];
	}

	// found a numeric/fraction quantity, for example: "1 1/3"
	else if (ingredientLine.match(numericAndFractionRegex)) {
		const quantity = getFirstMatch(ingredientLine, numericAndFractionRegex);
		const restOfIngredient = ingredientLine.replace(getFirstMatch(ingredientLine, numericAndFractionRegex), '').trim()
		return [ingredientLine.match(numericAndFractionRegex) && quantity, restOfIngredient];
	}

	// no parse-able quantity found
	else {
		return [null, ingredientLine];
	}
}

function keepThreeDecimals(val) {
	if (isNaN(val)) {
		return 0;
	}

	return parseFloat(val).toFixed(3);
}

function getUnit(input) {
	if (units[input] || pluralUnits[input]) {
		return [input];
	}
	for (const unit of Object.keys(units)) {
		for (const shorthand of units[unit]) {
			if (input === shorthand) {
				return [unit, input];
			}
		}
	}
	for (const pluralUnit of Object.keys(pluralUnits)) {
		if (input === pluralUnits[pluralUnit]) {
			return [pluralUnit, input];
		}
	}
	return [];
}

function parse(recipeString) {
	const ingredientLine = recipeString.trim(); // removes leading and trailing whitespace

	/* restOfIngredient represents rest of ingredient line.
	For example: "1 pinch salt" --> quantity: 1, restOfIngredient: pinch salt */
	let [quantity, restOfIngredient] = findQuantityAndConvertIfUnicode(ingredientLine);

	quantity = convertFromFraction(quantity);

	return [quantity, restOfIngredient].join(' ');
}

function gcd(a, b) {
	if (b < 0.0000001) {
		return a;
	}

	return gcd(b, Math.floor(a % b));
}
																 
function processRecipe(recipe) {
	if (recipe.author && recipe.author.name) {
		recipe.author = recipe.author.name;
	}
	
	toDel = ['aggregateRating', 'review', 'speakable', 'keywords', 'totalTime', 'dateModified', '@context', '@content', "@type", "@id", "cookingMethod", "isPartOf", "nutrition"];
	
	for (const del of toDel) {
		delete recipe[del];
	}

	if (recipe.image) {
		if (recipe.image.url) {
			recipe.imageUrl = recipe.image.url;
		} else if (Array.isArray(recipe.image) && recipe.image.length > 0) {
			recipe.imageUrl = recipe.image[0];
		} else {
			recipe.imageUrl = recipe.image;
		}
		
		delete recipe.image;
	}
			
	parseRecipeIngredient = (ingredient) => {
		ingredient = ingredient.replace(currencyRegex, '');
		ingredient = ingredient.replace(alternativeUnit, ' ');
		
		const matches = gUnitRegex.matchAll(/.*?\d+\s?([A-Za-z]*g)(?:rams)?/ig);
		
		for (const m of matches) {
			
		}

		return parse(ingredient);
	}

	for (let i = 0; i < recipe.recipeInstructions.length; i++) {
		let instruction = recipe.recipeInstructions[i];

		if (instruction['@type'] && instruction['@type'].toLowerCase() == 'howtostep') {
			recipe.recipeInstructions[i] = instruction.text;
		} else if (instruction['text']) {
			recipe.recipeInstructions[i] = instruction.text;
		}
	}

	for (let i = 0; i < recipe.recipeIngredient.length; i++) {
		let ingredient = recipe.recipeIngredient[i];

		recipe.recipeIngredient[i] = parseRecipeIngredient(ingredient);
	}
			
	if (recipe.recipeYield && Array.isArray(recipe.recipeYield)) { // clean yield
		recipe.recipeYield = recipe.recipeYield.sort(function (a, b) { return b.length - a.length; })[0];
	}

	if (recipe.recipeCategory && !Array.isArray(recipe.recipeCategory)) {
		recipe.recipeCategory = recipe.recipeCategory.split(',');
	}

	if (recipe.mainEntityOfPage) {
		if (recipe.mainEntityOfPage['@id']) {
			recipe.urlString = recipe.mainEntityOfPage['@id'];
		} else {
			recipe.urlString = recipe.mainEntityOfPage;
		}
		
		delete recipe.mainEntityOfPage;
	} else if (!recipe.url) {
		recipe.urlString = window.location.href;
	}
			
	delete recipe.url;
	
	if (recipe.publisher && recipe.publisher.name) { // try identify publisher
		recipe.publisher = recipe.publisher.name;
	}

	return recipe;
}

var capt = JSON.parse(document.evaluate('descendant-or-self::script[@type="application/ld+json"]', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.innerHTML)
hrecipe = selectRecipe(capt);

if (!hrecipe) {
	hrecipe = selectRecipe(Array.prototype.map.call(document.querySelectorAll('script[type="application/ld+json"]'), s => JSON.parse(s.innerText)));
}
																 
processRecipe(hrecipe);
