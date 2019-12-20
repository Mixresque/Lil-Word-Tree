<html>
 <head>
  <title>Change Scores</title>
 </head>
 <body>

  <?php
    // PHP code just started

    $mysqli = new mysqli("dbase.cs.jhu.edu", "19_xu", "knleqitjol", "cs415_fall_19_xu");

    if (mysqli_connect_errno()) {

      printf("Connection failed: %s<br>", mysqli_connect_error());
      exit();

    } else {

      if ($mysqli->multi_query("SELECT tName from TOPIC")) {
        if ($result = $mysqli->store_result()) {

            echo("<h2>Available topics: </h2>\n<span>");
            if($row = $result->fetch_array()) { 
              printf("%s", $row["tName"]);
            }
            while($row = $result->fetch_array()) {
              printf(", %s", $row["tName"]);
            }
            echo("</span>");
            $result->close();

            echo("<br><h2>Show top-k most frequent words specialized word for a certain topic.</h2><form action=\"q4.php\" method=\"post\">Topic: <input type=\"text\" name=\"topic\"><br>Number of words: <input type=\"text\" name=\"topk\"><br><input type=\"Submit\"></form>");
            echo("\n<br><h2>Show top-k most common words for a certain topic.</h2><form action=\"q1.php\" method=\"post\">Topic: <input type=\"text\" name=\"topic\"><br>Number of words: <input type=\"text\" name=\"topk\"><br><input type=\"Submit\"></form>");
            echo("\n<br><h2>Show top-k words recommended for Topic1 when you know Topic2.</h2><form action=\"q2.php\" method=\"post\">Topic1: <input type=\"text\" name=\"topic1\"><br>Topic2: <input type=\"text\" name=\"topic2\"><br>Number of words: <input type=\"text\" name=\"topk\"><br><input type=\"Submit\"></form>");
            echo("\n<br><h2>Show top-k words recommended to be learned for a certain topic.</h2><form action=\"q3.php\" method=\"post\">Topic: <input type=\"text\" name=\"topic\"><br>Number of words: <input type=\"text\" name=\"topk\"><br><input type=\"Submit\"></form>");
            echo("\n<br><h2>Find word pairs such that one word is derived from the other, and they are also synonyms.</h2><form action=\"q10.php\" method=\"post\"> <input type=\"Submit\"></form>");
            echo("\n<br><h2>List the words that are derived from another word but are more commonly used than their base form.</h2><form action=\"q5.php\" method=\"post\"><input type=\"Submit\"></form>");
            echo("\n<br><h2>List the chains of derived words for a given word. </h2><form action=\"q8.php\" method=\"post\">Word: <input type=\"text\" name=\"word\"><br><input type=\"Submit\"></form>");
            echo("\n<br><h2> Find number of words are there in the database under a specific word's concept (number of leaf nodes that are descendants of the meaning of this word), and list some example leaf node's definition. </h2><form action=\"q15.php\" method=\"post\">Word: <input type=\"text\" name=\"word\"><br><input type=\"Submit\"></form>");
           

        }
      } else {
        printf("<br>Error: %s\n", $mysqli->error);
      }

    }

    // PHP code about to end
  ?>

 </body>
</html>
