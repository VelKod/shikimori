Base64 = require('js-base64').Base64
LoaderBase = require './loader_base'

module.exports = class YandereLoader extends LoaderBase
  _initialize: ->
    @name = 'YandeRe'
    @base_url = 'https://yande.re'
