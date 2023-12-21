# \[NOTICE\]: The Atom editor has officially been sunsetted as of December 2022; see [GitHub's blog post](https://github.blog/2022-06-08-sunsetting-atom/)

# language-sca for Atom

*Copyright 2017-2021 Caleb Evans*  
*Released under the MIT license*

[![Build Status](https://app.travis-ci.com/caleb531/language-sca.svg?branch=master)](https://app.travis-ci.com/caleb531/language-sca)

Adds syntax highlighting to NetSuite's SuiteCommerce Advanced files in Atom.

This package requires that Atom's built-in `language-mustache`, `language-html`,
and `language-javascript` packages be enabled for syntax highlighting to work
properly, so please make sure they are.

Contributions are greatly appreciated. Please fork this repository and open a
pull request to add snippets, make grammar tweaks, etc.

## Supported File Types

- SCA Templates (`*.tpl`)
- SuiteScript Server Pages (`*.ssp`, `merchzone*.txt`)
- SuiteScript Services (`*.ss`)
- Token-Based Authentication Files (`.nstba`)

## Installation

You can install language-sca through the Atom Settings screen, or via the
command line:

```
apm install language-sca
```
