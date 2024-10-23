#!/bin/bash

# Subdomain Scanner using crt.sh API with Advanced Features
# Author: lamcodeofpwnosec
# Date: 23 Oct 2024

# Fungsi untuk menampilkan banner
banner() {
    echo "====================================="
    echo "     Advanced Subdomain Scanner"
    echo "====================================="
}

# Fungsi untuk mengecek apakah curl dan jq tersedia
check_dependencies() {
    dependencies=("curl" "jq" "xargs" "parallel" "mail")
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            echo "[!] $dep tidak ditemukan! Install terlebih dahulu."
            exit 1
        fi
    done
}

# Fungsi untuk melakukan pencarian subdomain
scan_subdomains() {
    local domain=$1
    echo "[+] Memulai pencarian subdomain untuk: $domain"

    # Query API crt.sh dengan retry handling
    response=$(curl -s --retry 3 "https://crt.sh/?q=%.$domain&output=json")

    if [ -z "$response" ]; then
        echo "[!] Tidak ada data ditemukan atau terjadi kesalahan saat mengambil data dari API."
        exit 1
    fi

    # Ekstraksi dan simpan subdomain unik
    echo "$response" | jq -r '.[].name_value' | sort -u > "${domain}_subdomains.txt"
    total=$(wc -l < "${domain}_subdomains.txt")
    echo "[+] Ditemukan $total subdomain untuk $domain."
}

# Fungsi untuk mengecek konektivitas secara paralel
check_connectivity() {
    local file=$1
    echo "[+] Memeriksa konektivitas subdomain secara paralel..."

    cat "$file" | parallel -j 10 "ping -c 1 -W 1 {} &>/dev/null && echo '[LIVE] {}' || echo '[DEAD] {}'" \
        | tee connectivity_result.txt

    live_count=$(grep -c "\[LIVE\]" connectivity_result.txt)
    dead_count=$(grep -c "\[DEAD\]" connectivity_result.txt)

    echo "[+] $live_count subdomain aktif dan $dead_count subdomain tidak aktif."
}

# Fungsi untuk mengirim hasil melalui email
send_email() {
    local domain=$1
    local email=$2

    if [ -n "$email" ]; then
        echo "[+] Mengirim hasil pemindaian ke $email..."
        cat connectivity_result.txt | mail -s "Hasil Pemindaian Subdomain untuk $domain" "$email"
        echo "[+] Email terkirim."
    else
        echo "[!] Email tidak disediakan. Lewati pengiriman."
    fi
}

# Fungsi utama
main() {
    banner
    check_dependencies

    if [ -z "$1" ]; then
        echo "[!] Penggunaan: ./subdomain_scanner.sh <domain> [email]"
        exit 1
    fi

    local domain=$1
    local email=$2

    start_time=$(date +%s)

    # Langkah pemindaian dan pengecekan konektivitas
    scan_subdomains "$domain"
    check_connectivity "${domain}_subdomains.txt"

    # Kirim hasil via email jika disediakan
    send_email "$domain" "$email"

    end_time=$(date +%s)
    duration=$((end_time - start_time))
    echo "[+] Pemindaian selesai dalam waktu $duration detik."
}

# Memulai program
main "$@"
