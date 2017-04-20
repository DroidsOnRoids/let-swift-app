#!/usr/bin/python
import re, urllib, urllib2

# Config
path_to_supporting_files = 'LetSwift/Resources'
keysColumnIndex = 1 # columnIndex with keys
languages = {'en' : 2, 'pl' : 3} # codeForLanguage : columnIndex, e.g. 'pl' : 3
spreadsheet_id = '1HZwNTyo2XRkADjNLvXlMMlZ_buzCNYxhjIzvwL6mid8' # spreadsheet id here

def download():
    url_format = 'https://docs.google.com/spreadsheets/d/%s/export?format=csv'
    try:
        request = urllib2.Request(url_format % spreadsheet_id)
        response = urllib2.urlopen(request)
        return response
    except urllib2.URLError, e:
        return False

def path_to_localizable_with_lang_code(lang_code, give_path_to_file):
    path_to_return = '%s/%s.lproj' % (path_to_supporting_files, lang_code)
    if give_path_to_file:
        path_to_return += '/Localizable.strings'
    return path_to_return

if __name__ == "__main__":
    import csv, os

    # Request a file-like object containing the spreadsheet's contents
    csv_file = download()

    if csv_file:
        # Open localizable files
        localizables = {}
        for lang, column in languages.iteritems():
            if not os.path.exists(path_to_localizable_with_lang_code(lang, False)):
                os.makedirs(path_to_localizable_with_lang_code(lang, False))
            localizables[lang] = open(path_to_localizable_with_lang_code(lang, True), 'w+')

        # Parse as CSV and write the localizables
        my_csv = list(csv.reader(csv_file))
        del my_csv[0] # delete header

        for row in my_csv:
            for lang, column in languages.iteritems():
                if row[keysColumnIndex] and row[column]:
                    keyToSave = row[column].replace('\n', '\\n')
                    localizables[lang].write('"%s" = "%s";\n' % (row[keysColumnIndex], keyToSave))

        for lang, column in languages.iteritems():
            localizables[lang].close()
