<?php
header("content-type: text/plain; charset=utf-8");

function getMp3StreamTitle($streamingUrl, $interval, $offset = 0, $headers = false)
{
    $needle = 'StreamTitle=';
    $ua = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36';

    $opts = [
            'http' => [
            'method' => 'GET',
            'header' => 'Icy-MetaData: 1',
            'user_agent' => $ua
        ]
    ];
    $context = stream_context_create($opts);

    if ($stream = fopen($streamingUrl, 'r', false, $context)) {
        $buffer = stream_get_contents($stream, $interval, $offset);
        fclose($stream);

        if (strpos($buffer, $needle) !== false) {
            $title = explode($needle, $buffer)[1];
            return substr($title, 1, strpos($title, ';') - 2);
        } else {
            return getMp3StreamTitle($streamingUrl, $interval, $offset + $interval, false);
        }
    } else {
        throw new Exception("Unable to open stream [{$streamingUrl}]");
    }
}

echo htmlentities(getMp3StreamTitle($_REQUEST['u'], 19200), ENT_HTML401, "UTF-8");
?>