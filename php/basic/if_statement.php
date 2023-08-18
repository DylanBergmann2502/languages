<?php
// if / else / elseif / else if

$score = 95;
if ($score >= 90) {
    echo 'A';
    if ($score >= 95){
        echo '+';
    }
} elseif ($score >= 80) {
    echo 'B';
} else if ($score >= 70) {
    echo 'C';
}

?>

<!DOCTYPE html>
<html lang="en">
<head>
</head>
<body>
    <?php $score = 55 ?>

    <?php if ($score >= 90): // use the : ?>
        <strong>A</strong>
    <?php elseif ($score >= 80): ?>
        <strong>B</strong>
    <?php else: ?>
        <strong>F</strong>
    <?php endif ?>
</body>
</html>

