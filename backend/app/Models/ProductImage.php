<?php

namespace App\Models;

use Database\Factories\ProductImageFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Facades\Storage;

class ProductImage extends Model
{
    /** @use HasFactory<ProductImageFactory> */
    use HasFactory;

    protected $fillable = [
        'product_id',
        'url',
        'path',
        'alt',
        'sort_order',
    ];

    protected function casts(): array
    {
        return [
            'sort_order' => 'integer',
        ];
    }

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }

    public function resolvedUrl(): ?string
    {
        if ($this->url && (str_starts_with($this->url, 'http://') || str_starts_with($this->url, 'https://'))) {
            return $this->url;
        }

        if ($this->path) {
            return Storage::disk(config('catalog.media_disk'))->url($this->path);
        }

        return $this->url;
    }
}
