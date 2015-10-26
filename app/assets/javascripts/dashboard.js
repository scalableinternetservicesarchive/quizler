/*
$(function() {

    $(document).on('click', '.js-join-quiz-by-id-btn', function (event) {
        var $joinQuizByIdBtn = $(event.target);
        var pathForRequest = $joinQuizByIdBtn.data('path');
        var quiz_id = $joinQuizByIdBtn.data('id');

        $.ajax({
            url: pathForRequest,
            method: "POST",
            data: {
                quiz_id: quiz_id
            },
            dataType: "json",
            success: successCallback($joinQuizByIdBtn),
            error: errorCallback($joinQuizByIdBtn)
        });
    });
});
*/