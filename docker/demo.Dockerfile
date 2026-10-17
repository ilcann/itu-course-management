FROM node:22-alpine AS frontend
WORKDIR /app
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/ ./
ENV VITE_APP_TITLE="Course Management Demo"
ENV VITE_API_BASE_URL=/ilcan21/api
ENV VITE_DEMO_MODE=true
RUN npm run build

FROM php:8.3-apache
RUN docker-php-ext-install pdo_mysql && a2enmod rewrite headers
COPY docker/demo-apache.conf /etc/apache2/sites-available/000-default.conf
COPY docker/demo-guard.php /opt/demo-guard.php
RUN printf '%s\n' 'display_errors=Off' 'log_errors=On' 'expose_php=Off' 'auto_prepend_file=/opt/demo-guard.php' > /usr/local/etc/php/conf.d/demo.ini
COPY --from=frontend /app/dist/ /var/www/html/ilcan21/
COPY backend/config/ /var/www/html/ilcan21/api/config/
COPY backend/src/ /var/www/html/ilcan21/api/src/
COPY backend/public/ /var/www/html/ilcan21/api/public/
RUN mkdir -p /var/www/html/ilcan21/api/storage/materials && chown -R www-data:www-data /var/www/html/ilcan21/api/storage
ENV DEMO_READ_ONLY=true
EXPOSE 80
