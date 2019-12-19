<html>
 <head>
  <title>wordtree</title>
 </head>
 <body>

  <?php
    // PHP code just started

    $mysqli = new mysqli("dbase.cs.jhu.edu", "19_xu", "knleqitjol", "cs415_fall_19_xu");

    if (mysqli_connect_errno()) {

      printf("Connection failed: %s<br>", mysqli_connect_error());
      exit();

    } else {

      $word = $_POST['word'];
      // $SSN = $_POST['ssn'];
      // $assignment_name = $_POST['assignment_name'];
      // $new_score = $_POST['new_score'];

      // if ($mysqli->multi_query("CALL ChangeScore('$password', '$SSN', '$assignment_name', '$new_score');")) {

      if ($mysqli->multi_query("CALL Leaves('$word');")) {
        if ($result = $mysqli->store_result()) {

            printf("<h2> How many words are there in the database for a specific food item?  (number of leafnodes that are descendants of the meaning of “food” in this ontology): </h2>\n");
            echo "<table border=1 cellpadding=10>\n";
            echo "<tr> <th>numLeafNodes</th> </tr> \n";
            while($row = $result->fetch_array()) {
              printf("<tr> <td>%s</td> </tr>\n", $row["numLeafNodes"]);
            }
            echo "</table>\n";
            
            $result->close();

            $mysqli->more_results();
            $mysqli->next_result();
            
            $result = $mysqli->store_result();
            $row = $result->fetch_array();

            echo "<table border=1 cellpadding=10>\n";
            echo "<tr> <th>definition</th> </tr>\n";
            while($row = $result->fetch_array()) {
              printf("<tr> <td>%s</td> </tr>\n", $row["definition"]);
            }
            echo "</table>\n";
            $result->close();
        }
      } else {
        printf("<br>Error: %s\n", $mysqli->error);
      }

    }

    // PHP code about to end
  ?>

 </body>
</html>
