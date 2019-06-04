import os
from distutils.core import setup
import os.path
import versioneer
from distutils.extension import Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize
import numpy
import glob


def populate_data_files(parent):
    data_files = []
    directories = glob.glob(parent)
    for directory in directories:
        files = glob.glob(directory + '*')
        data_files.append((directory, files))
    return data_files


os.environ['CC'] = 'gcc'

sourcefiles = ["shakemap/c/pcontour.pyx", "shakemap/c/contour.c"]

clib_source = ["shakemap/c/clib.pyx"]

ext_modules = [Extension("shakemap.c.pcontour",
                         sourcefiles,
                         libraries=["m"],
                         include_dirs=[numpy.get_include()],
                         extra_compile_args=["-O3"]),
               Extension("shakemap.c.clib",
                         clib_source,
                         libraries=['m'],
                         include_dirs=[numpy.get_include()],
                         extra_compile_args=["-O3", "-fopenmp"],
                         extra_link_args=["-fopenmp"])]

cmdclass = versioneer.get_cmdclass()
cmdclass['build_ext'] = build_ext

setup(name='shakemap',
      version=versioneer.get_version(),
      description='USGS Near-Real-Time Ground Motion Mapping',
      author='Bruce Worden, Mike Hearne, Eric Thompson',
      author_email='cbworden@usgs.gov,mhearne@usgs.gov,emthompson@usgs.gov',
      url='http://github.com/usgs/shakemap',
      packages=[
          'shakemap',
          'shakemap.utils',
          'shakemap.coremods',
          'shakemap.mapping',
          'shakelib',
          'shakelib.conversions',
          'shakelib.conversions.imc',
          'shakelib.conversions.imt',
          'shakelib.correlation',
          'shakelib.directivity',
          'shakelib.gmice',
          'shakelib.rupture',
          'shakelib.plotting',
          'shakelib.utils',
      ],
      package_data={
          'shakemap': [
              os.path.join('tests', 'shakemap', 'data', '*'),
              os.path.join('data', '**', '*'),
              os.path.join('data', '*')

          ],
          'shakelib': [
              os.path.join('test', 'data', '*'),
              os.path.join('utils', 'data', '*'),
              os.path.join('rupture', 'ps2ff', '*.csv'),
              os.path.join('conversions', 'imc', 'data', '*')
          ]
      },
      scripts=[
          'bin/associate_amps',
          'bin/getdyfi',
          'bin/receive_amps',
          'bin/receive_origins',
          'bin/run_verification',
          'bin/shake',
          'bin/sm_create',
          'bin/sm_migrate',
          'bin/sm_profile',
          'bin/sm_compare',
          'bin/sm_queue',
          'bin/sm_rupture'],
      cmdclass=cmdclass,
      ext_modules=cythonize(ext_modules))
