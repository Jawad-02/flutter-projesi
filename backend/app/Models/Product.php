<?php

namespace App\Models;

use Database\Factories\ProductFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Storage;

class Product extends Model
{
    /** @use HasFactory<ProductFactory> */
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'category_id',
        'brand_id',
        'name',
        'slug',
        'tagline',
        'description',
        'price_cents',
        'compare_at_price_cents',
        'currency',
        'image_path',
        'image_url',
        'specs',
        'is_active',
        'is_featured',
    ];

    protected function casts(): array
    {
        return [
            'price_cents' => 'integer',
            'compare_at_price_cents' => 'integer',
            'specs' => 'array',
            'is_active' => 'boolean',
            'is_featured' => 'boolean',
            'deleted_at' => 'datetime',
        ];
    }

    public function getRouteKeyName(): string
    {
        return 'slug';
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function brand(): BelongsTo
    {
        return $this->belongsTo(Brand::class);
    }

    public function variants(): HasMany
    {
        return $this->hasMany(ProductVariant::class);
    }

    public function images(): HasMany
    {
        return $this->hasMany(ProductImage::class)->orderBy('sort_order');
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopeFeatured($query)
    {
        return $query->where('is_featured', true);
    }

    public function primaryImageUrl(): ?string
    {
        if ($this->image_url) {
            return $this->image_url;
        }

        if ($this->image_path) {
            return Storage::disk(config('catalog.media_disk'))->url($this->image_path);
        }

        return null;
    }

    public function formattedPrice(): string
    {
        $amount = number_format($this->price_cents / 100, 2);

        return $this->currency === 'USD' ? '$'.$amount : $amount.' '.$this->currency;
    }

    public function hasStock(): bool
    {
        $stock = $this->relationLoaded('variants')
            ? $this->variants->sum('stock_quantity')
            : $this->variants()->sum('stock_quantity');

        return $stock > 0;
    }
}
