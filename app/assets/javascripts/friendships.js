$(function() {

    $(document).on('click', '.js-add-friend-btn', function(event) {
        var $addFriendBtn = $(event.target);
        var pathForRequest = $addFriendBtn.data('path');
        var user_id = $addFriendBtn.data('id');

        $addFriendBtn.attr('disabled', true);

        var successCallback = function($addFriendBtn) {
            return function(data, status, xhr) {

                if (data.status === "success") {
                    $addFriendBtn.html('Friend request sent');
                }
                else {
                    $addFriendBtn.html('Add Friend');
                    $addFriendBtn.attr('disabled', false);
                }
            }
        };

        var errorCallback = function($addFriendBtn) {
            return function(data, status, xhr) {
                $addFriendBtn.html('Add Friend');
                $addFriendBtn.attr('disabled', false);
            }
        };

        $.ajax({
            url: pathForRequest,
            method: "POST",
            data: {
                user_id: user_id
            },
            dataType: "json",
            success: successCallback($addFriendBtn),
            error: errorCallback($addFriendBtn)
        });
    });
});