# =========================
# Baza: lekki obraz Pythona
# =========================
FROM python:3.12-slim

# =========================
# Zmienne środowiskowe
# =========================
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# =========================
# Katalog roboczy
# =========================
WORKDIR /code

# =========================
# Systemowe zależności
# =========================
RUN apt-get update && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# =========================
# Kopiowanie i instalacja zależności Pythona
# =========================
COPY requirements.txt /code/
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# =========================
# Kopiowanie całego projektu
# =========================
COPY . /code/

# =========================
# Tworzenie użytkownika nie-root
# =========================
RUN useradd --create-home --shell /bin/bash appuser && \
    chown -R appuser:appuser /code
USER appuser

# =========================
# Domyślna komenda (development)
# =========================
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

# =========================
# UWAGI:
# - W produkcji zamiast runserver użyj:
#   CMD ["gunicorn", "twoj_projekt.wsgi:application", "--bind", "0.0.0.0:8000"]
# - Upewnij się, że masz .dockerignore z __pycache__, *.pyc, .git, venv itp.
# - Python 3.12 jest stabilny; 3.13 jest eksperymentalny.
# =========================
