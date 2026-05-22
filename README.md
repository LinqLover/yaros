# yaros

## Installation

### Squeak

```smalltalk
Metacello new
	baseline: 'Yaros';
	repository: 'github://LinqLover/yaros:main';
	get; "for updates"
	load.
```

See examples on class side of `YarosServer`.

## JavaScript

Install [Deno](https://deno.land/).

```bash
(cd js && deno run start)
```

See [js/README.md](js/README.md) for more details.

For Electron:

```bash
npx electron main-node.js
```
