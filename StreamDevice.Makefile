
where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(REQUIRE_TOOLS)/driver.makefile

APP:=
APPDB:=$(APP)/Db
APPSRC:=$(APP)/src

USR_INCLUDES += -I$(where_am_I)$(APPSRC)

BUSSES      += AsynDriver
BUSSES      += Dummy

FORMATS     += Enum
FORMATS     += BCD
FORMATS     += Raw
FORMATS     += RawFloat
FORMATS     += Binary
FORMATS     += Checksum
FORMATS     += Regexp
FORMATS     += MantissaExponent
FORMATS     += Timestamp

RECORDTYPES += aai aao
RECORDTYPES += ao ai
RECORDTYPES += bo bi
RECORDTYPES += mbbo mbbi
RECORDTYPES += mbboDirect mbbiDirect
RECORDTYPES += longout longin
RECORDTYPES += stringout stringin
RECORDTYPES += waveform
RECORDTYPES += calcout

SOURCES += $(RECORDTYPES:%=$(APPSRC)/dev%Stream.c)
SOURCES += $(FORMATS:%=$(APPSRC)/%Converter.cc)
SOURCES += $(BUSSES:%=$(APPSRC)/%Interface.cc)
SOURCES += $(wildcard $(APPSRC)/Stream*.cc)
SOURCES += $(APPSRC)/StreamVersion.c

HEADERS += $(APPSRC)/devStream.h
HEADERS += $(APPSRC)/StreamFormat.h
HEADERS += $(APPSRC)/StreamFormatConverter.h
HEADERS += $(APPSRC)/StreamBuffer.h
HEADERS += $(APPSRC)/StreamError.h


StreamCore$(DEP): streamReferences


# the original StreamDevice GNUMakefile uses perl
# I would like to use EPICS PERL instead of perl
# $PERL = perl -CSD 

streamReferences:
	$(PERL) $(where_am_I)$(APPSRC)/makeref.pl Interface $(BUSSES) > $@
	$(PERL) $(where_am_I)$(APPSRC)/makeref.pl Converter $(FORMATS) >> $@

export DBDFILES = streamSup.dbd

streamSup.dbd:
	@echo Creating $@
	$(PERL) $(where_am_I)$(APPSRC)/makedbd.pl $(RECORDTYPES) > $@






