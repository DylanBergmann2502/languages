<?php

use Symfony\Component\Mime\Email;
use Symfony\Component\Mailer\Mailer;
use Symfony\Component\Mailer\Transport;

$text = <<<BODY
Hello Dylan,

Thank you for signing up
BODY;

////////////////////////////////////////////////////////////////
$html = <<<HTML
<h1 style="text-align: center; color: blue;">Welcome</h1>
Hello Dylan,
<br /><br />
Thank you for signing up
HTML;

////////////////////////////////////////////////////////////////
$email = (new Email())
            ->from('dylan@noreply.com')
            ->to('dylanbergmann001@gmail.com')
            ->subject('Welcome!')
            ->attach('Hello world!', 'welcome.txt')
            ->text($text)
            ->html($html);

$dsn = 'smtp://mailhog:1025';

$transport = Transport::fromDsn($dsn);

$mailer = new Mailer($transport);

$mailer->send($email);
