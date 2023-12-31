<?php

use App\Http\Controllers\DepartmentController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\ProfileController;
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return Inertia::render('Welcome', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
        'laravelVersion' => Application::VERSION,
        'phpVersion' => PHP_VERSION,
    ]);
});

Route::get('/dashboard', function () {
    return Inertia::render('Dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');

    // products
    Route::prefix('product/')->group(function(){
        Route::get('',[ProductController::class, 'index'])->name('product.index');
        Route::get('{product:slug}',[ProductController::class, 'show'])->name('product.show');
        Route::post('store',[ProductController::class, 'store'])->name('product.store');
        Route::post('{product:slug}/edit',[ProductController::class, 'update'])->name('product.update');
        Route::delete('delete/{product}',[ProductController::class, 'destroy'])->name('product.destroy');
    });
    Route::prefix('department/')->group(function(){
        Route::get('',[DepartmentController::class, 'index'])->name('department.index');
        Route::get('{department:slug}',[DepartmentController::class, 'show'])->name('department.show');
        Route::get('{department:slug}',[DepartmentController::class, 'update'])->name('department.update');
    });
});

require __DIR__.'/auth.php';
