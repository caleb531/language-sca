describe 'NSTBA grammar', ->
  grammar = null

  beforeEach ->
    atom.config.set('core.useTreeSitterParsers', false)
    waitsForPromise ->
      atom.packages.activatePackage('language-json')
    waitsForPromise ->
      atom.packages.activatePackage('language-sca')

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.json.sca.nstba')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.json.sca.nstba'

  it 'tokenizes JSON', ->
    {tokens} = grammar.tokenizeLine '{"Client SB1": {"token": "abcd1234"}}'
    expect(tokens[0]).toEqual value: '{', scopes: ['source.json.sca.nstba', 'meta.structure.dictionary.json', 'punctuation.definition.dictionary.begin.json']
    expect(tokens[1]).toEqual value: '"', scopes: ['source.json.sca.nstba', 'meta.structure.dictionary.json', 'meta.structure.dictionary.key.json', 'string.quoted.double.json', 'punctuation.definition.string.begin.json']
    expect(tokens[12]).toEqual value: '"', scopes: ['source.json.sca.nstba', 'meta.structure.dictionary.json', 'meta.structure.dictionary.value.json', 'meta.structure.dictionary.json', 'meta.structure.dictionary.value.json', 'string.quoted.double.json', 'punctuation.definition.string.begin.json']
