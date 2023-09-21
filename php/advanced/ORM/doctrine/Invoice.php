<?php

use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\ORM\Mapping\Id;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping\Table;
use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\OneToMany;
use Doctrine\ORM\Mapping\GeneratedValue;
use Doctrine\Common\Collections\Collection;

#[Entity]
#[Table('invoices')]
class Invoice {
    #[Id]
    #[Column, GeneratedValue]
    private int $id;

    #[Column(type: Types::DECIMAL, precision: 10, scale: 2)]
    private float $amount;

    #[Column(name: 'invoiced_number')]
    private string $invoiceNumber;

    #[Column]
    private InvoiceStatus $status;

    #[Column(name: 'created_at')]
    private \DateTime $createdAt;

    #[OneToMany(targetEntity: InvoiceItem::class, mappedBy: 'invoice')]
    private Collection $items;

    public function __construct() {
        $this->items = new ArrayCollection();
    }

    ////////////////////////////////////////////////////////////////
    // Getters and setters
    public function getId()
    {
        return $this->id;
    }
    public function getAmount()
    {
        return $this->amount;
    }
    public function setAmount($amount)
    {
        $this->amount = $amount;

        return $this;
    }
    public function getInvoiceNumber()
    {
        return $this->invoiceNumber;
    }
    public function setInvoiceNumber($invoiceNumber)
    {
        $this->invoiceNumber = $invoiceNumber;

        return $this;
    }
    public function getStatus()
    {
        return $this->status;
    }
    public function setStatus($status)
    {
        $this->status = $status;

        return $this;
    }
    public function getCreatedAt()
    {
        return $this->createdAt;
    }
    public function setCreatedAt($createdAt)
    {
        $this->createdAt = $createdAt;

        return $this;
    }

    public function getItems()
    {
        return $this->items;
    }
    public function addItem(InvoiceItem $item): Invoice {
        $this->items->add($item);
        return $this;
    }


}
