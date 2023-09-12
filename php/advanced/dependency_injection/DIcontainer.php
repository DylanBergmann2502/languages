<?php

require_once './DIC/SalesTaxService.php';
require_once './DIC/PaymentGatewayService.php';
require_once './DIC/EmailService.php';
require_once './DIC/InvoiceService.php';
require_once './DIC/NotFoundException.php';
require_once './DIC/ContainerException.php';
require_once './DIC/Container.php';

$container = new Container();

$container->set(InvoiceService::class, function (Container $c) {
    return new InvoiceService(
        $c->get(SalesTaxService::class),
        $c->get(PaymentGatewayService::class),
        $c->get(EmailService::class),
    );
});

$container->set(SalesTaxService::class, fn() => new SalesTaxService());
$container->set(PaymentGatewayService::class, fn() => new PaymentGatewayService());
$container->set(EmailService::class, fn() => new EmailService());

$container->get(InvoiceService::class)->process([], 25);

