#!/bin/bash

set -e

cd /var/www/html/wordpress

if ! wp --allow-root core is-installed; then
    echo "WordPress is not installed."
    exit 1
fi

echo "WordPress healthcheck OK."
