var points_badge = function(points, max_points) {
    var badge = $("<span>", {"class": "badge pull-left"});
    return badge.append(points + "/" + max_points);
}

var progress_bar = function(points, max_points) {
    var percent = (points * 100) / max_points;
    var bar = $("<div>",
                {"class": "progress-bar progress-bar-success",
                 "role": "progressbar",
                 "aria-valuenow": points,
                 "aria-valuemin": "0",
                 "aria-valuemax": max_points,
                 "style": "width: " + percent  + "%;"});
    bar.append(points_badge(points, max_points));
    return $("<div>", {"class": "progress"}).append(bar);
}

var populate_scoreboard = function(scoreboard, api_url) {
    $.getJSON(api_url, function(data) {
        $.each(data, function(i, e) {
            var user = e.user;
            var points = e.points;
            var max_points = e["max-points"];
            var item = $("<dl>");
            item.append($("<dt>").append(user));
            item.append($("<dd>").append(progress_bar(points, max_points)));
            scoreboard.append(item);
        });
    });
}
