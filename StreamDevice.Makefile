
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



SOURCES +=$(APPSRC)/TimestampConverter.cc

SOURCES +=$(APPSRC)/StreamBuffer.cc
SOURCES +=$(APPSRC)/StreamBusInterface.cc
SOURCES +=$(APPSRC)/StreamCore.cc
SOURCES +=$(APPSRC)/StreamEpics.cc
SOURCES +=$(APPSRC)/StreamError.cc
SOURCES +=$(APPSRC)/StreamFormatConverter.cc
SOURCES +=$(APPSRC)/StreamProtocol.cc
SOURCES +=$(APPSRC)/StreamVersion.c

SOURCES +=$(APPSRC)/RegexpConverter.cc
SOURCES +=$(APPSRC)/RawFloatConverter.cc
SOURCES +=$(APPSRC)/RawConverter.cc
SOURCES +=$(APPSRC)/MantissaExponentConverter.cc
SOURCES +=$(APPSRC)/EnumConverter.cc

SOURCES +=$(APPSRC)/DummyInterface.cc
SOURCES +=$(APPSRC)/DebugInterface.cc

SOURCES +=$(APPSRC)/devaaiStream.c
SOURCES +=$(APPSRC)/devaaoStream.c
SOURCES +=$(APPSRC)/devaiStream.c
SOURCES +=$(APPSRC)/devaoStream.c
SOURCES +=$(APPSRC)/devbiStream.c
SOURCES +=$(APPSRC)/devboStream.c
SOURCES +=$(APPSRC)/devcalcoutStream.c
SOURCES +=$(APPSRC)/devlonginStream.c
SOURCES +=$(APPSRC)/devlongoutStream.c
SOURCES +=$(APPSRC)/devmbbiDirectStream.c
SOURCES +=$(APPSRC)/devmbbiStream.c
SOURCES +=$(APPSRC)/devmbboDirectStream.c
SOURCES +=$(APPSRC)/devmbboStream.c
SOURCES +=$(APPSRC)/devstringinStream.c
SOURCES +=$(APPSRC)/devstringoutStream.c
SOURCES +=$(APPSRC)/devwaveformStream.c

SOURCES +=$(APPSRC)/ChecksumConverter.cc
SOURCES +=$(APPSRC)/BinaryConverter.cc
SOURCES +=$(APPSRC)/BCDConverter.cc
SOURCES +=$(APPSRC)/AsynDriverInterface.cc
SOURCES +=$(APPSRC)/devmbboDirectStream.c

#SOURCES += $(APPSRC)/srcSynApps/devscalcoutStream.c


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






