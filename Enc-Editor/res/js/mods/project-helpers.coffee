fs = require 'fs-extra'
gate = require 'gate'
nedb = require 'nedb'
domain = require 'domain'

_dirs = [
    '/bin'
    '/res/audio/bgm'
    '/res/audio/me'
    '/res/audio/se'
    '/res/db'
    '/res/image/background'
    '/res/image/character'
    '/res/image/item'
    '/res/image/etc'
    '/res/image/ui'
    '/res/etc'
]
_dbs = ['character','script','snippet','audio','object','image','system']

class Project
    constructor:(path)->
        @isReady = false

        @path = path
        @dirs = for dir in _dirs
            path + dir
        @dbpath = {}

        for db in _dbs
            @dbpath[db] = path + _dirs[4] + '/'+ db + '.db'


    getReady:(cb)->
        d = domain.create()
        d.on 'error',(err)->
            d.dispose()
            cb err

        await fs.stat @path,d.intercept defer dir_stat
        throw new Error 'Not a directory' if !dir_stat.isDirectory()

        await fs.exists @path + '/.encproj',defer is_new
        if !is_new
            await fs.mkdir @path + '/.encproj',d.intercept defer()

        await fs.mkdirp dir,d.intercept defer()  for dir in @dirs
        @dbs = {}
        for db,path of @dbpath
            @dbs[db] = db =  new nedb({filename:path})
            await db.loadDatabase d.intercept defer()
        return cb(null)



module.exports = Project

##Debug

p = new Project 'D:/Encouragement_System/Enc-Project'
p.getReady ->console.dir arguments




