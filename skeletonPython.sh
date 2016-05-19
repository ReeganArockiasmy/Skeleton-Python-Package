#! /usr/bin/bash

check_package=["pip","distutils","nose","virtualenv"]

for name in "pip"  "distutils" "nose" "virtualenv"
do
    echo check $name package
    python -c "import $name"
    if [ $? -ne 0 ]
    then
	echo "install $name package"
	pip install --user $name
    fi
done

echo "Enter project name"
proj_name=`line`
echo $proj_name

mkdir projects
cd projects
mkdir skeleton
cd skeleton
mkdir bin $proj_name tests docs

touch $proj_name/__init__.py
touch tests/__init__.py


echo "
try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

config = {
    'description': 'My Project',
    'author': 'My Name',
    'url': 'URL to get it at.',
    'download_url': 'Where to download it.',
    'author_email': 'My email.',
    'version': '0.1',
    'install_requires': ['nose'],
    'packages': ['$proj_name'],
    'scripts': [],
    'name': 'projectname'
}

setup(**config) " > setup.py

cd tests
echo "
from nose.tools import *
import $proj_name

def setup():
    print \"SETUP!\"

def teardown():
    print \"TEAR DOWN!\"

def test_basic():
    print \"I RAN!\"
" > $proj_name"_tests.py"
cd ..
nosetests
