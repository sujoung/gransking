import codecs
import os    
from chardet import detect
from pprint import pprint
import pickle

all_files = {}
no_conv_files = {}

textchars = bytearray({7,8,9,10,12,13,27} | set(range(0x20, 0x100)) - {0x7f})
is_binary_string = lambda bytes: bool(bytes.translate(None, textchars))
is_this_file_bin = lambda pathstr: is_binary_string(open(pathstr, 'rb').read(1024))

path="./granska"
for (dirpath, dirnames, filenames) in os.walk(path):
    if ".git" in dirpath:
        continue
    for filename in filenames:
        path_and_file = os.sep.join([dirpath, filename])
        all_files[filename] = path_and_file
        for extension in ['.cpp', '.h', '.hpp', '.sh', '.bin', '.bak', '.old', '.md','.opt', '.inc', '.c', '.opt']:
            if filename.endswith(extension) or filename in ['Makefile', 'LICENSE', 'html2txt'] or is_this_file_bin(path_and_file):
                no_conv_files[filename] = os.sep.join([dirpath, filename])

conv_files = set(all_files) - set(no_conv_files)

def get_encoding_type(file):
    with open(file, 'rb') as f:
        rawdata = f.read()
    return detect(rawdata)['encoding']

encoding_dict = dict.fromkeys(list(conv_files))

for cv in conv_files:
    full_name = all_files[cv]
    encoding = get_encoding_type(full_name)
    encoding_dict[cv] = encoding
    print(cv, "encoding:", encoding)

#encoding_dict = pickle.load(open("encoding_dict.pickle", "rb"))

print("------ start converting ------")
for fn, enco in encoding_dict.items():
    srcfile = fn
    trgfile = "converted_"+str(fn)
    if enco != "ISO-8859-1" and enco is not None:
        # add try: except block for reliability
        try: 
            with open(srcfile, 'r', encoding=enco) as f, open(trgfile, 'w', encoding='iso-8859-1') as e:
                text = f.read() # for small files, for big use chunks
                e.write(text)
            os.remove(srcfile) # remove old encoding file
            os.rename(trgfile, srcfile) # rename new encoding
        except UnicodeDecodeError:
            print('Decode Error')
        except UnicodeEncodeError:
            print('Encode Error')
        except FileNotFoundError:
            continue
    print(fn, "converted")

    
