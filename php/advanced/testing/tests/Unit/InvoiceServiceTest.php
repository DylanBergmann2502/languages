<?php

declare(strict_types=1);

require_once 'mocking/SalesTaxService.php';
require_once 'mocking/PaymentGatewayService.php';
require_once 'mocking/EmailService.php';
require_once 'mocking/InvoiceService.php';

use PHPUnit\Framework\TestCase;

// Mocking can be used for API Calls, Email & SMS, Models, and DB Classes
class InvoiceServiceTest extends TestCase {
    public function test_it_processes_invoice(): void {
        // Mock
        $salesTaxServiceMock = $this->createMock(SalesTaxService::class);
        $gatewayServiceMock = $this->createMock(PaymentGatewayService::class);
        $emailServiceMock = $this->createMock(EmailService::class);

        $gatewayServiceMock->method('charge')->willReturn(true);

        // All methods of the mock object returns NULL
        // but this method is type hinted as float => NULL is cast into float(0)
        // $salesTaxServiceMock->calculate(25, []);

        ////////////////////////////////////////////////////////////////
        // given invoice service
        $invoiceService = new InvoiceService($salesTaxServiceMock, $gatewayServiceMock, $emailServiceMock);

        $customer = ['name'=>'Gio'];
        $amount = 150;

        // when process is called
        $result = $invoiceService->process($customer, $amount);

        // then assert invoice is processed successfully
        $this->assertTrue($result);
    }

    public function test_it_sends_receipt_email_when_invoice_is_processed(): void {
        // Mock
        $salesTaxServiceMock = $this->createMock(SalesTaxService::class);
        $gatewayServiceMock = $this->createMock(PaymentGatewayService::class);
        $emailServiceMock = $this->createMock(EmailService::class);

        $gatewayServiceMock->method('charge')->willReturn(true);
        $emailServiceMock
            ->expects($this->once())
            ->method('send')
            ->with(['name' => 'Gio'], 'receipt');

        ////////////////////////////////////////////////////////////////
        // given invoice service
        $invoiceService = new InvoiceService($salesTaxServiceMock, $gatewayServiceMock, $emailServiceMock);

        $customer = ['name'=>'Gio'];
        $amount = 150;

        // when process is called
        $result = $invoiceService->process($customer, $amount);

        // then assert invoice is processed successfully
        $this->assertTrue($result);
    }
}
