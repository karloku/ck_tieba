angular.module('app', ['ui.router','ui.bootstrap','ui.bootstrap.tpls','ui.select2'])
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
  // FlatUI Selects and Checkboxes
  // angular.element("select").select2({dropdownCssClass: 'dropdown-inverse'});
  angular.element(":checkbox").radiocheck();

  $scope.maxSize = 10;
  $scope.itemsPerPage = 100;

  $scope.loadPage = function(page) {
    $http.get('api/members?page=' + page).success(function(data, status, headers, config) {
      $scope.members = data;
      $scope.currentPage = headers('X-Pagination-Current-Page');
      $scope.totalItems = headers('X-Pagination-Total-Items');
    });
  }

  $scope.findMember = function() {
    if($scope.yourName === '') {
      $scope.you = {};
    } else {
      $http.get('api/members/' + $scope.yourName).success(function(data, status, headers, config) {
        $scope.you = data;
      });
    }
  }

  $scope.you = {};

  $scope.pageChanged = function() {
    $scope.loadPage($scope.currentPage);
  };

  $scope.loadPage(1);
})
.controller('highlightsController', function ($scope, $http) {
  $http.get('api/highlights').success(function(data) {
    $scope.highlights = data;
  });
})
.filter('floor', function() {
  return function(n) {
    if(angular.isNumber(n)) {
      return Math.floor(n * 100) / 100;
    } else {
      return '';
    }
  };
});