import os
import re

def extract_url_names_from_templates():
    url_names = set()
    template_dir = 'school/templates'
    
    for root, dirs, files in os.walk(template_dir):
        for file in files:
            if file.endswith('.html'):
                filepath = os.path.join(root, file)
                with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                    # Find all {% url 'pattern_name' %} occurrences
                    matches = re.findall(r"{%\s*url\s+['\"]([^'\"]+)['\"]", content)
                    url_names.update(matches)
    
    return sorted(url_names)

def extract_url_names_from_urls():
    url_names = set()
    with open('school/urls.py', 'r') as f:
        content = f.read()
        # Find all name='pattern_name' occurrences
        matches = re.findall(r"name=['\"]([^'\"]+)['\"]", content)
        url_names.update(matches)
    
    return sorted(url_names)

template_urls = extract_url_names_from_templates()
defined_urls = extract_url_names_from_urls()

print("=== URLs referenced in templates but not defined ===")
missing = set(template_urls) - set(defined_urls)
for url in sorted(missing):
    print(f"Missing: {url}")

print(f"\n=== Summary ===")
print(f"Total URLs in templates: {len(template_urls)}")
print(f"Total URLs defined: {len(defined_urls)}")
print(f"Missing URLs: {len(missing)}")
