var points_badge = function(points, max_points) {
    var badge = $("<span>", {"class": "badge"});
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
    return $("<div>", {"class": "progress"}).append(bar);
}

var populate_scoreboard = function(scoreboards, api_url) {
    $.getJSON(api_url, function(data) {
        var max_points = 0;
        $.each(data, function(i, e) {
            if (e["max-points"] > max_points) {
                max_points = e["max-points"];
            }
        });
        $.each(data, function(i, e) {
            var user = e.user;
            var points = e.points;
            var item = $("<dl>");
            var description = $("<dt>");
            var value = $("<dd>");
            description.append(user);
            value.append(points_badge(points, max_points));
            value.append(progress_bar(points, max_points));
            item.append(description);
            item.append(value);
            scoreboards[i % scoreboards.length].append(item);
        });
    });
}
