#
#  Copyright (c) 2007 - 2017     Paul Scherrer Institute 
#  Copyright (c) 2017 - Present  European Spallation Source ERIC
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
#               date    : Thursday, November 30 15:02:52 CET 2017
#               version : 0.0.1
#


where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(E3_REQUIRE_TOOLS)/driver.makefile

ifneq ($(strip $(ASYN_DEP_VERSION)),)
asyn_VERSION=$(ASYN_DEP_VERSION)
endif

ifneq ($(strip $(PCRE_DEP_VERSION)),)
pcre_VERSION=$(PCRE_DEP_VERSION)
endif


APP:=
APPDB:=$(APP)/Db
APPSRC:=$(APP)/src

# pcre-config --libs-cpp
#USR_LDFLAGS += -lpcrecpp -lpcre


BUSSES  += AsynDriver
BUSSES  += Dummy

FORMATS += Enum
FORMATS += BCD
FORMATS += Raw
FORMATS += RawFloat
FORMATS += Binary
FORMATS += Checksum
FORMATS += Regexp
FORMATS += MantissaExponent
FORMATS += Timestamp


RECORDTYPES += ao ai
RECORDTYPES += bo bi
RECORDTYPES += mbbo mbbi
RECORDTYPES += mbboDirect mbbiDirect
RECORDTYPES += longout longin
RECORDTYPES += stringout stringin
RECORDTYPES += waveform
RECORDTYPES += calcout
RECORDTYPES += aai aao

SOURCES += $(RECORDTYPES:%=src/dev%Stream.c)
SOURCES += $(FORMATS:%=src/%Converter.cc)
SOURCES += $(BUSSES:%=src/%Interface.cc)
SOURCES += $(wildcard src/Stream*.cc)
SOURCES += $(APPSRC)/StreamVersion.c

HEADERS += $(APPSRC)/devStream.h
HEADERS += $(APPSRC)/StreamFormat.h
HEADERS += $(APPSRC)/StreamFormatConverter.h
HEADERS += $(APPSRC)/StreamBuffer.h
HEADERS += $(APPSRC)/StreamError.h

# USR_LIBS += pcre
# USR_LIBS += pcrecpp


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
