FAW TRUCKS TURKMENISTAN — ПОЛНЫЙ ПАКЕТ / DOLY TOPLUM
=====================================================

1-SITE/faw/            ГОТОВЫЙ САЙТ ДЛЯ ЗАГРУЗКИ: index.html + img/ (все фото, оптимизированы для веба) + fonts/.
                       Загружается как есть. PHP, база данных, Node.js не нужны.
2-DEPLOY/              faw.conf (Nginx), deploy.sh (установка на Ubuntu 24.04), TM-TEST.md (проверка из Туркменистана).
3-ORIGINAL-GORSELLER/  Все исходные изображения в полном качестве: баннеры, фото из каталога (модели и спецтехника),
                       логотипы, AI-студийные фото, PDF-каталог. Для сайта НЕ нужны — это архив исходников.
DESIGN.md              Дизайн-система сайта.

Установка на VPS (Ubuntu 24.04), из папки этого архива:
  scp -r 1-SITE/faw 2-DEPLOY/faw.conf 2-DEPLOY/deploy.sh root@SERVER_IP:/tmp/
  ssh root@SERVER_IP "bash /tmp/deploy.sh"
  Проверка: http://SERVER_IP/

Любой другой хостинг: загрузить СОДЕРЖИМОЕ папки 1-SITE/faw/ в корень сайта.

Важно:
- Сайт не делает внешних запросов (нет Google, CDN, внешних шрифтов и API).
- НЕ включать прокси Cloudflare: Cloudflare заблокирован в Туркменистане.
- Проверить открытие из Туркменистана без VPN (домашний и мобильный интернет): 2-DEPLOY/TM-TEST.md.

Türkmençe: saýt — 1-SITE/faw/ bukjasy. Hostinge şonuň içindäkileri ýükläň. Cloudflare proksisini ulanmaň.
Türkmenistandan VPN-siz barlaň. 3-ORIGINAL-GORSELLER — ähli asyl suratlar (saýt üçin gerek däl, arhiw).
