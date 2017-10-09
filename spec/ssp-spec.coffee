describe "SSP grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-javascript")
    waitsForPromise ->
      atom.packages.activatePackage("language-html")
    waitsForPromise ->
      atom.packages.activatePackage("language-mustache")
    waitsForPromise ->
      atom.packages.activatePackage("language-sca")

    runs ->
      grammar = atom.grammars.grammarForScopeName("text.html.sca.ssp")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "text.html.sca.ssp"

  it "tokenizes HTML", ->
    {tokens} = grammar.tokenizeLine '<meta charset="UTF-8">'
    expect(tokens[1]).toEqual value: 'meta', scopes: ['text.html.sca.ssp', 'meta.tag.inline.any.html', 'entity.name.tag.inline.any.html']
    expect(tokens[3]).toEqual value: 'charset', scopes: ['text.html.sca.ssp', 'meta.tag.inline.any.html', 'entity.other.attribute-name.html']
    expect(tokens[6]).toEqual value: 'UTF-8', scopes: ['text.html.sca.ssp', 'meta.tag.inline.any.html', 'string.quoted.double.html']
