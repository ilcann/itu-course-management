# İTÜ Ders Yönetim Sistemi

İstanbul Teknik Üniversitesi Matematik Mühendisliği bitirme projesi kapsamında geliştirilen, React/TypeScript arayüzünü PHP API ve MySQL veritabanıyla birleştiren ders yönetim uygulaması.

Proje iki dönemde geliştirildi: **MAT 4901 / Bitirme I** arayüz modernizasyonunu, **MAT 4902 / Bitirme II** ise gerçek backend entegrasyonunu ve not/devamsızlık modüllerini kapsar. Bu depodaki güncel kod **Bitirme II** çalışmasını içerir.

## Sürümler ve demo durumu

| Sürüm | Kapsam | Bağlantı / durum |
| --- | --- | --- |
| Önceki bölüm sistemi | Modernizasyon öncesindeki sistem | [mathavuz.itu.edu.tr](https://mathavuz.itu.edu.tr/) |
| Bitirme I — MAT 4901 | React tabanlı arayüz modernizasyonu; mock veriyle çalışan ilk sürüm | [web.itu.edu.tr/ilcan21](https://web.itu.edu.tr/ilcan21/) |
| Bitirme II — MAT 4902 | PHP API, MySQL, kimlik doğrulama, rol bazlı erişim, not ve devamsızlık yönetimi | Bu deponun güncel kaynak kodu |
| Bitirme II portföy demosu | Ayrı Docker dağıtımı; örnek veriler ve salt okunur kullanım | Dağıtım dosyaları hazır; herkese açık demo adresi henüz eklenmedi |

**İTÜ sunucusundaki bağlantı Bitirme I sürümüne aittir; Bitirme II'nin güncel canlı demosu olarak değerlendirilmemelidir.**

## Özellikler

- Ders, duyuru ve materyallerin tek uygulamada sunulması
- `ADMIN`, `INSTRUCTOR` ve `STUDENT` rolleriyle kimlik doğrulama ve erişim kontrolü
- Öğrenci listeleri ve derse kayıt işlemleri
- Ders bazlı not dağılımları, not kayıtları ve haftalık devamsızlık takibi
- Not ve devamsızlık tablolarının Türkçe karakter destekli PDF çıktısı
- Türkçe/İngilizce arayüz, mobil uyum ve tema desteği

Gerçek İTÜ merkezi kimlik doğrulama sistemi (SSO) entegre değildir; uygulama kendi hesap ve oturum mekanizmasını kullanır.

## Mimari ve teknoloji seçimi

Backend, İTÜ'nün PHP tabanlı sunucu ortamına uyum sağlamak amacıyla PHP ile geliştirildi. Frontend ayrı bir React uygulamasıdır; üretim derlemesi Apache üzerinden PHP API ile aynı adreste sunulur. Üniversite kurulumuna ait `/ilcan21/` taban yolu korunur.

| Katman | Teknolojiler |
| --- | --- |
| Frontend | React 19, TypeScript, Vite |
| Arayüz | Tailwind CSS v4, shadcn/ui, Radix UI |
| Yönlendirme ve sunucu verisi | React Router 7, TanStack Query |
| Dil ve animasyon | i18next, Framer Motion |
| PDF çıktısı | jsPDF, jspdf-autotable |
| Backend | PHP, PDO, Apache |
| Veri katmanı | MySQL; ayrı demo dağıtımında MariaDB |
| Eski yerel geliştirme ortamı | PHP 5.6 / MySQL 5.6 Docker yapılandırması |
| Ayrı portföy demo ortamı | PHP 8.3 / Apache ve MariaDB 11.4 |

`docker/php54.Dockerfile` dosyasının adı tarihsel olarak korunmuştur; mevcut taban imajı `php:5.6-apache` şeklindedir. Portföy demosu bu eski ortamdan ayrı yapılandırılmıştır.

## Hızlı başlangıç: Bitirme II portföy demosu

Gereksinimler: Git, Docker Engine/Desktop ve Docker Compose.

```bash
git clone https://github.com/ilcann/itu-course-management.git
cd itu-course-management
cp .env.demo.example .env.demo
```

`.env.demo` içindeki `DEMO_DB_PASSWORD` ve `DEMO_DB_ROOT_PASSWORD` alanlarına birbirinden farklı rastgele parolalar yazın. Ardından:

```bash
docker compose --env-file .env.demo -f compose.demo.yaml up -d --build
```

Uygulama: [http://localhost:8080/ilcan21/](http://localhost:8080/ilcan21/)

Yeni ve boş veritabanı volume'ünde şemalar, örnek kullanıcılar, dersler ve duyurular otomatik yüklenir.

### Demo hesapları

| Rol | E-posta | Parola |
| --- | --- | --- |
| ADMIN | admin@bitirme.local | Bitirme123! |
| INSTRUCTOR | instructor@bitirme.local | Bitirme123! |
| STUDENT | student@bitirme.local | Bitirme123! |

Bunlar yalnızca örnek hesaplardır. Portföy demo dağıtımında giriş/çıkış ve veri okuma açıktır; yönetici hesabıyla bile içerik değiştirme ve dosya yükleme işlemleri HTTP 403 döndürür. Bu sınırlama güncel uygulamanın tüm sürümlerine değil, ayrı demo dağıtımına aittir.

Mevcut yüklenmiş belgeler demo imajına kopyalanmaz; materyal tablosu başlangıçta boştur. Public yayın için HTTPS reverse proxy ve Docker çalıştırabilen bir sunucu gerekir. PHP API, standart statik Vercel dağıtımında çalışmaz.

Kurulum ayrıntıları ve yayın öncesi runtime kontrolleri: [Demo dağıtım rehberi](docs/DEMO.md).

## Yerel frontend geliştirme

Node.js 22 ve npm ile:

```bash
cd frontend
npm ci
npm run dev
```

Vite geliştirme sunucusunda uygulama `http://localhost:5173/ilcan21/` adresinden açılır. `/ilcan21/api` istekleri `http://localhost:8080` adresine yönlendirilir; backend'in de çalışıyor olması gerekir.

```bash
npm run build
npm run preview
npm run lint
```

`npm run build`, TypeScript kontrolünü ve üretim derlemesini çalıştırır.

## Üniversiteye yönelik eski yerel ortam

Önceki geliştirme ortamı `docker/docker-compose.yml` ve `docker/php54.Dockerfile` dosyalarında korunur:

```bash
docker compose -f docker/docker-compose.yml up -d --build
```

Bu yapılandırmada veritabanı şemaları ve seed dosyaları elle içe aktarılır. Şema sırası: `users.sql`, `courses.sql`, `announcements.sql`, `course_materials.sql`; dosyalar `backend/database/` altındadır. Örnek veriler `backend/database/seeds/` klasöründedir.

Yeni portföy dağıtımı için yukarıdaki `compose.demo.yaml` yolunu kullanın.

## Klasör yapısı

```text
backend/
  config/         Ortam değişkenleri ve PDO bağlantısı
  database/       SQL şemaları ve örnek veriler
  public/         PHP API uç noktaları
  src/            Backend iş mantığı
frontend/
  src/            React uygulaması
  public/         Statik dosyalar
docker/           Eski geliştirme ve ayrı demo yapılandırmaları
docs/             Demo rehberi ve PDF raporları
compose.demo.yaml Portföy demo servisleri
main.tex          MAT 4901 rapor kaynağı
main2.tex         MAT 4902 rapor kaynağı
```

## Proje raporları

| Rapor | İçerik | PDF | LaTeX kaynağı |
| --- | --- | --- | --- |
| MAT 4901 — Bitirme I | Arayüz modernizasyonu ve ilk frontend mimarisi | [Rapor](docs/MAT4901.pdf) | [main.tex](main.tex) |
| MAT 4902 — Bitirme II | PHP/MySQL entegrasyonu, kimlik doğrulama, not ve devamsızlık modülleri | [Rapor](docs/MAT4902.pdf) | [main2.tex](main2.tex) |

Raporlar kendi dönemlerindeki durumu anlatır; güncel demo dağıtım bilgileri için [docs/DEMO.md](docs/DEMO.md) esas alınmalıdır.

LaTeX dağıtımı ve `latexmk` kuruluysa:

```bash
latexmk -pdf main.tex
latexmk -pdf main2.tex
```

## Akademik kapsam

**Recep İlcan — İstanbul Teknik Üniversitesi, Matematik Mühendisliği**  
MAT 4901: 2025–2026 Güz · MAT 4902: 2025–2026 Bahar

Bu depo bir bitirme projesini ve portföy demo hazırlığını içerir; üniversitenin resmî üretim sistemi olduğu iddiasını taşımaz.
