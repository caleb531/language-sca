exports.activate = function () {
  if (!atom.grammars.addInjectionPoint) return

  atom.grammars.addInjectionPoint('text.html.mustache.sca.ssp', {
    type: 'template',
    language (node) { return 'javascript' },
    content (node) { return node.descendantsOfType('code') }
  })

  atom.grammars.addInjectionPoint('text.html.mustache.sca.ssp', {
    type: 'template',
    language (node) { return 'html' },
    content (node) { return node.descendantsOfType('content') }
  })

}
