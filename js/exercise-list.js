jQuery(function($) {
    var exercise_list = $('#exercise-list');
    $('.alert-success').each(function(i, elem) {
        $(elem).attr('id', 'exercise-' + i);

        var exerciseName = $(elem).find('h3').text();
        var link = $('<a>', { href: '#exercise-' + i }).text(exerciseName);
        exercise_list.append($('<li>').append(link));
    });
});
