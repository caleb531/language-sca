describe 'SS grammar', ->
  grammar = null

  beforeEach ->
    atom.config.set('core.useTreeSitterParsers', false)
    waitsForPromise ->
      atom.packages.activatePackage('language-javascript')
    waitsForPromise ->
      atom.packages.activatePackage('language-sca')

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.js.sca.ss')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.js.sca.ss'

  it 'tokenizes JS', ->
    {tokens} = grammar.tokenizeLine 'var foo = "foo"; // comment'
    expect(tokens[0]).toEqual value: 'var', scopes: ['source.js.sca.ss', 'storage.type.var.js']
    expect(tokens[5]).toEqual value: 'foo', scopes: ['source.js.sca.ss', 'string.quoted.double.js']
    expect(tokens[9]).toEqual value: '//', scopes: ['source.js.sca.ss', 'comment.line.double-slash.js', 'punctuation.definition.comment.js']
