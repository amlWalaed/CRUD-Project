<?php
namespace App\Actions;
use App\Models\Product;
use App\Models\Rating;

class CalculateRateOfProduct {
    public function __invoke(Product $product)
    {
        $ratings = Rating::where('product_id', $product->id)->get();

        $ratings = $ratings->avg('rating_value');
        
        $product->forceFill([
            'rating' => $ratings
        ])->saveQuietly();
        return $ratings;
    }
}