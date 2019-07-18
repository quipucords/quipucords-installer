#!/usr/bin/env python
# coding=utf-8
"""A setuptools-based script for installing qpc."""
import os
import sys
import json

from setuptools import find_packages, setup
from release import EGG_NAME, BUILD_VERSION

setup(
    name=EGG_NAME,
    version=BUILD_VERSION,
    author='Quipucords Team',
    author_email='quipucords@redhat.com',
    classifiers=[
        'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
    ],
    include_package_data=True,
    license='GPLv3',
    packages=find_packages(exclude=['test*.py']),
    url='https://github.com/quipucords/quipucords',
    zip_safe=False
)