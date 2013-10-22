jQuery(function($) {
    var sidebar = $('<ul>', { 'class': 'sidebar-exercise-list nav nav-list' });
    $('.alert-success').each(function(i, elem) {
        $(elem).attr('id', 'exercise-' + i);

        var exerciseName = $(elem).find('h3').text();
        var link = $('<a>', { href: '#exercise-' + i }).text(exerciseName);
        sidebar.append($('<li>').append(link));
    });
    $('body').prepend(sidebar);
});
