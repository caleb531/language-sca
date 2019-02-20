describe "SSP grammar (HTML)", ->
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
      grammar = atom.grammars.grammarForScopeName("text.html.mustache.sca.ssp")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "text.html.mustache.sca.ssp"

  it "tokenizes HTML", ->
    {tokens} = grammar.tokenizeLine '<meta charset="UTF-8">'
    expect(tokens[1]).toEqual value: 'meta', scopes: ['text.html.mustache.sca.ssp', 'meta.tag.inline.meta.html', 'entity.name.tag.inline.meta.html']
    expect(tokens[3]).toEqual value: 'charset', scopes: ['text.html.mustache.sca.ssp', 'meta.tag.inline.meta.html', 'meta.attribute-with-value.html', 'entity.other.attribute-name.html']
    expect(tokens[6]).toEqual value: 'UTF-8', scopes: ['text.html.mustache.sca.ssp', 'meta.tag.inline.meta.html', 'meta.attribute-with-value.html', 'string.quoted.double.html']

  it "tokenizes <%= %> tags", ->
    {tokens} = grammar.tokenizeLine '<%= var foo = "foo"; %>'
    expect(tokens[0]).toEqual value: '<%=', scopes: ['text.html.mustache.sca.ssp', 'meta.embedded.sca.ssp', 'entity.name.tag.sca.ssp']
    expect(tokens[2]).toEqual value: 'var', scopes: ['text.html.mustache.sca.ssp', 'meta.embedded.sca.ssp', 'storage.type.var.js']
    expect(tokens[7]).toEqual value: 'foo', scopes: ['text.html.mustache.sca.ssp', 'meta.embedded.sca.ssp', 'string.quoted.double.js']
    expect(tokens[11]).toEqual value: '%>', scopes: ['text.html.mustache.sca.ssp', 'meta.embedded.sca.ssp', 'entity.name.tag.sca.ssp']

  it "tokenizes <% %> tags with unclosed block", ->
    {tokens} = grammar.tokenizeLine '<% if (foo) { %>'
    expect(tokens[0]).toEqual value: '<%', scopes: ['text.html.mustache.sca.ssp', 'meta.embedded.sca.ssp', 'entity.name.tag.sca.ssp']
    expect(tokens[2]).toEqual value: 'if', scopes: ['text.html.mustache.sca.ssp', 'meta.embedded.sca.ssp', 'keyword.control.js']
    expect(tokens[10]).toEqual value: '%>', scopes: ['text.html.mustache.sca.ssp', 'meta.embedded.sca.ssp', 'entity.name.tag.sca.ssp']

  it "tokenizes <% %> tags with unclosed block (no space)", ->
    {tokens} = grammar.tokenizeLine '<% if (foo){ %>'
    expect(tokens[0]).toEqual value: '<%', scopes: ['text.html.mustache.sca.ssp', 'meta.embedded.sca.ssp', 'entity.name.tag.sca.ssp']
    expect(tokens[2]).toEqual value: 'if', scopes: ['text.html.mustache.sca.ssp', 'meta.embedded.sca.ssp', 'keyword.control.js']
    expect(tokens[9]).toEqual value: '%>', scopes: ['text.html.mustache.sca.ssp', 'meta.embedded.sca.ssp', 'entity.name.tag.sca.ssp']

  it "tokenizes <% %> tags with closed block", ->
    {tokens} = grammar.tokenizeLine '<% if (foo) {} %>'
    expect(tokens[0]).toEqual value: '<%', scopes: ['text.html.mustache.sca.ssp', 'meta.embedded.sca.ssp', 'entity.name.tag.sca.ssp']
    expect(tokens[2]).toEqual value: 'if', scopes: ['text.html.mustache.sca.ssp', 'meta.embedded.sca.ssp', 'keyword.control.js']
    expect(tokens[10]).toEqual value: '%>', scopes: ['text.html.mustache.sca.ssp', 'meta.embedded.sca.ssp', 'entity.name.tag.sca.ssp']

  it "tokenizes <% %> tags with non-block", ->
    {tokens} = grammar.tokenizeLine '<% var foo = "foo"; %>'
    expect(tokens[0]).toEqual value: '<%', scopes: ['text.html.mustache.sca.ssp', 'meta.embedded.sca.ssp', 'entity.name.tag.sca.ssp']
    expect(tokens[2]).toEqual value: 'var', scopes: ['text.html.mustache.sca.ssp', 'meta.embedded.sca.ssp', 'storage.type.var.js']
    expect(tokens[7]).toEqual value: 'foo', scopes: ['text.html.mustache.sca.ssp', 'meta.embedded.sca.ssp', 'string.quoted.double.js']
    expect(tokens[11]).toEqual value: '%>', scopes: ['text.html.mustache.sca.ssp', 'meta.embedded.sca.ssp', 'entity.name.tag.sca.ssp']

  it "tokenizes Mustache tags", ->
    {tokens} = grammar.tokenizeLine '{{#if foo}}'
    expect(tokens[0]).toEqual value: '{{', scopes: ['text.html.mustache.sca.ssp', 'meta.tag.template.mustache', 'entity.name.tag.mustache']
    expect(tokens[1]).toEqual value: '#', scopes: ['text.html.mustache.sca.ssp', 'meta.tag.template.mustache', 'entity.name.tag.mustache', 'punctuation.definition.block.begin.mustache']
    expect(tokens[2]).toEqual value: 'if', scopes: ['text.html.mustache.sca.ssp', 'meta.tag.template.mustache', 'entity.name.tag.mustache', 'entity.name.function.mustache']
    expect(tokens[4]).toEqual value: '}}', scopes: ['text.html.mustache.sca.ssp', 'meta.tag.template.mustache', 'entity.name.tag.mustache']
