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

      // $password = $_POST['password'];
      // $SSN = $_POST['ssn'];
      // $assignment_name = $_POST['assignment_name'];
      // $new_score = $_POST['new_score'];

      // if ($mysqli->multi_query("CALL ChangeScore('$password', '$SSN', '$assignment_name', '$new_score');")) {

      if ($mysqli->multi_query("CALL ShowWordStatisticsMSA();")) {
        if ($result = $mysqli->store_result()) {

            printf("<h2> List the number of meanings, the number of synonyms and the number of antonymsfor every word in the database. </h2>\n");
            echo "<table border=1 cellpadding=10>\n";
            echo "<tr> <th>lName</th> <th>numMeanings</th> <th>numSynonyms</th> <th>numAntonyms</th></tr>\n";
            while($row = $result->fetch_array()) {
              printf("<tr> <td>%s</td> <td>%s</td> </tr>\n", $row["lName"], $row["numMeanings"], $row["numSynonyms"], $row["numAntonyms"]);
            }
            echo "</table>\n";
            
            $result->close();

            // $mysqli->more_results();
            // $mysqli->next_result();
            
            // $result = $mysqli->store_result();
            // $row = $result->fetch_array();

            // printf("<h2>Rawscores of student %s after the change: </h2>\n", $SSN);
            // echo "<table border=1 cellpadding=10>\n";
            // echo "<tr><th>StuID</th><th>LName</th><th>FName</th><th>HW1</th><th>HW2a</th><th>HW2b</th><th>Midterm</th><th>HW3</th><th>FExam</th></tr>\n";
            // printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $row["SSN"], $row["LName"], $row["FName"],$row["HW1"],$row["HW2a"],$row["HW2b"],$row["Midterm"],$row["HW3"],$row["FExam"]);
            // echo "</table>\n";
            
            // $result->close();
        }
      } else {
        printf("<br>Error: %s\n", $mysqli->error);
      }

    }

    // PHP code about to end
  ?>

 </body>
</html>
