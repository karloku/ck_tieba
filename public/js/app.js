angular.module('app', ['ui.router','ui.bootstrap','ui.bootstrap.tpls'])
.config(function($stateProvider, $urlRouterProvider){
      
  // For any unmatched url, send to /route1
  $urlRouterProvider.otherwise("/members");

  $stateProvider
    .state('MembersView', {
      url: "/members",
      templateUrl: "members.html",
      controller: 'membersController'
    })
    .state('HighlightView', {
      url: "/highlights",
      templateUrl: "highlights.html",
      controller: 'highlightsController'
    });
})
.controller('indexController', ['$scope','$state',function($scope, $state){
    
}])
.controller('membersController', function ($scope, $http) {
  $http.get('api/members').success(function(data) {
    $scope.members = data;
    $scope.pageSize = 100;
    $scope.currentPage = 0;
    
  });
})
.controller('highlightsController', function ($scope, $http) {
  $http.get('api/highlights').success(function(data) {
    $scope.highlights = data;
  });
});