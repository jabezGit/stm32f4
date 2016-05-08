

ledtest_SOURCES := stm32f4/tests/ledtest/main.c
ledtest_OBJECTS := stm32f4/tests/ledtest/main.o

$(ledtest_OBJECTS): %.o: %.c
	$(call cmd,cc_o_c)

ledtest_LIBS := stm32f4/build/libstm32f4.a \
                stm32f4/usb/build/libstm32_usb.a \
                FreeRTOS/build/libFreeRTOS.a

$(eval $(call toolchain,stm32f4/tests/ledtest/ledtest))
stm32f4/tests/ledtest/ledtest: OBJECTS := $(ledtest_OBJECTS) $(STARTUP_OBJECTS)
stm32f4/tests/ledtest/ledtest: LIBS    := $(ledtest_LIBS)
stm32f4/tests/ledtest/ledtest: CFLAGS  += -Istm32f4/include $(FREERTOS_INCLUDES)
stm32f4/tests/ledtest/ledtest: $(ledtest_LIBS)
stm32f4/tests/ledtest/ledtest: $(ledtest_OBJECTS) $(STARTUP_OBJECTS)
	$(call cmd,link)

stm32f4/tests/ledtest/ledtest.bin: stm32f4/tests/ledtest/ledtest
	$(call cmd,bin)

stm32f4/tests/ledtest/ledtest.ihex: stm32f4/tests/ledtest/ledtest
	$(call cmd,ihex)

all: stm32f4/tests/ledtest/ledtest     \
     stm32f4/tests/ledtest/ledtest.bin \
     stm32f4/tests/ledtest/ledtest.ihex

flash: ledtest.bin
	st-flash write ledtest.bin 0x8000000

clean::
	$(RM) $(ledtest_OBJECTS)
	$(RM) stm32f4/tests/ledtest/ledtest
	$(RM) stm32f4/tests/ledtest/ledtest.bin
	$(RM) stm32f4/tests/ledtest/ledtest.ihex
