describe "TPL grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-html")
    waitsForPromise ->
      atom.packages.activatePackage("language-mustache")
    waitsForPromise ->
      atom.packages.activatePackage("language-sca")

    runs ->
      grammar = atom.grammars.grammarForScopeName("text.html.sca.tpl")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "text.html.sca.tpl"

  it "tokenizes HTML", ->
    {tokens} = grammar.tokenizeLine '<meta charset="UTF-8">'
    expect(tokens[1]).toEqual value: 'meta', scopes: ['text.html.sca.tpl', 'meta.tag.inline.any.html', 'entity.name.tag.inline.any.html']
    expect(tokens[3]).toEqual value: 'charset', scopes: ['text.html.sca.tpl', 'meta.tag.inline.any.html', 'entity.other.attribute-name.html']
    expect(tokens[6]).toEqual value: 'UTF-8', scopes: ['text.html.sca.tpl', 'meta.tag.inline.any.html', 'string.quoted.double.html']

  it "tokenizes Mustache tags", ->
    {tokens} = grammar.tokenizeLine '{{#if foo}}'
    expect(tokens[0]).toEqual value: '{{', scopes: ['text.html.sca.tpl', 'meta.tag.template.mustache', 'entity.name.tag.mustache']
    expect(tokens[1]).toEqual value: '#', scopes: ['text.html.sca.tpl', 'meta.tag.template.mustache', 'entity.name.tag.mustache', 'punctuation.definition.block.begin.mustache']
    expect(tokens[2]).toEqual value: 'if', scopes: ['text.html.sca.tpl', 'meta.tag.template.mustache', 'entity.name.tag.mustache', 'entity.name.function.mustache']
    expect(tokens[4]).toEqual value: '}}', scopes: ['text.html.sca.tpl', 'meta.tag.template.mustache', 'entity.name.tag.mustache']