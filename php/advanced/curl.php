<?php

$handle = curl_init();

$url = "https://moviesjoy.is/";

curl_setopt($handle, CURLOPT_URL, $url);
curl_setopt($handle, CURLOPT_RETURNTRANSFER, true);

$content = curl_exec($handle);

if ( $content !== false ) {
    $data = json_decode($content, true);

    echo '<pre>';
    print_r($data);
}
