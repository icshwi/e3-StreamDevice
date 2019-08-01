#
#  Copyright (c) 2007            Paul Scherrer Institute 
#  Copyright (c) 2017 - Present  European Spallation Source ERIC
#  Copyright (c) 2019            Jeong Han Lee
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
#  PSI original author : Dirk Zimoch
#
#  ESS specific author  : Jeong Han Lee
#               email   : han.lee@esss.se
#               date    : Thursday, August  1 18:48:35 CEST 2019
#               version : 0.0.4
#
#   


where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(E3_REQUIRE_TOOLS)/driver.makefile
include $(E3_REQUIRE_CONFIG)/DECOUPLE_FLAGS


ifneq ($(strip $(ASYN_DEP_VERSION)),)
asyn_VERSION=$(ASYN_DEP_VERSION)
endif

ifneq ($(strip $(PCRE_DEP_VERSION)),)
pcre_VERSION=$(PCRE_DEP_VERSION)
endif

ifneq ($(strip $(CALC_DEP_VERSION)),)
calc_VERSION=$(CALC_DEP_VERSION)
endif



#USR_CPPFLAGS += -DUSE_TYPED_RSET


APP:=.
APPDB:=$(APP)/Db
APPSRC:=$(APP)/src

### CONFIG_STREAM START
RECORDTYPES += ao ai
RECORDTYPES += bo bi
RECORDTYPES += mbbo mbbi
RECORDTYPES += mbboDirect mbbiDirect
RECORDTYPES += longout longin
RECORDTYPES += stringout stringin
RECORDTYPES += waveform
RECORDTYPES += calcout
RECORDTYPES += aai aao

ifdef BASE_3_15
RECORDTYPES += lsi lso
endif
ifdef BASE_3_16
RECORDTYPES += int64in int64out
endif

RECORDTYPES += scalcout

BUSSES  += Debug
BUSSES  += Dummy
BUSSES  += AsynDriver

FORMATS += Enum
FORMATS += BCD
FORMATS += Raw
FORMATS += RawFloat
FORMATS += Binary
FORMATS += Checksum
FORMATS += MantissaExponent
FORMATS += Timestamp
FORMATS += Regexp

### CONFIG_STREAM END


### GNUmakefile
SOURCES += $(RECORDTYPES:%=src/dev%Stream.c)
SOURCES += $(FORMATS:%=src/%Converter.cc)
SOURCES += $(BUSSES:%=src/%Interface.cc)
SOURCES += $(wildcard src/Stream*.cc)

## E3 Specific source and header files
SOURCES += $(APPSRC)/StreamVersion.c
HEADERS += $(APPSRC)/StreamProtocol.h
HEADERS += $(APPSRC)/StreamBusInterface.h
HEADERS += $(APPSRC)/MacroMagic.h
HEADERS += $(APPSRC)/StreamCore.h

### GNUmakefile from the main stream PSI
HEADERS += $(APPSRC)/devStream.h
HEADERS += $(APPSRC)/StreamFormat.h
HEADERS += $(APPSRC)/StreamFormatConverter.h
HEADERS += $(APPSRC)/StreamBuffer.h
HEADERS += $(APPSRC)/StreamError.h


SCRIPTS += $(wildcard ../iocsh/*.iocsh)


StreamCore$(DEP): streamReferences

# the original StreamDevice GNUMakefile uses perl
# I would like to use EPICS PERL instead of perl
# $PERL = perl -CSD 

streamReferences:
	$(PERL) $(where_am_I)$(APPSRC)/makeref.pl Interface $(BUSSES)   > $@
	$(PERL) $(where_am_I)$(APPSRC)/makeref.pl Converter $(FORMATS) >> $@

export DBDFILES = streamSup.dbd

streamSup.dbd:
	@echo Creating $@
	$(PERL) $(where_am_I)$(APPSRC)/makedbd.pl $(RECORDTYPES) > $@



# db rule is the default in RULES_E3, so add the empty one

db:
#
.PHONY: vlibs db

vlibs:
#
