<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\product>
 */
class ProductFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'name' => fake()->name(),
            'description' => fake()->unique()->paragraph(5),
            'excerpt' => fake()->sentence(20),
            'price'=>fake()->randomNumber(4),
            'discount'=>fake()->randomFloat(1,0,100),
            'amount'=>fake()->randomNumber(3),
        ];
    }
}
