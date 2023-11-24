#! /usr/bin/env python3
# -*- coding: utf8 -*-

from __future__ import print_function

import os
from setuptools import setup


def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname), 'r', encoding='utf-8').read()

setup(
    name = "eng_ASR",
    version = "0.2.3",
    author = "Emre Yılmaz",
    author_email = "emre@nus.edu.sg",
    description = ("English Automatic Speech Recognition Webservice"),
    license = "AGPL3",
    keywords = "clam webservice rest nlp computational_linguistics rest",
    url = "https://github.com/opensource-spraakherkenning-nl/eng_ASR",
    packages=['eng_ASR'],
    long_description=read('README.md'),
    classifiers=[
        "Development Status :: 5 - Production/Stable",
        "Topic :: Internet :: WWW/HTTP :: WSGI :: Application",
        "Topic :: Text Processing :: Linguistic",
        "Programming Language :: Python :: 3"
        "Operating System :: POSIX",
        "Intended Audience :: Developers",
        "Intended Audience :: Science/Research",
        "License :: OSI Approved :: GNU General Public License v3 (GPLv3)",
    ],
    package_data = {'eng_ASR':['*.sh','*.wsgi','*.yml'] },
    include_package_data=True,
    install_requires=['CLAM >= 3.0']
)
