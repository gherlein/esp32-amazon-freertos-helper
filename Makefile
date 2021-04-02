include makefile.local

# initial learnings: https://blog.alikhalil.tech/2019/06/getting-started-with-amazon-freertos-and-the-espressif-esp32-devkitc/
# key learning about -GNinja: https://github.com/aws/amazon-freertos/issues/2957

all: git install config build compile erase flash monitor

git: 
	cd ${ESPBASE};git clone git@github.com:aws/amazon-freertos.git --recurse-submodules

install:
	cd ${FREERTOS};vendors/espressif/esp-idf/install.sh

${CONFFILE}.orig:
	cp ${CONFIG} ./${CONFFILE}.orig

config: ${CONFFILE}.orig
	sed -e 's/"$$thing_name"/"${THINGNAME}"/g' \
            -e 's/"$$wifi_ssid"/"${WIFI}"/g' \
            -e 's/"$$wifi_password"/"${PASSWORD}"/g' \
            -e 's/"$$wifi_security"/"${SECURITY}"/g' ${CONFFILE}.orig > ${CONFIG}
	cat ${CONFIG}
	cd ${FREERTOS}/tools/aws_config_quick_start;python SetupAWS.py setup

build: 
	cd ${FREERTOS}; . vendors/espressif/esp-idf/export.sh;cmake -DVENDOR=espressif -DBOARD=esp32_wrover_kit -DCOMPILER=xtensa-esp32 -S . -B build -GNinja

compile:
	cd ${FREERTOS};. vendors/espressif/esp-idf/export.sh;./vendors/espressif/esp-idf/tools/idf.py -p ${PORT} build

erase:
	cd ${FREERTOS};. vendors/espressif/esp-idf/export.sh;./vendors/espressif/esp-idf/tools/idf.py -p ${PORT} erase_flash

flash:
	cd ${FREERTOS};. vendors/espressif/esp-idf/export.sh;./vendors/espressif/esp-idf/tools/idf.py -p ${PORT} flash

monitor:
	cd ${FREERTOS};. vendors/espressif/esp-idf/export.sh;./vendors/espressif/esp-idf/tools/idf.py -p ${PORT} monitor

clean:
	cd ${FREERTOS};. vendors/espressif/esp-idf/export.sh;./vendors/espressif/esp-idf/tools/idf.py clean


fullclean: clean localclean
	cd ${FREERTOS}; . vendors/espressif/esp-idf/export.sh;./vendors/espressif/esp-idf/tools/idf.py fullclean
	aws iot delete-thing --thing-name "${THINGNAME}"
	aws iot delete-policy --policy-name ${THINGNAME}_amazon_freertos_policy

localclean:
	-rm *~
	-rm configure.json.orig



