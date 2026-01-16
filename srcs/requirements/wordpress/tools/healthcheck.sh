#!/bin/bash

set -eou pipefail

# Checks if WordPress is installed.
cd /var/www/html/wordpress
if wp --allow-root core is-installed 2>/dev/null; then
    # WP is installed. Checks core file integrity.
    wp --allow-root core verify-checksums
else
    echo "Hey, something went wrong during the WP install. Check your logs."
fi
