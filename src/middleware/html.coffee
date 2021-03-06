fs        = require "fs"
path      = require "path"
sysurl    = require "url"
urlrouter = require "urlrouter"
utils     = require '../util'


contentType =
    'Content-Type': "text/html;charset=UTF-8"


module.exports = (options) ->
    ROOT = options.cwd

    return urlrouter (app) ->
        app.get /\.(html|htm)\b/ , (req, res, next) ->
            url         = sysurl.parse req.url
            filepath           = path.join ROOT, url.pathname
            conf        = utils.config.parse filepath

            res.writeHead 200, contentType

            try
                envs = conf.getEnvironmentConfig()
            catch error
                envs = {}

            data = fs.readFileSync(filepath).toString().replace(/\r\n/g, '\n');
            curr = utils.getCurrentEnvironment options
            data = utils.replaceEnvironmentConfig "text", data.toString(), envs[curr]
            res.write data
            res.end()