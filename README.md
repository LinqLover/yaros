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
deno run --allow-net js/main.js
```
