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

  var levelScores = [0,  1, 5, 15, 30, 50, 100, 200, 500, 1000, 2000, 3000, 6000, 10000, 18000, 30000, 60000, 100000, 180000, 300000];

  $scope.level = function(score) {
    
    if (!score) {
      return 0;
    }
    var levelLow = 0;
    var levelScoresLength = levelScores.length;
    for (var i = 0; i < levelScoresLength; i++) {
      if (levelScores[i] <= score) {
        levelLow = i;
      } else {
        break;
      }
    }
    var nextLevelScore = levelScores[levelLow + 1] - levelScores[levelLow];
    var calculatedLevel = levelLow + (score - levelScores[levelLow]) / nextLevelScore;
    return calculatedLevel;
  };

  $scope.pointOf = function(score, highlights, role, isModder) {
    var levelPoint = function(level) {
      if (!level) {
        return 0;
      }

      var levelPoint = 0.25 * (Math.pow(level, 2)) - 2.25 * level + 14;
      return levelPoint;
    };

    var highlightsPoint = function(highlights) {
      if (!highlights) {
        return 0;
      }

      var highlightsPoint = 30 * (1 - Math.pow(0.95, highlights));
      return highlightsPoint;
    };

    var rolePoint = function(role) {
      var roleFloat = parseFloat(role);
      if (!roleFloat) {
        return 0;
      }
      return roleFloat;
    }

    var modderPoint = isModder ? 2 : 0;

    var calculatedPoint = levelPoint(this.level(score)) + highlightsPoint(highlights) + rolePoint(role) + modderPoint;
    return calculatedPoint;  
  }

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
})
.filter('floor', function() {
  return function(n) {
    return Math.floor(n * 100) / 100;
  };
});