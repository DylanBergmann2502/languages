<?php

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

declare(strict_types=1);

// This is automatically converted into "invoice_items"
class InvoiceItem extends Model {
    public $timestamps = false;

    public function invoice(): BelongsTo {
        return $this->belongsTo(Invoice::class);
    }
}
