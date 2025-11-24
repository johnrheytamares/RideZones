# Official image na may Nginx + PHP-FPM + Composer + lahat ng kailangan
FROM richarvey/nginx-php-fpm:3.1.0

# Copy lahat ng files mo sa container
COPY . /var/www/html

# Working directory
WORKDIR /var/www/html

# Install lahat ng kailangan + build ang Vue app
RUN echo "Installing system dependencies..." && \
    # Update package list
    apt-get update -y && \
    # Install Node.js 20 (para sa Vite)
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    # Install pnpm globally
    npm install -g pnpm@9 && \
    # Install Composer (kung wala pa sa image)
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    # Install PHP dependencies
    composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist && \
    # Install Node dependencies at i-build ang Vue
    pnpm install --frozen-lockfile && \
    pnpm run build:frontend && \
    # Linisin para maliit ang image
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.composer

# Expose port (Render uses $PORT environment variable)
EXPOSE 8080

# Start Nginx + PHP-FPM (built-in sa image na ito)
CMD ["/start.sh"]