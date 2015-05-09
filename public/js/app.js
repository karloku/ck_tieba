angular.module('app', ['components'])
 
.controller('Members', function ($scope, $http) {
  $http.get('api/members').success(function(data) {
    $scope.members = data;
  });
})
.controller('Highlights', function ($scope, $http) {
  $http.get('api/highlights').success(function(data) {
    $scope.highlights = data;
  });
});