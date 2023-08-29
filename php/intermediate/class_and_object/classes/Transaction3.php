<?php

declare(strict_types=1);

class Transaction3 {
    // public const PAID = 'paid';
    // public const PENDING = 'pending';
    // public const DECLINED = 'declined';

    // // This is called the lookup table
    // public const ALL_STATUSES = [
    //     self::PAID => 'Paid',
    //     self::PENDING => 'Pending',
    //     self::DECLINED => 'Declined',
    // ];

    private string $status;

    public function __construct(){
        // To access class constant within the class,
        // use the class itself or the "self" keyword
        // var_dump(Transaction3::STATUS_PAID); echo "<br/>";
        // var_dump(self::STATUS_PENDING); echo "<br/>";

        $this->setStatus(Status::PENDING);
    }

    public function setStatus(string $status): self {
        if (! isset(Status::ALL_STATUSES[$status])) {
            throw new \InvalidArgumentException('Invalid status');
        }
        $this->status = $status;
        return $this;
    }
}
