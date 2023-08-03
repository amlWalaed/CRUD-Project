<?php

namespace Database\Seeders;

use App\Models\Department;
use App\Models\product;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class SlugSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
         product::all()->each(function (product $product){
            $product->generateSlug();
            $product->save();
        });
        Department::all()->each(function (Department $department){
            $department->generateSlug();
            $department->save();
        });
    }
}
