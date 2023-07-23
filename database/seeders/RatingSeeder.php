<?php

namespace Database\Seeders;

use App\Actions\CalculateRateOfProduct;
use App\Models\Product;
use App\Models\Rating;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class RatingSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $ratings = Rating::factory(10)->create();
        $ratings->each(function($rating ){
            $calculateRateOfProduct = new CalculateRateOfProduct();
            $product = Product::find($rating->product_id);
           $calculateRateOfProduct($product);
        });
    }
}
