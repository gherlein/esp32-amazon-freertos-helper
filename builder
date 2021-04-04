. vendors/espressif/esp-idf/export.sh
cmake -DVENDOR=espressif -DBOARD=esp32_wrover_kit -DCOMPILER=xtensa-esp32 -S . -B build -GNinja
idf.py build

