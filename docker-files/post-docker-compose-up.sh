#!/usr/bin/env bash
cd /usr/share/nginx/html/ruggedy-vma
bower install --allow-root
composer install
php artisan key:generate
php artisan doctrine:generate:proxies
php artisan migrate
rm /tmp/parser.lock