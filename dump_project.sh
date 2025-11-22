#!/bin/bash
echo "=== EXCELLUS PROJECT DUMP (as of $(date)) ==="
echo "Project root: $(pwd)"
echo ""

# List project structure first
echo "=== PROJECT STRUCTURE (tree-like) ==="
find . -type f \( -name "*.py" -o -name "*.txt" -o -name "*.html" -o -name "*.css" -o -name "*.js" -o -name "urls.py" -o -name "settings.py" -o -name "*.env" \) | sort
echo ""

# Dump requirements and manage.py
echo "=== requirements.txt ==="
if [ -f requirements.txt ]; then cat requirements.txt; else echo "Not found"; fi
echo ""

echo "=== manage.py ==="
if [ -f manage.py ]; then cat manage.py; else echo "Not found"; fi
echo ""

# Dump main project dir files (Excellus/ or similar)
PROJECT_DIR="Excellus"  # Adjust if your project dir is named differently
if [ -d "$PROJECT_DIR" ]; then
  echo "=== $PROJECT_DIR/__init__.py ==="
  if [ -f "$PROJECT_DIR/__init__.py" ]; then cat "$PROJECT_DIR/__init__.py"; else echo "Not found"; fi
  echo ""
  
  echo "=== $PROJECT_DIR/settings.py ==="
  if [ -f "$PROJECT_DIR/settings.py" ]; then cat "$PROJECT_DIR/settings.py"; else echo "Not found"; fi
  echo ""
  
  echo "=== $PROJECT_DIR/urls.py ==="
  if [ -f "$PROJECT_DIR/urls.py" ]; then cat "$PROJECT_DIR/urls.py"; else echo "Not found"; fi
  echo ""
  
  echo "=== $PROJECT_DIR/wsgi.py ==="
  if [ -f "$PROJECT_DIR/wsgi.py" ]; then cat "$PROJECT_DIR/wsgi.py"; else echo "Not found"; fi
  echo ""
  
  echo "=== $PROJECT_DIR/asgi.py (if exists) ==="
  if [ -f "$PROJECT_DIR/asgi.py" ]; then cat "$PROJECT_DIR/asgi.py"; else echo "Not found"; fi
  echo ""
fi

# Dump app directories (assuming apps like core, students, teachers, classes, quizzes)
APPS=("core" "students" "teachers" "classes" "quizzes" "timetables" "auth")  # Add/remove based on your apps
for APP in "${APPS[@]}"; do
  if [ -d "$APP" ]; then
    echo "=== APP: $APP ==="
    
    echo "  === $APP/models.py ==="
    if [ -f "$APP/models.py" ]; then cat "$APP/models.py"; else echo "Not found"; fi
    echo ""
    
    echo "  === $APP/views.py ==="
    if [ -f "$APP/views.py" ]; then cat "$APP/views.py"; else echo "Not found"; fi
    echo ""
    
    echo "  === $APP/urls.py ==="
    if [ -f "$APP/urls.py" ]; then cat "$APP/urls.py"; else echo "Not found"; fi
    echo ""
    
    echo "  === $APP/admin.py ==="
    if [ -f "$APP/admin.py" ]; then cat "$APP/admin.py"; else echo "Not found"; fi
    echo ""
    
    echo "  === $APP/forms.py (if exists) ==="
    if [ -f "$APP/forms.py" ]; then cat "$APP/forms.py"; else echo "Not found"; fi
    echo ""
    
    echo "  === TEMPLATES in $APP/templates/ ==="
    if [ -d "$APP/templates" ]; then
      find "$APP/templates" -name "*.html" -exec echo "    === {} ===" \; -exec cat {} \; -exec echo "" \;
    else
      echo "    No templates dir"
    fi
    echo ""
    
    echo "  === STATIC in $APP/static/ (skipping binaries, only .css/.js) ==="
    if [ -d "$APP/static" ]; then
      find "$APP/static" -name "*.css" -o -name "*.js" | while read file; do
        echo "    === $file ==="
        cat "$file"
        echo ""
      done
    else
      echo "    No static dir"
    fi
    echo ""
    
    echo "  === MIGRATIONS in $APP/migrations/ (only __init__.py and latest) ==="
    if [ -d "$APP/migrations" ]; then
      if [ -f "$APP/migrations/__init__.py" ]; then
        echo "    === $APP/migrations/__init__.py ==="
        cat "$APP/migrations/__init__.py"
        echo ""
      fi
      LATEST_MIG=$(ls "$APP/migrations/" | grep -E '^[0-9]+.*\.py$' | sort -V | tail -1)
      if [ -n "$LATEST_MIG" ]; then
        echo "    === $APP/migrations/$LATEST_MIG (latest) ==="
        cat "$APP/migrations/$LATEST_MIG"
        echo ""
      fi
    else
      echo "    No migrations dir"
    fi
    echo ""
  fi
done

# Any .env or db.sqlite3 note (don't cat db)
echo "=== .env or similar (if exists) ==="
if [ -f .env ]; then cat .env; else echo "Not found (good, don't share secrets!)"; fi
echo ""
if [ -f db.sqlite3 ]; then echo "db.sqlite3 exists (size: $(du -h db.sqlite3 | cut -f1)) - not dumping contents"; else echo "No db.sqlite3"; fi
echo ""

echo "=== END OF DUMP ==="
