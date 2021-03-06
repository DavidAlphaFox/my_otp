#
# %CopyrightBegin%
# 
# Copyright Ericsson AB 1998-2012. All Rights Reserved.
# 
# The contents of this file are subject to the Erlang Public License,
# Version 1.1, (the "License"); you may not use this file except in
# compliance with the License. You should have received a copy of the
# Erlang Public License along with this software. If not, it can be
# retrieved online at http://www.erlang.org/.
# 
# Software distributed under the License is distributed on an "AS IS"
# basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
# the License for the specific language governing rights and limitations
# under the License.
# 
# %CopyrightEnd%
#
include $(ERL_TOP)/make/target.mk

ifeq ($(findstring ose,$(TARGET)),ose)
include $(ERL_TOP)/make/$(TARGET)/ose_lm.mk
endif

ifeq ($(TYPE),debug)
PURIFY     =
TYPEMARKER = .debug
TYPE_FLAGS = -DDEBUG -g
else

ifeq ($(TYPE),purify)
PURIFY     = purify
TYPEMARKER =
ifeq ($(findstring ose,$(TARGET)),ose)
  TYPE_FLAGS = -DPURIFY
else
  TYPE_FLAGS = -O2 -DPURIFY
endif
else

override TYPE = opt
PURIFY     =
TYPEMARKER =
ifeq ($(findstring ose,$(TARGET)),ose)
  TYPE_FLAGS =
else
  TYPE_FLAGS = -O2
endif
endif
endif

include $(ERL_TOP)/make/$(TARGET)/otp.mk
include ../../vsn.mk
include ../epmd.mk

BINDIR  = $(ERL_TOP)/bin/$(TARGET)
OBJDIR  = $(ERL_TOP)/erts/obj$(TYPEMARKER)/$(TARGET)
ERTS_INCL = -I$(ERL_TOP)/erts/include \
            -I$(ERL_TOP)/erts/include/$(TARGET) \
            -I$(ERL_TOP)/erts/include/internal \
            -I$(ERL_TOP)/erts/include/internal/$(TARGET)

# On windows we always need reentrant libraries.
ifeq ($(TARGET),win32)
ERTS_INTERNAL_LIBS=-L../../lib/internal/$(TARGET) -lerts_internal_r$(ERTS_LIB_TYPEMARKER) 
else
ifeq ($(findstring vxworks,$(TARGET)),vxworks)
ERTS_INTERNAL_LIBS=-L../../lib/internal/$(TARGET) -lerts_internal$(ERTS_LIB_TYPEMARKER) 
else
ifeq ($(findstring ose,$(TARGET)),ose)
ERTS_INTERNAL_LIBS=-L../../lib/internal/$(TARGET) -lerts_internal$(ERTS_LIB_TYPEMARKER) 
else
ERTS_INTERNAL_LIBS=-L../../lib/internal/$(TARGET) -lerts_internal$(ERTS_LIB_TYPEMARKER)  -lm
endif
endif
endif

ERTS_LIB = $(ERL_TOP)/erts/lib_src/obj/$(TARGET)/$(TYPE)/MADE

CC      = gcc
WFLAGS  = -Wall -Wstrict-prototypes -Wmissing-prototypes -Wdeclaration-after-statement
CFLAGS  = -Werror=return-type  -g -O2 -I/Users/david/Documents/workspace/my_otp/erts/x86_64-apple-darwin15.6.0   -D_XOPEN_SOURCE -DHAVE_CONFIG_H $(TYPE_FLAGS) $(WFLAGS) $(ERTS_INCL)
LD      = $(CC)
ifeq ($(findstring ose,$(TARGET)),ose)
LIBS    = $(ERTS_INTERNAL_LIBS) -lutil -ldl -lm 
else
LIBS    = -lutil -ldl -lm   $(ERTS_INTERNAL_LIBS)
endif
LDFLAGS = -m64 



# ----------------------------------------------------
# Release directory specification
# ----------------------------------------------------

# The targets
ifeq ($(findstring win32,$(TARGET)),win32)
EPMD = epmd.exe
else
EPMD = epmd
endif

INSTALL_PROGS = $(BINDIR)/$(EPMD)

#---------------------------------
# Options
#---------------------------------
 
EPMD_FLAGS = -DEPMD_PORT_NO=$(EPMD_PORT_NO)

#---------------------------------
# source and object file information
#---------------------------------

EPMD_OBJS = $(OBJDIR)/epmd.o       \
               $(OBJDIR)/epmd_cli.o   \
               $(OBJDIR)/epmd_srv.o 

#---------------------------------
# Build targets
#---------------------------------


all: $(BINDIR)/$(EPMD)

docs:

clean:
	rm -f $(BINDIR)/$(EPMD) 
	rm -f $(ERL_TOP)/erts/obj/$(TARGET)/epmd.o
	rm -f $(ERL_TOP)/erts/obj/$(TARGET)/epmd_cli.o
	rm -f $(ERL_TOP)/erts/obj/$(TARGET)/epmd_srv.o 
	rm -f *.o
	rm -f *~ core

ifeq ($(findstring ose,$(TARGET)),ose)
$(OBJDIR)/ose_confd.o: $(OSE_CONFD)
	$(V_CC) $(CFLAGS) -o $@ -c $<
$(OBJDIR)/crt0_lm.o: $(CRT0_LM)
	$(V_CC) $(CFLAGS) -o $@ -c $<
OSE_LM_OBJS += $(OBJDIR)/ose_confd.o $(OBJDIR)/crt0_lm.o
endif

#
# Objects & executables
#

ifeq ($(findstring ose,$(TARGET)),ose)
$(BINDIR)/$(EPMD): $(EPMD_OBJS) $(ERTS_LIB) $(OSE_LM_OBJS)
	$(call build-ose-load-module, $@, $(EPMD_OBJS) $(OSE_LM_OBJS), $(LIBS), $(EPMD_LMCONF))
else
$(BINDIR)/$(EPMD): $(EPMD_OBJS) $(ERTS_LIB)
	$(ld_verbose)$(PURIFY) $(LD) $(LDFLAGS) -o $@ $(EPMD_OBJS) $(LIBS)
endif

$(OBJDIR)/%.o: %.c epmd.h epmd_int.h
	$(V_CC) $(CFLAGS) $(EPMD_FLAGS) -o $@ -c $<

$(ERTS_LIB):
	$(make_verbose)cd $(ERL_TOP)/erts/lib_src && $(MAKE) $(TYPE)

include $(ERL_TOP)/make/otp_release_targets.mk

release_spec: all
	$(INSTALL_DIR)     "$(RELEASE_PATH)/erts-$(VSN)/bin"
	$(INSTALL_PROGRAM) $(INSTALL_PROGS) "$(RELEASE_PATH)/erts-$(VSN)/bin"


release_docs_spec:
