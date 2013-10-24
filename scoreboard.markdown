% Clojure Workshop
% 120 hour epic sax marathon

## Scoreboard

<script src="js/scoreboard.js"></script>
<ul id="score-list">
</ul>
<script>
var url = "http://localhost:8080/scoreboard?total=";
populate_scoreboard($("#scoreboard"), url);
</script>
