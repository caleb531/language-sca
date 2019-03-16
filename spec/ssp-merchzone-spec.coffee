describe 'SSP grammar (Merchzone)', ->
  grammar = null

  beforeEach ->
    atom.config.set('core.useTreeSitterParsers', false)
    waitsForPromise ->
      atom.packages.activatePackage('language-javascript')
    waitsForPromise ->
      atom.packages.activatePackage('language-html')
    waitsForPromise ->
      atom.packages.activatePackage('language-mustache')
    waitsForPromise ->
      atom.packages.activatePackage('language-sca')

    runs ->
      grammar = atom.grammars.grammarForScopeName('text.html.sca.ssp.merchzone')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'text.html.sca.ssp.merchzone'

  it 'tokenizes HTML', ->
    {tokens} = grammar.tokenizeLine '<meta charset="UTF-8">'
    expect(tokens[1]).toEqual value: 'meta', scopes: ['text.html.sca.ssp.merchzone', 'meta.tag.inline.meta.html', 'entity.name.tag.inline.meta.html']
    expect(tokens[3]).toEqual value: 'charset', scopes: ['text.html.sca.ssp.merchzone', 'meta.tag.inline.meta.html', 'meta.attribute-with-value.html', 'entity.other.attribute-name.html']
    expect(tokens[6]).toEqual value: 'UTF-8', scopes: ['text.html.sca.ssp.merchzone', 'meta.tag.inline.meta.html', 'meta.attribute-with-value.html', 'string.quoted.double.html']

  it 'tokenizes <script> tags', ->
    {tokens} = grammar.tokenizeLine '<script> var foo = {}; </script>'
    expect(tokens[0]).toEqual value: '<', scopes: ['text.html.sca.ssp.merchzone', 'meta.tag.script.html', 'punctuation.definition.tag.html']
    expect(tokens[1]).toEqual value: 'script', scopes: ['text.html.sca.ssp.merchzone', 'meta.tag.script.html', 'entity.name.tag.script.html']
    expect(tokens[2]).toEqual value: '>', scopes: ['text.html.sca.ssp.merchzone', 'meta.tag.script.html', 'punctuation.definition.tag.html']
    expect(tokens[4]).toEqual value: 'var', scopes: ['text.html.sca.ssp.merchzone', 'meta.tag.script.html', 'source.js.embedded.html', 'storage.type.var.js']
    expect(tokens[8]).toEqual value: '{', scopes: ['text.html.sca.ssp.merchzone', 'meta.tag.script.html', 'source.js.embedded.html', 'punctuation.section.scope.begin.js']
    expect(tokens[12]).toEqual value: '</', scopes: ['text.html.sca.ssp.merchzone', 'meta.tag.script.html', 'punctuation.definition.tag.html']
    expect(tokens[13]).toEqual value: 'script', scopes: ['text.html.sca.ssp.merchzone', 'meta.tag.script.html', 'entity.name.tag.script.html']
    expect(tokens[14]).toEqual value: '>', scopes: ['text.html.sca.ssp.merchzone', 'meta.tag.script.html', 'punctuation.definition.tag.html']

  it 'tokenizes <%= %> tags', ->
    {tokens} = grammar.tokenizeLine '<%= var foo = "foo"; %>'
    expect(tokens[0]).toEqual value: '<%=', scopes: ['text.html.sca.ssp.merchzone', 'meta.embedded.sca.ssp.merchzone', 'keyword.control.directive.sca.ssp.merchzone']
    expect(tokens[2]).toEqual value: '%>', scopes: ['text.html.sca.ssp.merchzone', 'meta.embedded.sca.ssp.merchzone', 'keyword.control.directive.sca.ssp.merchzone']

  it 'tokenizes <% %> tags', ->
    {tokens} = grammar.tokenizeLine '<% if (foo) { %>'
    expect(tokens[0]).toEqual value: '<%', scopes: ['text.html.sca.ssp.merchzone', 'meta.embedded.sca.ssp.merchzone', 'keyword.control.directive.sca.ssp.merchzone']
    expect(tokens[2]).toEqual value: '%>', scopes: ['text.html.sca.ssp.merchzone', 'meta.embedded.sca.ssp.merchzone', 'keyword.control.directive.sca.ssp.merchzone']
