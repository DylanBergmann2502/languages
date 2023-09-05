<?php

declare(strict_types=1);

class Home2 {
    public function index(): string{
        return <<<FORM
<form action="" method="post" enctype="multipart/form-data">
    <input type="file" name="receipt">
    <button type="submit">Upload</button>
</form>
FORM;
    }

    public function upload(){
        echo '<pre>';
        var_dump($_FILES);
        echo '<pre>';
    }
}
