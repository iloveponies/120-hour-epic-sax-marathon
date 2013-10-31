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

var score_item = function(score, label_key, max_points) {
    var points = score.points;
    var description = $("<dt>").append(score[label_key]);
    var value = $("<dd>");
    value.append(points_badge(points, max_points));
    value.append(progress_bar(points, max_points));
    return $("<dl>").append(description).append(value);
}

var populate_scoreboard = function(scores,
                                   scoreboards,
                                   label_key,
                                   global_max) {
    var max_points = 0;
    if (global_max) {
        $.each(scores, function(key, val) {
            if (val["max-points"] > max_points) {
                max_points = val["max-points"];
            }
        });
    }
    scores.sort(function(a,b) {
        return b.points - a.points;
    });
    $.each(scores, function(key, val) {
        if (!global_max) {
            max_points = val["max-points"];
        }
        var item = score_item(val, label_key, max_points);
        scoreboards[key % scoreboards.length].append(item);
    });
}

var make_user_links = function() {
    $("dt").each(function(i, elem) {
        var name = $(elem).text();
        var url_name = encodeURIComponent(name);
        var link = $("<a>", {href: "scoreboard.html?user="+name}).text(name);
        $(elem).text("").append(link);
    });
}

var urlParam = function(name) {
    var re = new RegExp('[\\?&]' + name + '=([^&#]*)');
    var results = re.exec(window.location.href);
    return (results || [])[1];
}

$(function() {
    var host = "http://polar-hollows-8825.herokuapp.com"
    var user = urlParam("user");
    if (user) {
        $('#scoreboard > h2').text(decodeURIComponent(user));
        $.getJSON(host+"/users/"+user, function(data) {
            populate_scoreboard(data,
                                [$("#score-list-1"),
                                 $("#score-list-2"),
                                 $("#score-list-3")],
                                "repo",
                                false);
        });
    } else {
        $.getJSON(host+"/scoreboard", function(data) {
            populate_scoreboard(data,
                                [$("#score-list-1"),
                                 $("#score-list-2"),
                                 $("#score-list-3")],
                                "user",
                                true);
            make_user_links();
        });
    }
});
