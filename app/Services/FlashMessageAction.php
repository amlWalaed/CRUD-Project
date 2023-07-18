<?php

namespace App\Services;

class FlashMessageAction
{
    private string $url;

    private string $text;

    public function __construct(string $url, string $text)
    {
        $this->url = $url;
        $this->text = $text;
    }

    /**
     * Create a new instance of the class.
     *
     * @return \App\Services\FlashMessageAction
     */
    public static function make(string $url, string $text): FlashMessageAction
    {
        return new self(
            url: $url,
            text: $text
        );
    }

    /**
     * Get the array representation of the class.
     */
    public function toArray(): array
    {
        return [
            'url' => $this->url,
            'text' => $this->text,
        ];
    }
}
