private
makeRangesBlock

	| js light lowlight toRanges |
	js := self jsConnector yaros remoteObjectNamed: #globalThis.
	
	lowlight := js eval: 'import("https://esm.sh/lowlight@3")'.
	light := lowlight createLowlight: lowlight all.
	
	toRanges := js eval: "Language=JavaScript" '(root, classMap = {}) => {
	  let offset = 0;
	  const ranges = [];

	  function walk(node) {
	    // Text node: just advance our running offset
	    if (node.type === "text") {
	      offset += node.value.length;
	      return;
	    }

	    // Element node: maybe record a highlight range
	    if (node.type === "element") {
	      // look for an hljs class
	      const classes = node.properties && node.properties.className;
	      const hlClass = Array.isArray(classes)
	        && classes.find((c) => c.startsWith("hljs-"));

	      // determine our semantic type
	      let type = null;
	      if (hlClass) {
	        type = classMap[hlClass] || hlClass.replace(/^hljs-/, "");
	      }

	      // remember where this element''s text will start
	      const start = offset;

	      // descend into children
	      if (Array.isArray(node.children)) {
	        node.children.forEach(walk);
	      }

	      // after children, our offset is at the end
	      const end = offset;
	      if (type && end > start) {
	        ranges.push([start, end, type]);
	      }
	      return;
	    }

	    // fallback: descend if it has children
	    if (Array.isArray(node.children)) {
	      node.children.forEach(walk);
	    }
	  }

	  walk(root);
	  return ranges;
	}'.
	
	^ [:source |
		| tree |
		tree := light highlight: self languageCode with: source asTrueOctetString.
		(js JSON stringify: (toRanges value: tree)) parseAsJson].