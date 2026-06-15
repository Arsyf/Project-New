FROM nginx:alpine
# Kendi yazdığımız index.html dosyasını Nginx'in varsayılan klasörüne kopyalıyoruz
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
