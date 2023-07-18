<?php

namespace App\Http\Controllers;

use App\Models\Product;
use App\Models\User;
use App\Services\FlashMessage;
use GuzzleHttp\Handler\Proxy;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class ProductController extends Controller
{
    public function index(Request $request)
    {
        $products = Product::Filters($request)->sortBy($request)->paginate(10);
        
        return Inertia::render('Product/Index', ['products' => $products]);
    }
    public function show(Product $product)
    {
        return Inertia::render('Product/Show', ['product' => $product]);
    }
    public function create()
    {
        return Inertia::render('Product/Create');
    }

    public function store(Request $request){
        $attributes = $request->validate([
            'thumbnail' => ['image'],
            'name'=>['required','max:255'],
            'excerpt'=>['max:255'],
            'price'=>['required'],
            'amount'=>['required'],
            'discount'=>['between:0,100'],
        ]);
        $attributes['thumbnail'] = $request->file('thumbnail')->store('product');
        Product::create($attributes);
        return redirect()->route('product.index');
    }
    public function update(Product $product,Request $request)
    {
        $attributes = $request->validate([
            'thumbnail' => ['image'],
            'name'=>['required','max:255'],
            'excerpt'=>['max:255'],
            'price'=>['required'],
            'amount'=>['required',],
            'discount'=>['between:0,100'],
        ]);
        $attributes['thumbnail'] = $request->file('thumbnail')->store('product');
        $product->update($attributes);
        FlashMessage::make()->success(
            message:'you have edit '. $attributes['name']
        )->closeable()->send();
        
        return back();
    }
    public function destroy(Product $product)
    {
        $isDeleted = product::find($product->id)->delete();
        if ((!$isDeleted)) {
            FlashMessage::make()->warning(
                message: 'failed delete product'
            )->closeable()->send();
            return back();
        }
        FlashMessage::make()->warning(
            message: 'The Product was successfully deleted'
        )->closeable()->send();
        return back();
    }
}
