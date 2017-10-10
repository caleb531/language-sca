describe "SS grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-javascript")
    waitsForPromise ->
      atom.packages.activatePackage("language-sca")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.sca.ss")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "source.sca.ss"

  it "tokenizes JS", ->
    {tokens} = grammar.tokenizeLine 'var foo = "foo"; // comment'
    expect(tokens[0]).toEqual value: 'var', scopes: ['source.sca.ss', 'storage.type.var.js']
    expect(tokens[5]).toEqual value: 'foo', scopes: ['source.sca.ss', 'string.quoted.double.js']
    expect(tokens[9]).toEqual value: '//', scopes: ['source.sca.ss', 'comment.line.double-slash.js', 'punctuation.definition.comment.js']
