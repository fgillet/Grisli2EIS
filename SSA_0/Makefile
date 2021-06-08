SRCDIR=./src
LIBS=Scalar_OUTPUT

all: $(LIBS)

%:$(SRCDIR)/%.F90
	elmerf90 $^ -o $@

clean:
	rm -f $(LIBS)
