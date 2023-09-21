<?php

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Relations\HasMany;

declare(strict_types=1);

/**
 * @property int $id
 * @property string $invoice_number
 * @property float $amount
 * @property InvoiceStatus $status
 * @property Carbon $created_at
 * @property Carbon $due_date
 *
 * @property-read Collection $items
 */
class Invoice extends Model {
    // By default, the name of the table is the name of the class in plural
    protected $table = 'invoices';

    // By default, "id" is the pk.
    // It is auto incrementing and int
    protected $primaryKey = 'invoiced_uuid';
    public $incrementing = false;
    protected $keyType = 'string';

    // By default, eloquent provides 2 timestamp columns which are
    // "created_at" and "updated_at"
    public $timestamps = false;
    CONST CREATED_AT = 'created_date';
    CONST UPDATE_AT = null;

    ////////////////////////////////////////////////////////////////
    // Relationships
    public function items(): HasMany {
        return $this->hasMany(InvoiceItems::class);
    }

    ////////////////////////////////////////////////////////////////
    // Typecasting
    protected $casts = [
        'created_at' => 'datetime',
        'due_date' => 'datetime',
        'status' => InvoiceStatus::class,
    ];
}
