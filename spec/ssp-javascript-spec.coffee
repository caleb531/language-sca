describe 'SSP grammar (JavaScript)', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-javascript')
    waitsForPromise ->
      atom.packages.activatePackage('language-sca')

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.js.sca.ssp')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.js.sca.ssp'

  it 'tokenizes JS', ->
    {tokens} = grammar.tokenizeLine 'var foo = "foo"; // comment'
    expect(tokens[0]).toEqual value: 'var', scopes: ['source.js.sca.ssp', 'storage.type.var.js']
    expect(tokens[5]).toEqual value: 'foo', scopes: ['source.js.sca.ssp', 'string.quoted.double.js']
    expect(tokens[9]).toEqual value: '//', scopes: ['source.js.sca.ssp', 'comment.line.double-slash.js', 'punctuation.definition.comment.js']

  it 'tokenizes <%= %> tags', ->
    {tokens} = grammar.tokenizeLine '<%= var foo = "foo"; %>'
    expect(tokens[0]).toEqual value: '<%=', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'keyword.control.directive.sca.ssp']
    expect(tokens[2]).toEqual value: 'var', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'source.js.embedded.sca.ssp', 'storage.type.var.js']
    expect(tokens[7]).toEqual value: 'foo', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'source.js.embedded.sca.ssp', 'string.quoted.double.js']
    expect(tokens[11]).toEqual value: '%>', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'keyword.control.directive.sca.ssp']

  it 'tokenizes <% %> tags with unclosed block', ->
    {tokens} = grammar.tokenizeLine '<% if (foo) { %>'
    expect(tokens[0]).toEqual value: '<%', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'keyword.control.directive.sca.ssp']
    expect(tokens[2]).toEqual value: 'if', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'source.js.embedded.sca.ssp', 'keyword.control.js']
    expect(tokens[10]).toEqual value: '%>', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'keyword.control.directive.sca.ssp']

  it 'tokenizes <% %> tags with unclosed block (no space)', ->
    {tokens} = grammar.tokenizeLine '<% if (foo){ %>'
    expect(tokens[0]).toEqual value: '<%', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'keyword.control.directive.sca.ssp']
    expect(tokens[2]).toEqual value: 'if', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'source.js.embedded.sca.ssp', 'keyword.control.js']
    expect(tokens[9]).toEqual value: '%>', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'keyword.control.directive.sca.ssp']

  it 'tokenizes <% %> tags with closed block', ->
    {tokens} = grammar.tokenizeLine '<% if (foo) {} %>'
    expect(tokens[0]).toEqual value: '<%', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'keyword.control.directive.sca.ssp']
    expect(tokens[2]).toEqual value: 'if', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'source.js.embedded.sca.ssp', 'keyword.control.js']
    expect(tokens[11]).toEqual value: '%>', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'keyword.control.directive.sca.ssp']

  it 'tokenizes <% %> tags with non-block', ->
    {tokens} = grammar.tokenizeLine '<% var foo = "foo"; %>'
    expect(tokens[0]).toEqual value: '<%', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'keyword.control.directive.sca.ssp']
    expect(tokens[2]).toEqual value: 'var', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'source.js.embedded.sca.ssp', 'storage.type.var.js']
    expect(tokens[7]).toEqual value: 'foo', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'source.js.embedded.sca.ssp', 'string.quoted.double.js']
    expect(tokens[11]).toEqual value: '%>', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'keyword.control.directive.sca.ssp']

  it 'tokenizes <% tags following curly braces', ->
    {tokens} = grammar.tokenizeLine '<% if (Error) { %> if (true) {} <% } %>'
    expect(tokens[21]).toEqual value: '<%', scopes: ['source.js.sca.ssp', 'meta.embedded.sca.ssp', 'keyword.control.directive.sca.ssp']
