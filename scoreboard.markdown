% Clojure Workshop
% 120 hour epic sax marathon

<script src="js/scoreboard.js"></script>
<div class="row">

<div class="col-xs-4">
<ul id="score-list-1">
</ul>
</div>

<div class="col-xs-4">
<ul id="score-list-2">
</ul>
</div>

<div class="col-xs-4">
<ul id="score-list-3">
</ul>
</div>

</div>
<script>
var url = "http://localhost:8080/scoreboard?total=";
populate_scoreboard([$("#score-list-1"),
                     $("#score-list-2"),
                     $("#score-list-3")], url);
</script>
