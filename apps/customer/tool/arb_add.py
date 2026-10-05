"""Adds strings to lib/l10n/app_{en,si,ta}.arb in one go.

Usage:  python tool/arb_add.py path/to/strings.py

The strings file defines  S = {"key": ("English", "සිංහල", "தமிழ்")}.
Use {name} for text placeholders and {name:int} for whole numbers (which allows
ICU plurals). Existing keys are replaced, so a wording change is just a re-run.
Run `flutter gen-l10n` afterwards.
"""
import json
import os
import re
import runpy
import sys

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
strings = runpy.run_path(sys.argv[1])['S']

placeholder = re.compile(r'\{(\w+)(?::(\w+))?\}')
langs = ('en', 'si', 'ta')
files = {lang: os.path.join(root, 'lib', 'l10n', f'app_{lang}.arb') for lang in langs}
data = {lang: json.load(open(path, encoding='utf-8')) for lang, path in files.items()}

for key, values in strings.items():
    assert len(values) == 3, key
    types = {}
    for text in values:
        for name, kind in placeholder.findall(text):
            if kind:
                types[name] = kind
            types.setdefault(name, 'String')
    names = [{n for n, _ in placeholder.findall(text)} for text in values]
    assert names[0] == names[1] == names[2], f'{key}: placeholders differ between languages'
    for lang, text in zip(langs, values):
        data[lang][key] = placeholder.sub(lambda m: '{' + m.group(1) + '}', text)
    if types:
        data['en']['@' + key] = {'placeholders': {n: {'type': t} for n, t in types.items()}}

for lang, path in files.items():
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data[lang], f, ensure_ascii=False, indent=2)
        f.write('\n')
print(len(strings), 'strings added or updated')
