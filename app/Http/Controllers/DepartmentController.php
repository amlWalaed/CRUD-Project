<?php

namespace App\Http\Controllers;

use App\Models\Department;
use App\Models\Product;
use Illuminate\Http\Request;
use Inertia\Inertia;

class DepartmentController extends Controller
{
    public function index(){
        return Inertia::render('Department/Index',[
            'departments' => Department::paginate(10), 
        ]);
    }

    public function show(Department $department){
        return Inertia::render('Department/Show',['department'=>$department,'products'=>$department->products]);
    }
}
