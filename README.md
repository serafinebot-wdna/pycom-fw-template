# Build custom Pycom firmware

## Project structure
```
├── firmware
│   ├── build
│   │   ├── GPY_21.12.23-14.12.33_master_6d23fa1.tar.gz
│   │   └── GPY_22.01.11-13.40.21_master_125e85c.tar.gz
│   ├── pycom-esp-idf
│   └── pycom-micropython-sigfox
├── lib
│   └── module
│       ├── __init__.py
│       └── module.py
├── boot.py
├── main.py
├── Makefile
└── README.md
```

## Setup
```shell
git clone --recursive git@github.com:snebot-bg/pycom-fw-template.git <project_name>
cd <project_name>
git submodule update --init --recursive
make mpy-build
make
make clean
```

The first time the `make` command is executed the build is likely to fail since it requires a specific `pycom-esp-idf` version. The following error message might be displayed
```
Incompatible IDF git hash:

3394ee5 is expected from IDF_HASH from Makefile, but
2c14666 is what IDF_PATH=/home/snebot/Development/pycom-fw/firmware/pycom-esp-idf is pointing at.

You should probably update one (or multiple) of:
  * IDF_PATH environment variable
  * IDF_HASH variable in esp32/Makefile
  * IDF commit, e.g.
cd $IDF_PATH && git checkout 3394ee5 && git submodule sync && git submodule update --init --recursive && cd -
```

If the previous error was prompted, the following command must be executed:
```shell
# Make sure this command is executed inside the project directory
cd firmware/pycom-esp-idf && git checkout 3394ee5 && git submodule sync && git submodule update --init --recursive && cd -
```
