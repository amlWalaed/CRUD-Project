<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Spatie\Sluggable\HasSlug;
use Spatie\Sluggable\SlugOptions;

class Product extends Model
{
    use HasFactory;
    use HasSlug;
    protected $guarded=[];
    public function getSlugOptions(): SlugOptions
    {
        return SlugOptions::create()
            ->generateSlugsFrom('name')
            ->saveSlugsTo('slug');
    }
    public function scopeFilters($query, $params)
    {
        $query->when(
            isset($params['search']) ?? false,
            fn ($query) => $query
                ->where('name', 'like', '%' . $params['search'] . '%')
                ->where('excerpt', 'like', '%' . $params['search'] . '%')
                ->where('description', 'like', '%' . $params['search'] . '%')
        );
        return $query;
    }
    public function scopeSortBy($query, $params)
    {
        $query->when($params->query('sort')??false,function($query,$sort){
            $sortTypes =['ascending'=>'ASC', 'descending'=>'DESC'];
            $query->orderBy($sort['col'], $sortTypes[$sort['order']]);
        });
        return $query;
    }
}
