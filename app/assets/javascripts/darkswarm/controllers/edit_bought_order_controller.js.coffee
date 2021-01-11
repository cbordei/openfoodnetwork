Darkswarm.controller "EditBoughtOrderController", ($scope, $resource, $timeout, Cart) ->
  $scope.showBought = false
  $scope.removeEnabled = true

  $scope.deleteLineItem = (id) ->
    if Cart.has_one_line_item()
      Messages.error(t 'orders_cannot_remove_the_final_item')
      $scope.removeEnabled = false
      $timeout (->
        $scope.removeEnabled = true
      ), 10000
    else
      params = {id: id}
      success = (response) ->
        $(".line-item-" + id).remove()
        Cart.removeFinalisedLineItem(id)
      fail = (error) ->
        console.log error

      $resource("/line_items/:id").delete(params, success, fail)
