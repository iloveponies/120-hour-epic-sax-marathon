jQuery(function($) {
    var exercise_list = $('#exercise-list');
    $('.alert-success').each(function(i, elem) {
        $(elem).attr('id', 'exercise-' + i);
        var exerciseName = $(elem).find('h3').text().split(" ")[1];
        var li = $('<li>');
        var link = $('<a>', { href: '#exercise-' + i,
                              class: 'navbar-link'});
        link.append(exerciseName);
        li.append(link);
        exercise_list.append(li);
    });
});
