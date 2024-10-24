#!/usr/bin/env bash

# Number of books per batch
BATCH_SIZE=$1 # Pass the batch size as an argument
BATCH_AMOUNT=$2

generate_isbn() {
    echo "$((RANDOM % 1000 + 1000))-$((RANDOM % 1000 + 1000))-$((RANDOM % 1000 + 1000))-$((RANDOM % 10))"
}

generate_title() {
    echo "Book Title $((RANDOM % 1000))"
}

generate_subtitle() {
    echo "Subtitle $((RANDOM % 1000))"
}

generate_year() {
    echo $((1990 + RANDOM % 34))
}

generate_price() {
    echo "$(awk -v min=5 -v max=50 'BEGIN{srand(); print min+rand()*(max-min)}')"
}

generate_buchsorte() {
    echo $((RANDOM % 26 + 1))
}

generate_language() {
    LANGUAGES=("deutsch" "englisch" "französisch" "spanisch" "griechisch")
    echo "${LANGUAGES[$((RANDOM % 5))]}"
}

# Prepare the SQL query for bulk insert
echo "INSERT INTO Buch (ISBNnummer, Titel, Untertitel, VerlagId, Erscheinungsjahr, BuchsorteId, Kurzbeschreibung, Preis, Auflage, Sprache) VALUES" >insert_books.sql

clear
printf "\033[?25l"
for ((j = 1; j <= $BATCH_AMOUNT; j++)); do
    for ((i = 1; i <= $BATCH_SIZE; i++)); do
        ISBN=$(generate_isbn)
        TITLE=$(generate_title)
        SUBTITLE=$(generate_subtitle)
        VERLAG_ID=1 # Random publisher ID
        YEAR=$(generate_year)
        BUCHSORTE=1
        DESCRIPTION="Random description $((RANDOM % 1000))"
        PRICE=$(generate_price)
        AUFLAGE=$((RANDOM % 5 + 1))
        LANGUAGE=$(generate_language)

        echo "('$ISBN', '$TITLE', '$SUBTITLE', $VERLAG_ID, $YEAR, $BUCHSORTE, '$DESCRIPTION', $PRICE, '$AUFLAGE', '$LANGUAGE')," >>insert_books.sql
        PERCENT=$(((100 * $i) / $BATCH_SIZE))
        printf "\033[%d;0H Batch \e[1;34m%.2d\e[0m | \e[1;36m%.3d%%\e[0m \e[1;32m%.5d\e[0m/\e[1;33m%.5d\e[0m" "$j" "$j" "$PERCENT" "$i" "$BATCH_SIZE"
    done &

done

wait

printf "\033[?25h"

ISBN=$(generate_isbn)
TITLE=$(generate_title)
SUBTITLE=$(generate_subtitle)
VERLAG_ID=$((RANDOM % 118 + 1)) # Random publisher ID
YEAR=$(generate_year)
BUCHSORTE=$(generate_buchsorte)
DESCRIPTION="Random description $((RANDOM % 1000))"
PRICE=$(generate_price)
AUFLAGE=$((RANDOM % 5 + 1))
LANGUAGE=$(generate_language)

echo "('$ISBN', '$TITLE', '$SUBTITLE', $VERLAG_ID, $YEAR, $BUCHSORTE, '$DESCRIPTION', $PRICE, '$AUFLAGE', '$LANGUAGE');" >>insert_books.sql
