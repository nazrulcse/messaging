var shareModule = angular.module('todos', []);

//shareModule.factory('todos', function() {
//    return {};
//});

shareModule.controller('TodosCtrl', function($scope) {
    $scope.init = function() {
        var source = new EventSource('/todos');
        source.onmessage = function(event) {
            $scope.$apply(function () {
                console.log(event.data);
                $scope.entries = JSON.parse(event.data);
//                for(var i = 0; i < $scope.entries.length; i++) {
//
//                }
                if($scope.entries.length > 0) {
                    popup_message($scope.entries[0]);
                }
            });
        };
    };
});

function popup_message(task) {
    $("#notification").show();
    if(task.state == 2) {
        $("#notification .title").html("Update: "+task.status);
    }
    else {
        $("#notification .title").html("New: "+task.status);
    }
    $("#notification .body").html(task.description);
    $("#notification").fadeOut(3000);
}