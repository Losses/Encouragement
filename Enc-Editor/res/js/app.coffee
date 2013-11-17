fs = require 'fs-extra'
gate = require 'gate'
nedb = require 'nedb'

gui = require 'nw.gui'
gui.Window.get().showDevTools()

app = angular.module('editor',['ui.bootstrap','ui.state'])

app.config ($stateProvider)->
    $stateProvider
    .state('startup',{
        url:''
        views:
            root:
                templateUrl:'template/startup.html'
                controller:($scope)->
                    $scope.prevProjCtrl = ($scope)->
                        $scope.projects = [
                            ['The Life','D:/Encouragement_System']
                        ]
                    $scope.newProjCtrl = ($scope)->
                        $scope.selectDir = ->
                            elem = $('#choose_dir')
                            elem.change (e)->
                                path = $(@).val()

                                await global.dbs.system.update {
                                    type:'proj_conf',key:'name'
                                },{value:$scope.proj_name},{upsert:true}, d.intercept defer()
                                localStorage.last2 = localStorage.last1 if localStorage.last1?
                                localStorage.last1 = JSON.stringify [path,$scope.proj_name]
                            elem.trigger 'click'
    })